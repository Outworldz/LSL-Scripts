// :CATEGORY:Sphere World
// :NAME:Sphere_World__Walk_and_live_on_a_sphere
// :AUTHOR:Ferd Frederix
// :CREATED:2013-12-13 14:01:06
// :EDITED:2013-12-13 14:01:06
// :ID:824
// :NUM:1554
// :REV:1.1
// :WORLD:Second Life
// :DESCRIPTION:
// Put this in a large sphere.
//  It sends the sphere's size and position to the pose balls
// You can then make the sphere any size, click the sphere, and pose balls will move to the correct radius
// Thanks to Shameena Short for reporting bugs!
// :CODE:

// Sphere script for walking on a planet or moon
// global listeners

integer To_Pose_CHANNEL = 98798771;
integer To_Planet_CHANNEL = 65835861;



Say()
{
    vector size = llGetScale();

    vector pos = llGetPos();
    string place = "SPHERE^" + (string)pos + "^" +  (string)size.x ;
    llShout(To_Pose_CHANNEL, place);
    llOwnerSay("Sending " +  place);

    
}
default
{
    state_entry()
    {
        llTargetOmega(<.5,0.0,0.0>*llGetRot(),0.1,0.01);

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
        llOwnerSay("Sphere Heard :" + msg);
        vector size = llGetScale();
        vector pos = llGetPos();

        //pos.z = pos.z - size.z / 2;

        Say();
    }
}
 



