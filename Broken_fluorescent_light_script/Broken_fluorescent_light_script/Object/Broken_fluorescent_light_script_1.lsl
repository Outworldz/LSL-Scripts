// :CATEGORY:Random
// :NAME:Broken_fluorescent_light_script
// :AUTHOR:oddyotoole
// :CREATED:2011-08-05 12:17:16.087
// :EDITED:2013-09-18 15:38:49
// :ID:118
// :NUM:177
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Broken_fluorescent_light_script
// :CODE:
//--------------------------------------
// Random Prim Glow (on/off) and lightning (on/off
// By Oddball Otoole
//--------------------------------------
// This program is free software; you can redistribute it and/or modify it.
// License information must be included in any script you give out or use.
// This script is licensed under the Creative Commons Attribution-Share Alike 3.0 License
// from http://creativecommons.org/licenses/by-sa/3.0 unless licenses are
// included in the script or comments by the original author,in which case
// the authors license must be followed.

//-------------------------------------
//Global Variables
float glow;
float time;

//-------------------------------------
// Main program
default
{
    state_entry()
    {
  llSetColor(<1.0, 1.0, 1.0>, ALL_SIDES);
        state begin;
    }
}

//-------------------------------------
// Begin state
state begin
    {
        state_entry()
        {
        glow = (integer) llRound(llFrand(1)); // Random on or off
        time = (float) llFrand(2); // Random wait time
            llSetPrimitiveParams([PRIM_GLOW, ALL_SIDES, glow]); //Set Prim glow on/off
            llSetPrimitiveParams([PRIM_POINT_LIGHT, TRUE, <1.0, 1.0, 1.0>, glow, 5.0, 0.5]); // Set prim light on/of
            state wait; // Go to the Wait State
        }
    }

//-------------------------------------
// Wait state
state wait
    {
        state_entry()
        {
            llSleep(time); //Wait
            state begin; // Go back to the Begin State
        }
    }
