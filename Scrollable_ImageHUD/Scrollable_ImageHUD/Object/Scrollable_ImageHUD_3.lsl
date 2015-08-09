// :CATEGORY:HUD
// :NAME:Scrollable_ImageHUD
// :AUTHOR:Valect
// :CREATED:2012-07-22 10:17:05.477
// :EDITED:2013-09-18 15:39:01
// :ID:725
// :NUM:992
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// This script goes in all the segments of the image 
// :CODE:

// something to keep in mind: depending on how the object is built, the axes may change on you. just use x or y or z instead on the required direction 
// increase x and z for the map blocks 
vector local_pos; 

default { 
    state_entry() { 
        local_pos = llGetLocalPos(); 
    } 
    link_message(integer sender_num, integer num, string str, key id) { 
        list primparams = []; 
        // 1 means reset 
        if (num == 1) { 
            primparams += [PRIM_SIZE, <0.2,0.2,0.2>, PRIM_POSITION, local_pos]; 
        // 10 means left 
        } else if (num == 10) { 
            vector pan = llGetLocalPos(); 
            pan.y = pan.y - (float)str; 
            primparams += [PRIM_POSITION, pan]; 
        // 11 means right 
        } else if (num == 11) { 
            vector pan = llGetLocalPos(); 
            pan.y = pan.y + (float)str; 
            primparams += [PRIM_POSITION, pan]; 
        // 12 means down 
        } else if (num == 12) { 
            vector pan = llGetLocalPos(); 
            pan.z = pan.z - (float)str; 
            primparams += [PRIM_POSITION, pan]; 
        // 13 means up 
        } else if (num == 13) { 
            vector pan = llGetLocalPos(); 
            pan.z = pan.z + (float)str; 
            primparams += [PRIM_POSITION, pan]; 
        } else if (num == 0) { 
            float scale; // size factor 
            scale = (float)str; 
            vector new_scale = llGetScale(); 
            new_scale.x = new_scale.x * scale; 
            new_scale.z = new_scale.z * scale; 
            new_scale.y = 0.2; 
            vector new_pos = llGetLocalPos(); 
            new_pos.z = new_pos.z * scale; 
            new_pos.y = new_pos.y * scale; 
            primparams = []; 
            primparams += [PRIM_SIZE, new_scale]; // resize 
            if (llGetLinkNumber() > 1) { // only move if we're not the root object 
                primparams += [PRIM_POSITION, new_pos]; // reposition 
            } 
        } 
        llSetPrimitiveParams(primparams); 
    } 
} 
