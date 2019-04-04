// :SHOW:
// :CATEGORY:Animation
// :NAME:Dance Hud
// :AUTHOR:Anonymous
// :KEYWORDS:
// :CREATED:2019-03-21 14:41:23
// :EDITED:2019-03-21  13:41:23
// :ID:1117
// :NUM:1960
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Animation HUD Next button
// :CODE:

default
{
    touch_start(integer total_number)
    {
        llMessageLinked(LINK_ROOT, 0, "dnext", NULL_KEY);
    }
}
