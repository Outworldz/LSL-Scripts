// :CATEGORY:Attachment
// :NAME:Multi_point_attachment
// :AUTHOR:Joannah Cramer
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:57
// :ID:531
// :NUM:716
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Multi point attachment by Joannah Cramer.lsl
// :CODE:

//********************************************************
//This Script was pulled out for you by YadNi Monde from the SL FORUMS at http://forums.secondlife.com/forumdisplay.php?f=15, it is intended to stay FREE by it s author(s) and all the comments here in ORANGE must NOT be deleted. They include notes on how to use it and no help will be provided either by YadNi Monde or it s Author(s). IF YOU DO NOT AGREE WITH THIS JUST DONT USE!!!
//********************************************************







// Multi point attachment by Joannah Cramer
//The idea for script came from this thread (http://forums.secondlife.com/showthread.php?t=145241). Basically, it will memorize offsets and rotations of item separately for each AV attachment point the item is attached to, and restore them as needed. This way rather than having to create separate versions of one attachment aligned for each of possible points, the item maker can just ship single item which will align itself properly in all pre-recorded spots, no matter where exactly the buyer picks to fit it.
//
//How to use: drop into root prim of attachment. Attach it to AV point, move and rotate around until it's positioned the way you like. Detach the item, attach it again to another point, position and rotate like before, detach when it looks fine there too. Repeat the attach-position-detach thing for each of the points you want to have recorded.




// this script memorizes position and rotation of object for each attachment point it was worn on.
// allows easy creation of items like weapons looking proper both in hand and when put on the hip/back,
// skirts and body parts which can be easily switched between lower torso points,
// headphones switching position when moved from head onto chest, etc
//
// USE: put the script in the root prim of your object.
// position and angle of last used attach point will be memorized when the object is detached.
//
// to pre-set positions for multiple points attach the item to selected point, adjust position and angle,
// then detach the item, attach it to another point, adjust position and angle, detach... repeat for all
// desired attachment points.

list    attach_points;
list    attach_offsets;
list    attach_angles;
integer current_point;

default {
    
    state_entry() { current_point = llGetAttached(); } // grab the attach point when script is first put in the item
    
    attach( key Contact ) {
        
        if( Contact != NULL_KEY ) {
            // item is being attached
            current_point = llGetAttached(); // cache the point so correct data can be saved on detach
            integer idx = llListFindList( attach_points, [ current_point ] );
            if( idx != -1 ) {
                // previously used attach point, restore memorized position of object
                llSetPrimitiveParams( [ PRIM_POSITION, llList2Vector( attach_offsets, idx ),
                                        PRIM_ROTATION, llList2Rot( attach_angles, idx ) ] );
            }
            else {
                // a new attach location. remove potential offsets from last recognized attach point.
                llSetPrimitiveParams( [ PRIM_POSITION, ZERO_VECTOR, PRIM_ROTATION, ZERO_ROTATION ] );
            }
        }
        else {
            // item is being detached, store the data
            if( current_point == 0 ) { return; }
            integer idx = llListFindList( attach_points, [ current_point ] );
            vector offset = llGetLocalPos();
            rotation angle = llGetLocalRot();
            if( idx == -1 ) {
                // add new point data
                attach_points  += current_point;
                attach_offsets += offset;
                attach_angles  += angle;
            }
            else {
                // update existing point data
                attach_offsets = llListReplaceList( attach_offsets, [ offset ], idx, idx );
                attach_angles  = llListReplaceList( attach_angles,  [ angle ], idx, idx );
            }
        }
    }
} // END //
