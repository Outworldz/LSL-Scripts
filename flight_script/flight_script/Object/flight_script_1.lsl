// :CATEGORY:Flight Assist
// :NAME:flight_script
// :AUTHOR:Barney Boomslang
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:53
// :ID:319
// :NUM:427
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// flight script.lsl
// :CODE:

// (c) 2006 Barney Boomslang
integer listener = 0;
integer speed = 0;
integer buoyancy = 0;

// up/down factor
float bfactor = 4;
float bfactor2 = 2;

list speeds = ["low", "medium", "high"];

init()
{
    llSetStatus(STATUS_PHYSICS, FALSE);
    speed = 0;
    llSetVehicleType(VEHICLE_TYPE_BALLOON);
    llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, 2.0);
    llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 6.0);
    llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 3.0);
    llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, 0.5);
    llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <7, 2, 5>);
    llSetVehicleFloatParam(VEHICLE_HOVER_HEIGHT, 0.0);
    llSetVehicleFloatParam(VEHICLE_BUOYANCY, 1.0);
    llSetBuoyancy(0.0);
    buoyancy = 0;
    llListenRemove(listener);
    listener = llListen(0, "", llGetOwner(), "");
    llSetTimerEvent(1.0);
    llSay(0, "Ready for boarding");
}

set_speed(string direction)
{
    if (direction != "")
    {
        if (speed > 0)
        {
            llOwnerSay("Changing "+direction+" to "+llList2String(speeds, (speed - 1))+" speed");
        }
        else if (speed < 0)
        {
            llOwnerSay("engaging reverse gear");
        }
        else
        {
            llOwnerSay("Stopping engines");
        }
    }
    if (buoyancy>=0)
    {
        llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <0,speed*5,buoyancy*bfactor>);
    }
    else
    {
        llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <0,speed*5,buoyancy*bfactor2>);
    }
    llMessageLinked(LINK_ALL_OTHERS, speed, "speed", NULL_KEY);
}

default
{
    
    changed(integer change)
    {
        key agent;
        if (change & CHANGED_LINK)
        {
            llSleep(0.5);
            agent = llAvatarOnSitTarget();
            if (agent == llGetOwner())
            {
                llSay(0, "Say 'start' to start flying. Say 'stop' if you want to stop flying.");
            }
            else if (agent == NULL_KEY)
            {
                llReleaseControls();
            }
            else
            {
                llSay(0, "Sorry, but the pilot has to be seated first!");
                llUnSit(agent);
            }
        }
    }
    
    state_entry()
    {
        init();
    }
    
    on_rez(integer param)
    {
        init();
    }
    
    timer()
    {
        set_speed("");
    }
    
    listen(integer channel, string name, key agent, string message)
    {
        if (message == "stop")
        {
            llReleaseControls();
            buoyancy = 0;
            llSetStatus(STATUS_PHYSICS, FALSE);
            llSay(0, "Airship fastened, it is now safe to stand up.");
        }
        else if (message == "start")
        {
            llRequestPermissions(llGetOwner(), PERMISSION_TAKE_CONTROLS);
            llSetStatus(STATUS_PHYSICS, TRUE);
            buoyancy = 0;
            llSay(0, "Airship released, use the left/right to turn, fwd/back to set the speed and up/down to change the height.");
        }
    }

    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_TAKE_CONTROLS)
        {
            llTakeControls(CONTROL_UP | CONTROL_DOWN | CONTROL_ROT_LEFT | CONTROL_ROT_RIGHT | CONTROL_FWD | CONTROL_BACK, TRUE, FALSE);
        }
    }
    
    control(key id, integer held, integer change)
    {
        //set_height();
        
        // set up sound and particles depending on movement keys
        if (change & CONTROL_ROT_LEFT)
        {
            if (held)
            {
                llMessageLinked(LINK_ALL_OTHERS, 1, "left", NULL_KEY);
            }
            else
            {
                llMessageLinked(LINK_ALL_OTHERS, 0, "left", NULL_KEY);
            }
        }
        else if (change & CONTROL_ROT_RIGHT)
        {
            if (held)
            {
                llMessageLinked(LINK_ALL_OTHERS, 1, "right", NULL_KEY);
            }
            else
            {
                llMessageLinked(LINK_ALL_OTHERS, 0, "right", NULL_KEY);
            }
        }
        else if (change & CONTROL_UP)
        {
            if (held)
            {
                llMessageLinked(LINK_ALL_OTHERS, 1, "up", NULL_KEY);
            }
            else
            {
                llMessageLinked(LINK_ALL_OTHERS, 0, "up", NULL_KEY);
            }
        }
       
        // do actual action depending on movement keys
        if (held & change & CONTROL_DOWN)
        {
            if (buoyancy > -3)
            {
                buoyancy -= 1;
                if (buoyancy > 0)
                {
                    llOwnerSay("going up "+llList2String(speeds, (buoyancy - 1))+" speed");
                }
                else if (buoyancy < 0)
                {
                    llOwnerSay("going down "+llList2String(speeds, (-1*buoyancy - 1))+" speed");
                }
                else
                {
                    llOwnerSay("switching airship to hover mode.");
                }
                llPlaySound("tick",1);
            }
        }
        else if (held & change & CONTROL_UP)
        {
            if (buoyancy < 3)
            {
                buoyancy += 1;
                if (buoyancy > 0)
                {
                    llOwnerSay("going up "+llList2String(speeds, (buoyancy - 1))+" speed");
                }
                else if (buoyancy < 0)
                {
                    llOwnerSay("going down "+llList2String(speeds, (-1*buoyancy - 1))+" speed");
                }
                else
                {
                    llOwnerSay("switching airship to hover mode.");
                }
                llPlaySound("tick",1);
            }
        }
        else if (held & change & CONTROL_FWD)
        {
            if (speed < 3)
            {
                speed += 1;
                set_speed("up");
            }
        }
        else if (held & change & CONTROL_BACK)
        {
            if (speed > -1)
            {
                speed -= 1;
                set_speed("down");
            }
        }
        else if (held & CONTROL_ROT_LEFT)
        {
            llApplyRotationalImpulse(llGetMass()*<0,0,-0.1>,TRUE);
        }
        else if (held & CONTROL_ROT_RIGHT)
        {
            llApplyRotationalImpulse(llGetMass()*<0,0,0.1>,TRUE);
        }
    }

}
// END //
