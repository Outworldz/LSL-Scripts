// :CATEGORY:Pointer
// :NAME:Pointer
// :AUTHOR:Davy Maltz
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:59
// :ID:636
// :NUM:864
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// First, The version which includes the llMoveToTarget follow: 
// :CODE:
default
{
    on_rez(integer start_param)
    {
        llResetScript();
    }
    state_entry()
    {
        llSensorRepeat("","",AGENT,96,TWO_PI,0.01);
    }
    sensor(integer num_detected)
    {
        integer num = 0;
        if(llDetectedKey(0) == llGetOwner())
        {
            num = 1;
        }
        llLookAt(llDetectedPos(num),.5,.5);
        integer i;
        for(i = 0; i < num_detected; ++i)
        {
            if(llDetectedKey(i) == llGetOwner())
            {
                llMoveToTarget(llDetectedPos(i) + <0,0,7>,0.1);
            }
        }
    }
    no_sensor()
    {
        llSetRot(ZERO_ROTATION);
    }
}
