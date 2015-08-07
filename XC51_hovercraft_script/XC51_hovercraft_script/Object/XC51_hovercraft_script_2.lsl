// :CATEGORY:Vehicles
// :NAME:XC51_hovercraft_script
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:09
// :ID:984
// :NUM:1409
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// flight script for XC-5 hovercraft
// :CODE:


key pilot;
vector pos;
vector linear;
vector angular;
integer under_power;
integer listenindex;
float throttle;
integer cloaked;

default
{
    state_entry()
    {
        llMessageLinked(LINK_SET, 0, "vtol", NULL_KEY);
        llWhisper(0, "Mode: Hover");
        linear = ZERO_VECTOR;
        angular = ZERO_VECTOR;
        under_power = FALSE;
        throttle = 0.0;
        llMessageLinked(LINK_SET, (integer)throttle, "throttle", NULL_KEY);

        llCollisionSound("", 0.0);
        llSetCameraEyeOffset(<-10.0, 0.0, 3.0>);
        llSetCameraAtOffset(<0.0, 0.0, 2.5>);
        
        llSetVehicleType(VEHICLE_TYPE_AIRPLANE);
        
        // linear friction
        llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <100.0, 100.0, 100.0>);
        
        // uniform angular friction
        llSetVehicleFloatParam(VEHICLE_ANGULAR_FRICTION_TIMESCALE, 1.0);
        
        // linear motor
        llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <0.0, 0.0, 0.0>);
        llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_TIMESCALE, 1.0);
        llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 1.0);
        
        // angular motor
        llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, <0.0, 0.0, 0.0>);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_TIMESCALE, 1.0);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, 2.0);
        
        // hover
        llSetVehicleFloatParam(VEHICLE_HOVER_HEIGHT, 0.0);
        llSetVehicleFloatParam(VEHICLE_HOVER_EFFICIENCY, 0.0);
        llSetVehicleFloatParam(VEHICLE_HOVER_TIMESCALE, 360.0);
        llSetVehicleFloatParam(VEHICLE_BUOYANCY, 0.981);
        
        // linear deflection
        llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 0.5);
        llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 1.0);
        
        // angular deflection
        llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 0.25);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, 100.0);
        
        // vertical attractor
        llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, 0.75);
        llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 1.0);
        
        // banking
        llSetVehicleFloatParam(VEHICLE_BANKING_EFFICIENCY, 0.0);
        llSetVehicleFloatParam(VEHICLE_BANKING_MIX, 1.0);
        llSetVehicleFloatParam(VEHICLE_BANKING_TIMESCALE, 360.0);
        
        // default rotation of local frame
        llSetVehicleRotationParam(VEHICLE_REFERENCE_FRAME, <0.0, 0.0, 0.0, 1.0>);
        
        // removed vehicle flags
        llRemoveVehicleFlags(VEHICLE_FLAG_NO_DEFLECTION_UP | VEHICLE_FLAG_HOVER_WATER_ONLY | VEHICLE_FLAG_HOVER_TERRAIN_ONLY | VEHICLE_FLAG_HOVER_UP_ONLY | VEHICLE_FLAG_LIMIT_MOTOR_UP | VEHICLE_FLAG_LIMIT_ROLL_ONLY);
        
        // set vehicle flags
        llSetVehicleFlags(VEHICLE_FLAG_HOVER_GLOBAL_HEIGHT);
        
        llListenRemove(listenindex);
        if (pilot != NULL_KEY) {
            listenindex = llListen(0, "", pilot, "");
        } else {
            llReleaseControls();
        }
        
        llSetTimerEvent(0.05);
    }
    
    on_rez(integer sparam)
    {
        llResetScript();
    }
    
    link_message(integer sender, integer num, string str, key id)
    {
        if (str == "pilot" && id != NULL_KEY) {
            linear = ZERO_VECTOR;
            angular = ZERO_VECTOR;
            under_power = FALSE;
            throttle = 0.0;
            llRequestPermissions(id, PERMISSION_TAKE_CONTROLS);
            pilot = id;
            llListenRemove(listenindex);
            listenindex = llListen(0, "", pilot, "");
        } else if (str == "pilot" && id == NULL_KEY) {
            llSetStatus(STATUS_PHYSICS, FALSE);
            if (cloaked) {
                cloaked = FALSE;
                llMessageLinked(LINK_SET, 0, "decloak", NULL_KEY);
            }
            llListenRemove(listenindex);
            pilot = NULL_KEY;
            llReleaseControls();
        }
    }
    
    run_time_permissions(integer permissions)
    {
        if (permissions & PERMISSION_TAKE_CONTROLS) {
            llTakeControls( CONTROL_FWD |
                            CONTROL_BACK |
                            CONTROL_LEFT |
                            CONTROL_RIGHT |
                            CONTROL_ROT_LEFT |
                            CONTROL_ROT_RIGHT |
                            CONTROL_UP |
                            CONTROL_DOWN |
                            CONTROL_LBUTTON,
                            TRUE, FALSE);
            vector current_pos = llGetPos();
            llSetVehicleFloatParam(VEHICLE_HOVER_HEIGHT, current_pos.z);
            pos = current_pos;
            llSetStatus(STATUS_PHYSICS, TRUE);
        }
    }
    
    control(key name, integer levels, integer edges)
    {
        if ((edges & levels & CONTROL_UP)) {
            llMessageLinked(LINK_SET, 0, "key", NULL_KEY);
            linear.z += 12.0;
        } else if ((edges & ~levels & CONTROL_UP)) {
            linear.z -= 12.0;
        }
        if ((edges & levels & CONTROL_DOWN)) {
            llMessageLinked(LINK_SET, 0, "key", NULL_KEY);
            linear.z -= 12.0;
        } else if ((edges & ~levels & CONTROL_DOWN)) {
            linear.z += 12.0;
        }
        
        if ((edges & levels & CONTROL_FWD)) {
            llMessageLinked(LINK_SET, 0, "key", NULL_KEY);
            linear.x += 14.0;
        } else if ((edges & ~levels & CONTROL_FWD)) {
            linear.x -= 14.0;
        }
        if ((edges & levels & CONTROL_BACK)) {
            llMessageLinked(LINK_SET, 0, "key", NULL_KEY);
            linear.x -= 14.0;
        } else if ((edges & ~levels & CONTROL_BACK)) {
            linear.x += 14.0;
        }
        
        if ((edges & levels & CONTROL_LEFT)) {
            llMessageLinked(LINK_SET, 0, "key", NULL_KEY);
            linear.y += 8.0;
        } else if ((edges & ~levels & CONTROL_LEFT)) {
            linear.y -= 8.0;
        }
        if ((edges & levels & CONTROL_RIGHT)) {
            llMessageLinked(LINK_SET, 0, "key", NULL_KEY);
            linear.y -= 8.0;
        } else if ((edges & ~levels & CONTROL_RIGHT)) {
            linear.y += 8.0;
        }
        
        if ((edges & levels & CONTROL_ROT_LEFT)) {
            llMessageLinked(LINK_SET, 0, "key", NULL_KEY);
            angular.z += (PI / 180) * 55.0;
            angular.x -= PI * 4;
        } else if ((edges & ~levels & CONTROL_ROT_LEFT)) {
            angular.z -= (PI / 180) * 55.0;
            angular.x += PI * 4;
        } 
        if ((edges & levels & CONTROL_ROT_RIGHT)) {
            llMessageLinked(LINK_SET, 0, "key", NULL_KEY);
            angular.z -= (PI / 180) * 55.0;
            angular.x += PI * 4;
        } else if ((edges & ~levels & CONTROL_ROT_RIGHT)) {
            angular.z += (PI / 180) * 55.0;
            angular.x -= PI * 4;
        }
    }
    
    timer()
    {
        llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, linear);

        llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, angular);
    }
    
    listen(integer channel, string name, key id, string message)
    {
        message = llToLower(message);
        if (message == "f" || message == "flight") {
            state flight;
        }
        if (message == "decloak" || message == "d") {
            if (cloaked) {
                cloaked = FALSE;
                llTriggerSound("cloak", 1.0);
                llMessageLinked(LINK_SET, 0, "decloak", NULL_KEY);
            } else {
                llWhisper(0, "Cloak Currently Inactive");
            }
        }
        if (message == "cloak" || message == "c") {
            if (!cloaked) {
                cloaked = TRUE;
                llTriggerSound("cloak", 1.0);
                llMessageLinked(LINK_SET, 0, "cloak", NULL_KEY);
            } else {
                llWhisper(0, "Cloak Already Active");
            }
        }
    }       
}

state flight
{
    state_entry()
    {
        llMessageLinked(LINK_SET, 0, "flight", NULL_KEY);
        llWhisper(0, "Mode: Flight");
        linear = ZERO_VECTOR;
        angular = ZERO_VECTOR;
        throttle = 0.0;
        under_power = FALSE;

        llCollisionSound("", 0.0);
        llSetCameraEyeOffset(<-12.0, 0.0, 3.0>);
        llSetCameraAtOffset(<0.0, 0.0, 2.5>);
        
        llListenRemove(listenindex);
        if (pilot != NULL_KEY) {
            listenindex = llListen(0, "", pilot, "");
        }
        
        llSetVehicleType(VEHICLE_TYPE_AIRPLANE);
        
        // linear friction
        llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <60.0, 1.0, 1.0>);
        
        // uniform angular friction
        llSetVehicleFloatParam(VEHICLE_ANGULAR_FRICTION_TIMESCALE, 0.05);
        
        // linear motor
        llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <0.0, 0.0, 0.0>);
        llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_TIMESCALE, 0.5);
        llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 10.0);
        
        // angular motor
        llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, <0.0, 0.0, 0.0>);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_TIMESCALE, 0.2);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, 0.2);
        
        // hover
        llSetVehicleFloatParam(VEHICLE_HOVER_HEIGHT, 0.0);
        llSetVehicleFloatParam(VEHICLE_HOVER_EFFICIENCY, 0.1);
        llSetVehicleFloatParam(VEHICLE_HOVER_TIMESCALE, 360.0);
        llSetVehicleFloatParam(VEHICLE_BUOYANCY, 1.0);
        
        // linear deflection
        llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 1.0);
        llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 2.0);
        
        // angular deflection
        llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 0.1);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, 100.0);
        
        // vertical attractor
        llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, 0.0);
        llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 360.0);
        
        // banking
        llSetVehicleFloatParam(VEHICLE_BANKING_EFFICIENCY, 0.25);
        llSetVehicleFloatParam(VEHICLE_BANKING_MIX, 0.5);
        llSetVehicleFloatParam(VEHICLE_BANKING_TIMESCALE, 1.0);
        
        // default rotation of local frame
        llSetVehicleRotationParam(VEHICLE_REFERENCE_FRAME, <0.0, 0.0, 0.0, 1.0>);
        
        // removed vehicle flags
        llRemoveVehicleFlags(VEHICLE_FLAG_NO_DEFLECTION_UP | VEHICLE_FLAG_HOVER_WATER_ONLY | VEHICLE_FLAG_HOVER_TERRAIN_ONLY | VEHICLE_FLAG_HOVER_UP_ONLY | VEHICLE_FLAG_LIMIT_MOTOR_UP | VEHICLE_FLAG_HOVER_GLOBAL_HEIGHT | VEHICLE_FLAG_LIMIT_ROLL_ONLY);
        
        // set vehicle flags
        //llSetVehicleFlags(VEHICLE_FLAG_LIMIT_ROLL_ONLY);
        
        llSetTimerEvent(0.05);
    }
    
    on_rez(integer sparam)
    {
        llResetScript();
    }
    
    control(key name, integer levels, integer edges)
    {
        if ((edges & levels & CONTROL_UP)) {
            llMessageLinked(LINK_SET, 0, "key", NULL_KEY);
            linear.z += 10.0;
        } else if ((edges & ~levels & CONTROL_UP)) {
            linear.z -= 10.0;
        }
        if ((edges & levels & CONTROL_DOWN)) {
            llMessageLinked(LINK_SET, 0, "key", NULL_KEY);
            linear.z -= 10.0;
        } else if ((edges & ~levels & CONTROL_DOWN)) {
            linear.z += 10.0;
        }
        
        if ((edges & levels & CONTROL_FWD)) {
            llMessageLinked(LINK_SET, 0, "key", NULL_KEY);
            angular.y += (PI / 180.0) * 45.0;
        } else if ((edges & ~levels & CONTROL_FWD)) {
            angular.y -= (PI / 180.0) * 45.0;
        }
        if ((edges & levels & CONTROL_BACK)) {
            llMessageLinked(LINK_SET, 0, "key", NULL_KEY);
            angular.y -= (PI / 180.0) * 75.0;
        } else if ((edges & ~levels & CONTROL_BACK)) {
            angular.y += (PI / 180.0) * 75.0;
        }
        
        if ((edges & levels & CONTROL_LEFT)) {
            llMessageLinked(LINK_SET, 0, "key", NULL_KEY);
            angular.x -= (PI / 180.0) * 120.0;
        } else if ((edges & ~levels & CONTROL_LEFT)) {
            angular.x += (PI / 180.0) * 120.0;
        }
        if ((edges & levels & CONTROL_RIGHT)) {
            llMessageLinked(LINK_SET, 0, "key", NULL_KEY);
            angular.x += (PI / 180.0) * 120.0;
        } else if ((edges & ~levels & CONTROL_RIGHT)) {
            angular.x -= (PI / 180.0) * 120.0;
        }
        
        if ((edges & levels & CONTROL_ROT_LEFT)) {
            llMessageLinked(LINK_SET, 0, "key", NULL_KEY);
            angular.x -= (PI / 180.0) * 120.0;
        } else if ((edges & ~levels & CONTROL_ROT_LEFT)) {
            angular.x += (PI / 180.0) * 120.0;
        } 
        if ((edges & levels & CONTROL_ROT_RIGHT)) {
            llMessageLinked(LINK_SET, 0, "key", NULL_KEY);
            angular.x += (PI / 180.0) * 120.0;
        } else if ((edges & ~levels & CONTROL_ROT_RIGHT)) {
            angular.x -= (PI / 180.0) * 120.0;
        }
    }
    
    link_message(integer sender, integer num, string str, key id)
    {
        if (str == "pilot" && id != NULL_KEY) {
            llRequestPermissions(id, PERMISSION_TAKE_CONTROLS);
            pilot = id;
            llListenRemove(listenindex);
            listenindex = llListen(0, "", pilot, "");
        } else if (str == "pilot" && id == NULL_KEY) {
            llSetStatus(STATUS_PHYSICS, FALSE);
            if (cloaked) {
                cloaked = FALSE;
                llMessageLinked(LINK_SET, 0, "decloak", NULL_KEY);
            }
            llListenRemove(listenindex);
            pilot = NULL_KEY;
            llReleaseControls();
            state default;
        }
    }
    
    listen(integer channel, string name, key id, string message)
    {
        message = llToLower(message);
        
        if (message == "h" || message == "hover" || message == "vtol") {
            state default;
        }
        if (message == "r" || message == "i" || message == "reverse" || message == "invert thrust") {
            throttle = -5.0;
        }
        if (message == "decloak" || message == "d") {
            if (cloaked) {
                cloaked = FALSE;
                llTriggerSound("cloak", 1.0);
                llMessageLinked(LINK_SET, 0, "decloak", NULL_KEY);
            } else {
                llWhisper(0, "Cloak Currently Inactive");
            }
        }
        if (message == "cloak" || message == "c") {
            if (!cloaked) {
                cloaked = TRUE;
                llTriggerSound("cloak", 1.0);
                llMessageLinked(LINK_SET, 0, "cloak", NULL_KEY);
            } else {
                llWhisper(0, "Cloak Already Active");
            }
        }
    }
    
    timer()
    {
        if (linear.z > 0 && llGetTime() >= 0.25 && throttle < 100.0) {
            if (throttle < 0.0) {
                throttle = 0.0;
            } else {
                throttle += linear.z;
            }
            llResetTime();
            llMessageLinked(LINK_SET, (integer)throttle, "throttle", NULL_KEY);
        } else if (linear.z < 0 && llGetTime() >= 0.25 && throttle > 0.0) {
            throttle += linear.z;
            llResetTime();
            llMessageLinked(LINK_SET, (integer)throttle, "throttle", NULL_KEY);
        }

        linear.x = 30.0 * (throttle / 100.0);
        vector linear_applied = <linear.x, 0.0, 0.0>;
        llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, linear_applied);
        
        if (angular == ZERO_VECTOR) {
            llSetVehicleFloatParam(VEHICLE_ANGULAR_FRICTION_TIMESCALE, 0.05);
        } else {
            llSetVehicleFloatParam(VEHICLE_ANGULAR_FRICTION_TIMESCALE, 1.0);
        }
        
        llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, angular);
    }
}// END //


