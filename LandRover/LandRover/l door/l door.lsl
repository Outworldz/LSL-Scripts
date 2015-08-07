// :CATEGORY:Vehicle
// :NAME:LandRover
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:56
// :ID:459
// :NUM:616
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Opensim Door script
// :CODE:

integer flag = FALSE;

default
{
    touch_start(integer n)
    {
        flag = ~ flag;
        if (flag)
            llMessageLinked( LINK_ROOT,1,"LO","");
        else
            llMessageLinked( LINK_ROOT,1,"LC","");
       
    }
}
