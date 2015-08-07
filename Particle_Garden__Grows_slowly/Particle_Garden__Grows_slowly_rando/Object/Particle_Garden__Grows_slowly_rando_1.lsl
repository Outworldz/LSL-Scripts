// :CATEGORY:Particles
// :NAME:Particle_Garden__Grows_slowly
// :AUTHOR:Zara Vale
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:59
// :ID:610
// :NUM:834
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Particle Garden - Grows slowly, random textures by Zara Vale.lsl
// :CODE:

//********************************************************
//This Script was pulled out for you by YadNi Monde from the SL FORUMS at http://forums.secondlife.com/forumdisplay.php?f=15, it is intended to stay FREE by it s author(s) and all the comments here in ORANGE must NOT be deleted. They include notes on how to use it and no help will be provided either by YadNi Monde or it s Author(s). IF YOU DO NOT AGREE WITH THIS JUST DONT USE!!!
//********************************************************







//Particle Garden - Grows slowly, random textures by Zara Vale
//Hello everyone,
//
//This is my first post in here so I hope I'm doing it right. Took me forever to learn how to put the code thing in. Anyway on behalf of Tina Vale and myself I would like to present the particle garden script that I use in my classes.
//
//What does it do?
//- It shows a particle picture of what ever texture that is in the object randomly.
//- The flowers grow slowly
//- It is visible from all angles like all particles
//
//How do you use it?
//- Rez an Object
//- Change the ROTATION X=90, Y=0, Z=0 (Under the OBJECT tab for the object)
//- You put this script into an object (Click on New Script in the object's contents and copy the code below to this object and save)
//- Put any other flowers, gnomes, tree textures you want inside it.
//- Click to start / stop




float MAX_RADIUS = 2.5;
float RADIUS_INTERVAL = 0.5;

// Modified values
integer IS_ON = FALSE;
float RADIUS = 2;
string TEXTURE = "f42bcc2b-20c8-9df7-cf1c-69566e377fd8";

garden() {
    llParticleSystem([
        PSYS_PART_FLAGS, 0 | PSYS_PART_EMISSIVE_MASK |
        PSYS_PART_INTERP_COLOR_MASK | PSYS_PART_INTERP_SCALE_MASK,
        PSYS_SRC_PATTERN,PSYS_SRC_PATTERN_ANGLE_CONE,
        
        // Texture / Size / Alpha / Color
        PSYS_SRC_TEXTURE, TEXTURE,
        PSYS_PART_START_SCALE,<0.2000, 0.2000, 0.0000>,
        PSYS_PART_END_SCALE,<0.5000, 0.5000, 0.0000>,
        PSYS_PART_START_ALPHA,0.000000,
        PSYS_PART_END_ALPHA,1.000000,
        PSYS_PART_START_COLOR, <1.0,1.0,1.0>,
        PSYS_PART_END_COLOR, <1.0,1.0,1.0>,    
        
        // Flow
        PSYS_PART_MAX_AGE,1000.0000,
        PSYS_SRC_BURST_RATE,1.000000,
        PSYS_SRC_BURST_PART_COUNT,1,
        PSYS_SRC_MAX_AGE,0.000000,
        
        // Rez position
        PSYS_SRC_BURST_RADIUS,RADIUS,
        PSYS_SRC_INNERANGLE,1.550000,
        PSYS_SRC_OUTERANGLE,1.550000,
        PSYS_SRC_OMEGA,<0.00000, 0.00000, 4>,        
        PSYS_SRC_BURST_SPEED_MIN,0.000000,
        PSYS_SRC_BURST_SPEED_MAX,0.000000
    ]);
}

stop() {
    llParticleSystem([]);
}

default {
    state_entry() {
        if(IS_ON) {
            llSetTimerEvent(RADIUS_INTERVAL);
            garden();
        } else {
            stop();
        }
    }
    
    touch_start(integer num_detected) {
        if(IS_ON) {
            llSetTimerEvent(0.0);
            stop();
            llWhisper(0, "Garden has stopped");
        } else {
            llSetTimerEvent(RADIUS_INTERVAL);
            garden();
            llWhisper(0, "Garden has started");
        }
        IS_ON = !IS_ON;
    }
    
    timer() {
        integer max_inventory = llGetInventoryNumber(INVENTORY_TEXTURE);
        if(max_inventory > 0) {
            TEXTURE = llGetInventoryName(INVENTORY_TEXTURE, (integer)llFrand(max_inventory));
        }
        RADIUS = llFrand(MAX_RADIUS);
        garden();
    }
} // END //
