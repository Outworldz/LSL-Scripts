// :CATEGORY:Sphere World
// :NAME:Walk-On-The-Moon
// :AUTHOR:Ferd Frederix
// :CREATED:2013-11-19 16:49:29
// :ID:1003
// :NUM:1543
// :REV:2
// :WORLD:Second Life
// :DESCRIPTION:
// Sphere script for walking on a planet or moon
// put these three scripts in a sphere and put the Poseball script in a pose ball.
// touch the sphere to train them, then sit on the pose ball. You can have multiple pose balls.

// :CODE:

// Sphere script for walking on a planet or moon
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
 



