// :CATEGORY:XS Pet
// :NAME:XS Pet Xundra Snowpaw Original Quail
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:10
// :ID:989
// :NUM:1471
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// XS Pet
// :CODE:

integer age;
float GROWTH_AMOUNT = 0.10;

// body
// x = 0.124
// y = 0.082
// z = 0.096

// head <0.042349,-0.000059,0.055298> 8
// x = 0.082
// y = 0.082
// z = 0.082

// tail <-0.032043,-0.000061,0.009560> 7
// x = 0.082
// y = 0.082
// z = 0.082

// left wing <-0.004141,0.034098,0.008184> 3
// x = 0.058
// y = 0.079
// z = 0.023

// right wing <-0.011113,-0.034257,0.008841> 2
// x = 0.058
// y = 0.079
// z = 0.023

// left leg <0.009700,0.020261,-0.052318> 9
// x = 0.010
// y = 0.010
// z = 0.064

// right leg <0.009747,-0.022943,-0.052399> 10
// x = 0.010
// y = 0.010
// z = 0.064

// left eye <0.067205,0.018735,0.070143> 5
// x = 0.024
// y = 0.024
// z = 0.024

// right eye <0.067265,-0.017552,0.070217> 6
// x = 0.024
// y = 0.024
// z = 0.024

// beak  <0.086439,-0.000059,0.049794> 4
// x = 0.043
// y = 0.043
// z = 0.043

default
{
    link_message(integer sender, integer num, string str, key id)
    {
        if (num == 800) {
            state running;
        }
    }
}

state running
{
    state_entry()
    {
        age = 0;
    }
    
    timer()
    {
        llMessageLinked(LINK_SET, 940, "1", "");
    }
    
    link_message(integer sender, integer num, string str, key id)
    {
        if (num == 942) {
            llMessageLinked(LINK_SET, 943, (string)age, "");
        } else
        if (num == 941) {
            llSetTimerEvent(86400.0); // 86400.0
        } else
        if (num == 940) {
            integer prev_age = age;
            integer size_age;
            
            age += (integer)str;
            
            if (prev_age == 0 && age > 7) {
                size_age = 7;
            } else {
                size_age = age;
            }
            
            if (size_age > 0 && size_age <= 7) {
                // grow to the correct proportion
                llMessageLinked(LINK_SET, 911, "1", ""); // tell mover to rest for 5 seconds
                

                float new_scale = (GROWTH_AMOUNT * size_age) + 1.0;
                
                vector new_size;
                vector new_pos;
                
                // -> body
                
                new_size = <0.124, 0.082, 0.096> * new_scale;
                
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
    }
}
