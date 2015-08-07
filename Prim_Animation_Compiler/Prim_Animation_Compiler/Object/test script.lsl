// :CATEGORY:Prim
// :NAME:Prim_Animation_Compiler
// :AUTHOR:Ferd Frederix
// :CREATED:2013-02-25 10:47:09.853
// :EDITED:2013-09-18 15:39:00
// :ID:648
// :NUM:880
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Simple trigger script example. Alternates playing animation named sit and Wag when you touch a prim,
// :CODE:
integer flag;
default
{
    touch_start(integer total_number)
    {
        if (flag++ %2 == 0)
        {
            llMessageLinked(LINK_SET,1,"wag",""); // wag tail
        }
        else
            llMessageLinked(LINK_SET,1,"sit","");   // sit on rear     
    }
}
