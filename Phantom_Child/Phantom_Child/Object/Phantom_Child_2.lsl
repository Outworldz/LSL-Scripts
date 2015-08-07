// :CATEGORY:Phantom
// :NAME:Phantom_Child
// :AUTHOR:Aeron Kohime
// :CREATED:2010-12-27 12:28:17.673
// :EDITED:2013-09-18 15:38:59
// :ID:623
// :NUM:849
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Switchable// // Addition to the above script, a switchable version that could be useful for a phantom door. 
// :CODE:
//Phantom Child Script by Aeron Kohime
//WARNING: When used on the root prim it makes the entire object phantom, it
//         also does not function correctly on tortured prims. (Sorry.)
//Reset on Sim restart added by Void Singer
//Strife Onizuka was here doing simplification
//Phantom door idea added by Taff Nouvelle
//Psi Merlin updated CHANGED_REGION_START (live as of Server 1.27)
 
integer a = 1;
 
default
 {
    state_entry()
    {
    }
    touch_start(integer total_number)
    {
    a*=-1;
    if(a == 1)
    {
        llSetPrimitiveParams([PRIM_TYPE, PRIM_TYPE_BOX,
            0, <0,1,0>, 0, <0,0,0>, <1,1,0>, <0,0,0>,
            PRIM_FLEXIBLE, TRUE, 0, 0, 0, 0, 0, <0,0,0>,
            PRIM_TYPE] + llGetPrimitiveParams([PRIM_TYPE])); 
            llOwnerSay ("Phantom");
    }
    else
    {
        llSetPrimitiveParams([PRIM_PHANTOM, FALSE]);
        llOwnerSay ("Solid");
    }
}
    on_rez(integer s) {
        llResetScript();
    }
    changed (integer vBitChanges){
        if (CHANGED_REGION_START & vBitChanges){
            llResetScript();
        }
    }
}
