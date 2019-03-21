// :CATEGORY:Pet
// :NAME:Mesh_Frog_Project
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2012-05-11 16:43:46.393
// :EDITED:2013-09-18 15:38:57
// :ID:512
// :NUM:693
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Leg test script
// :CODE:
default
{
    state_entry()
    {

    }


    touch_start(integer who)
    {

        llMessageLinked(LINK_SET,0,"SIT","");
        llSleep(2);

        llMessageLinked(LINK_SET,0,"HOP","");
        llSleep(2);

        llMessageLinked(LINK_SET,0,"SIT","");
        llSleep(2);

        llMessageLinked(LINK_SET,0,"EAT","");
        llSleep(2);

        llMessageLinked(LINK_SET,0,"SIT","");
        llSleep(2);
    }

}
