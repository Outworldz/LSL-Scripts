// :SHOW:
// :CATEGORY:Dance
// :NAME:Dance Hud
// :AUTHOR:Anonymous
// :KEYWORDS:
// :CREATED:2019-04-04 20:48:56
// :EDITED:2019-04-04  19:48:56
// :ID:1120
// :NUM:1968
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Dance Hud Next Button
// :CODE:

default
{
    touch_start(integer total_number)
    {
        llMessageLinked(LINK_ROOT, 0, "dnext", NULL_KEY);
    }
}
