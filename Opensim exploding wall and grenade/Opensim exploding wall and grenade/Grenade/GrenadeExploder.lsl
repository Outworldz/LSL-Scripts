// :SHOW:
// :CATEGORY:Explosion
// :NAME:Opensim exploding wall and grenade
// :AUTHOR:Steven Thompson
// :KEYWORDS:
// :CREATED:2015-04-23 13:48:00
// :EDITED:2015-04-23  12:48:00
// :ID:1076
// :NUM:1742
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
This script generates the explosion for a spawned grenade once this grenade is detonataed. This script handles the detonation events, communication with surrounding objects, and deletion of the grenade object. // Use: Apply this script to a grenade object 
// :CODE:

// Copyright 2015 ARL
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//   limitations under the License.


integer grenadeChannel = -9000; // This channel variable MUST have the same value as that in the greandeThrower script.
integer explosionChannel = -1337; // CHannel used to make nearby objects  react physically to the grenade explosion
//integer listenHandle;/ unused fkb
float detonationTime = 4.0;
float counter = 0.0;
integer primGeneratorStartValue = 10;
float explosionForce = 0.5;
// BELOW: Particle Effect Variables
integer particleCount = 450;
vector particleColorStart = <1.000, 0.863, 0.000>/1.5; // Orange
vector particleColorEnd = <0.5, 0.5, 0.5>;//<0.667, 0.667, 0.667>; // Grey
vector particleScaleStart = <0.8, 0.8, 0.8>;
vector particleScaleEnd = <5.0, 5.0, 5.0>;
float particleSpeed = 8;
float particleLifetime =  0.2;
float particleBurstRate = 10.0;
string sourceTextureID = "";
vector localOffset = <0.0, 0.0, 0.0>; // local_offset is ignored

// Taken from http://community.secondlife.com/t5/Scripting/Starting-an-explosion-script/td-p/453247
fakeMakeExplosion(integer particle_count, vector particle_color_start, vector particle_color_end, 
                  vector particle_scale_start, vector particle_scale_end, float particle_speed, 
                  float particle_lifetime, float particle_burst_rate, string source_texture_id, vector local_offset)
{
    // Make explosion burst
    llParticleSystem([
    PSYS_PART_FLAGS, PSYS_PART_EMISSIVE_MASK 
        | PSYS_PART_INTERP_COLOR_MASK
        | PSYS_PART_INTERP_SCALE_MASK,
    PSYS_PART_START_COLOR, particle_color_start,
    PSYS_PART_END_COLOR, particle_color_end,
    PSYS_PART_START_SCALE, particle_scale_start,
    PSYS_PART_END_SCALE, particle_scale_end,
    PSYS_PART_MAX_AGE, particle_lifetime,
    PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE, 
    PSYS_SRC_BURST_RATE, particle_burst_rate,
    PSYS_SRC_BURST_PART_COUNT, particle_count,
    PSYS_SRC_BURST_SPEED_MIN, 0,
    PSYS_SRC_BURST_SPEED_MAX, particle_speed
    ]);
}

default 
{
    state_entry()
    {
        counter = 0.0;
    }
    on_rez(integer start_param)
    {
        if(start_param == primGeneratorStartValue) // If ball was spawned from the 'grenade launcher', then start the timer. 
        {
            llSetTimerEvent(1.0); // Start the timer
        }
    }
    touch_start(integer num_detected) // Set grenade timer by clicking it
    {
        llSetTimerEvent(1.0); // Start the timer
    }
    timer()
    {
        string landLocation;
        ++counter;
        if(counter == detonationTime-1){ // Explosion is generated one second before grenade is removed 
            fakeMakeExplosion(particleCount, particleColorStart, // Make an explosion
                              particleColorEnd, particleScaleStart, 
                              particleScaleEnd, particleSpeed, 
                              particleLifetime, particleBurstRate, 
                              sourceTextureID, localOffset);
            llSetAlpha(0, ALL_SIDES); // Make the grenade no longer visible... but don't delete it just yet because particle effects
            llRegionSay(explosionChannel, "Smokey Time"); // Generate lingering smoke effects
            llTriggerSound("Grenade_Explosion", 30.0); // Make explosion sound
            landLocation = (string)llGetPos();
            string grenadeMessage = landLocation + "|" + (string)explosionForce;
            llRegionSay(explosionChannel, grenadeMessage); // Tell Nearby objects to react to explosion
        }
        if(counter == detonationTime)
        {
            llDie(); // Destroy Grenade
            counter = 0.0; // Reset Counter... just in case
        }
    }
}
