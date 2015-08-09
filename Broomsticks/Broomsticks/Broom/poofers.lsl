// :CATEGORY:Halloween
// :NAME:Broomsticks
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:49
// :ID:119
// :NUM:179
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// particles
// :CODE:




integer timer_count = 0;
integer mode = 3;
key owner;
integer f = 0;
integer glow = FALSE;           
integer bounce = FALSE;          
integer interpColor = TRUE;    
integer interpSize = TRUE;   
integer wind = FALSE;
integer followSource = FALSE;
integer followVel = FALSE; 
integer pattern = PSYS_SRC_PATTERN_EXPLODE;
key target = "";
float age = 10;     
float maxSpeed = 0.25;       
float minSpeed = 0.1;        
string texture="";               
float startAlpha = 0.5;          
float endAlpha = 0;          
vector startColor = <1,1,0>;    
vector endColor = <0,0,0>; 
vector startSize = <0.1,0.1,0.1>;   
vector endSize = <.1,.10,.10>;     
vector push = <0,0,0>; 
float rate = .1;          
float radius = 1;      
integer count = 10;        
float outerAngle = 0;  
float innerAngle = 0;    
vector omega = <0,0,0>;    
float life = 0;             
integer flags;
 
updateParticles()
{
    flags = 0;
    if (target == "owner") target = llGetOwner();
    if (target == "self") target = llGetKey();
    if (glow) flags = flags | PSYS_PART_EMISSIVE_MASK;
    if (bounce) flags = flags | PSYS_PART_BOUNCE_MASK;
    if (interpColor) flags = flags | PSYS_PART_INTERP_COLOR_MASK;
    if (interpSize) flags = flags | PSYS_PART_INTERP_SCALE_MASK;
    if (wind) flags = flags | PSYS_PART_WIND_MASK;
    if (followSource) flags = flags | PSYS_PART_FOLLOW_SRC_MASK;
    if (followVel) flags = flags | PSYS_PART_FOLLOW_VELOCITY_MASK;
    if (target != "") flags = flags | PSYS_PART_TARGET_POS_MASK;

    llParticleSystem([  PSYS_PART_MAX_AGE,age,
                        PSYS_PART_FLAGS,flags,
                        PSYS_PART_START_COLOR, startColor,
                        PSYS_PART_END_COLOR, endColor,
                        PSYS_PART_START_SCALE,startSize,
                        PSYS_PART_END_SCALE,endSize, 
                        PSYS_SRC_PATTERN, pattern,
                        PSYS_SRC_BURST_RATE,rate,
                        PSYS_SRC_ACCEL, push,
                        PSYS_SRC_BURST_PART_COUNT,count,
                        PSYS_SRC_BURST_RADIUS,radius,
                        PSYS_SRC_BURST_SPEED_MIN,minSpeed,
                        PSYS_SRC_BURST_SPEED_MAX,maxSpeed,
                        PSYS_SRC_TARGET_KEY,target,
                        PSYS_SRC_INNERANGLE,innerAngle, 
                        PSYS_SRC_OUTERANGLE,outerAngle,
                        PSYS_SRC_OMEGA, omega,
                        PSYS_SRC_MAX_AGE, life,
                        PSYS_SRC_TEXTURE, texture,
                        PSYS_PART_START_ALPHA, startAlpha,
                        PSYS_PART_END_ALPHA, endAlpha
                            ]);
}

default
{


    on_rez(integer start_param)
    {
        owner = llGetOwner();
        llParticleSystem([]);
    }    
    link_message(integer sender_num, integer num, string str, key id)
    {
        if((str == "particles on"))
        {
            rate = 0.01;          
            count = 2;
            updateParticles();
        }
        
       
        if((str == "unseated") || (str == "particles off"))
        {
            llParticleSystem([]);
        }
    }

}


    
