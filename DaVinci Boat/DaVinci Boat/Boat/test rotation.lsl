// :CATEGORY:Boat
// :NAME:DaVinci Boat
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-08
// :EDITED:2013-09-18 15:38:51
// :ID:220
// :NUM:303
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// tests for the rotation of the wheels and stuff
// :CODE:
default
{
    state_entry()
    {
        llSay(0, "test rotation script");
    }

    touch_start(integer total_number)
    {
        llMessageLinked(LINK_SET,10,"spin","");
        llSleep(10);
        llMessageLinked(LINK_SET,0,"spin","");
    }
}
