// :CATEGORY:OpenSim NPC
// :NAME:Dance_all_NPC
// :AUTHOR:Fritigern
// :CREATED:2013-07-30 13:36:07.930
// :EDITED:2013-09-18 15:38:51
// :ID:210
// :NUM:284
// :REV:1.0
// :WORLD:OpenSim
// :DESCRIPTION:
//From http://opensimulator.org/wiki/User:Fritigern/Scripts#NPC_stuff// License: http://creativecommons.org/licenses/by-sa/2.5/// You are free:// to Share — to copy, distribute and transmit the work// to Remix — to adapt the work// to make commercial use of the work
// 
// Get your NPCs (and whoever else may be in the region) to dance.
// To make this work, create a prim, fill it with (dance) animations, put this script in it, click the prim, and PAR-TAY!.
// :CODE:
list avies;
list thedance;
list olddance;
list dancers;
integer duration = 10;
 
EverybodyDanceNow()
{
    llSetText("Dancing",<1,1,1>,1);
    avies = osGetAvatarList();
    integer n;
 
    if(llGetListLength(thedance) != 0)
    {
        for(n=0;n<llGetListLength(thedance);++n)
        {
            olddance = olddance + llList2String(thedance,n);
        }
    }
 
 
    for(n=0;n<llGetListLength(avies);n=n+3)
    {
        integer animnum = llFloor(llFrand(llGetInventoryNumber(INVENTORY_ANIMATION)));
        string animation = llGetInventoryName(INVENTORY_ANIMATION,animnum);
        key avieID = llList2Key(avies,n);
        dancers = dancers + [avieID];
        thedance = thedance + [animation];
    }
 
    for(n=0;n<llGetListLength(dancers);++n)
    {
        key avie = llList2Key(dancers,n);
        string dance = llList2String(thedance,n);
        osAvatarPlayAnimation(avie, dance);
 
    }
}
 
Stop_HammerTime()
{
    llSetText("Stopped Dancing",<1,1,1>,1);
    integer n;
    for(n=0;n<llGetListLength(dancers);++n)
    {
        key avie = llList2Key(dancers,n);
        string dance = llList2String(thedance,n);
        osAvatarStopAnimation(avie, dance);
    }
        dancers = [];
        thedance = [];
        avies = [];
}
 
default
{    
    touch_start(integer numdet)
    {
        state on;
    }
}
 
state on
{
    state_entry()
    {
        EverybodyDanceNow();
        llSetTimerEvent(duration);
    }
 
    touch_start(integer numdet)
    {
        state off;
    }
 
    timer()
    {
        EverybodyDanceNow();
    }
}
 
 
state off
{
    state_entry()
    {
        Stop_HammerTime();
    }
 
    touch_start(integer numdet)
    {
        state on;
    }
}
