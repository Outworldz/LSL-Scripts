// :CATEGORY:Movement
// :NAME:Dodge
// :AUTHOR:Davy Maltz
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:51
// :ID:245
// :NUM:336
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Dodge
// :CODE:
default
{
    state_entry()
    {
        llSensorRepeat("","",ACTIVE,5,PI,0.1);
    }

    sensor(integer num_detected)
    {
        if(llVecMag(llDetectedVel(0)) >= 10 && llDetectedOwner(0) != llGetOwner())
        {
            vector savedpos = llGetPos();
            llMoveToTarget(llGetPos() + <0,0,10>,0.045);
            llSleep(1.4);
            llMoveToTarget(savedpos,0.045);
            llSleep(0.2);
            llStopMoveToTarget();
            
        }
    }
}

