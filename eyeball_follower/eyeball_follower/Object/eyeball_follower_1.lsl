// :CATEGORY:Eyeballs
// :NAME:eyeball_follower
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:52
// :ID:292
// :NUM:390
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// eyeball follower.lsl
// :CODE:

vector AXIS_UP = <0,0,1>;
vector AXIS_LEFT = <0,1,0>;
vector AXIS_FWD = <1,0,0>;
// Strength and damping are values used to control how llRotLookAt and llLookAt move, these values are tunable.
float strength = 1.0;
float damping = 1.0;



// getRotToPointAxisAt()
// Gets the rotation to point the specified axis at the specified position.
// @param axis The axis to point. Easiest to just use an AXIS_* constant.
// @param target The target, in region-local coordinates, to point the axis at.
// @return The rotation necessary to point axis at target.
// Created by Ope Rand, modifyed by Christopher Omega


rotation getRotToPointAxisAt(vector axis, vector target) 
{
    return llGetRot() * llRotBetween(axis * llGetRot(), target - llGetPos());
}


default
{
    state_entry()
    {
         llSensorRepeat("", NULL_KEY, AGENT, 20.0, PI, 2 );

    }

     sensor(integer num) 
    {


         vector target = llDetectedPos(0);
    

        // These two lines are equivalent, and point the up (Z) axis at the target:
        llRotLookAt(getRotToPointAxisAt(AXIS_UP, target), strength, damping);
        //llLookAt(target, strength, damping);



    }
}
  // END //
