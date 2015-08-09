// :CATEGORY:Animation
// :NAME:Float_On_Water
// :AUTHOR:Davy Maltz
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:53
// :ID:323
// :NUM:432
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Then, I made a modification to this for my own uses to make the object stay within a certain distance of a certain position. Heres the same script including those changes: 
// :CODE:
float distance = 3; //Distance to allow away from the position.
vector position = <109,206,21>; //Position to stay close to.
default
{
    state_entry()
    {
        llSetTimerEvent(1);
        llSetBuoyancy(0.2);
        llSetStatus(STATUS_ROTATE_X|STATUS_ROTATE_Y,FALSE);
         llSetVehicleType(VEHICLE_TYPE_BOAT);
        llSetVehicleFlags(VEHICLE_FLAG_HOVER_WATER_ONLY);
        llSetVehicleFloatParam(VEHICLE_HOVER_HEIGHT,0.2);
        llSetVehicleFloatParam(VEHICLE_HOVER_EFFICIENCY,0.0);
        llSetVehicleFloatParam(VEHICLE_HOVER_TIMESCALE, 0);
    }
    timer()
    {
        vector pos = llGetPos();
        vector v;
        if(pos.z - 0.4 <= llWater(v))
        {
            llPlaySound("91666289-b6ec-7066-1727-4de10cbc465e",1.0);
        }
        if(llVecDist(llGetPos(),position) > distance)
        {
            llApplyImpulse((llVecMag(llGetVel()) + 2) * (llRot2Up(llAxes2Rot(ZERO_VECTOR, ZERO_VECTOR, llVecNorm(position - llGetPos())))),FALSE);
        }
    }
}
