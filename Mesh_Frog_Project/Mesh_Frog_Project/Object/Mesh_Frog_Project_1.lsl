// :CATEGORY:Pet
// :NAME:Mesh_Frog_Project
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2012-05-11 16:43:46.393
// :EDITED:2013-09-18 15:38:57
// :ID:512
// :NUM:685
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Bug Legs script
// :CODE:
//Put any texture converted by gif_2_SL_animation_v0.6.exe into a prim with this script to get it to play back automatically as a movie.  You can get the GIF 2 SL executable at http://secondlife.mitsi.com/download/
//

// Downloaded from : http://www.outworldz.com/cgi/freescripts.plx?ID=1594

// This program is free software; you can redistribute it and/or modify it.
// Additional Licenes may apply that prevent you from selling this code
// and these licenses may require you to publish any changes you make on request.
//
// There are literally thousands of hours of work in these scripts. Please respect
// the creators wishes and follow their license requirements.
//
// Any License information included herein must be included in any script you give out or use.
// Licenses are included in the script or comments by the original author, in which case
// the authors license must be followed.

// A GNU license, if attached by the author, means the original code must be FREE.
// Modifications can be made and products sold with the scripts in them.
// You cannot attach a license to make this GNU License
// more or less restrictive.  see http://www.gnu.org/copyleft/gpl.html

// Creative Commons licenses apply to all scripts from the Second Life
// wiki and script library and are Copyrighted by Linden Lab. See
// http://creativecommons.org/licenses/

// Please leave any author credits and headers intact in any script you use or publish.
// If you don't like these restrictions, then don't use these scripts.
//////////////////////// ORIGINAL AUTHORS CODE BEGINS ////////////////////////////////////////////
// Put any texture converted by gif_2_SL_animation_v0.6.exe into a prim with this script to get it to play back automatically as a movie


integer animOn = TRUE; //Set to FALSE and call initAnim() again to stop the animation.
//Effect parameters: (can be put in list together, to make animation have all of said effects)
//LOOP - loops the animation
//SMOOTH - plays animation smoothly
//REVERSE - plays animation in reverse
//PING_PONG - plays animation in one direction, then cycles in the opposite direction
list effects = [LOOP];  // LOOP for GIF89 movies
//Movement parameters (choose one):
//ROTATE - Rotates the texture
//SCALE - Scales the texture
//Set movement to 0 to slide animation in the X direction, without any special movement.
integer movement = 0;
integer face = ALL_SIDES; //Number representing the side to activate the animation on.
integer sideX = 1; //Represents how many horizontal images (frames) are contained in your texture.
integer sideY = 1; //Same as sideX, except represents vertical images (frames).
float start = 0.0; //Frame to start animation on. (0 to start at the first frame of the texture)
float length = 0.0; //Number of frames to animate, set to 0 to animate all frames.
float speed = 10.0; //Frames per second to play.
initAnim() //Call this when you want to change something in the texture animation.
{
    if(animOn)
    {
        integer effectBits;
        integer i;
        for(i = 0; i < llGetListLength(effects); i++)
        {
            effectBits = (effectBits | llList2Integer(effects,i));
        }
        integer params = (effectBits|movement);
        llSetTextureAnim(ANIM_ON|params,face,sideX,sideY,     start,length,speed);
    }
    else
    {
        llSetTextureAnim(0,face,sideX,sideY, start,length,speed);
    }
}

fetch()
{
    string texture = llGetInventoryName(INVENTORY_TEXTURE,0);
    llSetTexture(texture,ALL_SIDES);
    list data  = llParseString2List(texture,[";"],[]);
    llOwnerSay( llDumpList2String(data ,","));
    string X = llList2String(data,1);
    string Y = llList2String(data,2);
    string Z = llList2String(data,3);

    // llOwnerSay("X=" + X + " Y=" + Y + " Z = " + (string) Z);

    sideX = (integer) X;
    sideY = (integer) Y;
    speed = (float) Z;
    if (speed)
        initAnim();
}

default
{
    state_entry()
    {
        fetch();
    }
    changed(integer what)
    {
        if (what & CHANGED_INVENTORY)
        {
            fetch();
        }
    }
}


