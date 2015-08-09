// :CATEGORY:OpenSim NPC
// :NAME:Populate_a_region_with_random_NPC
// :AUTHOR:Fritigern
// :CREATED:2013-07-30 13:44:43.853
// :EDITED:2013-09-18 15:39:00
// :ID:638
// :NUM:867
// :REV:1.0
// :WORLD:OpenSim
// :DESCRIPTION:
//http://opensimulator.org/wiki/User:Fritigern/Scripts#NPC_stuff// touch to create an NPC at a random position in your region. // The NPC will be created at 100m up in the air, just for dramatic effect :-)// Set npcNum to how many NPCs you want.// // License: http://creativecommons.org/licenses/by-sa/2.5/
// You are free:
// to Share — to copy, distribute and transmit the work
// to Remix — to adapt the work
// to make commercial use of the work
//  
// :CODE:
key npc;
vector toucherPos;
integer n;
integer i;
integer npcNum = 5;
integer wait = 0;
string toucher;
key toucherkey;
 
default
{
    state_entry()
    {
        llSetText("Populate this region",<1,1,1>,1);
    }
 
    touch_start(integer number)
    {
        toucher = llKey2Name(llDetectedKey(0));
        toucherkey = llDetectedKey(0);
        state raise;
    }
}
 
state raise
{
    state_entry()
    {
        for (n=0;n<npcNum;++n)
        {
            llSetText("Creating NPC #"+(string)(n+1)+"...",<1,1,1>,1);
            vector npcPos = <llFrand(255),llFrand(255),100>;
            osNpcCreate(toucher, "", npcPos, toucherkey);
 
            if (wait)
            {
                for (i=wait;i>0;--i)
                {
                    llSetText("Creating NPC #"+(string)(n+2)+" in "+(string)i+"...",<1,1,1>,1);
                    llSleep(1);                
                }
            }
        }
        llSetText("Done",<1,1,1>,1);
    }
 
    touch_start(integer number)
    {
        llSay(0,"Removing all NPCs from this scene!");
        list avies = osGetAvatarList();
        for(n=0;n<llGetListLength(avies);n=n+3)
        {
            llOwnerSay("Attempting to remove "+llList2String(avies,n+2)+" with UUID "+llList2String(avies,n+0));
            osNpcRemove((key)llList2Key(avies,n));
        }
 
        llResetScript();
    }
}
