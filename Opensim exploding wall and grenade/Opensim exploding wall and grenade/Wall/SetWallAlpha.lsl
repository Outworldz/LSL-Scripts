// :SHOW:
// :CATEGORY:Explosion
// :NAME:Opensim exploding wall and grenade
// :AUTHOR:Steven Thompson
// :KEYWORDS:
// :CREATED:2015-04-23 13:48:07
// :EDITED:2015-04-23  12:48:07
// :ID:1076
// :NUM:1750
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// This script is nice to have but not necessarily essential. It allows the destructible wall to switch from being visible to invisible at the press of a button, which is nice if you need to know where it is when it's not populated by bricks or when it is populated by bricks and you don't want users to see the wall.
// Use: Apply the script to the destructible that spawns the bricks. It will be listening for the corresponding button press. 

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

integer setWallAlphaButtonChannel = -88; // Channel for making the wall visible or transparent

default
{
    state_entry()
    {
        integer listenHandle = llListen(setWallAlphaButtonChannel, "", "", ""); // Listen to SetWallAlpha Button
    }
    listen(integer channel, string name, key id, string message)
    {
        if(channel == setWallAlphaButtonChannel) { // Make sure the channel is correct 
            if(llGetAlpha(ALL_SIDES) == 0.0){ 
                llSetAlpha(0.5, ALL_SIDES); // Make the wall half-way visible
            } else {
                llSetAlpha(0.0, ALL_SIDES); // Make the wall completely invisible 
            }
        }
    }
}
