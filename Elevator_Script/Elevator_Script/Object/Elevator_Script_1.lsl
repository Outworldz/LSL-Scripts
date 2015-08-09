// :CATEGORY:Elevator
// :NAME:Elevator_Script
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:52
// :ID:276
// :NUM:368
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Elevator Script.lsl
// :CODE:

vector  alignment;
vector  targetVector;
integer travelDistance;
integer numListen;
integer targetFloor;
list    floorHeights = [26.1,36,46,56,66,76,86,96,106,116,126,136];
float   fixedFloorHeight = 10; //Set to floor heights, or set to -1 to use floorHeights list
float   speed = 0.25; //Valid values are 0.01 to 1.0, a Percentage of maxSpeed;
float   maxSpeed = 32;
float   precision = 0.5;
integer autoSpeed = TRUE;
integer initialDistance;

elevate (vector end)
{
    vector current = llGetPos();
    travelDistance = llRound(current.z-end.z);
    travelDistance = llAbs(travelDistance);
    
    if (autoSpeed)
    {
        if (travelDistance < (initialDistance / 2))
        {
            speed -= (precision / 50);
            if (speed < 0.25) 
              speed = 0.25;
        }
        else
        {
            speed += (precision / 25);
            if (speed > 1) 
              speed = 1;
        }
    }
    if (travelDistance > 30)
    {
        travelDistance = 30;
        if (end.z > current.z)
        {
            end.z = current.z + 30;
        }
        else
        {
            end.z = current.z - 30;
        }
    }
    float i = travelDistance/(maxSpeed*speed);
    llMoveToTarget(end,i);
}

GotoFloor (integer floor, key id)
{    
    llWhisper(0, "Moving to floor#" + (string)floor);
    llSetStatus(STATUS_PHYSICS, TRUE);
    llLoopSound("ElevatorNoises", 1);
    
    targetFloor = floor;

    if (fixedFloorHeight > 0)
    {
        targetVector = alignment;
        targetVector.z = alignment.z + (fixedFloorHeight * floor);
    }
    else
    {
        targetVector = alignment;
        targetVector.z = llList2Float(floorHeights, floor);
    }
    llWhisper(0, "At " + (string)targetVector.z + " meters...");
    
    vector current = llGetPos();
    initialDistance = llRound(current.z-targetVector.z);
    initialDistance = llAbs(initialDistance);
    
    if (autoSpeed)
    {
        speed = 0.01;
    }

    elevate(targetVector);
    llSetTimerEvent(precision);
}

reset()
{
    llSay(0, "Resetting Elevator...");
    llSetStatus(STATUS_ROTATE_X| STATUS_ROTATE_Y| STATUS_ROTATE_Z, FALSE);
    
    alignment = llGetPos();
    llSetStatus(STATUS_PHYSICS, FALSE);
    llStopSound();
    llListenRemove(numListen);
    numListen = llListen( 0, "", "", "" );
}
default 
{
    state_entry()
    {
        reset();
    }
    object_rez(key id)
    {
        llResetScript();
    }
    listen(integer a, string n, key id, string m) 
    { 
        vector pos;
        integer Floor;
        float tempFloat;
        
        if (llSubStringIndex(m, "goto floor") == 0)
        {
            Floor = (integer)llGetSubString(m, 10, llStringLength(m));
            GotoFloor(Floor, NULL_KEY);
        }
        if (llSubStringIndex(m, "speed") == 0)
        {
            tempFloat = (float)llGetSubString(m, 5, llStringLength(m));
            if ((tempFloat > 0.001) && (tempFloat <= 1.0))
            {
                speed = tempFloat;
            }
        }
        if ((m=="elevator reset") && (id==llGetOwner()))
        {
            reset();
        }        
    } 
    
    timer()
    {
        vector CurrentPos;
        float tempfloat;
        
        CurrentPos = llGetPos();
        tempfloat = (CurrentPos.z - targetVector.z);
        
        if (llFabs(tempfloat) < 2) 
        {
            if (llFabs(tempfloat) < 0.05) 
            {
                //Arrived at Floor
                llWhisper(0, "Arrived at floor #" + (string)targetFloor);
                llSetTimerEvent(0); 
                llSetStatus(STATUS_PHYSICS, FALSE);
                llStopSound();
            }
            else
            {
                llMoveToTarget(targetVector,1.0);
            }
        }
        else 
        {
            if (fixedFloorHeight > 0)
            {
                targetVector = alignment;
                targetVector.z = alignment.z + (fixedFloorHeight * targetFloor);
            }
            else
            {
                targetVector = alignment;
                targetVector.z = llList2Float(floorHeights, targetFloor);
            }
            elevate(targetVector);
        }
    }
}




// END //
