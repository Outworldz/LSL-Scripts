// :CATEGORY:Follower
// :NAME:Keyframe Follower
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2014-12-04 12:14:28
// :EDITED:2014-12-04
// :ID:1058
// :NUM:1686
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Dragon Flames for a dragon follower
// :CODE:
Particles()
{
    llParticleSystem(  [ 

           PSYS_SRC_TEXTURE,"", // llGetInventoryName(INVENTORY_TEXTURE, 0), 
           PSYS_PART_START_SCALE, <.1,.1,1>,  PSYS_PART_END_SCALE, <0,2.0, 0>, 
           PSYS_PART_START_COLOR, <0.2,1,0.2>,       PSYS_PART_END_COLOR, <.5,1,1>, 
           PSYS_PART_START_ALPHA, 1.0,            PSYS_PART_END_ALPHA, 0.0,     
         
           PSYS_SRC_BURST_PART_COUNT, 1, 
           PSYS_SRC_BURST_RATE,  0.01,  
           PSYS_PART_MAX_AGE, .5, 
           PSYS_SRC_MAX_AGE, 0,   

           PSYS_SRC_PATTERN, 8, // 1=DROP, 2=EXPLODE, 4=ANGLE, 8=ANGLE_CONE,
           PSYS_SRC_ACCEL, <1.0,0.0,0.0>,      

        // PSYS_SRC_BURST_RADIUS, 0.0,

           PSYS_SRC_BURST_SPEED_MIN, .01,  
           PSYS_SRC_BURST_SPEED_MAX, 3.01, 

           PSYS_SRC_ANGLE_BEGIN,  PI,         
           PSYS_SRC_ANGLE_END, PI,
           PSYS_SRC_OMEGA, <0,0,0>, 
   
           PSYS_PART_FLAGS, ( 0      

                                | PSYS_PART_INTERP_COLOR_MASK   

                                | PSYS_PART_INTERP_SCALE_MASK   

                                | PSYS_PART_EMISSIVE_MASK   

                                | PSYS_PART_FOLLOW_VELOCITY_MASK

                             // | PSYS_PART_WIND_MASK            

                             // | PSYS_PART_BOUNCE_MASK          

                             // | PSYS_PART_FOLLOW_SRC_MASK     

                             // | PSYS_PART_TARGET_POS_MASK     

                             // | PSYS_PART_TARGET_LINEAR_MASK    

            ) ] );

    
}


default
{
    
    state_entry()
    {
         llParticleSystem([]);
    }
    link_message(integer sender, integer num, string str, key id)
    {
        if (str=="flames"){
            float which = llFrand(3);
            //llOwnerSay((string) which);
            if (which < 1)
                llTriggerSound("roar1",1.0);
            else if (which < 2)
                llTriggerSound("roar2",1.0);
            else
                llTriggerSound("roar3",1.0);
                
                
            Particles();
            llSetTimerEvent(1.0);
        }
    } 
    
    timer()
    {
        llSetTimerEvent(0);
        llParticleSystem([]);
        
    }
    
}
