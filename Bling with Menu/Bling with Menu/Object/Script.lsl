// :CATEGORY:Particles
// :NAME:Bling with Menu
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:48
// :ID:95
// :NUM:130
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Bling
// :CODE:


fakeMakeExplosion(integer particle_count, float particle_scale, float particle_speed, 
                 float particle_lifetime, float source_cone, string source_texture_id, 
                 vector local_offset) 
{
    //local_offset is ignored
    llParticleSystem([
        PSYS_PART_FLAGS,            PSYS_PART_INTERP_COLOR_MASK|PSYS_PART_INTERP_SCALE_MASK|PSYS_PART_EMISSIVE_MASK|PSYS_PART_WIND_MASK,
        PSYS_SRC_PATTERN,           PSYS_SRC_PATTERN_ANGLE_CONE,
        PSYS_PART_START_COLOR,      <1.0, 1.0, 1.0>,
        PSYS_PART_END_COLOR,        <1.0, 1.0, 1.0>,
        PSYS_PART_START_ALPHA,      0.50,
        PSYS_PART_END_ALPHA,        0.25,
        PSYS_PART_START_SCALE,      <particle_scale, particle_scale, 0.0>,
        PSYS_PART_END_SCALE,        <particle_scale * 2 + particle_lifetime, particle_scale * 2 + particle_lifetime, 0.0>,
        PSYS_PART_MAX_AGE,          particle_lifetime,
        PSYS_SRC_ACCEL,             <0.0, 0.0, 0.0>,
        PSYS_SRC_TEXTURE,           source_texture_id,
        PSYS_SRC_BURST_RATE,        1.0,
        PSYS_SRC_ANGLE_BEGIN,       0.0,
        PSYS_SRC_ANGLE_END,         source_cone * PI,
        PSYS_SRC_BURST_PART_COUNT,  particle_count / 2,
        PSYS_SRC_BURST_RADIUS,      0.0,
        PSYS_SRC_BURST_SPEED_MIN,   particle_speed / 3,
        PSYS_SRC_BURST_SPEED_MAX,   particle_speed * 2/3,
        PSYS_SRC_MAX_AGE,           particle_lifetime / 2,
        PSYS_SRC_OMEGA,             <0.0, 0.0, 0.0>
        ]);
}




generalParticleEmitterOn(float rate)                
{   
    llParticleSystem([                   
        PSYS_PART_FLAGS , 0 
    //| PSYS_PART_BOUNCE_MASK       //Bounce on object's z-axis
    //| PSYS_PART_WIND_MASK           //Particles are moved by wind
    | PSYS_PART_INTERP_COLOR_MASK   //Colors fade from start to end
    | PSYS_PART_INTERP_SCALE_MASK   //Scale fades from beginning to end
    | PSYS_PART_FOLLOW_SRC_MASK     //Particles follow the emitter
    | PSYS_PART_FOLLOW_VELOCITY_MASK//Particles are created at the velocity of the emitter
    //| PSYS_PART_TARGET_POS_MASK   //Particles follow the target
    | PSYS_PART_EMISSIVE_MASK       //Particles will glow
    //| PSYS_PART_TARGET_LINEAR_MASK//Undocumented--Sends particles in straight line?
    ,
    
    //PSYS_SRC_TARGET_KEY , NULL_KEY,//The particles will head towards the specified key
    //Select one of the following for a pattern:
    //PSYS_SRC_PATTERN_DROP                 Particles start at emitter with no velocity
    //PSYS_SRC_PATTERN_EXPLODE              Particles explode from the emitter
    //PSYS_SRC_PATTERN_ANGLE                Particles are emitted in a 2-D angle
    //PSYS_SRC_PATTERN_ANGLE_CONE           Particles are emitted in a 3-D cone
    //PSYS_SRC_PATTERN_ANGLE_CONE_EMPTY     Particles are emitted everywhere except for a 3-D cone
    
    PSYS_SRC_PATTERN,           PSYS_SRC_PATTERN_EXPLODE
    
    ,PSYS_SRC_TEXTURE,           ""           //UUID of the desired particle texture, or inventory name
    ,PSYS_SRC_MAX_AGE,           0.0            //Time, in seconds, for particles to be emitted. 0 = forever
    ,PSYS_PART_MAX_AGE,          0.2            //Lifetime, in seconds, that a particle lasts
    ,PSYS_SRC_BURST_RATE,        rate            //How long, in seconds, between each emission
    ,PSYS_SRC_BURST_PART_COUNT,  6              //Number of particles per emission
    ,PSYS_SRC_BURST_RADIUS,      10.0           //Radius of emission
    ,PSYS_SRC_BURST_SPEED_MIN,   .1             //Minimum speed of an emitted particle
    ,PSYS_SRC_BURST_SPEED_MAX,   .1             //Maximum speed of an emitted particle
    ,PSYS_SRC_ACCEL,             <0,0,0>    //Acceleration of particles each second
    ,PSYS_PART_START_COLOR,      <1,1,1>  //Starting RGB color
    ,PSYS_PART_END_COLOR,        <1,1,1>  //Ending RGB color, if INTERP_COLOR_MASK is on 
    ,PSYS_PART_START_ALPHA,      1.0            //Starting transparency, 1 is opaque, 0 is transparent.
    ,PSYS_PART_END_ALPHA,        1.0            //Ending transparency
    ,PSYS_PART_START_SCALE,      <.04,.25,.01>  //Starting particle size
    ,PSYS_PART_END_SCALE,        <.03,.25,.01>  //Ending particle size, if INTERP_SCALE_MASK is on
    ,PSYS_SRC_ANGLE_BEGIN,       1.54 //Inner angle for ANGLE patterns
    ,PSYS_SRC_ANGLE_END,         1.55 //Outer angle for ANGLE patterns
    ,PSYS_SRC_OMEGA,             <0.0,0.0,0.0>  //Rotation of ANGLE patterns, similar to llTargetOmega()
            ]);
}

generalParticleEmitterOff()
{
    llParticleSystem([]);
}

float rate = 0.5;

integer bling_state = TRUE;
 
list MENU1 = ["(Bling)","(Effects)"];
list MENU2 = ["(Effects)","Bling Stop","Bling On","Slower","Faster"];
list MENU3 = ["(Bling)","Big Bang","Hearts","Butterflies"];

integer listener;
integer MENU_CHANNEL = 1023;
 
 
Dialog(key id, list menu)
{
    llListenRemove(listener);
    listener = llListen(MENU_CHANNEL, "", NULL_KEY, "");
    llDialog(id, "Select one object below: ", menu, MENU_CHANNEL);
}
 
default
{
    on_rez(integer num)
    {
        llResetScript();
    }
    
   
    state_entry()
    {
        generalParticleEmitterOn(rate);
        //llPreloadSound("explosion");
    }
 
    touch_start(integer total_number)
    {
        integer i = 0;
        Dialog(llDetectedKey(0), MENU1);
    }
 
    listen(integer channel, string name, key id, string message) 
    {
        if (channel == MENU_CHANNEL)
        {
            llListenRemove(listener);  
            if (message == "(Bling)")
            {
                Dialog(id, MENU2);
            }
            else if (message == "(Effects)")
            {
                Dialog(id, MENU3);
            }
            
            
            // Effects
            else if (message == "Big Bang")
            {
                fakeMakeExplosion(80, 1.0, 13.0, 2.2, 1.0, "fire", <0.0, 0.0, 0.0>);
                //llTriggerSound("explosion", 10.0);
                llSleep(.5);
                fakeMakeExplosion(80, 1.0, 13.0, 2.2, 1.0, "smoke", <0.0, 0.0, 0.0>);
                llSleep(1);
                if (bling_state = TRUE)
                    generalParticleEmitterOn(rate);
                else
                    llParticleSystem([]);
                

                Dialog(id, MENU3);
            }
            else if (message == "Hearts")
            {
                llWhisper(0,"Hearts");
                 Dialog(id, MENU3);
            }
            else if (message == "Butterflies")
            {
                llWhisper(0,"Butterflies");     
                Dialog(id, MENU3);           
            }            
            
            //bling
            else if (message == "Bling Stop")
            {
                generalParticleEmitterOff();
                bling_state = FALSE;
                Dialog(id, MENU2);
            }    
            else if (message == "Bling On")
            {
                generalParticleEmitterOn(rate);
                bling_state = TRUE;
                Dialog(id, MENU2);
            }   
            else if (message == "Faster")
            {
                rate /=2;
                generalParticleEmitterOn(rate);
                bling_state = TRUE;
                Dialog(id, MENU2);
            }    
            else if (message == "Slower")
            {
                rate *=2;
                generalParticleEmitterOn(rate);
                bling_state = TRUE;
                Dialog(id, MENU2);
            }        
            else                    
            {
                // todo add offsets so box sites perfect on rezzer 
                //llRezAtRoot(message, llGetPos(), ZERO_VECTOR, llGetRot(), 0);
            }      
        }
    }  
}


