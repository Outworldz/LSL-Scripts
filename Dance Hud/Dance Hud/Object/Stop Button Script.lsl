// :SHOW:
// :CATEGORY:Dance
// :NAME:Dance Hud
// :AUTHOR:Anonymous
// :KEYWORDS:
// :CREATED:2019-04-04 20:49:27
// :EDITED:2019-04-04  19:49:27
// :ID:1120
// :NUM:1970
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Dance Hud Stop Button
// :CODE:
integer active = FALSE;

default
{
    state_entry()
    {
        llSetColor(<1,0,0>, ALL_SIDES);
    }
    
    touch_start(integer num)
    {
        if (active) {
            llMessageLinked(LINK_ROOT, 0, "doff", NULL_KEY);
            active = FALSE;
            llSetColor(<1,0,0>, ALL_SIDES);
        } else {
            llMessageLinked(LINK_ROOT, 0, "don", NULL_KEY);
            active = TRUE;
            llSetColor(<0,1,0>, ALL_SIDES);
        }
    }
    
    on_rez(integer sparam)
    {
        llResetScript();
    }
}
