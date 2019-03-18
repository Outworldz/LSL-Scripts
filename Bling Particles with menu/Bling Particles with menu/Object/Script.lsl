// :CATEGORY:Particles
// :NAME:Bling Particles with menu
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:48
// :ID:94
// :NUM:129
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Bling particles
// :CODE:

integer _debug = 1;

list MENU1 = ["(Bling)","(Effects)","(Poofer)","(Typing)"];
list MENU2 = ["(Menu)","Bling Stop","Bling On","Slower","Faster"];
list MENU3 = ["(Menu)","Big Bang"];
list MENU4 = ["(Menu)","Stop"];
list MENU5 = ["(Menu)","Stop"];
 

list anims = [];

string typo;
 

key           target = "";      // Select a target for particles to arrive at when they die
                                // can be "self" (emitter), "owner" (you), "" or any prim/persons KEY.

                

Poofer(string target, string texture)
{
    integer    followVel = TRUE;    // TRUE or FALSE(*), Particles rotate towards their direction
    integer followSource = FALSE;   // TRUE or FALSE(*), Particles move as the emitter moves, (TRUE disables
    integer     wind = TRUE;   // TRUE or FALSE(*), Particles get blown away by wind in the sim
    integer      glow = TRUE;        // TRUE or FALSE(*)
    vector startColor = <1,1,1>;     // RGB color, black<0,0,0> to white<1,1,1>(*)
    vector   endColor = <1,1,1>;     // 
    vector  startSize = <0.1,0.1,0>; // <0.04,0.04,0>(min) to <10,10,0>(max>, <1,1,0>(*)/
    vector    endSize = <0.1,0.1,0>; // (Z part of vector is discarded)  
    float     age = 10.0;   // How long each particle lives, 0.1 to 60, 10.0(*)
    float    Poofrate = 0.1;   // Delay between bursts of new particles, 0.0 to 60, 0.1(*)
    integer count = 10;    // Number of particles created per burst, 1(*) to 4096
    integer       bounce = FALSE;   // TRUE or FALSE(*), Make particles bounce on Z altitude of emitter
    
    
    
    list sys;
    integer flags;
    key targetkey;
    if (target == "owner") targetkey = llGetOwner();
    if (target == "self") targetkey = llGetKey();
    
    if (glow) flags = flags | PSYS_PART_EMISSIVE_MASK;
    if (bounce) flags = flags | PSYS_PART_BOUNCE_MASK;
    if (startColor != endColor) flags = flags | PSYS_PART_INTERP_COLOR_MASK;
    if (startSize != endSize) flags = flags | PSYS_PART_INTERP_SCALE_MASK;
    if (wind) flags = flags | PSYS_PART_WIND_MASK;
    if (followSource) flags = flags | PSYS_PART_FOLLOW_SRC_MASK;
    if (followVel) flags = flags | PSYS_PART_FOLLOW_VELOCITY_MASK;
    if (target != "owner") flags = flags | PSYS_PART_TARGET_POS_MASK;
    sys = [  PSYS_PART_MAX_AGE,age,
                        PSYS_PART_FLAGS,flags,
                        PSYS_PART_START_COLOR, startColor,
                        PSYS_PART_END_COLOR, endColor,
                        PSYS_PART_START_SCALE,startSize,
                        PSYS_PART_END_SCALE,endSize, 
                        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
                        PSYS_SRC_BURST_RATE,Poofrate,
                        PSYS_SRC_ACCEL, <0,0,0.1>,
                        PSYS_SRC_BURST_PART_COUNT,count,
                        PSYS_SRC_BURST_RADIUS,0.3,
                        PSYS_SRC_BURST_SPEED_MIN,0.3,
                        PSYS_SRC_BURST_SPEED_MAX,0.2,
                        PSYS_SRC_TARGET_KEY,targetkey,
                        PSYS_SRC_INNERANGLE,PI, 
                        PSYS_SRC_OUTERANGLE,0.0,
                        PSYS_SRC_OMEGA, <0,0,0>,
                        PSYS_SRC_MAX_AGE, 0.0,
                        PSYS_SRC_TEXTURE, texture,
                        PSYS_PART_START_ALPHA, 1.0,
                        PSYS_PART_END_ALPHA, 1.0
                            ];
    float newrate = Poofrate;
    if (newrate == 0.0) newrate=.01;
    if ( (age/Poofrate)*count < 4096) llParticleSystem(sys);
    else {
        llInstantMessage(llGetOwner(),"Your particle system creates too many concurrent particles.");
        llInstantMessage(llGetOwner(),"Reduce count or age, or increate rate.");
        llParticleSystem( [ ] );
    }
}
                
TypingOn(string target, string texture)
{
    integer    followVel = TRUE;    // TRUE or FALSE(*), Particles rotate towards their direction
    integer followSource = FALSE;   // TRUE or FALSE(*), Particles move as the emitter moves, (TRUE disables
    integer         wind = FALSE;   // TRUE or FALSE(*), Particles get blown away by wind in the sim
    integer      glow = TRUE;        // TRUE or FALSE(*)
    vector startColor = <1,1,1>;     // RGB color, black<0,0,0> to white<1,1,1>(*)
    vector   endColor = <1,1,1>;     // 
    vector  startSize = <0.1,0.1,0>; // <0.04,0.04,0>(min) to <10,10,0>(max>, <1,1,0>(*)/
    vector    endSize = <0.1,0.1,0>; // (Z part of vector is discarded)  
    float     age = 3.0;   // How long each particle lives, 0.1 to 60, 10.0(*)
    float    Poofrate = 0.1;   // Delay between bursts of new particles, 0.0 to 60, 0.1(*)
    integer count = 10;    // Number of particles created per burst, 1(*) to 4096
    integer       bounce = FALSE;   // TRUE or FALSE(*), Make particles bounce on Z altitude of emitter
    
    list sys;
    integer flags;
    key targetkey;
    if (target == "owner") targetkey = llGetOwner();
    if (target == "self") targetkey = llGetKey();
    

    if (glow) flags = flags | PSYS_PART_EMISSIVE_MASK;
    if (bounce) flags = flags | PSYS_PART_BOUNCE_MASK;
    if (startColor != endColor) flags = flags | PSYS_PART_INTERP_COLOR_MASK;
    if (startSize != endSize) flags = flags | PSYS_PART_INTERP_SCALE_MASK;
    if (wind) flags = flags | PSYS_PART_WIND_MASK;
    if (followSource) flags = flags | PSYS_PART_FOLLOW_SRC_MASK;
    if (followVel) flags = flags | PSYS_PART_FOLLOW_VELOCITY_MASK;
    if (target != "owner") flags = flags | PSYS_PART_TARGET_POS_MASK;
    llParticleSystem( [  PSYS_PART_MAX_AGE,3.0,
                        PSYS_PART_FLAGS,flags,
                        PSYS_PART_START_COLOR, <1,1,1>,
                        PSYS_PART_END_COLOR, <1,1,1>,
                        PSYS_PART_START_SCALE,<0.1,0.1,0>,
                        PSYS_PART_END_SCALE,<1.0,1.0,0>, 
                        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
                        PSYS_SRC_BURST_RATE,0.1,
                        PSYS_SRC_ACCEL, <0,0,0.1>,
                        PSYS_SRC_BURST_PART_COUNT,2,
                        PSYS_SRC_BURST_RADIUS,0.30,
                        PSYS_SRC_BURST_SPEED_MIN, 0.3,
                        PSYS_SRC_BURST_SPEED_MAX, 0.2,
                        PSYS_SRC_TARGET_KEY,targetkey,
                        PSYS_SRC_INNERANGLE,PI, 
                        PSYS_SRC_OUTERANGLE,0.0,
                        PSYS_SRC_OMEGA, <0,0,0>,
                        PSYS_SRC_MAX_AGE, 0.0,
                        PSYS_SRC_TEXTURE, texture,
                        PSYS_PART_START_ALPHA, 1.0,
                        PSYS_PART_END_ALPHA, 1.0
                        ]);
                            
                            
}                                
                                                
                                                                                
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
        PSYS_SRC_BURST_RATE,        0.1,
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


BlingOn(float blingrate)                
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
    ,PSYS_SRC_BURST_RATE,        blingrate            //How long, in seconds, between each emission
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

float myrate = 0.5;

integer bling_state = TRUE;
 


integer listener;
integer MENU_CHANNEL = 1023;
 
 
Dialog(key id, list menu)
{
    llListenRemove(listener);
    listener = llListen(MENU_CHANNEL, "", NULL_KEY, "");
    llDialog(id, "Select one object below: ", menu, MENU_CHANNEL);
}
 
 
list name;
list inventory;
    
     
       
default
{
    on_rez(integer num)
    {
        llResetScript();
    }
    

    changed(integer num)
    {
        llResetScript();
    }
    
    
    state_entry()
    {
        BlingOn(myrate);
        integer     num = llGetInventoryNumber(INVENTORY_TEXTURE);
        if (_debug)
                llOwnerSay("Contains " + (string) num ); 
        integer     i;

        for (i = 0; i < num; ++i) 
        {
            string name = llGetInventoryName(INVENTORY_TEXTURE, i);
            
               
            if (llGetSubString(name,0,0) == "_")
            {                    
                MENU5 += name;
                if (_debug)
                {
                        llOwnerSay("Menu5  " + name ); 
                        llSleep(0.2);
                }    
            }
            else
            {
                MENU4 +=  name;
                if (_debug)
                {
                        llOwnerSay("Menu4  " + name ); 
                        llSleep(0.2);
                }    
            }

        }
    }
 
    timer()
    {
        anims = llGetAnimationList(llGetOwner());
        if(llListFindList(anims,[(key)("c541c47f-e0c0-058b-ad1a-d6ae3a4584d9")]) != -1)
        {
            TypingOn("owner", typo);
                   
        }
        if(llListFindList(anims,[(key)("c541c47f-e0c0-058b-ad1a-d6ae3a4584d9")]) == -1)
        {
            generalParticleEmitterOff();
        }
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
            
             if (_debug)
                    llOwnerSay("msg: " + message);
                    
            llListenRemove(listener);  
            if (message == "(Menu)")
            {
                Dialog(id, MENU1);
            }
            else if (message == "(Bling)")
            {
                Dialog(id, MENU2);
            }
            else if (message == "(Effects)")
            {
                Dialog(id, MENU3);
            }
            else if (message == "(Poofer)")
            {
                Dialog(id, MENU4);
            }
            else if (message == "(Typing)")
            {
                Dialog(id, MENU5);
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
                    BlingOn(myrate);
                else
                    llParticleSystem([]);
                
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
                BlingOn(myrate);
                bling_state = TRUE;
                Dialog(id, MENU2);
            }   
            else if (message == "Faster")
            {
                myrate /=2;
                BlingOn(myrate);
                bling_state = TRUE;
                Dialog(id, MENU2);
            }    
            else if (message == "Slower")
            {
                myrate *=2;
                BlingOn(myrate);
                bling_state = TRUE;
                Dialog(id, MENU2);
            }        
            else if (message == "Stop")
            {
                llParticleSystem( [ ] );
                Dialog(id, MENU1);
                llSetTimerEvent(0);
            }     
            else if (llGetSubString(message,0,0) == "_")
            {
                if (_debug)
                    llOwnerSay("typo  " + message);
                typo = message;
                Dialog(id, MENU5);
                
                llSetTimerEvent(.2);
            }
            else if ( llGetSubString(message,0,0) != "_")
            {
                if (_debug)
                    llOwnerSay("Playing " + message);
                    
                Poofer("owner", message);
                Dialog(id, MENU4);           
            }  
            
                        
             
            
            else                    
            {
                // todo add offsets so box sites perfect on rezzer 
                //llRezAtRoot(message, llGetPos(), ZERO_VECTOR, llGetRot(), 0);
            }      
        }
    }  
}

