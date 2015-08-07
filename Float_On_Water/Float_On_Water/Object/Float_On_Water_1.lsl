// :CATEGORY:Animation
// :NAME:Float_On_Water
// :AUTHOR:Davy Maltz
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:53
// :ID:323
// :NUM:431
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// The most basic form of the script, No constraints here: 
// :CODE:
default
{
    state_entry()
    {
        llSetBuoyancy(0.2);
        llSetStatus(STATUS_ROTATE_X|STATUS_ROTATE_Y,FALSE);
         llSetVehicleType(VEHICLE_TYPE_BOAT);
        llSetVehicleFlags(VEHICLE_FLAG_HOVER_WATER_ONLY);
        llSetVehicleFloatParam(VEHICLE_HOVER_HEIGHT,0.2);
        llSetVehicleFloatParam(VEHICLE_HOVER_EFFICIENCY,0.0);
        llSetVehicleFloatParam(VEHICLE_HOVER_TIMESCALE, 0);
    }
}
