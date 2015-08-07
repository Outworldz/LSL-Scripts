// :CATEGORY:Picture
// :NAME:L99pictureimages
// :AUTHOR:Dana Moore
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:56
// :ID:450
// :NUM:606
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// L9.09-picture-images.lsl
// :CODE:

// Copyright (c) 2008, Scripting Your World
// All rights reserved.
//
// Scripting Your World
// By Dana Moore, Michael Thome, and Dr. Karen Zita Haigh
// http://syw.fabulo.us
// http://www.amazon.com/Scripting-Your-World-Official-Second/dp/0470339837/
//
// You are permitted to use, share, and adapt this code under the 
// terms of the Creative Commons Public License described in full
// at http://creativecommons.org/licenses/by/3.0/legalcode.
// That means you must keep the credits, do nothing to damage our
// reputation, and do not suggest that we endorse you or your work.

// Listing 9.9: The Images -- One per Prim
default
{
    state_entry() {
        llSetPos(<0,0,0>);
        llSetLocalRot(llEuler2Rot(<0,0,PI>));
    }
    link_message(integer senderNum, integer num, string size, key id){
        vector v = (vector) size;
        float z = v.z / 2.0;
        if (num == llGetLinkNumber() - 2) {
            llSetPrimitiveParams(
                [PRIM_COLOR, ALL_SIDES, <1,1,1>, 0.0,
                 PRIM_POSITION, <0,0, -z>,
                 PRIM_SIZE, (vector)size,
                 PRIM_TEXTURE, ALL_SIDES, (string)id,
                               <1,1,0>, <0,0,0>, 0.0]);
        } else {
            llSetPrimitiveParams(
                [PRIM_COLOR, ALL_SIDES, <1,1,1>, 1.0,
                 PRIM_POSITION, <0,0,z>,
                 PRIM_SIZE, (vector)size]);
        }
    }
}
// END //
