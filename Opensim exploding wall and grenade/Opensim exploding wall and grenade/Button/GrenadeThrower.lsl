// :SHOW:
// :CATEGORY:Explosion
// :NAME:Opensim exploding wall and grenade
// :AUTHOR:Steven Thompson
// :KEYWORDS:
// :CREATED:2015-04-23 13:48:04
// :EDITED:2015-04-23  12:48:04
// :ID:1076
// :NUM:1746
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// 
//This script generates the grenade prim at a certain velocity in the direction of where the avatar's camera is facing 
//Use: Create a Grenade Launcher Button, and apply this script to it. Each time you click the button a grenade should fly out of it, so it's best if the button is on your HUD somewhere; this will cause the grenade to fly out of your avatar at about head level. 
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



integer Boxes = 1;
integer permission_track_camera = 0x400; // Permission varaible for tracking the camera position

vector relativePosOffset = <0.4, 0.0, 0.0>; 
vector relativeVel = <7.0, 0.0, 5.0>; 
rotation relativeRot = <0.0, 0.0, 0.0, 0.0>; 
integer startParam = 10; // Variable needed by llRezObject that provides permissions to allow the object to be spawned
integer grenadeChannel = -9000;

makePrims(){
    integer i = 0;
    relativePosOffset = relativePosOffset + llGetCameraPos(); // Adjust the spawn direction to be that of the camera
    vector myPos = llGetPos();
    rotation myRot = llGetRot();
    vector rezPos = myPos+relativePosOffset*myRot; // Set the spawn location to be offset by the avatar position and the camera position
    vector rezVel = relativeVel*myRot; // modify the grenade velocity by the avatar's rotation... think of Shot Put
    rotation rezRot = relativeRot*myRot; // modify the grenade rotation with that of the avatar's... again... Shot Put
    
    // Spawn the grenade with the appropriate position, velocity, and rotation
    llRezObject(llGetInventoryName(INVENTORY_OBJECT, 0), rezPos, rezVel, rezRot, startParam);
}
      
default
{
    on_rez(integer a)
    {
        llResetScript();
    }
    state_entry()
    {   
    }
    touch_start(integer a)
    {
        llRegionSay(grenadeChannel, "Destroy Grenade"); // Destroy any lingering grenades... This may deprecated
        makePrims();
    }
}
