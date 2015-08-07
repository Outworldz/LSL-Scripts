// :CATEGORY:Useful Subroutines
// :NAME:Close_Approach_Calculator__Imaginar
// :AUTHOR:Northwest Portland
// :CREATED:2010-11-16 11:27:43.270
// :EDITED:2013-09-18 15:38:50
// :ID:184
// :NUM:257
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// This is something I've seen asked for a lot on various forums and in world. It could be useful for a few things I suppose, combat systems, path finding, what have you.// // The work here is done by a function that given the starting positions of two objects, and their velocities, it will tell you how close they'll get. In a combat system you might do something like assume all avatars have a radius of about one meter, and then use this to calculate how close an imaginary projectile could come to hitting someone. If it comes closer than one meter, it would be a hit.// // Here's the code in the form of an "Imaginary Gun".
// :CODE:
float target_radius = 1.0;
float bullet_speed = 50.0;

float ClosestApproachDistance(vector target, vector target_velocity, vector me, vector me_velocity)
{
    // This makes the calculation much simpler by changing the frame of
    // reference so that the target appears stationary in relation to me.
    // Now it's a matter of calculating closest approach between a point and
    // a ray, instead of two rays.
    vector target_relative_velocity = me_velocity - target_velocity;

    // Initial distance between you and the target. This becomes the hypotenuse
    // of a right triangle.
    float initial_distance = llVecDist(me, target);

    // Use the dot product of the normalized vector to target and my normalized
    // velocity to determine the angle of approach.
    float angle_of_approach = llAcos(llVecNorm(target - me) * llVecNorm(target_relative_velocity));

    if (angle_of_approach < PI_BY_TWO) // Make sure the projectile is headed toward the target.
    {
        // We have the hypotenuse and theta, so now it's just trig to determine
        // distance of closest approach.
        return llSin(angle_of_approach) * initial_distance;
    }
    else
    {
        // I'm already moving tangent or headed away from the target. We're not
        // getting any closer than we already are.
        return initial_distance;
    }
}

initialize()
{
    llRequestPermissions(llGetOwner(), PERMISSION_TAKE_CONTROLS);
}

finalize()
{
    llReleaseControls();
}

default
{
// --> Basic Attachment Junk.
    state_entry()
    {
        if (llGetAttached() != 0)
        {
            initialize();
        }
    }
    
    on_rez(integer sparam)
    {
        // If for some reason detach didn't call finalize, we call it again now.
        if (llGetAttached() == 0)
        {
            finalize();
        }
    }
    
    attach(key id)
    {
        // Start when attached and stop when detached.
        if (id != NULL_KEY)
        {
            initialize();
        }
        else
        {
            finalize();
        }
    }
// --> Basic Attachment Junk.
    
    run_time_permissions(integer perms)
    {
        if ((perms & PERMISSION_TAKE_CONTROLS) != 0)
        {
            llTakeControls(CONTROL_ML_LBUTTON, TRUE, FALSE);
        }
    }
    
    control(key id, integer level, integer edge)
    {
        if ((edge & level & CONTROL_ML_LBUTTON) != 0)
        {
            llSensor("", NULL_KEY, AGENT, 96.0, PI_BY_TWO);
            llOwnerSay("BANG!");
        }
    }
    
    sensor(integer n)
    {
        vector agent_size = llGetAgentSize(llGetOwner());
        vector bullet_start_position = llGetPos() + <0.0, 0.0, agent_size.z * 0.45>;
        vector bullet_velocity = llRot2Fwd(llGetRot()) * bullet_speed;
        integer i;
        
        for (i = 0; i < n; i += 1)
        {
            if (ClosestApproachDistance(llDetectedPos(i), llDetectedVel(i), bullet_start_position, bullet_velocity) < target_radius)
            {
                llOwnerSay("You shot " + llDetectedName(0) + "!");
                return;
            }
        }
    }
}
