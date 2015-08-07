// :CATEGORY:Altimeter
// :NAME:AirSeaAltimeter
// :AUTHOR:OoPsGalatea
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:47
// :ID:23
// :NUM:33
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// I wrote this for some friends who were new to SL, as a tutorial...then gave it away as a gift to some, since I feel it is more substantial than rating someone. I realized that it would be most substantial to share it with everyone.
// :CODE:
default
{
    state_entry()
    {
        llSetTimerEvent(.01); // How often your timer() event updates
    }

    timer()
    {
        vector pos = llGetPos(); // Gets your current position
        vector size = llGetAgentSize(llGetOwner()); // Get the dimensions of your agent
        size.z = size.z / 2.0; // Halve the height element of your agent, get altitude from feet
        float aboveground = ((float)pos.z - llGround(<0.0,0.0,0.0>) - size.z); // Distance above ground 
        if (aboveground < 0.0) // If it thinks your feet are below ground 
        {
            aboveground = llSqrt(aboveground * aboveground); // - flip it
        }
        if (aboveground < 0.09) // Check the margin of error for zeroing - you can redefine this
        {
            aboveground = 0.0; // Zero it out
        }
        vector Speed = llGetVel(); // LSL function that should be fixed in next release.
        float RealSpeed = llVecMag(Speed); // Convert it to velocity you can use.
        float abovewater = llWater(<0.0,0.0,0.0>) - pos.z; // difference between yourwater height
        if (pos.z >= llWater(<0.0,0.0,0.0>)) // If at or above water
        {
            abovewater = llSqrt(abovewater * abovewater);             
        }        
        if (pos.z < llWater(<0.0,0.0,0.0>)) // If underwater
        {
            abovewater = abovewater - (abovewater * 2.0); // Push the number into the negative range      
        }
        llSetText("Sea Lvl ALT: " + (string)abovewater + "\n" + "Grnd Lvl ALT: " + (string)(aboveground) + "\nSpeed: " + (string)RealSpeed, <1.0,0.0,0.0>, 1.0); // Emit string          
    }
}
