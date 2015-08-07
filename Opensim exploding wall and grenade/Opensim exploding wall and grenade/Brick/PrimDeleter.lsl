// :SHOW:
// :CATEGORY:Explosion
// :NAME:Opensim exploding wall and grenade
// :AUTHOR:Steven Thompson
// :KEYWORDS:
// :CREATED:2015-04-23 13:48:02
// :EDITED:2015-04-23  12:48:02
// :ID:1076
// :NUM:1744
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// When attached to an object, this script will allow that object to be deleted once the deleter button is pushed.
// Use: attach this script to any item that needs to be deleted regularly. This is good for cleaning up after spawning a large number of that you may or may not be keeping track of.

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
    state_entry()
    {
        llListen(objectChannel, "", "", "Die Prims"); // Listen for "Die Prims" to be entered broadcasted over objectChannel
    }
    listen(integer channel, string name, key id, string message)
    {
        if(message == "Die Prims") llDie(); //Delete Prims
    }
}
