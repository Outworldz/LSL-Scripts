// :CATEGORY:Pointer
// :NAME:Pointer
// :AUTHOR:Davy Maltz
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:59
// :ID:636
// :NUM:865
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// And this version, which doesn't: 
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
    }
    no_sensor()
    {
        llSetRot(ZERO_ROTATION);
    }
}
