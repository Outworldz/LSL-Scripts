// :CATEGORY:XS Pet
// :NAME:Texture_server_for_XS_Pets
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2012-08-16 11:11:55.200
// :EDITED:2013-09-17 21:48:44
// :ID:879
// :NUM:1241
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// test code for texture server.   Put this into a set of prims with the pet texture script and touch it.   Any prim with the same name as a texture in the server will change to that texture.
// :CODE:
// test code to make a pet change textures.
// Just put this in a prim inside the pet, and touch it again and again.
// The pet should change textures on any prim name that
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



integer LINK_TEXTURE = 801;        // ask for a new texture, or paint a color

///////// end global Link constants ////////

vector colour1 = <1,1,1>;
vector colour2 = <0,0,0>;
integer sex = 1;
integer shine = 0;
float glow = 0.0;


default
{

    touch_start(integer total_number)
    {

        colour1.x = llFrand(1.0);   // pick a random texture 
        llOwnerSay("Breed Param:" + (string) colour1.x);

        string msg = (string) colour1 + "^" +
            (string) colour2 + "^" +
            (string) sex + "^" +
            (string) shine + "^" +
            (string) glow + "^";

        llMessageLinked(LINK_SET,LINK_TEXTURE,msg,NULL_KEY);

    }
}
