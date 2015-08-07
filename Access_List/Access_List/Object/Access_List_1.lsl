// :CATEGORY:Access List
// :NAME:Access_List
// :AUTHOR:Shine Renoir
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:47
// :ID:12
// :NUM:17
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Place this script in a platform. Then you can add and delete user names from an internal access list (see source code comments). If an avatar is not on the access list, it will be pushed back on entering the platform.// // This script demonstrates some of the list functions and the access list feature could be useful for other applications as well.
// :CODE:
// access list script
// 2007 Copyright by Shine Renoir (fb@frank-buss.de)
// Use it for whatever you want, but keep this copyright notice
// and credit my name in notecards etc., if you use it in
// closed source objects
//
// usage: say /1 add Avatar for adding a name to the access list
// and say /1 del Avatar for removing a name

// reflection multiplicator, useful values: 1 .. 100
float pushPower = 5.0;

// current access list
list accessList = [];

// show access list to owner, comma separated
dumpAccessList()
{
    llOwnerSay("current access list: " + llDumpList2String(accessList, ", "));
}

default
{
    state_entry()
    {
        // register handler on chat channel 1
        llListen(1, "", NULL_KEY, "");
        
        // clean accessList
        accessList = [];
    }

    collision_start(integer detected) 
    { 
        // get owner UUID and from avatar who entered the platform
        key ownerKey = llGetOwner();
        key detectedKey = llDetectedKey(0);
        
        // get names
        string owner = llKey2Name(ownerKey);
        string avatar = llKey2Name(detectedKey);
        
        // test, if in access list. Owner is always allowed to enter the platform
        if (llListFindList(accessList, [avatar]) < 0 && detectedKey != ownerKey) {
            // say something
            llWhisper(0, "you are not on the access list, ask " + owner + " if you would like to visit this place");

            // get current velocity vector and push back in opposite direction
            vector vel = -llDetectedVel(0);
            llPushObject(llDetectedKey(0), pushPower * vel, ZERO_VECTOR, FALSE);
        }
    }

    listen(integer channel, string name, key id, string message)
    {
        // only owner can change access list
        if (id == llGetOwner()) {
            // command and avatar name is space separated
            integer space = llSubStringIndex(message, " ");
            if (space > 0) {
                // get command and avatar name
                string command = llGetSubString(message, 0, space - 1);
                string avatar = llGetSubString(message, space + 1, -1);
                if (command == "add") {
                    // if not already in access list, add name
                    if (llListFindList(accessList, [avatar]) == -1) {
                        accessList = llListInsertList(accessList, [avatar], 0);
                    }
                } else if (command == "del") {
                    // if in access list, remove name
                    integer pos = llListFindList(accessList, [avatar]);
                    if (pos >= 0) {
                        accessList = llDeleteSubList(accessList, pos, pos);
                        dumpAccessList();
                    }
                }
                
                // display new access list
                dumpAccessList();
            }
        }
    }

    touch_start(integer total_number)
    {
        // display new access list, if owner touches the platform
        key ownerKey = llGetOwner();
        key detectedKey = llDetectedKey(0);
        if (detectedKey == ownerKey) {
            dumpAccessList();
        }
    }

}
