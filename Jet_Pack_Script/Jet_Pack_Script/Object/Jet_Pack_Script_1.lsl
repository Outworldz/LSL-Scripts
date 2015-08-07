// :CATEGORY:Vehicles
// :NAME:Jet_Pack_Script
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:55
// :ID:409
// :NUM:565
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Jet Pack Script.lsl
// :CODE:

1// remove this number for the script to work.

integer moving = FALSE;
integer flying = FALSE;

default
{
    attach(key on)
    {
        if (on != NULL_KEY)
        {
            llLoopSound("boom", 1.0);
            moving = TRUE;
            integer perm = llGetPermissions();
            
            if (perm != (PERMISSION_TAKE_CONTROLS))
            {
                llRequestPermissions(on, PERMISSION_TAKE_CONTROLS);
            }
            else
            {
                llTakeControls(CONTROL_FWD | CONTROL_ML_LBUTTON, TRUE, TRUE);
                llSetTimerEvent(0.5);
            }
        }
        else
        {
            moving = FALSE;
            llStopSound();
            llReleaseControls();
            llSetTimerEvent(0.0); 
        }
    }
    
    timer()
    {
        if(llGetAgentInfo(llGetOwner()) & AGENT_FLYING)
        {
            if(flying == FALSE)
            {
                        

vector I_start_color = <1,1,1>;
vector I_end_color = <0.5,0,0.2>; 

float I_start_alpha = 0.0; 
float I_end_alpha = 1.0;   

vector I_start_scale = <0.3,0.3,0.0>;   
vector I_end_scale = <0,0,0>;    

float I_particle_age = 1.5;

float I_inner_angle = PI; 
float I_outer_angle = PI; 
vector I_spin_speed = <0.0,0.0,0.0>;   

vector I_particle_accel = <0.0,0.0,0.0>;

float I_burst_rate = 0.1;
integer I_burst_count = 50;
float I_burst_radius = 0.05;
float I_min_speed = 0.1;
float I_max_speed = 0.65;

float I_source_age = 0.0;  // 0.0 = forever

string I_particle_texture = "particle_glowWhite2"; //if not defined, the default particle

key I_target; //the target of your particles if they use a follow mask


        llParticleSystem([
            PSYS_PART_FLAGS, 
                PSYS_PART_INTERP_COLOR_MASK |
                PSYS_PART_INTERP_SCALE_MASK |
              
                PSYS_PART_FOLLOW_SRC_MASK |
                PSYS_PART_FOLLOW_VELOCITY_MASK |
              
                PSYS_PART_EMISSIVE_MASK, 
         
                     
            PSYS_PART_START_COLOR, I_start_color,
            PSYS_PART_END_COLOR, I_end_color,
                     
         
                     
            PSYS_PART_START_SCALE, I_start_scale,
            PSYS_PART_END_SCALE, I_end_scale,
                     
            PSYS_PART_MAX_AGE, I_particle_age,
                     
            
            PSYS_SRC_PATTERN,
                PSYS_SRC_PATTERN_ANGLE_CONE,
            
            PSYS_SRC_INNERANGLE, I_inner_angle,
            PSYS_SRC_OUTERANGLE, I_outer_angle,
            PSYS_SRC_OMEGA, I_spin_speed,
            
            PSYS_SRC_ACCEL,  I_particle_accel,
            
            PSYS_SRC_TEXTURE, I_particle_texture,
            
            PSYS_SRC_BURST_RATE, I_burst_rate,
            PSYS_SRC_BURST_PART_COUNT, I_burst_count,
            PSYS_SRC_BURST_RADIUS, I_burst_radius,
            PSYS_SRC_BURST_SPEED_MIN, I_min_speed,
            PSYS_SRC_BURST_SPEED_MAX, I_max_speed,
            
            PSYS_SRC_MAX_AGE, I_source_age
            ]);
        }
            
            flying = TRUE;
            llMessageLinked(LINK_SET, 0, "fly", "");
            //..................IDLE...............................

        }
        else
        {
            flying = FALSE;
            llMessageLinked(LINK_SET, 0, "nofly", "");
            llParticleSystem([]);
        }
    }
            
        

    run_time_permissions(integer perm)
    {
        if (perm)
        {
            llTakeControls(CONTROL_FWD | CONTROL_ML_LBUTTON, TRUE, TRUE);
            llSetTimerEvent(0.1);
        }
    }
    
    control(key owner, integer level, integer edge)
    {
       if(flying)
       { // Look for the jump key going down for the first time.
        if (!(level & CONTROL_FWD))
        {
            llMessageLinked(LINK_SET, FALSE, "stop", "");
                    
            
//..................IDLE...............................
        

vector I_start_color = <1,1,1>;
vector I_end_color = <0.5,0,0.2>; 

float I_start_alpha = 0.0; 
float I_end_alpha = 1.0;   

vector I_start_scale = <0.3,0.3,0.0>;   
vector I_end_scale = <0,0,0>;    

float I_particle_age = 1.5;

float I_inner_angle = PI; 
float I_outer_angle = PI; 
vector I_spin_speed = <0.0,0.0,0.0>;   

vector I_particle_accel = <0.0,0.0,0.0>;

float I_burst_rate = 0.1;
integer I_burst_count = 50;
float I_burst_radius = 0.05;
float I_min_speed = 0.1;
float I_max_speed = 0.65;

float I_source_age = 0.0;  // 0.0 = forever

string I_particle_texture = "particle_glowWhite2"; //if not defined, the default particle

key I_target; //the target of your particles if they use a follow mask


        llParticleSystem([
            PSYS_PART_FLAGS, 
                PSYS_PART_INTERP_COLOR_MASK |
                PSYS_PART_INTERP_SCALE_MASK |
              
                PSYS_PART_FOLLOW_SRC_MASK |
                PSYS_PART_FOLLOW_VELOCITY_MASK |
              
                PSYS_PART_EMISSIVE_MASK, 
         
                     
            PSYS_PART_START_COLOR, I_start_color,
            PSYS_PART_END_COLOR, I_end_color,
                     
         
                     
            PSYS_PART_START_SCALE, I_start_scale,
            PSYS_PART_END_SCALE, I_end_scale,
                     
            PSYS_PART_MAX_AGE, I_particle_age,
                     
            
            PSYS_SRC_PATTERN,
                PSYS_SRC_PATTERN_ANGLE_CONE,
            
            PSYS_SRC_INNERANGLE, I_inner_angle,
            PSYS_SRC_OUTERANGLE, I_outer_angle,
            PSYS_SRC_OMEGA, I_spin_speed,
            
            PSYS_SRC_ACCEL,  I_particle_accel,
            
            PSYS_SRC_TEXTURE, I_particle_texture,
            
            PSYS_SRC_BURST_RATE, I_burst_rate,
            PSYS_SRC_BURST_PART_COUNT, I_burst_count,
            PSYS_SRC_BURST_RADIUS, I_burst_radius,
            PSYS_SRC_BURST_SPEED_MIN, I_min_speed,
            PSYS_SRC_BURST_SPEED_MAX, I_max_speed,
            
            PSYS_SRC_MAX_AGE, I_source_age
            ]);
            
        }
        else
        {
            
          llMessageLinked(LINK_SET, TRUE, "burst", ""); 
vector start_color = <1,1,1>;
vector end_color = <0.65,0.3,0.0>; 

float start_alpha = 1.0; 
float end_alpha = 0.0; 

vector start_scale = <0.25,0.25,0.0>;
vector end_scale = <0.1,0.1,0.0>;   //scale (z is ignored)

float particle_age = 2.5; 

float inner_angle = PI; 
float outer_angle = PI;  
vector spin_speed = <0.0,0.0,0.0>;
vector particle_accel = <0.0,0.0,0.0>;

float burst_rate = 0.01;   
integer burst_count = 20;
float burst_radius = 0.1;   
float min_speed = 1;      
float max_speed = 1.5;

float source_age = 0.0; //  0.0 = forever

string particle_texture = "particle_glowOrange4";

key target; 


{

    {

        llParticleSystem([
            PSYS_PART_FLAGS, 
                PSYS_PART_INTERP_COLOR_MASK |
                PSYS_PART_INTERP_SCALE_MASK |
                //PSYS_PART_WIND_MASK |
                //PSYS_PART_BOUNCE_MASK |
                PSYS_PART_FOLLOW_SRC_MASK |
                PSYS_PART_FOLLOW_VELOCITY_MASK |
                //PSYS_PART_TARGET_POS_MASK |
                PSYS_PART_EMISSIVE_MASK, 
                //PSYS_PART_TARGET_LINEAR_MASK, 
                     
            PSYS_PART_START_COLOR, start_color,
            PSYS_PART_END_COLOR, end_color,
                     
            PSYS_PART_START_ALPHA, start_alpha,
            PSYS_PART_END_ALPHA, end_alpha,
                     
            PSYS_PART_START_SCALE, start_scale,
            PSYS_PART_END_SCALE, end_scale,
                     
            PSYS_PART_MAX_AGE, particle_age,
                     
            
            PSYS_SRC_PATTERN,
                //PSYS_SRC_PATTERN_DROP,
                //PSYS_SRC_PATTERN_EXPLODE,
                //PSYS_SRC_PATTERN_ANGLE,
                PSYS_SRC_PATTERN_ANGLE_CONE,
            
            PSYS_SRC_INNERANGLE, inner_angle,
            PSYS_SRC_OUTERANGLE, outer_angle,
            PSYS_SRC_OMEGA, spin_speed,
            
           // PSYS_SRC_ACCEL,  particle_accel,
            
            PSYS_SRC_TEXTURE, particle_texture,
            
            PSYS_SRC_BURST_RATE, burst_rate,
            PSYS_SRC_BURST_PART_COUNT, burst_count,
            PSYS_SRC_BURST_RADIUS, burst_radius,
            PSYS_SRC_BURST_SPEED_MIN, min_speed,
            PSYS_SRC_BURST_SPEED_MAX, max_speed,
            
            PSYS_SRC_MAX_AGE, source_age//,
            
            //PSYS_SRC_TARGET_KEY, target
            
            ]);
        
        }}
        
}
            
     
        
    

}   
}
}
// END //
