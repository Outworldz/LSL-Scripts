// :CATEGORY:driving
// :NAME:Horse_Riding_script
// :AUTHOR:fratserke
// :CREATED:2010-11-09 06:15:07.590
// :EDITED:2013-09-18 15:38:55
// :ID:384
// :NUM:532
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// put this script in the master prim(yellow) off the horse en drive
// :CODE:
// History
// 0.5 added DustIsOn Boolean for streamlining
// 0.4 unknown
// 0.3 duston/dustoff split & anti-push global on/off
// 0.2 dust call & anti-push
// 0.1 fix attach event problem for attach from inventory
// 0.0 create

// globals
// animation to play when attached
string animation = "badhorseriding";

// this set to true will enable the "anti push" code so acts as a minimal push shield
integer anti_push = TRUE;

// time to wait if avatar does not move to "lock" into place.  
// ignore if anti_push is false.
float lockwait = 1.0;

// globals for state tracking
integer have_permissions = FALSE;
integer is_attached = FALSE;
integer is_locked = FALSE;

// globals for boolean lists
integer perm_list;
integer control_list;

//integer clipclop;
integer effectFlags=0;
//integer running=1;
integer dustIsOn = FALSE;

// Color Secelection Variables

// Interpolate between startColor and endColor
integer colorInterpolation  = 1;
// Starting color for each particle 
vector  startColor          = <.85,.75,.72>;
// Ending color for each particle
vector  endColor          = <.85,.75,.72>;
// Starting Transparency for each particle (1.0 is solid)
float   startAlpha          = .5;
// Ending Transparency for each particle (0.0 is invisible)
float   endAlpha            = 0;
// Enables Absolute color (true) ambient lighting (false)
integer glowEffect          = 0;


// Size & Shape Selection Variables

// Interpolate between startSize and endSize
integer sizeInterpolation   = 1;
// Starting size of each particle
vector  startSize           = <.75,.75,0>;
// Ending size of each particle
vector  endSize             = <4,4,0>;
// Turns particles to face their movement direction
integer followVelocity      = 0;
// Texture the particles will use ("" for default)
string  texture             = "smoke";


// Timing & Creation Variables Variables

// Lifetime of one particle (seconds)
float   particleLife        = 10;
// Lifetime of the system 0.0 for no time out (seconds)
float   SystemLife          = 0;
// Number of seconds between particle emissions
float   emissionRate        = .1;
// Number of particles to releast on each emission
integer partPerEmission     = 5;


// Angular Variables

// The radius used to spawn angular particle patterns
float   radius              = 0;
// Inside angle for angular particle patterns
float   innerAngle          = 0;
// Outside angle for angular particle patterns
float   outerAngle          = 2;
// Rotational potential of the inner/outer angle
vector  omega               = <0,0,0>;


// Movement & Speed Variables

// The minimum speed a particle will be moving on creation
float   minSpeed            = 0;
// The maximum speed a particle will be moving on creation
float   maxSpeed            = .5;
// Global acceleration applied to all particles
vector  acceleration        = <0,0,0>;
// If true, particles will be blown by the current wind
integer windEffect          = 1;
// if true, particles 'bounce' off of the object's Z height
integer bounceEffect        = 0;
// If true, particles spawn at the container object center
integer followSource        = 0;
// If true, particles will move to expire at the target
//integer followTarget        = 1;
// Desired target for the particles (any valid object/av key)
// target Needs to be set at runtime
key     target              = "";


//As yet unimplemented particle system flags

integer randomAcceleration  = 0;
integer randomVelocity      = 0;
integer particleTrails      = 0;

// Pattern Selection

//   Uncomment the pattern call you would like to use
//   Drop parcles at the container objects' center
//integer pattern = PSYS_SRC_PATTERN_DROP;
//   Burst pattern originating at objects' center
//integer pattern = PSYS_SRC_PATTERN_EXPLODE;
//   Uses 2D angle between innerAngle and outerAngle
integer pattern = PSYS_SRC_PATTERN_ANGLE;
//   Uses 3D cone spread between innerAngle and outerAngle
//integer pattern = PSYS_SRC_PATTERN_ANGLE_CONE;
// 
//integer pattern = PSYS_SRC_PATTERN_ANGLE_CONE_EMPTY;

setParticles()
{
// Here is where to set the current target
// llGetKey() targets this script's container object
// llGetOwner() targets the owner of this script
// Feel free to insert any other valid key
    target="";
// The following block of if statements is used to construct the mask 
    if (colorInterpolation) effectFlags = effectFlags|PSYS_PART_INTERP_COLOR_MASK;
    if (sizeInterpolation)  effectFlags = effectFlags|PSYS_PART_INTERP_SCALE_MASK;
    if (windEffect)         effectFlags = effectFlags|PSYS_PART_WIND_MASK;
    if (bounceEffect)       effectFlags = effectFlags|PSYS_PART_BOUNCE_MASK;
    if (followSource)       effectFlags = effectFlags|PSYS_PART_FOLLOW_SRC_MASK;
    if (followVelocity)     effectFlags = effectFlags|PSYS_PART_FOLLOW_VELOCITY_MASK;
    if (target!="")       effectFlags = effectFlags|PSYS_PART_TARGET_POS_MASK;
    if (glowEffect)         effectFlags = effectFlags|PSYS_PART_EMISSIVE_MASK;
//Uncomment the following selections once they've been implemented
//    if (randomAcceleration) effectFlags = effectFlags|PSYS_PART_RANDOM_ACCEL_MASK;
//    if (randomVelocity)     effectFlags = effectFlags|PSYS_PART_RANDOM_VEL_MASK;
//    if (particleTrails)     effectFlags = effectFlags|PSYS_PART_TRAIL_MASK;
    llParticleSystem([
        PSYS_PART_FLAGS,            effectFlags,
        PSYS_SRC_PATTERN,           pattern,
        PSYS_PART_START_COLOR,      startColor,
        PSYS_PART_END_COLOR,        endColor,
        PSYS_PART_START_ALPHA,      startAlpha,
        PSYS_PART_END_ALPHA,        endAlpha,
        PSYS_PART_START_SCALE,      startSize,
        PSYS_PART_END_SCALE,        endSize,    
        PSYS_PART_MAX_AGE,          particleLife,
        PSYS_SRC_ACCEL,             acceleration,
        PSYS_SRC_TEXTURE,           texture,
        PSYS_SRC_BURST_RATE,        emissionRate,
        PSYS_SRC_INNERANGLE,        innerAngle,
        PSYS_SRC_OUTERANGLE,        outerAngle,
        PSYS_SRC_BURST_PART_COUNT,  partPerEmission,      
        PSYS_SRC_BURST_RADIUS,      radius,
        PSYS_SRC_BURST_SPEED_MIN,   minSpeed,
        PSYS_SRC_BURST_SPEED_MAX,   maxSpeed, 
        PSYS_SRC_MAX_AGE,           SystemLife,
        PSYS_SRC_TARGET_KEY,        target,
        PSYS_SRC_OMEGA,             omega   ]);
}


// sample dust functions
duststart(integer is_running) {
    // call dust particles
    if(is_running) {
        // agent is running
        llLoopSound("98dc028e-c44b-b17d-4540-c0a7ba026908", 1);
        setParticles();
        dustIsOn = TRUE;
    }  else  {
        llLoopSound("e8a669ca-2400-69e3-693f-f87dd18fa9cd", 1);
    }
}

duststop() {
    // stop dust particles
    llStopSound();
    if(dustIsOn) {
        llParticleSystem([]);
        dustIsOn = FALSE;
    }
}


// My own attach event because of bug with attach from inventory not calling attach event
doattach(key attachedAgent) {
    // process the attach event
    if (attachedAgent != NULL_KEY) {
        // we are attached to an agent so set the attached state
        is_attached = TRUE;
        // Request permission to do stuff from agent
        if(!have_permissions) llRequestPermissions(llGetOwner(), perm_list );  
    } else {
        // we are not attached so set the state
        is_attached = FALSE;
        // if we HAVE permissions then assume we were animating an avatar
        // (the avatar just detached us for example)
        if (have_permissions) {
            // stop animating the avatar
            llStopAnimation(animation);
            // reliquinsh our permissions (fake but good for state)
            have_permissions = FALSE;
        }
        // turn off the push stuff
        llSetTimerEvent(0.0);
        // stop damping movement
        llMoveToTarget(llGetPos(), 0);
        // turn off locking
        is_locked = FALSE;
    }
}

// the meat of the script
default {
    on_rez(integer initparm) {
        // reset the script
        llResetScript();
    }

    state_entry() {
        // sit from original horse control box
        llSitTarget(<0.3,0,0.6>, ZERO_ROTATION);

        // set up the state tracking vars to their initial values
        dustIsOn = FALSE;
        have_permissions = FALSE;
        is_attached = FALSE;
        is_locked = FALSE;
        perm_list = (PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS);
        control_list = (CONTROL_FWD|
                       CONTROL_BACK|
                       CONTROL_RIGHT|
                       CONTROL_LEFT|
                       CONTROL_ROT_RIGHT|
                       CONTROL_ROT_LEFT|
                       CONTROL_UP|
                       CONTROL_DOWN);

        // Fake the attached event because we are attached and attached didn't get called.
        if(llGetAttached()>0) doattach(llGetOwner());
    }
    changed(integer change)
    {
        if(change & CHANGED_OWNER)    // You'd better put the this changed() event when you use llGetOwner
        {                             // by way of precaution.
            llResetScript();
        }
    }
    run_time_permissions(integer permissions) {
        // process the permissions requests
        if (permissions == perm_list) {
            // if we are attached then start the animation and attach to the 
            // correct point on avatar
            if(is_attached) {
                // start the animation
                llStartAnimation(animation);
                llTakeControls(control_list, TRUE, TRUE);
                llTriggerSound("a2b85091-b0c8-f77e-2c85-d52624b3081c", 1.0);
            }
            // start the antipush timer if script calls for it
            if(anti_push) llSetTimerEvent(1);
            // let everything know we got the permissions we requested
            have_permissions = TRUE;
        }
    }

    control(key id, integer level, integer edge) {
        // check anti_push state
        if(anti_push) {
            // if we are locked and this event (control) is called then avatar requested move
            // so we have to unlock
            if (is_locked) {
                // undamp avatar
                llMoveToTarget(llGetPos(), 0);
                // set locked state to false
                is_locked = FALSE;
            }
            // reset the timer
            llResetTime();
        }

        // check to see if the agent is running
        integer running = llGetAnimation(llGetPermissionsKey()) == "Running";
        integer landing = llGetAgentInfo(llGetPermissionsKey()) & AGENT_FLYING;
        integer jumping = llGetAnimation(llGetPermissionsKey()) == "Jumping";
         
        // now we capture the various controls for any "effects hooks"
        if(level>0 && edge>0) {
            // these get called because the just got pressed
            // they get called once
            if(level & CONTROL_FWD) {
                // avatar is starting to go forwards
            }
            if(level & CONTROL_BACK) { 
                // avatar is starting to go backwards
            }
            if(level & (CONTROL_RIGHT|CONTROL_ROT_RIGHT)) {
                // avatar is starting to go right
            }
            if(level & (CONTROL_LEFT|CONTROL_ROT_LEFT)) {
                // avatar is starting to go left
            }
            if(level & CONTROL_UP) {
                // avatar is starting to go up
            }
            if(level & CONTROL_DOWN) {
                // avatar is starting to go down
            }
        }else if(level>0) {
            // these get called because the key is down!
            // they get called repeatedly
            if(level & CONTROL_FWD) {
                // avatar is going forwards
                if(!landing & !jumping) duststart(running);
                else duststop();
            }
            if(level & CONTROL_BACK) { 
                // avatar is going backwards
                if(!landing & !jumping) duststart(running);
                else duststop();
            }
            if(level & (CONTROL_RIGHT|CONTROL_ROT_RIGHT)) {
                // avatar is going right
                if(!landing & !jumping) duststart(running);
                else duststop();
            }
            if(level & (CONTROL_LEFT|CONTROL_ROT_LEFT)) {
                // avatar is going left
                if(!landing & !jumping) duststart(running);
                else duststop();
            }
            if(level & CONTROL_UP) {
                // avatar is going up
                duststop();
            }
            if(level & CONTROL_DOWN) {
                // avatar is going down
                duststop();
            }
        }else{
            // called once when key is up
            if(edge & CONTROL_FWD) {
                // avatar stopped going forwards
                duststop();
            }
             if(edge & CONTROL_BACK) { 
                // avatar stopped going backwards
                duststop();
            }
            if(edge & (CONTROL_RIGHT|CONTROL_ROT_RIGHT)) {
                // avatar stopped going right
                duststop();
            }
            if(edge & (CONTROL_LEFT|CONTROL_ROT_LEFT)) {
                // avatar stopped going left
                duststop();
            }
            if(edge & CONTROL_UP) {
                // avatar stopped going up
                duststop();
            }
            if(edge & CONTROL_DOWN) {
                // avatar stopped going down
                duststop();
            }
        }           
    }

    attach(key attachedAgent) {
        // we got attached so call the attach function (we swapped this because
        // of a linden script bug where the attach event didn't get called
        // when attached from inventory
        doattach(attachedAgent);
    }

    timer() {
        // if we are handling anti_push
        if(anti_push) {
            // check if we are not already locked and we haven't moved since our wait
            if ((!is_locked) && (llGetTime() > lockwait)) {
                // ok we aren't already locked and it's past the lock interval
                // so damp movement on the avatar
                llMoveToTarget(llGetPos(), 0.2);
                // set the locked state to true
                is_locked = TRUE;
            }
        }
    }
}
 
