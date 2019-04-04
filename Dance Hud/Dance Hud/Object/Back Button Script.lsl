// :SHOW:
// :CATEGORY:Animation HUD Previous Button
// :NAME:Dance Hud
// :AUTHOR:Anonymous
// :KEYWORDS:
// :CREATED:2019-03-21 14:41:56
// :EDITED:2019-03-21  13:41:56
// :ID:1117
// :NUM:1961
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Animation HUD Previous Button
// :CODE:
default
{
    touch_start(integer total_number)
    {
        llMessageLinked(LINK_ROOT, 0, "dprev", NULL_KEY);
    }
}
