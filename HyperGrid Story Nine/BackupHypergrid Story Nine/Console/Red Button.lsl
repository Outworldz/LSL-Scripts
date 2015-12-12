//:AUTHOR: Ferd Frederix
//:DESCRIPTION:
// Button Script for console
//:CODE:

// chose a direction for one of 8 buttons.

default
{
    touch_start(integer total_number)
    {
        llMessageLinked(LINK_SET,2,"go","");
    }
}