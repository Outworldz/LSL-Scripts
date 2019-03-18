// :CATEGORY:Tandy
// :NAME:Tandy the Nymph
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:06
// :ID:867
// :NUM:1227
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Tandy
// :CODE:

// X-wing script for Tandy the Nymph
// 12-10-2012

// License:
// Copyright (c) 2009, Fred Beckhusen (Ferd Frederix)

// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the follo// conditions:

// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.


integer animOn = TRUE; //Set to FALSE and call initAnim() again to stop the animation.

//Effect parameters: (can be put in list together, to make animation have all of said effects)

//LOOP - loops the animation
//SMOOTH - plays animation smoothly
//REVERSE - plays animation in reverse
//PING_PONG - plays animation in one direction, then cycles in the opposite direction

list effects = [LOOP];

//Movement parameters (choose one):
//ROTATE - Rotates the texture
//SCALE - Scales the texture
//Set movement to 0 to slide animation in the X direction, without any special movement.

integer movement = 0;

integer face = ALL_SIDES; //Number representing the side to activate the animation on.
integer sideX = 1; //Represents how many horizontal images (frames) are contained in your texture.
integer sideY = 2; //Same as sideX, except represents vertical images (frames).
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
        llSetTextureAnim(ANIM_ON|params,face,sideX,sideY,
            start,length,speed);
    }
    else
    {
        llSetTextureAnim(0,face,sideX,sideY,start,length,speed);
    }
}


default
{
    state_entry()
    {
        initAnim();
        llSleep(2);
        llSetAlpha(0.0,ALL_SIDES);
    }

    link_message(integer sender, integer num, string msg, key id)
    {
        if (msg == "on")
        {
            llSetAlpha(1.0,ALL_SIDES);
        } else if (msg == "off")
    {
        llSetAlpha(0.0,ALL_SIDES);
    }

        if (num == 100)
            llSetColor((vector) msg, ALL_SIDES);
    }

    on_rez(integer p)
    {
        llResetScript();
    }
}

