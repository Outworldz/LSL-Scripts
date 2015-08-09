// :CATEGORY:Combat
// :NAME:The_Terra_Combat_System_TCS
// :AUTHOR:Cubey Terra
// :CREATED:2010-07-01 15:11:14.270
// :EDITED:2013-09-18 15:39:07
// :ID:887
// :NUM:1262
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// gun particles
// :CODE:
// TERRA COMBAT SYSTEM V2.5 - PARTICLE EMITTER
// Put in gun barrel. Emits particle bullet effect along the prim's Z axis.
// Loops a gunfire sound while emitting particles.

integer combat = FALSE;
string gunSound = "6e866a66-9739-43a7-6b64-ebed378262f2";
integer firing;


fire() 
{
    if (!firing)
    {
        firing = TRUE;
        //llOwnerSay("DEBUG: Start firing...");
        llParticleSystem([PSYS_PART_FLAGS, PSYS_PART_INTERP_COLOR_MASK|PSYS_PART_INTERP_SCALE_MASK|PSYS_PART_EMISSIVE_MASK|PSYS_PART_FOLLOW_SRC_MASK|PSYS_PART_FOLLOW_VELOCITY_MASK, PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_ANGLE_CONE, PSYS_SRC_INNERANGLE, 10.0, PSYS_SRC_OUTERANGLE, 10.0, PSYS_PART_MAX_AGE, 10.0, PSYS_SRC_MAX_AGE, 0.0, PSYS_PART_START_COLOR, <1,1,0>, PSYS_PART_END_COLOR, <1,1,0>, PSYS_PART_START_ALPHA, 1.0, PSYS_PART_END_ALPHA, 1.0, PSYS_PART_START_SCALE, <0.5,0.5,0.5>, PSYS_PART_END_SCALE, <0.5,0.5,0.5>, PSYS_SRC_BURST_RATE, 0.01, PSYS_SRC_BURST_PART_COUNT, 1, PSYS_SRC_BURST_SPEED_MIN, 80.0, PSYS_SRC_BURST_SPEED_MAX, 80.0]);
        llLoopSound(gunSound,1);
    }
}

ceaseFire()
{
    if (firing)
    {
        firing = FALSE;
        //llOwnerSay("DEBUG: Stop firing.");
        llParticleSystem([]);
        llStopSound();
    }
    
}


default
{
    state_entry()
    {
        ceaseFire();
    }
    
    on_rez(integer num)
    {
        ceaseFire();
    }

    
    link_message(integer sender_number, integer number, string message, key id)
    {
        if ((message == "tc ctrl") && combat)
        {
            
            // The the vehicle script should pass the held (or "level") integer to this script
            integer ctrl = number;
            if ((ctrl & CONTROL_ML_LBUTTON) || (ctrl & CONTROL_LBUTTON))
            {
                fire();
            }
            else ceaseFire();
            
        } 
        
        else if (message == "tc on")    combat = TRUE;

        else if ((message == "tc off") || (message == "tc unseated"))   combat = FALSE;
    }
}
