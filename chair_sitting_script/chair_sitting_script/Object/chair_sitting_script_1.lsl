// :CATEGORY:Pose Balls
// :NAME:chair_sitting_script
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:50
// :ID:163
// :NUM:231
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// chair sitting script.lsl
// :CODE:

default
{
    state_entry()
    {
        llSitTarget(<0.25,0.0,0.35>,<0,0,0,1>);	// forward 0.25, up 0.35
        llSetSitText("sit");	
    }
}
