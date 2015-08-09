// :CATEGORY:XS Pet
// :NAME:XS Pet Robot
// :AUTHOR:Ferd Frederix
// :KEYWORDS: Pet,XS,breed,breedable,companion,Ozimal,Meeroo,Amaretto,critter,Fennux,Pets
// :CREATED:2013-09-06
// :EDITED:2014-01-30 12:24:20
// :ID:988
// :NUM:1437
// :REV:0.50
// :WORLD:Second Life, OpenSim
// :DESCRIPTION:
//  XS Pet globe rotator
// :CODE:



default
{
    state_entry()
    {   
        // llSetTextureAnim() is a function that animates a texture on a face.
        llSetTextureAnim(ANIM_ON | SMOOTH | LOOP, ALL_SIDES,0,1,1.0, 0.5,1);
                 // animate the script to scroll across all the faces.
    }
    
}

