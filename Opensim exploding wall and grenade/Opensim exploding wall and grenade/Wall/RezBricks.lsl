// :SHOW:
// :CATEGORY:Explosion
// :NAME:Opensim exploding wall and grenade
// :AUTHOR:Steven Thompson
// :KEYWORDS:
// :CREATED:2015-04-23 13:48:05
// :EDITED:2015-04-23  12:48:05
// :ID:1076
// :NUM:1748
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:

// This script spawns brick objects based off of the wall's location.
// Use: Apply this script to a hollow, non-physical, phantom wall. When the wall is clicked and if the brick object is in the wall, then bricks will be spawned in a staggered pattern
//    NOTE: The dimensions of the wall aren't important. They act more as a place-holder within an environment.  
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

integer startParam = 0;
vector rezPos;
integer brickRowAmount = 5; // brickRowAmount / brickSize.z = number of bricks rows (round up)
integer brickColumnAmount = 7; // brickColumnAmount / brickSize.x = number of brick columns (round up)

default
{
    state_entry()
    {
    }
    touch_start(integer num_detected)
    {
        float i;
        float j;
        float k = 0.0;
        vector brickSize = <0.5,0.24,0.25>; // Dimensions of brick placed in wall: a mechanism to grab this data is currently being made
        vector wallSize = llGetScale(); // Get the wall location 
        rotation wallRot = llGetRot(); // Get the wall rotation
        vector wallRotVector = llRot2Euler(wallRot); // Convert the wall rotation to vector so it can be applied the placement formula
        // NOTE: Getting the wall to spawn bricks once it's been rotated is currently not working. This mechanism is currently being worked on.
        // Below: loop for spawning bricks
        for(j=0;j<brickRowAmount;j+=brickSize.z){ 
            if(k == 0.0){ // Stagger the placement of the bricks every other row
                k = brickSize.x/2; // Stagger them by half length of the bricks
            } else {
                k =0.0;
            }
            for(i=0;i<=brickColumnAmount;i+=brickSize.x){
                rezPos = llGetPos() - <(wallSize.x/2 - brickSize.x/2 - (float)i + k), 0.0, (wallRotVector.z + wallSize.z/2 - brickSize.z/2 - (float)j)>; // Position Equation
                llRezObject("Brick", rezPos, <0.0,0.0,0.0>, wallRot, startParam); // Rez them bricks
            }
        }
    }
}
