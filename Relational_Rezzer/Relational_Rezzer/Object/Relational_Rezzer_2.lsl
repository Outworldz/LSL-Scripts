// :CATEGORY:Rezzers
// :NAME:Relational_Rezzer
// :AUTHOR:Innula Zenovka
// :CREATED:2010-11-16 11:22:38.940
// :EDITED:2013-09-18 15:39:01
// :ID:690
// :NUM:940
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Helper Script
// :CODE:
//reads position and rotation
default
{
    state_entry()
    {
        llOwnerSay((string)llGetPos()+" "+(string)llGetRot());
        llRemoveInventory(llGetScriptName());
    }

  
}
