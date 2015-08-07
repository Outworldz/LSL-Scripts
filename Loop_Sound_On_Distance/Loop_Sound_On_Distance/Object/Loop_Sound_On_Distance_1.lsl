// :CATEGORY:Sound
// :NAME:Loop_Sound_On_Distance
// :AUTHOR:Davy Maltz
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:56
// :ID:494
// :NUM:661
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// The script
// :CODE:
float distance = 10; //Distance in which to sense for Agents.
default
{
    on_rez(integer start_param)
    {
        llResetScript();
    }
    state_entry()
    {
        llSensorRepeat("","",AGENT,distance,PI,0.01);
    }
    sensor(integer num_detected)
    {
        llStopSound();
    }
    no_sensor()
    {
        llLoopSound("",1.0);
    }
}
