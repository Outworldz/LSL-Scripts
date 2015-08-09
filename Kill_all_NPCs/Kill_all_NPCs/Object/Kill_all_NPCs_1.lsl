// :CATEGORY:OpenSim NPC
// :NAME:Kill_all_NPCs
// :AUTHOR:Fritigern
// :CREATED:2013-07-30 13:37:33.100
// :EDITED:2013-09-18 15:38:55
// :ID:422
// :NUM:578
// :REV:1.0
// :WORLD:OpenSim
// :DESCRIPTION:
//http://opensimulator.org/wiki/User:Fritigern/Scripts#NPC_stuff// sim-wide NPC killer// License: http://creativecommons.org/licenses/by-sa/2.5/// You are free:// to Share — to copy, distribute and transmit the work// to Remix — to adapt the work// to make commercial use of the work
// 
// kill all of NPCs in this SIM
// Attempts to kill agents too, but it will silently fail
// http://opensimulator.org/wiki/OsNpcRemove
// Unfortunatly, from time to time, one or more NPCs do get stuck in the scene, and can not be removed. They can't be removed by this script either.
// :CODE:

default
{
    touch_start(integer number)
    {
        list avatars = llList2ListStrided(osGetAvatarList(), 0, -1, 3);
        integer i;
        llSay(0,"NPC Removal: No avatars will be harmed or removed in this process!");
        for (i=0; i<llGetListLength(avatars); i++)
        {
            string target = llList2String(avatars, i);
            osNpcRemove(target);
            llSay(0,"NPC Removal: Target "+target);
        }
    }
}
