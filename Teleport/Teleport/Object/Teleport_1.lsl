// :CATEGORY:Teleport
// :NAME:Teleport
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:06
// :ID:869
// :NUM:1229
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Teleport.lsl
// :CODE:

key lastAVkey = NULL_KEY;
string fltText = "Teleportation Script";
vector dest = <17.144,154.847,26.836>;
default
{
    state_entry()
    {
        llSetSitText("Teleport");
        llSetText(fltText, <1,1,1>, 1);
        llSitTarget(dest-llGetPos(), <0,0,0,1>);
    }
    touch_start(integer i)
    {
        llSay(0,"Right click me and chose 'Teleport'");
    }
    changed(integer change)
    {
        key currentAVkey = llAvatarOnSitTarget();
        if (currentAVkey != NULL_KEY && lastAVkey == NULL_KEY)
        {
            lastAVkey = currentAVkey;        
            if (!(llGetPermissions() & PERMISSION_TRIGGER_ANIMATION))  
                llRequestPermissions(currentAVkey,PERMISSION_TRIGGER_ANIMATION);
            llUnSit(currentAVkey);
            llStopAnimation("sit");
            llResetScript();
        }
    }
}
// END //
