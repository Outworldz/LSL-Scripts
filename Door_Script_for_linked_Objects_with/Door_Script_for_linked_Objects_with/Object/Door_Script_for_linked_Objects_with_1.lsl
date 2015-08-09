// :CATEGORY:Door
// :NAME:Door_Script_for_linked_Objects_with
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:52
// :ID:258
// :NUM:349
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// This has an API so you can put a PIN number in the door to control access or as the script says "whatever".
// :CODE:




1// USAGE INSTRUCTIONS FOR EVERYDAY USE:
//------------------------------------------------------
// Say the following commands on channel 0:
// 'unlock'     - Unlocks all doors in range.
// 'lock'       - Locks all doors in range and allows
//                only the permitted users to open it.
// To open the door, either Touch it, Walk into it or
// say 'open' or say 'close'.

//------------------------------------------------------
// USAGE INSTRUCTIONS FOR BUILDERS:
//------------------------------------------------------
// 1. Copy and paste this script into the door prim and
//    change the settings (see further down).
// 2. The door prim must be linked to at least one other
//    prim (could be linked to the house for example).
// 3. The door prim MUST NOT be the root prim.
// 4. Use Edit Linked Parts to move, rotate and size the
//    door prim for the closed state.
// 5. When ready, stand close to the door and say
//    '/door closed' (this records the closed door
//    position, rotation and size to the object's
//    name and description).
// 6. Use the Edit Linked parts to move, rotate and size
//    the door prim for the opened state.
// 7. When ready, stand close to the door and say
//    '/door opened' (this records the opened door
//    position, rotation and size).
// 8. Once recorded it will not accept these commands
//    again. If you do need to redo the settings then
//    delete the Name and Description of the door prim
//    (these are where the position information is
//    stored), and then follow the steps above again.
//    Note: deleting the object name won't save, so set
//    the object name to 'Object' to reset the object
//    name.

//------------------------------------------------------
// Change these settings to suit your needs.
//------------------------------------------------------
// To mute any/all of the sounds set the sound string(s)
// to "" (empty string).
// To get the UUID of a sound, right click on the sound
// in your inventory and choose "Copy Asset UUID", then
// paste the UUID in here.
string      doorOpenSound       = "b28e90d2-df9c-4a4d-0883-5fdfe204efae";
string      doorCloseSound      = "813a6132-5953-b9ab-f8c7-f4d4d356aa35";
string      confirmedSound      = "69743cb2-e509-ed4d-4e52-e697dc13d7ac";
string      accessDeniedSound   = "58da0f9f-42e5-8a8f-ee51-4fac6c247c98";
string      doorBellSound       = ""; // Setting to empty stops door announcements too.
float       autoCloseTime       = 120.0; // 0 seconds to disable auto close.
integer     allowGroupToo       = TRUE; // Set to FALSE to disallow same group access to door.
list        allowedAgentUUIDs   = ["8efecbac-35de-4f40-89c1-2c772b83cafa"]; // Comma-separated, quoted list of avatar UUIDs who are allowed access to this door.
integer     listenChannel       = 0;


//------------------------------------------------------
// Leave the rest of the settings alone, these are
// handled by the script itself.
//------------------------------------------------------
integer     isLocked              = FALSE; // Only when the door is locked do the permissions apply.
integer     isOpen              = TRUE;
vector      openPos             = ZERO_VECTOR;
rotation    openRot             = ZERO_ROTATION;
vector      openScale           = ZERO_VECTOR;
vector      closedPos           = ZERO_VECTOR;
rotation    closedRot           = ZERO_ROTATION;
vector      closedScale         = ZERO_VECTOR;
key         openerKey           = NULL_KEY;
key         closerKey           = NULL_KEY;
integer     isSetup             = FALSE;
integer     listenHandle        = 0;
string      avatarName          = "";

mySayName(integer channel, string objectName, string message)
{
    string name = llGetObjectName();
    llSetObjectName(objectName);
    llSay(0, "/me " + message);
    llSetObjectName(name);
}

mySay(integer channel, string message)
{
    string name = llGetObjectName();
    llSetObjectName("Door");
    llSay(0, message);
    llSetObjectName(name);
}

myOwnerSay(string message)
{
    string name = llGetObjectName();
    llSetObjectName("Door");
    llOwnerSay(message);
    llSetObjectName(name);
}

mySoundConfirmed()
{
    if (confirmedSound != "")
    {
        llTriggerSound(confirmedSound, 1.0);
    }
}

mySoundAccessDenied()
{
    if (accessDeniedSound != "")
    {
        llTriggerSound(accessDeniedSound, 1.0);
    }
}

myGetDoorParams()
{
    isSetup = FALSE;
    if (llSubStringIndex(llGetObjectDesc(), "door;") == 0 && llSubStringIndex(llGetObjectName(), "door;") == 0)
    {
        list nameWords = llParseString2List(llGetObjectName(), [";"], []);
        list descWords = llParseString2List(llGetObjectDesc(), [";"], []);
        if (llGetListLength(nameWords) != 4 || llGetListLength(descWords) != 4)
        {
            myOwnerSay("The door prim's name and/or description has invalid syntax and/or number of parameters. Delete the door prim's name and description and setup the door prim again.");
        }
        else
        {
            openPos = (vector)llList2String(nameWords, 1);
            openRot = (rotation)llList2String(nameWords, 2);
            openScale = (vector)llList2String(nameWords, 3);
            closedPos = (vector)llList2String(descWords, 1);
            closedRot = (rotation)llList2String(descWords, 2);
            closedScale = (vector)llList2String(descWords, 3);
            isSetup = TRUE;
        }
    }
}

mySetDoorParams(vector openPos, rotation openRot, vector openScale, vector closedPos, rotation closedRot, vector closedScale)
{
    llSetObjectName("door;" +
        (string)openPos + ";" +
        (string)openRot + ";" +
        (string)openScale);
    llSetObjectDesc("door;" +
        (string)closedPos + ";" +
        (string)closedRot + ";" +
        (string)closedScale);
    isSetup = TRUE;
}

integer myPermissionCheck(key id)
{
    integer hasPermission = FALSE;
    if (isLocked == FALSE)
    {
        hasPermission = TRUE;
    }
    else if (llGetOwnerKey(id) == llGetOwner())
    {
        hasPermission = TRUE;
    }
    else if (allowGroupToo == TRUE && llSameGroup(id))
    {
        hasPermission = TRUE;
    }
    else if (llListFindList(allowedAgentUUIDs, [(string)id]) != -1)
    {
        hasPermission = TRUE;
    }
    return hasPermission;
}

myOpenDoor()
{
    isOpen = FALSE;
    myToggleDoor();
}

myCloseDoor()
{
    isOpen = TRUE;
    myToggleDoor();
}

myToggleDoor()
{
    if (isSetup == FALSE)
    {
        myOwnerSay("The door prim has not been configured yet. Please read the usage instructions in the door script.");
    }
    else if (llGetLinkNumber() == 0 || llGetLinkNumber() == 1)
    {
        myOwnerSay("The door prim must be linked to at least one other prim and the door prim must not be the root prim");
    }
    else
    {
        isOpen = !isOpen;
        if (isOpen)
        {
            if (doorBellSound != "")
            {
                llTriggerSound(doorBellSound, 1.0);
                if (avatarName != "")
                {
                    mySayName(0, avatarName, "is at the door.");
                    avatarName = "";
                }
            }
            if (doorOpenSound != "")
            {
                llTriggerSound(doorOpenSound, 1.0);
            }
            llSetPrimitiveParams([ PRIM_POSITION, openPos, PRIM_ROTATION, ZERO_ROTATION * openRot / llGetRootRotation(), PRIM_SIZE, openScale ]);
            // Door API.
            llMessageLinked(LINK_SET, 255, "cmd|door|opened", NULL_KEY);
        }
        else
        {
            if (doorCloseSound != "")
            {
                llTriggerSound(doorCloseSound, 1.0);
            }
            llSetPrimitiveParams([ PRIM_POSITION, closedPos, PRIM_ROTATION, ZERO_ROTATION * closedRot / llGetRootRotation(), PRIM_SIZE, closedScale ]);
            // Door API.
            llMessageLinked(LINK_SET, 255, "cmd|door|closed", NULL_KEY);
        }
        
        llSetTimerEvent(0.0);
        if (isOpen == TRUE && autoCloseTime != 0.0)
        {
            llSetTimerEvent(autoCloseTime);
        }
    }
}

default
{
    state_entry()
    {
        listenHandle = llListen(listenChannel, "", NULL_KEY, "");
        myGetDoorParams();
    }

    touch_start(integer total_number)
    {
        if (myPermissionCheck(llDetectedKey(0)) == TRUE)
        {
            avatarName = llDetectedName(0);
            myToggleDoor();
        }
        else
        {
            mySoundAccessDenied();
        }
    }
    
    timer()
    {
        myCloseDoor();
    }
    
    link_message(integer sender_num, integer num, string str, key id)
    {
        // Door API. The API is here in case you want to create PIN entry keypads or whatever.
        if (num == llGetLinkNumber())
        {
            if (str == "cmd|door|doOpen")
            {
                myOpenDoor();
            }
            else if (str == "cmd|door|doClose")
            {
                myCloseDoor();
            }
        }
        if (str == "cmd|door|discover")
        {
            llMessageLinked(LINK_SET, 255, "cmd|door|discovered|" + (string)llGetKey(), id);
        }
    }
    
    listen(integer channel, string name, key id, string message)
    {
        // Performance note: it's quicker to compare the strings than to compare permissions each time anyone says anything on this channel.
        if (message == "open")
        {
            if (myPermissionCheck(id) == TRUE)
            {
                // Only open the door if the person is quite close to this door.
                openerKey = id;
                closerKey = NULL_KEY;
                avatarName = name;
                llSensor(name, id, AGENT, 5.0, TWO_PI);
            }
            else
            {
                mySoundAccessDenied();
            }
        }
        else if (message == "close")
        {
            if (myPermissionCheck(id) == TRUE)
            {
                openerKey = NULL_KEY;
                closerKey = id;
                avatarName = name;
                // Only close the door if the person is quite close to this door.
                llSensor(name, id, AGENT, 5.0, TWO_PI);
            }
            else
            {
                mySoundAccessDenied();
            }
        }
        else if (message == "lock")
        {
            if (myPermissionCheck(id) == TRUE)
            {
                isLocked = TRUE;
                mySoundConfirmed();
            }
            else
            {
                mySoundAccessDenied();
            }
        }
        else if (message == "unlock")
        {
            if (myPermissionCheck(id) == TRUE)
            {
                isLocked = FALSE;
                mySoundConfirmed();
            }
            else
            {
                mySoundAccessDenied();
            }
        }
        else if (message == "/door opened" && llSubStringIndex(llGetObjectName(), "door;") == -1)
        {
            if (llGetOwnerKey(id) == llGetOwner())
            {
                mySoundConfirmed();
                openPos = llGetLocalPos();
                openRot = llGetLocalRot();
                openScale = llGetScale();
                isOpen = TRUE;
                if (! (closedPos == ZERO_VECTOR && closedRot == ZERO_ROTATION && closedScale == ZERO_VECTOR))
                {
                    mySetDoorParams(openPos, openRot, openScale, closedPos, closedRot, closedScale);
                }
            }
            else
            {
                mySoundAccessDenied();
            }
        }
        else if (message == "/door closed" && llSubStringIndex(llGetObjectDesc(), "door;") == -1)
        {
            if (llGetOwnerKey(id) == llGetOwner())
            {
                mySoundConfirmed();
                closedPos = llGetLocalPos();
                closedRot = llGetLocalRot();
                closedScale = llGetScale();
                isOpen = FALSE;
                if (! (openPos == ZERO_VECTOR && openRot == ZERO_ROTATION && openScale == ZERO_VECTOR))
                {
                    mySetDoorParams(openPos, openRot, openScale, closedPos, closedRot, closedScale);
                }
            }
            else
            {
                mySoundAccessDenied();
            }
        }
    }
    
    sensor(integer num_detected)
    {
        if (openerKey != NULL_KEY)
        {
            integer i;
            for (i = 0; i < num_detected; i++)
            {
                if (llDetectedKey(i) == openerKey && myPermissionCheck(llDetectedKey(i)) == TRUE)
                {
                    myOpenDoor();
                }
            }
            openerKey = NULL_KEY;
        }
        else
        {
            integer i;
            for (i = 0; i < num_detected; i++)
            {
                if (llDetectedKey(i) == closerKey && myPermissionCheck(llDetectedKey(i)) == TRUE)
                {
                    myCloseDoor();
                }
            }
            closerKey = NULL_KEY;
        }
    }

//------------------------------------------------------
// Uncomment the following code if you particularly want
// collisions to affect the door state.    
//------------------------------------------------------

//    collision_start(integer num_detected)
//    {
//        integer i;
//        for (i = 0; i < num_detected; i++)
//        {
//            if (myPermissionCheck(llDetectedKey(i)) == TRUE)
//            {
//                avatarName = llDetectedName(i);
//                myOpenDoor();
//            }
//            else if (llDetectedType(i) & AGENT)
//            {
//                mySoundAccessDenied();
//            }
//        }
//    }

} // End of default state and end of script
