// :SHOW:
// :CATEGORY:Explosion
// :NAME:Opensim exploding wall and grenade
// :AUTHOR:Steven Thompson
// :KEYWORDS:
// :CREATED:2015-04-23 13:48:01
// :EDITED:2015-04-23  12:48:01
// :ID:1076
// :NUM:1743
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// This script is goes into a brick

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



integer ExplosionChannel = -1337;
integer listenHandle;
// float explosionDistance;  // unused fkb
// vector impulseDirection; / unused fkb
float blastRadius = 2.0;
integer counter = 0;
integer superCounter = 0;
default
{
    state_entry()
    {
        listenHandle = llListen(ExplosionChannel, "", "", "");
    }
    listen (integer channel, string name, key id, string message)
    {
        list messageList = llParseString2List(message, ["|"], []);// Parse Message to get greande position and explosion force
        //llSay(0, messageList(0));
        vector grenadeLocation = llList2Vector(messageList, 0); // Grenade position is in the first cell of the list
        float explosionForce = (float)llList2String(messageList, 1);  // Explosion force value is in the second cell of the list
        vector objectLocation = llGetPos();
        /*explosionDistance = llVecDist(grenadeLocation, objectLocation); // Calculate the distance from grenade to object
        // Impulse on object is based on how close the object is to the explosion
        impulseDirection = <grenadeLocation.x-objectLocation.x, grenadeLocation.y-objectLocation.y, grenadeLocation.z-objectLocation.z>;//explosionDistance;
        if(explosionDistance <= 15) llApplyImpulse(impulseDirection*10, TRUE); // If the object is within 15 meters of the explosion, make object react
        llSay(0, message);*/

        //llSay(0, (string)objectLocation);
        //llSay(0, (string)grenadeLocation);
        //BELOW: From Mike
        vector diff = objectLocation-grenadeLocation;//objectLocation-grenadeLocation;//mypos-bpos;
        //llSay(0, (string)diff);
        float mag = llVecMag(diff);
        //llSay(0, (string)mag);
        //llSay(0, "diff.z: " + (string)diff.z);
        float cylinderMag  = llVecMag(<diff.x, diff.y, 0>); // Come up with better name 
        if(cylinderMag < blastRadius && diff.z < blastRadius*2){ // Make bricks within blast radius and those near destroyed bricks ready to react to detonation
            llSetStatus(STATUS_PHYSICS, TRUE); // make the object Physical
            llSetStatus(STATUS_PHANTOM, FALSE); // no phantom objects
        }
        if(mag < blastRadius){ // Make all bricks within blast radius to get exploded
            //llSetStatus(STATUS_PHYSICS, TRUE); // make the object Physical
            //llSetStatus(STATUS_PHANTOM, FALSE); // no phantom objects
            float brickMass = llGetMass();
            vector velocityVector = explosionForce*diff;
            vector momentumVector = brickMass * velocityVector;
            //llSetVelocity(diff*(blastRadius-mag), TRUE);
            //llSetPos(llGetPos()+diff*(blastRadius-mag));
            llApplyImpulse(momentumVector, FALSE);//diff*(blastRadius-mag), FALSE);
            //llSetForce(diff*(blastRadius-mag), TRUE);
            llSetTimerEvent(1.0); // Start timer to see how long it make bricks come to rest after so many seconds
        }
    }
    timer()
    {        
        counter++;
        if (counter == 20) {
            //llSay(0, (string)llGetVel());
            if (llVecMag(llGetVel()) == 0) {
                llSetStatus(STATUS_PHYSICS, FALSE); // If the object has stopped moving, make it Non-physical
            } else if(superCounter == 5){
                llSetVelocity(<0.0,0.0,0.0>, FALSE);
                llSetStatus(STATUS_PHYSICS, FALSE);
            } else {
                counter = 0;
                superCounter++;
                //llSay(0, (string)superCounter);
            }
        }
    }
}
