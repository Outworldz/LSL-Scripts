// :SHOW:
// :CATEGORY:Animation
// :NAME:Dance Hud
// :AUTHOR:Anonymous
// :KEYWORDS:
// :CREATED:2019-03-21 14:42:14
// :EDITED:2019-03-21  13:42:14
// :ID:1117
// :NUM:1962
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// DESCRIPTION: []::Animation HUD Root Prim
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
