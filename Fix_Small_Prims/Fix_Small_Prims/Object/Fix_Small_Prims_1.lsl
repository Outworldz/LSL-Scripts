// :CATEGORY:Tiny Prims
// :NAME:Fix_Small_Prims
// :AUTHOR:Emma Nowhere
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:53
// :ID:311
// :NUM:410
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Fix Small Prims.lsl
// :CODE:

 
///////////////////////////////////////////////////////////////////////////////
// FixSmallPrims
// by Emma Nowhere
//
// How to use:
// 1. Install this script in the root prim of a linked set of prims (aka "linkset")
// 2. Type /1fspsetup to copy copy scripts into all the prims in the linkset
// 3. Take the linkset into inventory
// 4. Re-rez the linkset from inventory
// 5. Select the linkset and choose "Set Scripts to Running in Selection" under the Tools menu
// 6. Type /1fsprun to fix all the small prims
// 7. Resize the linkset object to the desired size
// 8. Type /1fspcleanup to remove the scripts from the linkset
 
integer CHANNEL = 1;
 
vector backupScale = ZERO_VECTOR;
integer backupStored = FALSE;
 
integer rescaleX = FALSE;
integer rescaleY = FALSE;
integer rescaleZ = FALSE;
 
backup() {
    if (!backupStored) {
        backupScale = llGetScale();
        backupStored = TRUE;
    }
}
 
restore() {
    if (backupStored) {
        llSetScale(backupScale);
    }
    rescaleX = FALSE;
    rescaleY = FALSE;
    rescaleZ = FALSE;
}
 
cleanup() {
    vector scale = llGetScale();
 
    if (rescaleX) {
        scale.x = backupScale.x;
    }
 
    if (rescaleY) {
        scale.y = backupScale.y;
    }
 
    if (rescaleZ) {
        scale.z = backupScale.z;
    }
 
    if (rescaleX || rescaleY || rescaleZ) {
        llSay(0, "Cleaning scale of linked prim #" + (string)llGetLinkNumber());
        llSetScale(scale);
    }
 
    llRemoveInventory(llGetScriptName()); 
}
 
process() {
    restore();
    backup();
 
    vector scale = llGetScale();
 
    if (scale.x < .015) {
        scale.x = .015;
        rescaleX = TRUE;
    }
 
    if (scale.y < .015) {
        scale.y = .015;
        rescaleY = TRUE;
    }
 
    if (scale.z < .015) {
        scale.z = .015;
        rescaleZ = TRUE;
    }
 
    if (rescaleX || rescaleY || rescaleZ) {
        llSay(0, "Fixing size of linked prim #" + (string)llGetLinkNumber());
        llSetScale(scale);
    }
}
 
GiveScriptToLinkedPrims()
{
    integer p = llGetNumberOfPrims();
    integer i = 0;
    for (i = 2; i <= p; i++)
    {
        key prim = llGetLinkKey(i);
        llGiveInventory(prim, llGetScriptName());
    }
}
 
default
{
    state_entry() 
    {
        integer linkNum = llGetLinkNumber();
        if (linkNum < 2) llListen(CHANNEL, "", llGetOwner(), "");
    }
 
    on_rez(integer start_param) {
        integer linkNum = llGetLinkNumber();
        if (linkNum < 2) llSay(0, "FixSmallPrims Installed");
   }    
 
    listen(integer channel, string name, key id, string message) 
    {
        if (message == "fspsetup")
        {
            GiveScriptToLinkedPrims();
        }
        else
        {
            llMessageLinked(LINK_SET, 0, message, NULL_KEY);
        }
    }
 
    link_message(integer sender_num, integer num, string str, key id)
    {
        integer linkNum = llGetLinkNumber();
 
        if (str == "fsptest") {
            llSay(0, "Script is installed and running in linked prim #" + (string)linkNum);            
        }
        else if (str == "fspbackup") {
            backup();
        }
        else if (str == "fsprestore") {
            restore();
        }
        else if (str == "fspcleanup") {        
            cleanup();                    
        }
        else if (str == "fsprun") {
            process();            
        }
 
    }
}
 
 
 
// END //
