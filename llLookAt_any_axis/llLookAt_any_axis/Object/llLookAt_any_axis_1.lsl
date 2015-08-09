// :CATEGORY:Useful Subroutines
// :NAME:llLookAt_any_axis
// :AUTHOR:LSL Wiki
// :CREATED:2010-02-01 16:11:49.660
// :EDITED:2013-09-18 15:38:56
// :ID:484
// :NUM:651
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// llLookAt_any_axis
// :CODE:
// AXIS_* constants, represent the unit vector 1 unit on the specified axis.
vector AXIS_UP = <0,0,1>;
vector AXIS_LEFT = <0,1,0>;
vector AXIS_FWD = <1,0,0>;

// getRotToPointAxisAt()
// Gets the rotation to point the specified axis at the specified position.
// @param axis The axis to point. Easiest to just use an AXIS_* constant.
// @param target The target, in region-local coordinates, to point the axis at.
// @return The rotation necessary to point axis at target.
// Created by Ope Rand, modifyed by Christopher Omega
rotation getRotToPointAxisAt(vector axis, vector target) {
    return llGetRot() * llRotBetween(axis * llGetRot(), target - llGetPos());
}

// Strength and damping are values used to control how llRotLookAt and llLookAt move, these values are tunable.
float strength = 1.0;
float damping = 1.0;

default {
    state_entry() {
        vector target = <10, 20, 30>; // A vector to look at.

        // These two lines are equivalent, and point the up (Z) axis at the target:
        llRotLookAt(getRotToPointAxisAt(AXIS_UP, target), strength, damping);
        llLookAt(target, strength, damping);

        // This line points the fwd (X) axis at the target:
        llRotLookAt(getRotToPointAxisAt(AXIS_FWD, target), strength, damping);

        // This line points the left (Y) axis at the target:
        llRotLookAt(getRotToPointAxisAt(AXIS_LEFT, target), strength, damping);
    }
}
