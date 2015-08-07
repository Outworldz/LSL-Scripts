// :CATEGORY:HUD
// :NAME:Nonrotating_HUD_positioner
// :AUTHOR:Ferd Frederix
// :CREATED:2012-07-08 17:41:08.030
// :EDITED:2013-09-18 15:38:58
// :ID:562
// :NUM:766
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Nonrotating_HUD_positioner
// :CODE:

integer  lasttarget;

default
{

    attach( key id)
    {

        if (id)
        {
            integer target = llGetAttached();

            vector position = llGetLocalPos();

            if (target == lasttarget )
                return;

            lasttarget = target; // save the position we just set

            float Y = 0.0;
            float Z = 0.0;
            float trYoffset = 0.185;     // right edge
            float brYoffset = 0.125;     // right edge
            float otherYoffset = 0.080;      // move right from left edge
            float VerticalOffset = 0.2;        // move down for room for hover text
            float CenterOffset = 0.7;        // left and right center offset to left and right edge
            float BVerticalOffset = 0.080;     // Bottom Z.


            if (target == ATTACH_HUD_CENTER_2)
            {
                Y = CenterOffset; Z = 0.0;       // move to left edge
            }
            else if (target == ATTACH_HUD_TOP_RIGHT)
            {
                Y = trYoffset; Z = -VerticalOffset;      // down for room for hovertext
            }
            else if (target == ATTACH_HUD_TOP_CENTER)
            {
                Y = 0; Z = -VerticalOffset;
            }
            else if (target == ATTACH_HUD_TOP_LEFT)
            {
                Y = -otherYoffset; Z = -VerticalOffset;
            }
            else if (target == ATTACH_HUD_CENTER_1)
            {
                Y = -CenterOffset; Z = 0.0;      // move to right edge
            }
            else if (target == ATTACH_HUD_BOTTOM_LEFT)
            {
                Y = -otherYoffset; Z = BVerticalOffset;
            }
            else if (target == ATTACH_HUD_BOTTOM)
            {
                Y = 0.0; Z = BVerticalOffset;
            }
            else if (target == ATTACH_HUD_BOTTOM_RIGHT)
            {
                Y = brYoffset; Z = BVerticalOffset ;       // 2 x to miss buttons
            }
            else
            {
                llOwnerSay("You must attach this as a HUD");
                return;

            }

            vector newtarget = <0.0,Y,Z>;
            llSetPos (newtarget);

        }
    }


}


