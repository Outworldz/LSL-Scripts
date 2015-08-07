// :CATEGORY:Combat
// :NAME:The_Terra_Combat_System_TCS
// :AUTHOR:Cubey Terra
// :CREATED:2010-07-01 15:11:14.270
// :EDITED:2013-09-18 15:39:07
// :ID:887
// :NUM:1260
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Particles
// :CODE:
// TERRA COMBAT SYSTEM 2.5 CRASH EFFECT
// Emits smoke particles and makes explosion sound when 
// vehicle is destroyed in TCS combat


// UUID of sound to play once when vehicle is destroyed
string sndDie = "883c6ec9-074c-4404-b7c3-e02e1462a36e";


// Smoke particle variables
// --------------
integer glow = FALSE;           
integer bounce = FALSE;          
integer interpColor = TRUE;    
integer interpSize = TRUE;   
integer wind = TRUE;
integer followSource = FALSE;
integer followVel = FALSE; 
integer pattern = PSYS_SRC_PATTERN_EXPLODE;
//integer pattern = PSYS_SRC_PATTERN_DROP;
key target = "";
float age = 30.0;     
float maxSpeed = 0.3;       
float minSpeed = 0.01;        
string texture="ee46b9a0-cdcb-2ea3-fac6-41fa995fc41a";               
float startAlpha = 1.0;          
float endAlpha = 0.0;          
vector startColor = <0.4,0.4,0.4>;    
vector endColor = <0,0,0>; 
vector startSize = <4,4,4>;
vector endSize = <10,10,10>; 
vector push = <0,0,2>; 
float rate = 0.1;          
float radius = 0.01;      
integer count = 10;        
float outerAngle = 0.0;  
float innerAngle = 0.0;    
vector omega = <0,0,0>;    
float life = 0.0; 
integer flags;    
//-------------  

dead() // this sequence plays when vehicle is destroyed
{
    llTriggerSound(sndDie,1);
    
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

undead() // this sequence plays when vehicle is regenerated
{
    llParticleSystem([]);
}


default
{
    state_entry()
    {
        llParticleSystem([]); // stop particles, if any
    }
    
    on_rez(integer foo)
    {
        llParticleSystem([]); // stop particles, if any
    }

    link_message(integer sender, integer num, string message, key id)
    {
        if (message == "tc crash") // Vehicle has been destroyed, do death particles/sounds
        {
            dead();
        }
        else if (message == "tc uncrash") // Vehicle has regenerated and is ready to go
        {
            undead();
        }
    }
}

