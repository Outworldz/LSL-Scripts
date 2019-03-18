// :CATEGORY:XS Pet
// :NAME:Breedable_pet_eye_scripts
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2012-08-16 10:21:14.630
// :EDITED:2013-09-17 21:48:30
// :ID:116
// :NUM:173
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// This script uses animated eyes made from GIF files.  There is an article on how to use it at <a href="http://www.outworldz.com/secondlife/posts/breedable-pet-robot/pet-Robot.htm">http://www.outworldz.com/secondlife/posts/breedable-pet-robot/pet-Robot.htm</a>
// :CODE:
// xs_eye script
// Version 0.32  12-03-2011


// blinking eye plug in script.lsl
// Use this with eyes made by the Gif2SL converter
/////////////////////////////////////////////////////////////////////
// This code is licensed as Creative Commons Attribution/NonCommercial/Share Alike

// See http://creativecommons.org/licenses/by-nc-sa/3.0/
// Noncommercial -- You may not use this work for commercial purposes
// If you alter, transform, or build upon this work, you may distribute the resulting work only under the same or similar license to this one.
// This means that you cannot sell this code but you may share this code.
// You must attribute authorship to me and leave this notice intact.
//
// Exception: I am allowing this script to be sold inside an original build.
// You are not selling the script, you are selling the build.
// Fred Beckhusen (Ferd Frederix)


// Put any texture converted by gif_2_SL_animation_v0.6.exe into a prim with this script to get it to play back automatically as a movie
//

integer nTextures;

integer animOn = TRUE; //Set to FALSE and call initAnim() again to stop the animation.
list effects = [LOOP];  // LOOP for GIF89 movies
integer movement = 0;
integer face = ALL_SIDES; //Number representing the side to activate the animation on.
integer sideX = 1; //Represents how many horizontal images (frames) are contained in your texture.
integer sideY = 1; //Same as sideX, except represents vertical images (frames).
float start = 0.0; //Frame to start animation on. (0 to start at the first frame of the texture)
float length = 0.0; //Number of frames to animate, set to 0 to animate all frames.
float speed = 10.0; //Frames per second to play.


integer i;

fetch()
{
    nTextures = llGetInventoryNumber(INVENTORY_TEXTURE);
    string texture = llGetInventoryName(INVENTORY_TEXTURE,i);
    string texture1 = llGetInventoryName(INVENTORY_TEXTURE,i+1);

    llSetTextureAnim(LOOP,ALL_SIDES,1,1,     1,1,1);
    llSetTexture(texture,ALL_SIDES);

    llSleep(llFrand(5));

    list data  = llParseString2List(texture1,[";"],[]);
    string X = llList2String(data,1);
    string Y = llList2String(data,2);
    string Z = llList2String(data,3);

    sideX = (integer) X;
    sideY = (integer) Y;
    speed = (float) Z;

    float  tot = (float) (sideX * sideY);

    llSetTextureAnim(ANIM_ON|LOOP,ALL_SIDES,sideX,sideY,start,length,speed);
    llSetTexture(texture1,ALL_SIDES);
    llSetTimerEvent(tot/10);
}


default
{
    state_entry()
    {
        llSetTimerEvent(1);
    }
    // touch the prim to switch to a pair of flipping textures, one of them a movie
    touch_start(integer p)
    {
        i+=2;
        if (i >= nTextures)
        {
            i = 0;
        }
    }

    timer()
    {
        fetch();
    }

}

