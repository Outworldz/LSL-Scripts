// :CATEGORY:HUD
// :NAME:Scrollable_ImageHUD
// :AUTHOR:Valect
// :CREATED:2012-07-22 10:17:05.477
// :EDITED:2013-09-18 15:39:01
// :ID:725
// :NUM:990
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// The  script goes in the "back" control object
// :CODE:

// rescales the linked set by the specified factor. factor > 1 makes it larger, < 1 smaller 
// example: "/9 2.5" 
vector start_size = <0.2,0.2,0.2>; 

// getting too large will really mess shit up 
vector max_size = <2.0,2.0,2.0>; 

// so will getting to small 
vector min_size = <0.2,0.2,0.2>; 
float pan_dist = 0.3; 

// control link numbers 
// these will need to be changed based on your object 
integer left = 48; 
integer right = 49; 
integer down = 2; 
integer up = 45; 
integer plus = 47; 
integer minus = 46; 
integer reset = 44; 

vector current_scale = start_size; 
key owner = NULL_KEY; 
// this function is so we don't get an odd delay. hopefully will cause this 
// to resize first and avoid a lag issue 
// ** i think the lag issue was due to calling llsetprimitiveparams on EVERY link message, however i like this new solution better 
scale_self(float scale) { 
    list primparams = []; 
    vector new_scale = llGetScale(); 
    new_scale.y = new_scale.y * scale; 
    new_scale.z = new_scale.z * scale; 
    new_scale.x = 0.2; 
    vector new_pos = llGetLocalPos(); 
    new_pos.y = new_pos.y * scale; 
    new_pos.z = new_pos.z * scale; 
    primparams = []; 
    primparams += [PRIM_SIZE, new_scale]; // resize 
    llSetPrimitiveParams(primparams); 
} 
Resize(float scale, integer resize) { 
    scale_self(scale); 
    llMessageLinked(LINK_SET, resize, (string)scale, NULL_KEY);    
} 
calc_zoom(vector current_scale, float scale) { 
    // if our current size is greater than 2, and user wants to increase more, don't 
    if ((current_scale.z >= max_size.z) && (scale > 1.0)) { 
        llOwnerSay("Sorry, we can't zoom in any further"); 
        return; 
        // if our current size is less than 0.5 and the user wants to decrease, don't 
    } else if ((scale < 1.0) && (current_scale.z <= min_size.z)) { 
        llOwnerSay("Sorry, we can't zoom out any further"); 
        return; 
    } else { 
        // if the user wants to increase, set current scale 
        if (scale > 1.0) { 
            current_scale = (current_scale * scale); 
            //llOwnerSay("Zooming in "+(string)scale+" units."); 
        // if the user wants to decrease, set current scale 
        } else if (scale < 1.0) { 
            //llOwnerSay("Zooming out "+(string)scale+" units."); 
            current_scale = (current_scale * scale); 
        } 
    } 
    if ( scale == 0.0 ) return; // we don't resize by factor 0.0 
    // if we are within our limits... 
    if (((current_scale.z * scale) >= min_size.z) || ((current_scale.z * scale) <= max_size.z)) { 
        // resize everything 
        Resize(scale,0); 
    } 
} 
pan(integer direction,string dist) { 
    llMessageLinked(LINK_SET, direction, dist, NULL_KEY); 
} 
default { 
    attach(key id) { 
        if (llGetAttached() == 35) { 
            Resize(0.0,1); 
            owner = llGetOwner(); 
            llResetScript(); 
        } else if (llGetAttached() != 0) { 
            llOwnerSay("Attached to wrong spot."); 
        } 
    } 
    state_entry() { 
        if (owner == NULL_KEY) { 
            llListen(9, "", llGetOwner(), ""); 
        } else { 
            llListen(9, "", owner, ""); 
        } 
    } 
    // don't listen for commands from av, listen for commands from the buttons 
//    listen(integer channel, string name, key id, string message) { 
    link_message(integer sender_num, integer num, string str, key id) { 
        float scale = 0; 
        vector current_scale = llGetScale(); 
        // if reset.. 
        if (sender_num == reset) { 
            // send reset 
            Resize(0.0,1); 
        } else { 
            // if zoom in.. 
            if (sender_num == plus) { 
                // set scale to 1.2 
                scale = 1.2; 
                // do calculations.. 
                calc_zoom(current_scale,scale); 
            // if zoom out.. 
            } else if (sender_num == minus) { 
                // set scale to 0.8 
                scale = 0.8; 
                // do calculations 
                calc_zoom(current_scale,scale); 
            } else if (sender_num == left ) { 
                pan(10,(string)pan_dist); 
            } else if (sender_num == right ) { 
                pan(11,(string)pan_dist); 
            } else if (sender_num == down ) { 
                pan(12,(string)pan_dist); 
            } else if (sender_num == up ) { 
                pan(13,(string)pan_dist); 
            } 

        } 
    } 
} 
