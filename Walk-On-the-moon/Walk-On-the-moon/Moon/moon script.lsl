// :CATEGORY:World
// :NAME:Walk-On-the-moon
// :AUTHOR:Ferd Frederix
// :CREATED:2013-11-19 16:49:18
// :EDITED:2013-11-19 16:49:18
// :ID:1003
// :NUM:1543
// :REV:1.1
// :WORLD:Second Life
// :DESCRIPTION:
// Sphere script for walking on a planet or moon
// put this in a sphere and put the other script in a pose ball.
// touch the sphere, then sit on the poae ball
// :CODE:



// global listeners

integer To_Pose_CHANNEL = 9879877;
integer To_Planet_CHANNEL = 6583586;


Say()
{
    vector size = llGetScale();

    vector pos = llGetPos();
    string place = "SPHERE^" + (string)pos + "^" +  (string)size.x ;
    llRegionSay(To_Pose_CHANNEL, place);
   // llOwnerSay("Sending " +  place);

    
}
default
{
    state_entry()
    {
        llListen(To_Planet_CHANNEL, "", "", "");      // listen for a pet to say XSPET_PING_HOME - Mod by Ferd to listen to HOME_CHANNEL, not -237918
         Say();
    }

    touch_start(integer total_number)
    {
        if (llDetectedKey(0) == llGetOwner()) {
            
            Say();
        }
        
    }

    listen(integer channel, string name, key id, string msg)
    {
       // llOwnerSay("Sphere Heard :" + msg);
        vector size = llGetScale();
        vector pos = llGetPos();

        //pos.z = pos.z - size.z / 2;

        Say();
    }
}
 



