// :CATEGORY:Helicopter
// :NAME:Helicopter scripts
// :AUTHOR:Anonymous
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:54
// :ID:377
// :NUM:521
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// controller
// :CODE:

        
////////////////////////////////////////////////////////////////

integer HUD = 87654567;        // the secret channel the HUD is own
float ROTATION_RATE = 1.0;      //  Rate of turning  
float FWD_THRUST = 25;        //  Forward thrust motor force 
float BACK_THRUST = 25;       //  Backup thrust
float VERTICAL_THRUST = 15;
vector linear_motor = <0,0,0>; // Keep a running linear motor value for better response


default {

    // this runs first after a reset
    state_entry() {

        llListen(HUD,"","","");            // listen for HUD commands
        llListen(0,"",llGetOwner(),"");    // listen for owner on channel 0

        llSitTarget(<0.1, 0.0, 1.95>, ZERO_ROTATION);
        
        llSetVehicleType(VEHICLE_TYPE_AIRPLANE);

        llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 0.5);
        llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 0.5);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, 100);
        llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 100);

        llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_TIMESCALE, 0.2);
        llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 10);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_TIMESCALE, 0.2);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, 0.1);

        llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <5,5,5>);
        llSetVehicleVectorParam(VEHICLE_ANGULAR_FRICTION_TIMESCALE, <10,10,10>);
        llSetVehicleFloatParam(VEHICLE_HOVER_HEIGHT, 0.0);
        llSetVehicleFloatParam(VEHICLE_HOVER_EFFICIENCY, 0.0);
        llSetVehicleFloatParam(VEHICLE_HOVER_TIMESCALE, 1.0);
        llSetVehicleFloatParam(VEHICLE_BUOYANCY, 1.0);

        llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, 0.2);
        llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 3.0);

        llSetVehicleFloatParam(VEHICLE_BANKING_EFFICIENCY, 1.0);
        llSetVehicleFloatParam(VEHICLE_BANKING_MIX, 0.75);
        llSetVehicleFloatParam(VEHICLE_BANKING_TIMESCALE, 0.05);

        llSetCameraEyeOffset(<-7.0, 0.0, 3.0>);
        llSetSitText("RAH-66");
        llSetCameraAtOffset(<0.5, 0, 0>);
    }

    changed(integer change) {
        if (change & CHANGED_LINK) {
            key agent = llAvatarOnSitTarget();
            if (agent) {
                if (agent != llGetOwner()) {
                    // only the owner can use this vehicle
                    llSay(0, "You aren't the owner of this Comanche.");
                    llUnSit(agent);
                    llPushObject(agent, <0,0,10>, ZERO_VECTOR, FALSE);
                } else {
                    // driver is entering the vehicle
                    llOwnerSay("type 'start' to begin fying");
                    // llRequestPermissions(agent, PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS);
                }
            } else {
                // driver is getting up
                llSetStatus(STATUS_PHYSICS, FALSE);
                llReleaseControls();
            }
        }
    }


    listen(integer channel, string name, key id, string message)
    {
        if(llToLower(message) == "start")    {
            // owner or HUD spoke 'STart' or START or start
            llMessageLinked(LINK_SET,0,"start","");    // send to any other scripts
            llRequestPermissions(llGetOwner(), PERMISSION_TAKE_CONTROLS);
        } else if (llToLower(message) == "stop")        {
            llMessageLinked(LINK_SET,0,"stop","");    // send 'stop' to any other scripts
            llSetStatus(STATUS_PHYSICS, FALSE);
            llReleaseControls();
        }
    }
    
    run_time_permissions(integer perm) {
        if (perm & PERMISSION_TAKE_CONTROLS) {
            
            llSetStatus(STATUS_PHYSICS, TRUE);
            llTakeControls(CONTROL_FWD | CONTROL_BACK | CONTROL_RIGHT | CONTROL_LEFT | CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT | CONTROL_UP | CONTROL_DOWN, TRUE, FALSE);
        }
    }


    link_message(integer sender_number, integer number, string message, key id)
    {
        // incoming link messages appar here, so you can control this script from other scripts.
    }
    
    control(key id, integer level, integer edge) {
        if(level & (CONTROL_LEFT | CONTROL_ROT_LEFT)) {
            llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, <-ROTATION_RATE,0,0>);
        } else if (edge & (CONTROL_LEFT | CONTROL_ROT_LEFT)) {
            llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, <0,0,0>);
        }
        if(level & (CONTROL_RIGHT | CONTROL_ROT_RIGHT)) {
            llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, <ROTATION_RATE,0,0>);
        } else if (edge & (CONTROL_RIGHT | CONTROL_ROT_RIGHT)) {
            llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, <0,0,0>);
        }

        if(level & CONTROL_FWD) {
            linear_motor.x = FWD_THRUST;
        } else if (edge & CONTROL_FWD) {
            linear_motor.x = 0;
        }
        if(level & CONTROL_BACK) {
            linear_motor.x = -BACK_THRUST;
        } else if (edge & CONTROL_BACK) {
            linear_motor.x = 0;
        }
        
        if(level & CONTROL_UP) {
            linear_motor.z = VERTICAL_THRUST;
        } else if (edge & CONTROL_UP) {
            linear_motor.z = 0;
        }
        if(level & CONTROL_DOWN) {
            linear_motor.z = -VERTICAL_THRUST;
        } else if (edge & CONTROL_DOWN) {
            linear_motor.z = 0;
        }
        llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, linear_motor);
        
    }
}
