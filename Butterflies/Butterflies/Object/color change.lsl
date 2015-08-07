// :CATEGORY:Butterflies
// :NAME:Butterflies
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:49
// :ID:133
// :NUM:197
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Butterflies
// :CODE:

// color change

integer count = 0;

default
{
    touch_start(integer total_number)
    {
        string aname  = "wing" + (string) count;
        string abody  = "body" + (string) count;
        llSetTexture(aname,ALL_SIDES);
        llMessageLinked(LINK_SET,0,abody,"");
        count++;
        if (count >9)
            count = 0;
    }
}

