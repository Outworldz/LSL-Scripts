// :CATEGORY:Animation
// :NAME:Unlimited_storage_Prim_Animator
// :AUTHOR:Ferd Frederix
// :CREATED:2011-09-07 21:37:12.857
// :EDITED:2013-09-18 15:39:08
// :ID:936
// :NUM:1344
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// This is the main prim animator script.   You also need the Store 0 script.     An article on how to use this to make objects move is at http://www.outworldz.com/Secondlife/Posts/Robin/
// :CODE:
// Prim Animator DB
// 06/20/2011
// Author Ferd Frederix
// Use with one or more copies of the script 'Store 0..Store 1.. Store N'
// Copyright 2011 Fred Beckhusen aka Ferd Frederix
//
// Licensed under the GNU Version3 license at http://www.gnu.org/copyleft/gpl.html
// This program and the STORE scipts it uses must be left Copy/Transfer/MOD
// Any items that use these scripts may have more restrictive permissions.

// for help and how to use, see "http://meteverse.mitsi.com/secondlife/Posts/Prim-Animator-DB

// Prim position root script
// Put this script in the root prim.
// touch the prim  to start recording

// Record  - store a new set of child prim positions
// Clear RAM - wipe out all recording in the prim. Leaves the database intact
// Pause - insert a 0.1 second pause
// Erase - Erases the Server data
// Load - Loads the data from the Server
// Publisgh - Saves the data to the database
// Recordings - Lists all recordings ( up to 16)
// Name  - name a new recording
// Play All  Plays back all recordings with a 1 second Pause.

// Publish - Saves to database
// Help - Get Web Help
// More - TBD

// configurable things




string MyName ;                      // The creator of the animation
string MyItemName;       // a Name  just for this unique item and any copies

integer debug = FALSE;          // if set to TRUE, debug info appears

// Code follows - no need to edit below this line.
// remote db reading
key kHttpRequestID;


integer countLoaded = 0;            // how many nanims have been loaded via HTTP

integer iPlayChannel = 1;    // the playback channel, this is the channel you use in LinkMessages
integer countchannel= 2001; // how many have been saved
integer iDialogChannel ;         // dialog boxes
integer iPrimCount ;             // total number of prims
integer iWantNameFlag;           // flag indicating we are waiting for a name to be chatted
integer imax;                    // total records in store
integer runtime = 0; // set to 1 after Recording and publishing.
// animation store
string sCurrentAnimationName;   // The name of the animation we are playing
string sPriorAniName;           // the prior animation name so we can spot differences as we read them in
list lLastPrimList;             // storage of the last prim position we learned
integer iLastSTRIDE = 4;        // size of the last prim list
integer iListenerHandle;        // temp iListenerHandle when we are waiting for them to give us a name
list lUserAnimNames;            // animations read from the notecard added to the Menu display


// Commands
integer Clear = 99;     // erase local db
integer Erase   = 100;  // erase  Server DB command
integer Add     = 101;  // add a coordinate
integer Publish = 102;  // save to db
integer Name    = 103;  // send Name to db
integer thisName = 104; // send thisName to db
integer Play    = 105;    // play channel to make an animation run

Debug( string msg)
{
    if (debug) llOwnerSay(msg);
}

// clear any old listeners and make a new on to control lag
NewListen()
{
    iDialogChannel = (integer) (llFrand(400) + 300);
    llListenRemove(iListenerHandle);
    iListenerHandle = llListen(iDialogChannel,"","","");
}

// prompt the user for an animation name.   Uses text box or chat
AskForName()
{
    iWantNameFlag = TRUE;
    llSetTimerEvent(60);
    NewListen();
    llOwnerSay("Enter the name in the text box or type the new animation name on channel /" + (string) iDialogChannel );
    llTextBox(llGetOwner(),"Type the new animation name",iDialogChannel);
}


Get(string data)
{
    Debug("Data was " + data);

    list lLine = (llParseString2List(data, ["|"], []));
    string sAniName = llList2String(lLine,0);
    string sNum = (string) Getline(lLine,1);
    float fNum = (float) sNum;
    vector vPos = (vector) Getline(lLine,2);          // global for calcChild()
    rotation rRot = (rotation) Getline(lLine,3);        // global for calcChild()
    vector vprimSize  = (vector) Getline(lLine,4);
    countLoaded++;
    // the first record is always the root prim size
    if (fNum == 0)
    {
        FetchNext();
        return;
    }

    if (sAniName != sPriorAniName)
    {
        sPriorAniName = sAniName;
        sCurrentAnimationName = sAniName;
        if (llListFindList(lUserAnimNames,[sAniName]) == -1)
        {
            Debug("Loading animation " + sAniName);
            lUserAnimNames += sAniName;
        }

    }
    // Debug("Loading Prim #" + (string) fNum);
    if(fNum != 1)        // skip root prim
    {
        sCurrentAnimationName = sAniName;
        llMessageLinked(LINK_THIS,Add,sAniName
            +"|"
            + (string) fNum
            +"|"
            + (string) vPos
            + "|"
            + (string) rRot
            + "|"
            + (string) vprimSize,"");



        llSetText("Initialising... \n" + (string) (countLoaded) , <1,1,1>, 1.0);
    }
    llSleep(1);         // http throttle avoidance

    FetchNext();

}
// in case of hand editing, we wupe out extra stuff at end
string Getline(list Input, integer line)
{
    return llStringTrim(llList2String(Input, line),STRING_TRIM);
}

Record()
{
    if (llStringLength(sCurrentAnimationName) > 0)
    {
        integer ifoundmovement = 0;      // will be set if any child moved
        integer iPrimCounter ;        // skip past the root prim
        for (iPrimCounter =2; iPrimCounter <= iPrimCount ; iPrimCounter++ )
        {
            list my_list = llGetLinkPrimitiveParams(iPrimCounter,[PRIM_POSITION,PRIM_ROTATION, PRIM_SIZE ]);

            // position is always in region coordinates, even if the prim is a child or the root prim of an attachment.
            // rot is always the global rotation, even if the prim is a child or the root prim of an attachment.
            // get current prim pos, rot and size

            vector      vrealPrimPos    = llList2Vector (my_list,0) - llGetPos();   // position subtract Global Pos
            vrealPrimPos /= llGetRot();
            rotation    rrealPrimRot    = llList2Rot    (my_list,1) / llGetRot();   // rotation subtract Global Rot
            vector      vrealPrimSize   = llList2Vector (my_list,2);                 // size

            // compare it to the last one we had, stride of list is a 4, and it is already sorted
            integer iindex = (iPrimCounter - 2) * iLastSTRIDE;    // zeroth position is fPrimCounter - start, or 2

            // get the last thing we remembered about this prim
            integer     iprimNum        = llList2Integer    (lLastPrimList, iindex);    // must be 0,1,2, in order
            vector      vlastPrimPos    = llList2Vector     (lLastPrimList, iindex+1);
            rotation    rlastPrimRot    = llList2Rot        (lLastPrimList, iindex+2);
            vector      vlastPrimSize   = llList2Vector     (lLastPrimList, iindex+3);

            // if anything changed on this prim, we must record it.
            if (vlastPrimPos != vrealPrimPos ||
                rlastPrimRot != rrealPrimRot ||
                vlastPrimSize!= vrealPrimSize
                    )
                    {
                        ifoundmovement++;

                        //Save them in the master list of all animations
                        llMessageLinked(LINK_THIS,Add,sCurrentAnimationName+ "|"
                            + (string) iPrimCounter
                            + "|"
                            + (string) vrealPrimPos
                            + "|"
                            + (string) rrealPrimRot
                            + "|"
                            + (string) vrealPrimSize,"");


                        imax = llGetListLength(lLastPrimList);
                        // save the changes in the last prim list so we can keep our lists smaller

                        lLastPrimList = llListReplaceList(lLastPrimList,[vrealPrimPos],iPrimCounter+1,iPrimCounter+1);
                        lLastPrimList = llListReplaceList(lLastPrimList,[rrealPrimRot],iPrimCounter+2,iPrimCounter+2);
                        lLastPrimList = llListReplaceList(lLastPrimList,[vrealPrimSize],iPrimCounter+3,iPrimCounter+3);
                        //Debug("Saved in history at prim # " + (string) (iPrimCounter));
                        llSleep(0.1);
                    } // if
            else
            {
                Debug("Same @" + (string) iPrimCounter);
            }

        } // for

        if (!ifoundmovement)
        {
            llOwnerSay("You must move at least one child prim.");
        }

    }
    else
    {
        AskForName();
    }

}

// on reset, record the base position in history so we can see changes

ClearRAM()
{

    iPrimCount  = llGetNumberOfPrims();      // how many we are recording
    Debug("Prim Count = " + (string) iPrimCount);

    sCurrentAnimationName = "";      // no name in use

    lLastPrimList = [];         // wipe last animations list
    integer iPrimCounter ;
    integer primCounter = 0;
    for (iPrimCounter=2; iPrimCounter <= iPrimCount ; iPrimCounter++ ) // skip 1, which is the root prim
    {
        list my_list = llGetLinkPrimitiveParams(iPrimCounter,[PRIM_POSITION, PRIM_ROTATION, PRIM_SIZE ]);

        // save the local  pos and rot, since llGetLinkPrimitiveParams returns global pos and rot
        vector primpos      = llList2Vector (my_list,0) - llGetPos();
        primpos /= llGetRot();
        rotation primrot    = llList2Rot    (my_list,1) / llGetRot();

        vector primsize     = llList2Vector (my_list,2) ;
        lLastPrimList += iPrimCounter;
        lLastPrimList += primpos;
        lLastPrimList += primrot;
        lLastPrimList += primsize;
        primCounter++;
    }
    llOwnerSay("RAM is cleared - Initial Settings saved for " + (string) primCounter + " child prims");
}


rotation calcChildRot(rotation rdeltaRot)
{
    if (llGetAttached())
        return rdeltaRot/llGetLocalRot();
    else
        return rdeltaRot/llGetRootRotation();
}


MakeMenu()
{
    if (runtime)
    {
        MakeMenu2();
        return;
    }

    list amenu = ["Name", "Record","Pause"] +
        ["Erase","Load","Publish"] +
        ["Recordings","-","Play All"] +
        ["Help","-",  "Finish"];

    string menuText =  "Available Memory: " + (string) llGetFreeMemory()  +
        "\n\n" +
        "Recordings: Select a named animation\n" +
        "Name: Set the animation name\n" +
        "Play All: Play all animations\n" +
        "Erase: Delete Recorded Data\n" +
        "Load: Get from Server\n" +
        "Publish: Save to Server\n" +
        "Record: Record a snapshot of prim positions\n" +
        "Pause: Insert 0.1 second pause\n" +
        "Finish: End all programming\n" +
        "Help: Help";

    NewListen();
    llDialog(llGetOwner(), menuText,amenu,iDialogChannel);

}

MakeMenu2()
{
    string menuText ;
    list menu2 = lUserAnimNames;
    menu2 = llDeleteSubList(menu2,11,999);       // 12 max

    if (runtime)
        menu2 += "Unlock";
    if (llGetListLength(lUserAnimNames) == 0)
    {
        menu2 += ["Back"] ;
        menuText = " There are no animation names to display\n\n" +
            "Back:- Go back to programming menu";
    }
    else
        menuText =  "Pick an animation to play.";

    NewListen();
    llDialog(llGetOwner(), menuText,menu2,iDialogChannel);
}


FetchNext()
{
    string url = "http://www.outworldz.com/cgi/animate.plx?Type=Load&Count=" + (string) countLoaded + "&Name=" + llEscapeURL(MyName) + "&Password=" + llEscapeURL(MyItemName);
    Debug(url);

    kHttpRequestID = llHTTPRequest(url, [], "");
}


default
{
    state_entry()
    {
        MyName = llKey2Name(llGetCreator());             // assign the creator if we get reset
        MyItemName = llGetObjectName();    // and get the name of the Object
        llOwnerSay("Animation name from the description is " + MyItemName);

        if (MyItemName == "(No Description)" || llStringLength(MyItemName) == 0)
        {
            MyItemName = "Archipelis_" + (string) (llCeil(llFrand(200000) + 5000000)); // pick a large random number for a name
            llOwnerSay("Animations will be saved as '" + MyItemName + "'");
            llSetObjectDesc(MyItemName);
        }


        llMessageLinked(LINK_THIS,Name,MyName,"");
        llMessageLinked(LINK_THIS,thisName,MyItemName,"");

        if (runtime)
        {
            ClearRAM();
            FetchNext();        // start with first line in DB
        }
        else
        {
            ClearRAM();
        }
    }

    http_response(key queryid, integer status, list metadata, string data)
    {
        if (queryid == kHttpRequestID )
        {
            if (status == 200) // HTTP success status
            {
                if (data == "nothing to do")
                {
                    llOwnerSay("Initialized with " + (string) countLoaded + " settings");
                    llSetText(""  , <1,1,1>, 1.0);
                    return;
                }
                Get(data);
            }
            else
            {
                llOwnerSay("Server Error loading animations");
            }
        }
    }

    touch_start(integer total_number)
    {
        if (llDetectedKey(0) == llGetOwner() )
        {
            MakeMenu();
        }
    }

    // timed out waitig for a name of an animation
    timer()
    {
        iWantNameFlag = FALSE;
        llSetTimerEvent(0);
        llOwnerSay(" Timeout waiting for animation name");
        llListenRemove(iListenerHandle);
    }

    listen( integer channel, string name, key id, string message )
    {
        llListenRemove(iListenerHandle);
        // Debug(message);

        if (message == "Finish")
        {
            runtime++;
            llOwnerSay("The animator is now locked. Further touches will bring up a list of animations. You must unlock the menu to add more animations");
        }
        else if (message == "Unlock")
        {
            runtime = 0;
            llOwnerSay("The animator is now unlocked for programming.");
        }

        else if (message == "Erase")
        {
            ClearRAM();
            llMessageLinked(LINK_THIS,Erase,"",""); // erase the db
            MakeMenu();
        }
        else if (message =="Pause")
        {
            llMessageLinked(LINK_THIS,Add,"sCurrentAnimationName|"
                + "-0.1"            // sleep 1 tenth a second
                + "|"
                + "<0,0,0>"         // null pos
                + "<0,0,0,1>"       // null rot
                + "|"
                + "<0,0,0>","");    // null size
            MakeMenu();
        }
        else if (message == "Recordings")
        {
            MakeMenu2();
        }
        else if (message == "Load")
        {
            countLoaded = 0;
            FetchNext();        // start with first line in DB
        }
        else if (message == "Record")
        {
            Record();
            MakeMenu();
        }
        else if (message == "Publish")
        {
            llMessageLinked(LINK_THIS,Name,MyName,"");  // in case we reset just the stores
            llMessageLinked(LINK_THIS,thisName,MyItemName,"");
            llMessageLinked(LINK_THIS,Publish,"","");
            MakeMenu();
        }
        else if (message == "Name")
        {
            AskForName();
        }
        else if (message == "Back")
        {
            MakeMenu();
        }
        else if (message == "More")
        {
            MakeMenu();
        }
        else if (message == "Play All")
        {
            integer l = llGetListLength(lUserAnimNames);
            if (l == 0)
                llOwnerSay("Nothing to do");
            else
            {
                integer i = 0;
                for ( i = 0; i < l; i++)
                {
                    string ani = llList2String(lUserAnimNames,i);
                    llMessageLinked(LINK_THIS,Play,ani,"");
                    llSleep(1);
                }
            }
            MakeMenu();

        }
        else if (message == "Help")
        {
            llLoadURL(llGetOwner(),"View online help", "http://www.outworldz.com/secondlife/Posts/Prim-Animator-DB");
        }
        else if (iWantNameFlag)
        {
            sCurrentAnimationName = message;
            if (llGetListLength(lUserAnimNames) < 11)
            {
                if (llListFindList(lUserAnimNames,[sCurrentAnimationName]) == -1)
                    lUserAnimNames += message;
            }
            else
            {
                lUserAnimNames = llDeleteSubList(lUserAnimNames,11,99);
            }

            MakeMenu();

            llOwnerSay("Ready to record animation '" + sCurrentAnimationName + "'");
            llOwnerSay("Position all child  prims, then select the Menu item 'Record', and repeat as necessary. When finished, click 'Recordings' to play back the animation.  Click 'Name' again to start a new animation sequence.");

            iWantNameFlag = 0;
            llSetTimerEvent(0);
        }
        else
        {
            if (llListFindList(lUserAnimNames,[message]) != -1)
            {
                Debug("playback animation " + message);
                llMessageLinked(LINK_THIS,Play,message,"");
                MakeMenu();
            }
        }
    }

    link_message(integer sender_num, integer num, string message, key id)
    {
        if (num == countchannel)
        {
            llSetText(message,<1,1,1>,1.0);
            llSleep(1);
            llSetText("",<1,1,1>,1.0);
        }
        else if (num == iPlayChannel)       // external messages come in channel 1 - change them to channel Play
        {
            Debug("playback animation " + message);
            llMessageLinked(LINK_THIS,Play,message,"");
        }
    }


}

