// :CATEGORY:Prim
// :NAME:Prim_Animator_using_one_script
// :AUTHOR:Ferd Frederix
// :CREATED:2010-10-23 21:23:45.047
// :EDITED:2013-09-18 15:39:00
// :ID:649
// :NUM:883
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// A simple touch and playback script. When touched, it plays back animations named 'stand' and 'sit' in order, then the next time it is clicked, it plays 'sit'.
// :CODE:
integer flag;

default
{
    touch_start(integer total_number)
    {
        if (flag++ %2 == 0)
        {
            llMessageLinked(LINK_SET,1,"stand",""); // stand on all 4's
            llMessageLinked(LINK_SET,1,"wag",""); // stand on all 4's
        }
        else
            llMessageLinked(LINK_SET,1,"sit","");   // sit on rear     
    }
}
