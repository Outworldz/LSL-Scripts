// :CATEGORY:Rezzers
// :NAME:Jutsu_Rezzer
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:55
// :ID:415
// :NUM:571
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Jutsu Rezzer.lsl
// :CODE:

default {

    on_rez( integer Parameter ) { llResetScript(); }
    
    state_entry() { llListen( 0, "", llGetOwner(), "Containment Jutsu" ); }
    
    listen( integer Channel, string Name, key Id, string Message ) {
    
        vector position = llGetPos();
        rotation angle = llGetRot();
        vector offset = <1.0, 0, 0>;

        llRezObject( "Containment", position + (offset * angle), ZERO_VECTOR, angle, 0 );
    }
} // END //
