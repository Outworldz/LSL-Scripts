// :SHOW:
// :CATEGORY:Explosion
// :NAME:Opensim exploding wall and grenade
// :AUTHOR:Steven Thompson
// :KEYWORDS:
// :CREATED:2015-04-23 13:48:06
// :EDITED:2015-04-23  12:48:06
// :ID:1076
// :NUM:1749
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Allows the destructible wall's alpha to be changed via button click
// Use: Apply this script to a button to change the wall's aplha; I called mine SetWallAlphaButton. 
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


integer setWallAlphaButtonChannel = -88;

default
{
    state_entry()
    {
    }
    touch_start(integer num_detected)
    {
        llRegionSay(setWallAlphaButtonChannel, ""); // Send an empty message to DestructibleWall_Brick that makes it change its alpha
    }
}
