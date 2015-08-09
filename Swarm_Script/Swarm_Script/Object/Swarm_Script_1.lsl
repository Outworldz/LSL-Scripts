// :CATEGORY:Weapons
// :NAME:Swarm_Script
// :AUTHOR:Apotheus Silverman
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:05
// :ID:855
// :NUM:1190
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Swarm Script.lsl
// :CODE:

// Swarm script
// by Apotheus Silverman
// with mods from Riptide Ramos
// This script is my implementation of the well-known swarm algorithm
// which can be found in numerous open-source programs.
// Due to the specifics of the SL environment, I have strayed from some
// of the traditional rules slightly. Regardless, the end effect is
// indistiguishable from the original algorithm.

// Configurable parameters

// Determines whether or not to enable STATUS_SANDBOX.
integer sandbox = FALSE;

// Timer length
float timer_length = 0.7;

// Die after this many seconds
integer kill_time = 300;

// How much force to apply with each impulse
float force_modifier = 1.0;

// How much force to apply when repulsed by another like me
float repulse_force_modifier = 0.5;

// How much friction to use on a scale from 0 to 1.
// Note that friction takes effect each timer cycle, so the lower the timer length,
// the more the friction you specify here will take effect, thereby increasing actual
// friction applied.
float friction = 0.6;

// How much to modify rotation damping. Higher numbers produce slower rotation.
float rotation_modifier = 80;

// Does this object "swim" in air or water?
// 2 = air
// 1 = water
// 0 = both
integer flight_mode = 2;

// *** Don't change anything below unless you *really* know what you're doing ***


// Collision function
collide(vector loc) {
    vector mypos = llGetPos();
    float mass = llGetMass();
    // Apply repulse force
    vector impulse = llVecNorm(mypos - loc);
    llApplyImpulse(impulse * repulse_force_modifier * mass, FALSE);
    // Update rotation
    llLookAt(mypos + llGetVel(), mass * 0.5, mass * rotation_modifier);
}

// This function is called whether the sensor senses anything or not
sensor_any() {
    // Die after reaching kill_time
    if (kill_time != 0 && llGetTime() >= kill_time) {
        llDie();
    }

    // Get my position and mass
    vector mypos = llGetPos();

    // Check for air/water breach
    if (flight_mode == 1) {
        // water
        if (mypos.z >= llWater(mypos)) {
            collide(<mypos.x, mypos.y, mypos.z + 0.3> );
        }
    } else if (flight_mode == 2) {
        // air
        if (mypos.z <= llWater(mypos)) {
            collide(<mypos.x, mypos.y, mypos.z - 0.3> );
        }
    }
}


default {
    state_entry() {
        llSay(0, "Fishy spawned.");

        // Sandbox
        llSetStatus(STATUS_SANDBOX, sandbox);
        llSetStatus(STATUS_BLOCK_GRAB, FALSE);

        // Initialize physics behavior
        llSetBuoyancy(1.0);
        llSetStatus(STATUS_PHYSICS, TRUE);
        llSetStatus(STATUS_PHANTOM, FALSE);

        // Initialize sensor
        llSensorRepeat(llGetObjectName(), NULL_KEY, ACTIVE|SCRIPTED, 96, PI, timer_length);
    }


    collision_start(integer total_number) {
        collide(llDetectedPos(0));
    }
    land_collision_start(vector position) {
        vector mypos = llGetPos();
        collide(mypos - llGroundNormal(mypos));
    }

    no_sensor() {
        sensor_any();
    }

    sensor(integer total_number) {
        sensor_any();

        // Populate neighbors with the positions of the two nearest neighbors.
        vector mypos = llGetPos();
        float mass = llGetMass();
        list neighbors = [];
        integer i;
        
        vector v1;
        vector v2;
        float d1 = 100;
        float d2 = 100;

        for (i = 0; i < total_number; i++) {
        vector current_pos = llDetectedPos(i);
        float cur_dist = llVecDist(mypos, current_pos);
        if ( cur_dist < d1 ) {
            // Shift list down, take over top slot.
           d2 = d1;
           v2 = v1;
           d1 = cur_dist;
           v1 = current_pos;
        } else if ( cur_dist < d2 ) {
            // Replace second slot only
           d2 = cur_dist;
           v2 = current_pos;
        }
        }
        
        // Process movement

        // Apply friction
        llApplyImpulse(-(llGetVel() * friction * mass), FALSE);

        // Apply force
        if (llGetListLength(neighbors) == 2) {
            vector neighbor1 = llList2Vector(neighbors, 0);
            vector neighbor2 = llList2Vector(neighbors, 1);
            vector target = neighbor2 + ((neighbor1 - neighbor2) * 0.5);
            vector impulse = llVecNorm(target - mypos);
            llSetForce(impulse * force_modifier * mass, FALSE);
        }

        // Update rotation
        llLookAt(llGetPos() + llGetVel(), mass * 0.5, mass * rotation_modifier);
    }

    on_rez(integer start_param) {
        llResetTime();
    }
}
// END //
