// :SHOW:
// :CATEGORY:Explosion
// :NAME:Opensim exploding wall and grenade
// :AUTHOR:Steven Thompson
// :KEYWORDS:
// :CREATED:2015-04-23 13:48:05
// :EDITED:2015-04-23  12:48:05
// :ID:1076
// :NUM:1747
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// This script will broadcast the message "Die Prims" across the region on the objectChannel = -9. This will cause any objects with the PrimDeleter script to get deleted.
// Use: This should be applied to a button. I called mine DeleterButton.
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



integer objectChannel = -9;

default
{
    touch_start(integer num)
    {
        llRegionSay(objectChannel, "Die Prims"); 
    }
}
