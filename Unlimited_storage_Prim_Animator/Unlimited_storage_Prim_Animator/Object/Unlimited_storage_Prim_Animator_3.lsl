// :CATEGORY:Animation
// :NAME:Unlimited_storage_Prim_Animator
// :AUTHOR:Ferd Frederix
// :CREATED:2011-09-07 21:37:12.857
// :EDITED:2013-09-18 15:39:08
// :ID:936
// :NUM:1346
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// This is an example script to loop 3 animations named 'start', 'baby1', and 'baby2'
// :CODE:
integer counter;

list animations = ["start","baby1","baby2"];
default
{
    state_entry()
    {
        llSetTimerEvent(2);
    }
    timer()
    {
        string name = llList2String(animations, counter);
        llMessageLinked(LINK_SET,1,name,"");

        if (counter++ >= llGetListLength(animations)-1)
            counter = 0;

    }
}
