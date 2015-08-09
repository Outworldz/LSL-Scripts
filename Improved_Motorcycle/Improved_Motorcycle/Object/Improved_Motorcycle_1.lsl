// :CATEGORY:Vehicles
// :NAME:Improved_Motorcycle
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:55
// :ID:400
// :NUM:556
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Improved Motorcycle.lsl
// :CODE:

default
{
    state_entry()
    {
        llSetSitText("Ride");
        llSitTarget(<0.6, 0.05, 0.20>, ZERO_ROTATION);
        llSetCameraEyeOffset(<-5.0, 0.0, 2.0>);
        llSetCameraAtOffset(<3.0, 0.0, 2.0>);
        llSetVehicleFlags(-1);
        llSetVehicleType(VEHICLE_TYPE_CAR);
        llSetVehicleFlags(VEHICLE_FLAG_NO_FLY_UP | VEHICLE_FLAG_LIMIT_ROLL_ONLY);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 0.2);
        llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 0.80);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, 0.10);
        llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 0.10);
         
        llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_TIMESCALE, 1.0);
        llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 0.2);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_TIMESCALE, 0.1);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, 0.5);
        
        
        llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <1000.0, 2.0, 1000.0>);
        llSetVehicleVectorParam(VEHICLE_ANGULAR_FRICTION_TIMESCALE, <10.0, 10.0, 1000.0>);
        
        
        llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, 0.50);
        llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 0.50);
        
        llSetVehicleFloatParam(VEHICLE_BANKING_EFFICIENCY, 0.99);
        llSetVehicleFloatParam(VEHICLE_BANKING_TIMESCALE, 0.01);
    }
    
    changed(integer change)
    {
        if (change & CHANGED_LINK)
        {
            key agent = llAvatarOnSitTarget();
            if (agent)
            {
                if (agent != llGetOwner())
                {
                    llSay(0, "You aren't the owner");
                    llUnSit(agent);
                    llPushObject(agent, <0,0,100>, ZERO_VECTOR, FALSE);
                }
                else
                {
                    llSetStatus(STATUS_PHYSICS, TRUE);
                    llRequestPermissions(agent, PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS);
                }
            }
            else
            {
                llSetStatus(STATUS_PHYSICS, FALSE);
                llReleaseControls();
                llStopAnimation("motorcycle_sit");
            }
        }
        
    }
    
    run_time_permissions(integer perm)
    {
        if (perm)
        {
            llStartAnimation("motorcycle_sit");
            llTakeControls(CONTROL_FWD | CONTROL_DOWN | CONTROL_UP | CONTROL_BACK | CONTROL_RIGHT | CONTROL_LEFT | CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT, TRUE, FALSE);
        }
    }
    control(key id, integer level, integer edge)
    {
        vector angular_motor;

        if(level & CONTROL_FWD)
        {
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <200,0,0>);
        }
        if(level & CONTROL_BACK)
        {
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <-10,0,0>);
        }
        if(level & (CONTROL_RIGHT|CONTROL_ROT_RIGHT))
        {
            angular_motor.x += 100;
            angular_motor.z -= 100;
        }
        if(level & (CONTROL_LEFT|CONTROL_ROT_LEFT))
        {
            angular_motor.x -= 100;
            angular_motor.z += 100;
        }
        if(level & (CONTROL_UP))
        {
            angular_motor.y -= 50;
        }
        if(level & (CONTROL_DOWN))
        {
            angular_motor.y += 50;
        }
    
        llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, angular_motor);
    }
    
}
// END //
