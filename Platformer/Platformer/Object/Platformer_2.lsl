// :CATEGORY:Platform
// :NAME:Platformer
// :AUTHOR:Davy Maltz
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:59
// :ID:633
// :NUM:861
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// And then the script to go inside of the platform, which then goes inside of the platformer attachment: 
// :CODE:
default
{
    on_rez(integer start_param)
    {
        llSensor("",llGetOwner(),AGENT,20,TWO_PI);
        llSleep(1.0);
        llSetStatus(STATUS_PHYSICS|STATUS_PHANTOM,TRUE);
        llSetTimerEvent(0.1);
        alpha = 1;
    }
    sensor(integer num_detected)
    {
        llSetPos(llDetectedPos(0));
        llSetRot(llDetectedRot(0));
    }
    timer()
    {
        alpha = alpha - 0.07125;
        llSetAlpha(alpha,ALL_SIDES);
        if(alpha < 0)
        {
            llDie();
        }
    }
}
