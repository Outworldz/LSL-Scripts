// :SHOW:
// :CATEGORY:Dance
// :NAME:Dance Hud
// :AUTHOR:Anonymous
// :KEYWORDS:
// :CREATED:2019-04-04 20:49:09
// :EDITED:2019-04-04  19:49:09
// :ID:1120
// :NUM:1969
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Dance Hud Prev
// :CODE:
default
{
    touch_start(integer total_number)
    {
        llMessageLinked(LINK_ROOT, 0, "dprev", NULL_KEY);
    }
}
