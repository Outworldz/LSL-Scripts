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
