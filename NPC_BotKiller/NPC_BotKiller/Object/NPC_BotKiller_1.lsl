// :CATEGORY:OpenSim NPC
// :NAME:NPC_BotKiller
// :AUTHOR:DZ
// :CREATED:2013-08-02 12:52:56.077
// :EDITED:2013-09-18 15:38:58
// :ID:571
// :NUM:784
// :REV:1.0
// :WORLD:OpenSim
// :DESCRIPTION:
Original script from http://opensimulator.org/wiki/User:Dz/NPC_Scripts
// 
// License: 
// You are free:
// to Share — to copy, distribute and transmit the work
// to Remix — to adapt the work
// to make commercial use of the work
See http://creativecommons.org/licenses/by-sa/2.5/
// :CODE:
/ OpenSimian BotKiller
// Kills all the NPC's in the region.. Please use with discretion.
// Iterate over a list of avatar keys, using them as an arguments to osNpcRemove
// Add a delay to the timer if sim performance starts to drag during logouts
// Feel free to use/distribute/modify to suit your needs
// Prepared for transfer to MOSES grid -  D Osborn  5.3.2013
 
integer who2kill = 0;
integer howmany = 0;
list avatars = [];
 
default
{
    state_entry()
    {
       llSetText("waiting ", <1.0, 0.0, 0.0>, 1.0);
    }
 
    touch_end(integer total_number)  // should not change state in touch_start events....
    {
       avatars = osGetAvatarList();
       howmany = llGetListLength(avatars)/3;
       state KillThem;
    }
 
    changed(integer change)    //  Reset on region restart
    {
       if (change & CHANGED_REGION_RESTART)
       {
           llResetScript();
       }
    }
}
 
state KillThem
 
{
    state_entry()
    {
       llSetText("Processing ", <1.0, 0.0, 0.0>, 1.0);
       llSetTimerEvent(3.0);                            // remove 1 every 3 seconds to minimize performance impact
    }
 
    timer()
    {
       osNpcRemove(llList2Key(avatars,who2kill*3));  
       llSetText("Removed so far : " + (string) (who2kill + 1), <1.0, 0.0, 0.0>, 1.0);
 
       who2kill++;       
       if(who2kill>=howmany)
           state default;          
 
       llSetTimerEvent(3.0/ llGetRegionTimeDilation());   // Use timedilation to add to the delay if lagging
    }
 
 
    touch_end(integer interrupt)   // abort by touching the object while it is processing
    {
       llResetScript();
    }
 
    changed(integer change)
    {
       if (change & CHANGED_REGION_RESTART)
       {
           llResetScript();
       }
    }
}
