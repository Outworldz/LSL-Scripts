// :CATEGORY:ANimation
// :NAME:Flame
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:53
// :ID:313
// :NUM:412
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Flame.lsl
// :CODE:

integer animOn = TRUE; //Set to FALSE and call initAnim() again to stop the animation.

//Effect parameters: (can be put in list together, to make animation have all of said effects)

//LOOP - loops the animation
//SMOOTH - plays animation smoothly
//REVERSE - plays animation in reverse
//PING_PONG - plays animation in one direction, then cycles in the opposite direction

list effects = [SMOOTH,LOOP];

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
        llSetTextureAnim(ANIM_ON|params,face,sideX,sideY,
        start,length,speed);
    }
    else
    {
        llSetTextureAnim(0,face,sideX,sideY,
        start,length,speed);
    }
}


default
{
    state_entry()
    {
        initAnim();
    }
}
// END //
