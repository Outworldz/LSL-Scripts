// :CATEGORY:Texture
// :NAME:texture_rotate__with_llRotateTexture
// :AUTHOR:Green Fate
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:06
// :ID:878
// :NUM:1238
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// texture rotate  with llRotateTexture + timer example.lsl
// :CODE:

// chunk of code that rotate a texture.
// Green Fate + ixO Baskerville

float rad = 0.0;
float radinc = 0.05;
float time_inc = .2;
float rotspeed = 3.2;

default
{    

    state_entry()
    {
//    llSetTimerEvent( time_inc );
        llSetTextureAnim(ANIM_ON | ROTATE | LOOP | SMOOTH, ALL_SIDES, 0, 0, 0, 100, rotspeed);
    }
    
    timer()
    {
        if ( rad < 6.28318530717958 )
        {
            rad = rad + radinc;
        }
        else
        {
        // llSay(0, "6.28318530717958 or something");
        rad = 0;
        }
//        llRotateTexture( rad, 0 );    
    }
}// END //
