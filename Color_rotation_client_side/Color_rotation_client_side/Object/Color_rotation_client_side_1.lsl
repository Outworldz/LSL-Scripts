// :CATEGORY:Color
// :NAME:Color_rotation_client_side
// :AUTHOR:Jeffrey Gomez
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:50
// :ID:195
// :NUM:268
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Color rotation client side.lsl
// :CODE:

//Passive, Client-Side Color-Changer by Jeffrey Gomez
//Please use this. It saves a lot of color-swap grief. =D

key colorpallete = "0c23e2ea-a6aa-4ee5-7d86-efafa4b9e221";
//Basic image I uploaded that defines the useable colors.
//For those wondering, this is the MS Paint default pallete, minus black :P
default
{
    state_entry()
    {
        llSetTexture(colorpallete,ALL_SIDES);
        llSetTextureAnim(ANIM_ON | LOOP,ALL_SIDES,5,5,0,0,1);
    }
}// END //
