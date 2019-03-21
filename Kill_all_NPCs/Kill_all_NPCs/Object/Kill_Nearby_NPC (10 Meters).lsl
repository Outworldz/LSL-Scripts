// :CATEGORY:OpenSim NPC
// :NAME:Kill_all_NPCs
// :AUTHOR:Fritigern and Ferd
// :KEYWORDS:
// :CREATED:2015-01-23 00:05:57
// :EDITED:2015-01-23
// :ID:422
// :NUM:1713
// :REV:1.0
// :WORLD:OpenSim
// :DESCRIPTION:
// Mods by Fred Beckhusen (Ferd Frederix) to onlykill NPCS withing 10 meters
// Based on http://opensimulator.org/wiki/User:Fritigern/Scripts#NPC_stuff
// sim-wide NPC killer
// License: http://creativecommons.org/licenses/by-sa/2.5/
// You are free:
// to Share — to copy, distribute and transmit the work
// to Remix — to adapt the work
// to make commercial use of the work
// 
// kill all of NPCs in the nearby area 
// Attempts to kill agents too, but it will silently fail
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
            list detail = llGetObjectDetails((key) target, [OBJECT_POS]);
            vector pos = llList2Vector(detail, 0);
            if (llVecDist( pos, llGetPos()) < 10 ){
            
                osNpcRemove(target);
                llSay(0,"NPC Removal: Target "+target);
            }
        }
    }
}
