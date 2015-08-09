// :CATEGORY:Door
// :NAME:Door_class_Script
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:52
// :ID:251
// :NUM:342
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Door (class Script).lsl
// :CODE:

rotation interval;
float strength;
integer i = 0;
default
{
    state_entry()
    {
        vector pos = llGetPos();//sets pos at where object is made
        llMoveToTarget(pos,0.1);//pos is where to move to,,,0.1 is how fast         it'll get there
        llSetStatus(STATUS_PHYSICS,TRUE);//for enabling physics (putting this        after the 11movetotarget allows us not to use the 11sleep call
        strength = llGetMass();//Nada Epoch says,and now, there is a nice c        all that will get you the mass without having to use physics equation        s to get it
    }

    touch_start(integer total_number)//everything in the { } below the touch_    start gets done (read) when you touch the object
    {
        i++;//Nada Epoch says, i thought origianly you could use the integer        total_number, but, that only keeps track of how many avatars touch it        , not how many times it gets touched, so to make the counter increment       by one put in....same as saying i=i+1
       interval=llEuler2Rot(<0,0,i*PI/6>);//in the (< and >)  the first            three components are the axis of rotation and the last one is the            actual angle, the vector that is inside the ll Euler2Rot call is a           representation of how the object is rotated, so we want it to rotate 0       about the x axis, 0 about the y axis, and 30 degrees about the z, PI         is 180 degrees, so PI/6 is 30---that means that we are multipling 30         degrees times the number of times the object has been touched........       ok so what the llEuler2Rot does is it translates a the angles from the       euler axis, to a rotation 
       llRotLookAt(interval,(strength)/20,strength/20);//this is telling the        object to rotate to the specific rotation "interval" over time               "strength/20", with force "strength/2"  the scripting doc says that          good forcevalues are half of the mass, and good time values are one          tenth of the force. The force causes a torque which moves the object         to the specified rotation
    }
}
// END //
