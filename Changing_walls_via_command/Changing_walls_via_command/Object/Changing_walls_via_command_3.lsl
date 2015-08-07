// :CATEGORY:Walls
// :NAME:Changing_walls_via_command
// :AUTHOR:Ariane Brodie
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:50
// :ID:165
// :NUM:235
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Floor Script (bonus command "miston" covers your floor with fog, "mistoff" turns the fog machines off)
// :CODE:
// Dynamic floors, change textures with a simple command
// By Ariane Brodie
// Particle system by

integer Handle;

//start of Mist routine data
// Mask Flags - set to TRUE to enable
integer glow = TRUE;            // Make the particles glow
integer bounce = TRUE;          // Make particles bounce on Z plan of object
integer interpColor = TRUE;     // Go from start to end color
integer interpSize = TRUE;      // Go from start to end size
integer wind = FALSE;           // Particles effected by wind
integer followSource = TRUE;    // Particles follow the source
integer followVel = TRUE;       // Particles turn to velocity direction

// Choose a pattern from the following:
// PSYS_SRC_PATTERN_EXPLODE
// PSYS_SRC_PATTERN_DROP
// PSYS_SRC_PATTERN_ANGLE_CONE_EMPTY
// PSYS_SRC_PATTERN_ANGLE_CONE
// PSYS_SRC_PATTERN_ANGLE
integer pattern = PSYS_SRC_PATTERN_EXPLODE;

// Select a target for particles to go towards
// "" for no target, "owner" will follow object owner 
//    and "self" will target this object
//    or put the key of an object for particles to go to
key target = "self";

// Particle paramaters
float age = 20;                  // Life of each particle
float maxSpeed = 3;            // Max speed each particle is spit out at
float minSpeed = 2;            // Min speed each particle is spit out at
string texture;                 // Texture used for particles, default used if blank
float startAlpha = 0.2;           // Start alpha (transparency) value
float endAlpha = 0.5;           // End alpha (transparency) value
vector startColor = <1,1,1>;    // Start color of particles <R,G,B>
vector endColor = <1,1,1>;      // End color of particles <R,G,B> (if interpColor == TRUE)
vector startSize = <1.5,1.5,1.5>;     // Start size of particles 
vector endSize = <0.5,0.5,0.5>;       // End size of particles (if interpSize == TRUE)
vector push = <0,0,-1>;          // Force pushed on particles

// System paramaters
float rate = .2;            // How fast (rate) to emit particles
float radius = 3;          // Radius to emit particles for BURST pattern
integer count = 999;        // How many particles to emit per BURST 
float outerAngle = 1.54;    // Outer angle for all ANGLE patterns
float innerAngle = 1.55;    // Inner angle for all ANGLE patterns
vector omega = <1,2,3>;    // Rotation of ANGLE patterns around the source
float life = 0;             // Life in seconds for the system to make particles
// Script variables
integer flags;

default {
    state_entry() {
        Handle = llListen(10, "", NULL_KEY, ""); // start listening on channel 10

	//particle initialization
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
    }

    touch_start(integer total_number) {
        // when touched...
        llListenControl(Handle, TRUE); // ...enable listen
    }
    
    listen(integer channel, string name, key id, string message) {
        // when told "off"...
        if (message == "off") {
            llListenControl(Handle, FALSE);
        }
        else {
            if (message == "black" || message == "blackfloor")
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <0, 0, 0>, 1.0, 
            PRIM_TEXTURE, ALL_SIDES, "5748decc-f629-461c-9a36-a35a221fe21f", <1,1,0>, <0.0,0.0,0>, 0.0]);
            if (message == "grid" || message == "gridfloor")
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <255, 255, 255>, 1.0, 
            PRIM_TEXTURE, ALL_SIDES, "45d55eec-4da6-d4a3-83b2-005e029f25b3", <1,1,0>, <0.0,0.0,0>, 0.0]);
            if (message == "glass" || message == "glassfloor")
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <255, 255, 255>, 1.0, 
            PRIM_TEXTURE, ALL_SIDES, "5b2eb7d3-2e83-7a3e-d944-8baa3f971fec", <1,1,0>, <0.0,0.0,0>, 0.0]);
            if (message == "wood" || message == "woodfloor")
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <255, 255, 255>, 1.0, 
            PRIM_TEXTURE, ALL_SIDES, "89556747-24cb-43ed-920b-47caed15465f", <1,1,0>, <0.0,0.0,0>, 0.0]);
            if (message == "dirt" || message == "dirtfloor")
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <255, 255, 255>, 1.0, 
            PRIM_TEXTURE, ALL_SIDES, "0bc58228-74a0-7e83-89bc-5c23464bcec5", <1,1,0>, <0.0,0.0,0>, 0.0]);
            if (message == "grass" || message == "grassfloor")
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <255, 255, 255>, 1.0, 
            PRIM_TEXTURE, ALL_SIDES, "63338ede-0037-c4fd-855b-015d77112fc8", <1,1,0>, <0.0,0.0,0>, 0.0]);
            if (message == "white" || message == "whitefloor")
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <255, 255, 255>, 1.0, 
            PRIM_TEXTURE, ALL_SIDES, "5748decc-f629-461c-9a36-a35a221fe21f", <1,1,0>, <0.0,0.0,0>, 0.0]);
            if (message == "rock" || message == "rockfloor")
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <255, 255, 255>, 1.0, 
            PRIM_TEXTURE, ALL_SIDES, "53a2f406-4895-1d13-d541-d2e3b86bc19c", <1,1,0>, <0.0,0.0,0>, 0.0]);
            if (message == "mountain" || message == "mountainfloor")
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <255, 255, 255>, 1.0, 
            PRIM_TEXTURE, ALL_SIDES, "303cd381-8560-7579-23f1-f0a880799740", <1,1,0>, <0.0,0.0,0>, 0.0]);
            if (message == "hide" || message == "hidefloor")
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <255, 255, 255>, 0.0]);
            if (message == "miston")
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
            if (message == "mistoff")
            llParticleSystem([]);                     
    }
    }
}
