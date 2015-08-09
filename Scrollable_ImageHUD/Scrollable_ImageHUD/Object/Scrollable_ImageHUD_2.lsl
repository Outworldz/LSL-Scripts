// :CATEGORY:HUD
// :NAME:Scrollable_ImageHUD
// :AUTHOR:Valect
// :CREATED:2012-07-22 10:17:05.477
// :EDITED:2013-09-18 15:39:01
// :ID:725
// :NUM:991
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// The  script goes in the "back" control object
// :CODE:
vector local_pos; 
default { 
    state_entry() { 
        local_pos = <0.0,0.0,0.0>; //llGetLocalPos(); 
    } 
    link_message(integer sender_num, integer num, string str, key id) { 
        list    primparams = []; 
        // 1 means reset 
        if (num == 1) { 
            primparams += [PRIM_SIZE, <0.2,0.2,0.2>, PRIM_POSITION, local_pos]; 
            llSetPrimitiveParams(primparams); 
        } 
    } 
} 
