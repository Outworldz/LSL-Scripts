// :CATEGORY:HUD
// :NAME:Hud_Hider
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:55
// :ID:393
// :NUM:546
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Hud Hider.lsl
// :CODE:

integer visible = TRUE;

default
{
    touch_start(integer num)
    {
        if(visible == FALSE)
        {
            llMessageLinked(LINK_SET,0,"SHOW",NULL_KEY);
            visible = TRUE;
            return;
        }
        if(visible == TRUE)
        {
            llMessageLinked(LINK_SET,0,"HIDE",NULL_KEY);
            visible = FALSE;
            return;
        }
    }
}
        // END //
