// :CATEGORY:HUD
// :NAME:Selkie
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:02
// :ID:737
// :NUM:1008
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Hus positioner
// :CODE:

// Author: Ferd Frederix
// This improved HUD positioner is updated for Viewer 2.0. It will place your HUD in any of the 4 corners, and it moves Center and Center 2 to the left and right edges.   It also allows the user to re-position the HUD, and it will remember their movements.   Detach and re-attach will place it at the remembered position.

// Downloaded from : http://www.outworldz.com/cgi/freescripts.plx?ID=1453

// This program is free software; you can redistribute it and/or modify it.
// Additional Licenes may apply that prevent you from selling this code
// You must leave any author credits and any headers intact in any script you use or publish.
///////////////////////////////////////////////////////////////////////////////////////////////////
// If you don't like these restrictions and licenses, then don't use these scripts.
//////////////////////// ORIGINAL AUTHORS CODE BEGINS ////////////////////////////////////////////


// 
//The HUD positioner is designed to set the HUD into a 'preferred' position whenever it get attached.   If the user moves it, and re-attaches it to the same spot, it ignores the hard-coded settings.   It keeps a list of offsets from the top, bottom, left and right and moves the prim when it is first attached by that offset.  Ity also forces the prim to face in a know direction, just in case it is accidentally rotated by the end-user.
//
//If the HUD pops off-screen, wear another HUD, press Ctrl-3 to go into edit mode, click the other HUD, and use the scroll wheel to zoom out.  You will see a line representing the edge of the 'normal' screen, and outside of it, hopefully, you will see the misplaced HUD.  You can then grab it and move it back on-screen.
//
//This script was originally designed for a small HUD.  You will probably need to edit the offsets that are in the script unless your HUD is also very small.     The best way to do this is to wear the HUD, edit it, and look at the coordinates that appear in screen.   These are offsets from the 'default' positions of the viewer.   Move the prim to the correct position, and notice the X and Y and Z numbers change?   You will need to change the Y and Z those numbers and put them in this scripts if you HUD is to go into another position.
//
//For example, if you attach something to the right side top or the right side bottom, the prim's center will normally be along the right edge.   This script moves it to the left by trYoffset = 0.185 when at the top right, and brYoffset=0.125 when at the bottom right edge so that it can clear the little hump in some viewers. Another example is attaching to the very bottom, which is really bottom center.  The script will move the prim vertically by BVerticalOffset = 0.080 to clear the nav bars, and leave the Y axis alone by adding to Y a 0.
//
//
// ______           _  ______            _           _
// |  ___|         | | |  ___|          | |         (_)
// | |_ ___ _ __ __| | | |_ _ __ ___  __| | ___ _ __ ___  __
// |  _/ _ \ '__/ _` | |  _| '__/ _ \/ _` |/ _ \ '__| \ \/ /
// | ||  __/ | | (_| | | | | | |  __/ (_| |  __/ |  | |>  <
// \_| \___|_|  \__,_| \_| |_|  \___|\__,_|\___|_|  |_/_/\_\
//
// fred@mitsi.com
// author Ferd Frederix
//

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

            rotation  myrot = llEuler2Rot( <0.0,90.0,270.0> * DEG_TO_RAD);
            llSetLocalRot(myrot);


        }
    }


}




