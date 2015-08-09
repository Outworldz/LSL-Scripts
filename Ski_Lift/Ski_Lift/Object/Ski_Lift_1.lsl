// :CATEGORY:Ski Lift
// :NAME:Ski_Lift
// :AUTHOR:wiki.YAK.net
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:03
// :ID:776
// :NUM:1064
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// The scripts
// :CODE:
vector Lo = <128,120,50>;
vector Hi = <10,150,110>;
vector Side = <0, -5, 0>;

integer Period = 40;
integer TTL = 600;
integer Life; // time to live
vector Corner;
float Phase;


Balloon() {
    llSetVehicleType(VEHICLE_TYPE_BALLOON);
    llSetVehicleFlags( VEHICLE_FLAG_HOVER_GLOBAL_HEIGHT  );

    // more like a baloon
    llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 1.0);
    //llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 3.0);
    llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, 0.8);

    llSetVehicleFloatParam(VEHICLE_HOVER_TIMESCALE, 1.0);
    //llSetVehicleFloatParam(VEHICLE_HOVER_TIMESCALE, 3.0);
    llSetVehicleFloatParam(VEHICLE_HOVER_EFFICIENCY, 0.8);

    // more like a plane
    llSetVehicleFloatParam(VEHICLE_BANKING_EFFICIENCY, 0.5);
    llSetVehicleFloatParam(VEHICLE_BANKING_MIX, 0.5);

    llSitTarget( <.4,0,.4>, ZERO_ROTATION );
    llSetSitText("RIDE");
    llSetCameraEyeOffset(<-3, 0, 3>);
    llSetCameraAtOffset(<2, 0, 2>);
}

SetAltitude(float alt) {
    llSetVehicleFloatParam( VEHICLE_HOVER_HEIGHT, alt );
}

vector TargetFromNormalized(float t) {
    vector b; //begin
    vector e; //end

    // This t ranges 0 .. 1
    if ( t < 0.1 ) {
        t = t / 0.1;
        b = Lo+Side;
        e = Lo;
    } else if ( t < 0.5 ) {
        t = (t+-0.1)/0.4;
        b = Lo;
        e = Hi;
    } else if ( t < 0.6 ) {
        t = (t+-.5)/.1;
        b = Hi;
        e = Hi+Side;
    } else {
        t = (t+-.6) / .4;
        b = Hi+Side;
        e = Lo+Side;
    }
    return b + t*(e-b);
}




vector TargetFromTimeOfDay(integer periodSecs) {

        integer period = periodSecs * 1000; // now in ms
        float t = llGetTimeOfDay(); // secs
        integer rem = (integer)(t*1000) % period; // ms
        t = (float)rem / (float)period; // normalized 0 .. 1

        // adjust for phase
        t += Phase;
        if (t>1) t= t+-1;

        vector targ = TargetFromNormalized(t);
        return targ;
}
SetAcceleration(vector desired_acceleration) {
    // Using Newtons Second law, thanks to lsl wiki
    //float mass = llGetMass();
    //llSetForce(mass * (desired_acceleration + <0,0,9.8>), FALSE);
    llApplyImpulse(llGetMass()*desired_acceleration,FALSE);
}
SetVel(vector velocity) {
    float clamp = 15;
    vector accel = velocity - llGetVel();
    if ( llVecMag(accel) > clamp ) {
        accel = clamp * llVecNorm(accel);
    }
    //llShout(0, "SetVel " +(string)velocity+ " Accel " + (string)accel );
    SetAcceleration( accel );
}
SetTarget(vector targ) {
    vector diff = targ - llGetPos();
    SetVel(diff); // time frame 1 sec.
}
Move() {
    vector targ = TargetFromTimeOfDay(Period);
    float dist = llVecMag( targ - llGetPos() );
    //llShout( 0, (string)dist + " ########## " + (string)( TargetFromTimeOfDay(120) ) );
    //llShout(0, "At " +(string)llGetPos()+ " To " +(string)targ );
    // TODO
    SetAltitude(targ.z);
    SetTarget(targ);
}



default
{
    on_rez(integer a) {
        Phase = (float)(a%1000)/1000.0; // phase: a from 0 to 999
        state moving;
    }
    state_entry()
    {
        llSetStatus(STATUS_PHYSICS, FALSE);
        llSay(0, "Hello, Avatar!");
    }

    touch_start(integer total_number)
    {
        llSay(0, "Touched.");
        state moving;
    }
}

state moving {
    state_entry() {
        llListen(404, "", NULL_KEY, "");
        llSetTimerEvent(1.0);
        Life = TTL;
        Corner = llGetRegionCorner();
        llSetStatus(STATUS_PHYSICS, TRUE);
        Balloon();
        Move();
    }
    timer() {
        //-- Life;//NO Longer Needed
        if (Life < 0) {
            llShout(0, "TTL Bye at " + (string)llGetPos() );
            llDie();
        }
        if (Corner != llGetRegionCorner()) {
            llShout(0, "Wrong Corner: " + (string)llGetRegionName());
            llDie();
        }

        Move();
    }
    //touch_start(integer ignore) {
    //    state default;
    //}
    listen(integer channel, string name, key id, string message) {
        llShout(404, (string)llGetPos() );
        llDie();
    }
}

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@  Above here is the seat, named "Ride Me".
@@@  Following here is the rezzer object.
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

string Payload = "Ride Me";
integer N = 8;

Rez(integer a) {
    llRezObject(Payload, llGetPos()+<0,0,5>, <0,0,0>, <0,0,0,0>, a);
}

default
{
    touch_start(integer total_number)
    {
        llSay(0, "Creating ski lift");
        integer i;
        for ( i=0; i<N; i++) {
            Rez(i*1000/N);
        }
        state running;
    }
}
state running {
    touch_start(integer ignore) {
        llSay(0, "Destructing ski lift");
        llShout(404, "Die");
        state default;
    }
}

