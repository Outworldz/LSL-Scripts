// :SHOW:
// :CATEGORY:Explosion
// :NAME:Opensim exploding wall and grenade
// :AUTHOR:Steven Thompson
// :KEYWORDS:
// :CREATED:2015-04-23 13:48:03
// :EDITED:2015-04-23  12:48:03
// :ID:1076
// :NUM:1745
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// This script is used to generate lingering smoke effects after detonation of Grenade etc.
// Use: This should be applied to a grenade object. It's best if this script is placed in one of the other prims comprising the grenade other than the one using the GrenadeExploder script. 


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




integer explosionChannel = -1337; // CHannel used to make objects involved in explosions communicate with one another
// integer listenHandle;  // unused - Ferd Frederix
float detonationTime = 4.0;
float counter = 0.0;
integer primGeneratorStartValue = 10;

// Modified from http://community.secondlife.com/t5/Scripting/Starting-an-explosion-script/td-p/453247
makeLingeringSmoke() 
{
    //local_offset is ignored
    llParticleSystem([ // Taken From: http://forums-archive.secondlife.com/54/73/273441/1.html
    PSYS_PART_START_ALPHA, 0.3,
          PSYS_PART_END_ALPHA, 0.0,
          PSYS_PART_START_COLOR, <0.667, 0.667, 0.667>,
          PSYS_PART_END_COLOR, <0.667, 0.667, 0.667>,
          PSYS_PART_START_SCALE, <20.0, 20.0, 20.0>,
          PSYS_PART_END_SCALE, <5.0, 5.0, 5.0>,
          PSYS_PART_MAX_AGE, 3.0,
          PSYS_SRC_ACCEL, ZERO_VECTOR,
          PSYS_SRC_ANGLE_BEGIN, 0.0,
          PSYS_SRC_ANGLE_END, PI,
          PSYS_SRC_BURST_PART_COUNT, 100,
          PSYS_SRC_BURST_RADIUS, 0.0,
          PSYS_SRC_BURST_RATE, 0.2,
          PSYS_SRC_BURST_SPEED_MIN, 2.5,
          PSYS_SRC_BURST_SPEED_MAX, 5.0,
          PSYS_SRC_PATTERN,
              PSYS_SRC_PATTERN_EXPLODE,
          PSYS_PART_FLAGS,
              0
              | PSYS_PART_INTERP_COLOR_MASK
              | PSYS_PART_INTERP_SCALE_MASK
        ]);
}

default // Detonate grenade after so many seconds
{
    state_entry()
    {
    }
    on_rez(integer start_param)
    {
        if(start_param == primGeneratorStartValue) // If Grenade was spawned from the 'grenade launcher', then start the timer. 
        {
            llSetTimerEvent(1.0); // Start timer
        }
    }
    timer()
    {
        ++counter;
        if(counter == detonationTime-1){ // Explosion is generated one second before grenade is removed 
            makeLingeringSmoke(); // Generate the lingering smoke effects
        }
    }
}
