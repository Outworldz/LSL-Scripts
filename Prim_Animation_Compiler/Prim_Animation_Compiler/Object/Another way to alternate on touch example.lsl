// :SHOW:
// :CATEGORY:Prim
// :NAME:Prim_Animation_Compiler
// :AUTHOR:Ferd Frederix
// :KEYWORDS: Animation, Puppeteer
// :CREATED:2013-02-25 10:47:09.853
// :EDITED:2015-08-07  14:27:52
// :ID:648
// :NUM:880
// :REV:1.1
// :WORLD:Second Life, Opensim
// :DESCRIPTION:
// Simple trigger script example. Alternates playing animation named sit and wag when you touch a prim.
// It uses a different way to alternate the action than the Aternating Up and Down example
// It divides an ever-increasing number (flag++) by 2, ( flag++ % 2)  and looks at the remainder (%).   For example, 2/2 = 1 with 0 remaining, 3/2 = 1 with a remainder of 0.5.  
// so this means it detects ODD or EVEN numbers, which occur ever other touch. Its dioes the same as (x = ~x) in a more general way.  You could have it do this every fifth touch with (flag++ % 5), as another example.
// :CODE:

integer flag; // this increments forever,sort of, well, for all practical purposes.

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
