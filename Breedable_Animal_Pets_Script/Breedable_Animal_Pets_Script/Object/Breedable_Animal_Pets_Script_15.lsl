// :CATEGORY:Animal
// :NAME:Breedable_Animal_Pets_Script
// :AUTHOR:Xundra Snowpaw
// :CREATED:2011-07-25 13:48:33.917
// :EDITED:2013-09-18 15:38:49
// :ID:115
// :NUM:170
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// This script can be used to set the quail into it's initial size. Once this script has been loaded into the root prim of the quail and run, it can be deleted// Author Ferd Frederix
// :CODE:
default
{
    state_entry()
    {
        
        float new_scale = 1.0;
        
        vector  new_size = <0.124, 0.082, 0.096> * new_scale;
        vector new_pos;
        
        llSetPrimitiveParams([PRIM_SIZE, new_size]);

        // -> body -> tail <-0.032043,-0.000061,0.009560> 9

        new_size = <0.082, 0.082, 0.082> * new_scale;
        new_pos = <-0.032043,-0.000061,0.009560> * new_scale;
        llSetLinkPrimitiveParams(9, [PRIM_SIZE, new_size, PRIM_POSITION, new_pos]);

        // -> body -> left wing <-0.004141,0.034098,0.008184> 7
        new_size = <0.058, 0.079, 0.023> * new_scale;
        new_pos = <-0.004141,0.034098,0.008184> * new_scale;

        llSetLinkPrimitiveParams(7, [PRIM_SIZE, new_size, PRIM_POSITION, new_pos]);

        // -> body -> right wing <-0.011113,-0.034257,0.008841> 4
        new_size = <0.058, 0.079, 0.023> * new_scale;
        new_pos = <-0.011113,-0.034257,0.008841> * new_scale;

        llSetLinkPrimitiveParams(4, [PRIM_SIZE, new_size, PRIM_POSITION, new_pos]);

        // -> body -> left leg <0.009700,0.020261,-0.052318> 6
        new_size = <0.01, 0.01, 0.064> * new_scale;
        new_pos = <0.009700,0.020261,-0.052318> * new_scale;

        llSetLinkPrimitiveParams(6, [PRIM_SIZE, new_size, PRIM_POSITION, new_pos]);

        // -> body -> right leg <0.009747,-0.022943,-0.052399> 10
        new_size = <0.01, 0.01, 0.064> * new_scale;
        new_pos = <0.009747,-0.022943,-0.052399> * new_scale;

        llSetLinkPrimitiveParams(10, [PRIM_SIZE, new_size, PRIM_POSITION, new_pos]);

        // -> body -> head <0.042349,-0.000059,0.055298> 5
        new_size = <0.082, 0.082, 0.082> * new_scale;
        new_pos = <0.042349,-0.000059,0.055298> * new_scale;

        llSetLinkPrimitiveParams(5, [PRIM_SIZE, new_size, PRIM_POSITION, new_pos]);
        // -> body -> head  -> left eye <0.067205,0.018735,0.070143> 8
        new_size = <0.024, 0.024, 0.024> * new_scale;
        new_pos = <0.067205,0.018735,0.070143> * new_scale;

        llSetLinkPrimitiveParams(8, [PRIM_SIZE, new_size, PRIM_POSITION, new_pos]);

        // -> body -> head -> right eye <0.067265,-0.017552,0.070217> 3
        new_size = <0.024, 0.024, 0.024> * new_scale;
        new_pos = <0.067265,-0.017552,0.070217> * new_scale;

        llSetLinkPrimitiveParams(3, [PRIM_SIZE, new_size, PRIM_POSITION, new_pos]);

        // -> body -> head -> beak  <0.086439,-0.000059,0.049794> 2
        new_size = <0.043, 0.043, 0.043> * new_scale;
        new_pos = <0.086439,-0.000059,0.049794> * new_scale;

        llSetLinkPrimitiveParams(2, [PRIM_SIZE, new_size, PRIM_POSITION, new_pos]);
    }

}
