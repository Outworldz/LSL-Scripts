// :CATEGORY:Buckyball
// :NAME:BuckyBall
// :AUTHOR:Anonymous
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:49
// :ID:121
// :NUM:184
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Buckyball
// :CODE:

list points = [
    <-0.265,0.328,-0.695>,
    <-0.164,-0.796,0.000>,
    <0.594,-0.531,0.164>,
    <0.000,0.164,0.796>,
    <-0.164,-0.594,0.531>,
    <-0.796,0.000,0.164>,
    <0.164,-0.594,0.531>,
    <-0.531,0.164,-0.594>,
    <0.164,0.594,-0.531>,
    <0.328,0.695,-0.265>,
    <-0.594,-0.531,0.164>,
    <-0.594,0.531,-0.164>,
    <-0.164,-0.594,-0.531>,
    <-0.265,-0.328,-0.695>,
    <-0.695,-0.265,0.328>,
    <0.695,0.265,0.328>,
    <-0.164,0.796,0.000>,
    <0.695,0.265,-0.328>,
    <-0.328,0.695,0.265>,
    <-0.695,-0.265,-0.328>,
    <0.796,0.000,0.164>,
    <0.265,-0.328,0.695>,
    <0.695,-0.265,-0.328>,
    <0.000,-0.164,-0.796>,
    <0.000,-0.164,0.796>,
    <0.164,0.594,0.531>,
    <-0.695,0.265,-0.328>,
    <-0.328,0.695,-0.265>,
    <0.164,-0.796,0.000>,
    <0.695,-0.265,0.328>,
    <-0.531,-0.164,-0.594>,
    <0.531,0.164,0.594>,
    <0.265,0.328,0.695>,
    <0.594,0.531,-0.164>,
    <-0.594,-0.531,-0.164>,
    <0.265,-0.328,-0.695>,
    <0.328,-0.695,0.265>,
    <0.796,0.000,-0.164>,
    <-0.531,0.164,0.594>,
    <-0.695,0.265,0.328>,
    <-0.265,-0.328,0.695>,
    <0.594,-0.531,-0.164>,
    <-0.164,0.594,0.531>,
    <-0.265,0.328,0.695>,
    <0.164,0.796,0.000>,
    <-0.531,-0.164,0.594>,
    <0.265,0.328,-0.695>,
    <0.164,-0.594,-0.531>,
    <0.531,0.164,-0.594>,
    <0.531,-0.164,0.594>,
    <-0.164,0.594,-0.531>,
    <0.328,0.695,0.265>,
    <0.594,0.531,0.164>,
    <-0.328,-0.695,-0.265>,
    <0.000,0.164,-0.796>,
    <-0.796,0.000,-0.164>,
    <0.531,-0.164,-0.594>,
    <0.328,-0.695,-0.265>,
    <-0.328,-0.695,0.265>,
    <-0.594,0.531,0.164>
    ];

integer totalNumberOfObjects = 0;
integer rezCount = 0;


default {
    on_rez(integer start_param) { llResetScript(); } 
    
    state_entry() {
        llOwnerSay("Touch to Make Ball - Replace BallObject to change point");
    }
    
    
    touch_start(integer total_number) {
        llOwnerSay("Start");
        string rezObjName = llGetInventoryName( INVENTORY_OBJECT, 0 );
        llOwnerSay( "Found: " + rezObjName );
        vector centerPos = llGetPos();

        totalNumberOfObjects = llGetListLength(points);
        integer i;
        for(i=0; i<totalNumberOfObjects; i++) {
            vector pos = llList2Vector(points, i);
pos *=9;
            llRezObject( rezObjName, centerPos - pos, ZERO_VECTOR, ZERO_ROTATION, i );
        }
    }

    
    object_rez(key id) {
        rezCount++;
        llOwnerSay("rezed: " + (string)rezCount);
        if (rezCount>=totalNumberOfObjects) {
            string scriptName = llGetScriptName();
            llOwnerSay("Done - Die : " + scriptName);
            llDie();
        }
    }
    
}








integer what;
generalParticleEmitterOn()                
{                
    llParticleSystem([                   
        PSYS_PART_FLAGS , 0 
    //| PSYS_PART_BOUNCE_MASK       //Bounce on object's z-axis
    //| PSYS_PART_WIND_MASK           //Particles are moved by wind
    //| PSYS_PART_INTERP_COLOR_MASK   //Colors fade from start to end
    | PSYS_PART_INTERP_SCALE_MASK   //Scale fades from beginning to end
    | PSYS_PART_FOLLOW_SRC_MASK     //Particles follow the emitter
    //| PSYS_PART_FOLLOW_VELOCITY_MASK//Particles are created at the velocity of the emitter
    //| PSYS_PART_TARGET_POS_MASK   //Particles follow the target
    | PSYS_PART_EMISSIVE_MASK       //Particles are self-lit (glow)
    //| PSYS_PART_TARGET_LINEAR_MASK//Undocumented--Sends particles in straight line?
    ,
    
    //PSYS_SRC_TARGET_KEY , NULL_KEY,//The particles will head towards the specified key
    //Select one of the following for a pattern:
    //PSYS_SRC_PATTERN_DROP                 Particles start at emitter with no velocity
    //PSYS_SRC_PATTERN_EXPLODE              Particles explode from the emitter
    //PSYS_SRC_PATTERN_ANGLE                Particles are emitted in a 2-D angle
    //PSYS_SRC_PATTERN_ANGLE_CONE           Particles are emitted in a 3-D cone
    //PSYS_SRC_PATTERN_ANGLE_CONE_EMPTY     Particles are emitted everywhere except for a 3-D cone
    
    PSYS_SRC_PATTERN,           PSYS_SRC_PATTERN_ANGLE_CONE
    
    ,PSYS_SRC_TEXTURE,           "f00bcb1e-8ba3-6d14-4ad6-79ed05c0a1d6"        //UUID of the desired particle texture, or inventory name
    ,PSYS_SRC_MAX_AGE,           0.0            //Time, in seconds, for particles to be emitted. 0 = forever
    ,PSYS_PART_MAX_AGE,          2.0            //Lifetime, in seconds, that a particle lasts
    ,PSYS_SRC_BURST_RATE,        1.0            //How long, in seconds, between each emission
    ,PSYS_SRC_BURST_PART_COUNT,  1             //Number of particles per emission
    ,PSYS_SRC_BURST_RADIUS,      0.1           //Radius of emission
    ,PSYS_SRC_BURST_SPEED_MIN,   .0             //Minimum speed of an emitted particle
    ,PSYS_SRC_BURST_SPEED_MAX,   .0             //Maximum speed of an emitted particle
    ,PSYS_SRC_ACCEL,             <0.0,0,.0>    //Acceleration of particles each second
    ,PSYS_PART_START_COLOR,      <1.0,1.0,1.0>  //Starting RGB color1
    ,PSYS_PART_END_COLOR,        <1.0,1.0,1.0>  //Ending RGB color, if INTERP_COLOR_MASK is on 
    ,PSYS_PART_START_ALPHA,      1.0            //Starting transparency, 1 is opaque, 0 is transparent.
    ,PSYS_PART_END_ALPHA,        1.0            //Ending transparency
    ,PSYS_PART_START_SCALE,      <1.0,1.0,1.0>  //Starting particle size
    ,PSYS_PART_END_SCALE,        <1.0,1.0,1.0>  //Ending particle size, if INTERP_SCALE_MASK is on
    ,PSYS_SRC_ANGLE_BEGIN,       0 * DEG_TO_RAD //Inner angle for ANGLE patterns
    ,PSYS_SRC_ANGLE_END,         1 * DEG_TO_RAD//Outer angle for ANGLE patterns
    ,PSYS_SRC_OMEGA,             <1.0,1.0,0.0>  //Rotation of ANGLE patterns, similar to llTargetOmega()
            ]);
}
 

default
{
    state_entry()
    {
        
        generalParticleEmitterOn();

        llListen( 0, "", llGetOwner(), "" );

    }


    listen(integer channel, string name, key id, string msg)
    {
        if (msg == "die") 
        {
            llParticleSystem( [ ] );
            // stop timer
            llSetTimerEvent(0);
            llDie();
        }         
    }    
}

