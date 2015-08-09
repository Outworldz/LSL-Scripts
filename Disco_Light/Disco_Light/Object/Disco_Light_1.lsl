// :CATEGORY:Texture
// :NAME:Disco_Light
// :AUTHOR:Melnik Balogh
// :CREATED:2010-05-15 11:35:58.667
// :EDITED:2013-09-18 15:38:51
// :ID:238
// :NUM:326
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Script for a disco light...   // create two (or more)  textures with different color and put them in the root prim// change name in scrip of texture and the time...// // PS: if you know a better way, let me know...
// :CODE:
default
{

    state_entry() {
        llSetTexture("off",0);
        llSetTimerEvent(0.5);
    }
    timer() {

        // set the texture
        llSetTexture("on",0);
        llResetScript();
    }
    
}
