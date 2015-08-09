// :SHOW:
// :CATEGORY:Boat
// :NAME:OpenSim JetSki
// :AUTHOR:Thomas Ringate
// :KEYWORDS:
// :CREATED:2015-06-11 16:29:24
// :EDITED:2015-06-11  15:29:24
// :ID:1080
// :NUM:1799
// :REV:1
// :WORLD:Opensim
// :DESCRIPTION:
// TSim Jet Ski
// :CODE:
//:License: GPLV2
//:VERSION:1.02

// XEngine:lsl
// TSim Jet Ski V1.02
// Licensed under the GPLv2.
// From the OsGrid Forums:
// http://forums.osgrid.org/viewtopic.php?f=5&t=5486

// Tested as working with the bullet physics engine.
// This script detects the region edge and stops the jet ski from crossing the border.  It detects the size of a var region.
// The four arrow keys steer the jet ski.
// The jet ski will detect shore and come to a near stop.  
// If you beach the jet ski you are going to have to drive it back in the water. It will move very slowly on land.
// Version V1.02
// Initial release
//
//==== G L O B A L   V A R I A B L E   D E C L A R A T I O N ====

integer xlimit; // region size limit
integer ylimit; // region size limit
integer   gRun; //Engine status
integer gGuard = 3; // the distance to detect the edge of the region boundary
string   gDrivingAnim = "motorcycle_sit"; // sit animation for the jet ski
vector   gSitTarget_Pos = <-0.43,0.03,0.69>; // sit position (will need to be adjusted for your jet ski)
vector   vTarget; // vehicle position
key      gAgent; // the key for the siting avatar
float   fWaterLevel; //region water level
float   gSpeed = 35.0; // forward speed of the jet ski
float   gForwardThrust; // variable for forward thrust 
float   gReverseThrust = -15; // reverse thrust which is it's reverse speed
float   gTurnMulti=1.012345; // used for the AngularMotor
float   gTurnRatio; // used for the AngularMotor

init_engine(){
    gRun = 0; //Engine off
    vector gSitTarget_Rot = llRot2Euler( llGetRootRotation() ); // SIT TARGET IS BASED ON VEHICLE'S ROTATION.
    llSitTarget(gSitTarget_Pos, llEuler2Rot(DEG_TO_RAD * gSitTarget_Rot));
    llSetLinkPrimitiveParamsFast(LINK_ALL_CHILDREN, [PRIM_PHYSICS_SHAPE_TYPE, PRIM_PHYSICS_SHAPE_NONE]);
}

init_followCam(){
    llSetCameraParams(
       [
         CAMERA_ACTIVE, 1,                 // 0=INACTIVE  1=ACTIVE
         CAMERA_BEHINDNESS_ANGLE, 2.5,     // (0 to 180) DEGREES
         CAMERA_BEHINDNESS_LAG, 0.3,       // (0 to 3) SECONDS
         CAMERA_DISTANCE, 6.0,             // ( 0.5 to 10) METERS
         CAMERA_PITCH, 12.0,                // (-45 to 80) DEGREES
         CAMERA_POSITION_LOCKED, FALSE,    // (TRUE or FALSE)
         CAMERA_POSITION_LAG, 0.0,         // (0 to 3) SECONDS
         CAMERA_POSITION_THRESHOLD, 0.0,   // (0 to 4) METERS
         CAMERA_FOCUS_LOCKED, FALSE,       // (TRUE or FALSE)
         CAMERA_FOCUS_LAG, 0.0,           // (0 to 3) SECONDS
         CAMERA_FOCUS_THRESHOLD, 0.0,      // (0 to 4) METERS
         CAMERA_FOCUS_OFFSET, <0.0,0,0>   // <-10,-10,-10> to <10,10,10> METERS
      ]);
   llForceMouselook(FALSE); // make sure mouse look is off
}

set_engine(){
    llSetVehicleType(VEHICLE_TYPE_BOAT);
// default rotation of local frame
    llSetVehicleRotationParam(VEHICLE_REFERENCE_FRAME, <0.00000, 0.00000, 0.00000, 0.00000>); // <0.00000, 0.00000, 0.00000, 0.00000>
// linear motor wins after about five seconds, decays after about a minute 
    llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_TIMESCALE, 0.90);
    llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 0.10);
// least for forward-back, most friction for up-down
    llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <1.0,1.0,1.0> );
// uniform angular friction (setting it as a scalar rather than a vector)
    llSetVehicleVectorParam(VEHICLE_ANGULAR_FRICTION_TIMESCALE, <1.0,1000.0,1000.0> );
// agular motor wins after four seconds, decays in same amount of time
    llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_TIMESCALE, 0.20);
    llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, 0.10);
// halfway linear deflection with timescale of 3 seconds
    llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 0.10);
    llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 10.00);
// angular deflection
    llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 0.10);
    llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, 10.00);
// somewhat bounscy vertical attractor
   llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, 0.5);
   llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 2.00);
// hover
    llSetVehicleFloatParam(VEHICLE_HOVER_HEIGHT, 0.1 );
    llSetVehicleFloatParam(VEHICLE_HOVER_EFFICIENCY, 0.5 );
    llSetVehicleFloatParam(VEHICLE_HOVER_TIMESCALE, 50.0 );
   llSetVehicleFloatParam(VEHICLE_BUOYANCY, 1.0 );
// weak negative damped banking
    llSetVehicleFloatParam( VEHICLE_BANKING_EFFICIENCY, 1.0 );
    llSetVehicleFloatParam( VEHICLE_BANKING_MIX, 1.0 );
    llSetVehicleFloatParam( VEHICLE_BANKING_TIMESCALE, 0.5 );
// remove these flags
   llRemoveVehicleFlags( VEHICLE_FLAG_HOVER_TERRAIN_ONLY
       | VEHICLE_FLAG_LIMIT_ROLL_ONLY
       | VEHICLE_FLAG_HOVER_GLOBAL_HEIGHT);
// set these flags
   llSetVehicleFlags( VEHICLE_FLAG_NO_DEFLECTION_UP
       | VEHICLE_FLAG_HOVER_WATER_ONLY
       | VEHICLE_FLAG_HOVER_UP_ONLY
       | VEHICLE_FLAG_LIMIT_MOTOR_UP );
}

default {
    state_entry()
    {
        vector vTarget = llGetPos();
       vTarget.z = llGround( ZERO_VECTOR );
       fWaterLevel = llWater( ZERO_VECTOR );
       if( vTarget.z < fWaterLevel )
       {
           vTarget.z = fWaterLevel;
           llSay(0,"Ready to go!");
       }
       else
        {
            llSay(0,"I work best in water!");
        }
       llSetRegionPos(vTarget + <0,0,0.1>);
        init_engine(); // initialize the engine
        state Running; // switch to the running state
    }
}

state Running{

    state_entry(){
      
    }
    
    on_rez(integer param) {
        llResetScript();
    }
    
    changed(integer change){
        if ((change & CHANGED_LINK) == CHANGED_LINK){
            gAgent = llAvatarOnSitTarget();  // get the sitting avatars key
            if (gAgent != NULL_KEY){ // we have a driver
            llSetStatus(STATUS_PHYSICS, TRUE);
            llSetStatus(STATUS_ROTATE_Y,TRUE);
            llSetStatus(STATUS_ROTATE_Z,TRUE);
            set_engine(); // set the engine parameters
            vector regionsize = osGetRegionSize(); // get the max size of the region dimentions
            xlimit = (integer)regionsize.x - gGuard; // set the region top limit
            ylimit = (integer)regionsize.y - gGuard; // set the region top limit
            llRequestPermissions(gAgent, PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS | PERMISSION_CONTROL_CAMERA | PERMISSION_TRACK_CAMERA);
            gRun = 1; // Engine on
            }
            else { // driver got off
                llSetStatus(STATUS_PHYSICS, FALSE); // turn physics off
                gRun = 0; // Engine off
                init_engine(); //  initialize the engine
                llStopAnimation(gDrivingAnim);
                llPushObject(gAgent, <3,3,21>, ZERO_VECTOR, FALSE);
                llReleaseControls();
                llClearCameraParams();
                llSetCameraParams([CAMERA_ACTIVE, 0]);
                llSetText("",<0,0,0>,1.0);
            }
        }
    }
    run_time_permissions(integer perm){
        if (perm) {
            llTakeControls(CONTROL_FWD | CONTROL_BACK | CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT, TRUE, FALSE);
         init_followCam();
            llStartAnimation(gDrivingAnim);
            llSleep(1.5);
        }
    }

    control(key id, integer held, integer change){
        if(gRun == 0){
            return;
        }
        integer reverse=1;
        vector vel = llGetVel();
        vector speedvec = llGetVel() / llGetRot();
      vector AngularMotor;
        gTurnRatio = 1.5;
      vTarget = llGetPos(); // get jet ski position
        if (held & CONTROL_FWD){
            reverse=1;
            gForwardThrust = gSpeed;
         // if near region edge, slow down, and veer to the right
         if (vTarget.x > xlimit || vTarget.x < gGuard || vTarget.y > ylimit || vTarget.y < gGuard) {
            llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <1.0, 2.0, 8.0>);
               gForwardThrust = 3; // slow us down
            if (vTarget.x > xlimit) vTarget.x = xlimit;
            if (vTarget.x < gGuard) vTarget.x = gGuard;
            if (vTarget.y > xlimit) vTarget.y = ylimit;
            if (vTarget.y < gGuard) vTarget.y = gGuard;
            reverse = -1;
               llWhisper(0, "Approaching sim edge, turn away...");
         }
         if (vTarget.z > (fWaterLevel + 1.4)) {
         gForwardThrust = 2; // slow us down
         }
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <gForwardThrust,0,0>);
            llSetPos(vTarget);
        }

        if (held & CONTROL_BACK){
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <gReverseThrust,0,0>);
            gTurnRatio = -2.0;
            reverse = -1;
        }

//        vector AngularMotor;
        AngularMotor.y = 0;  
        if (held & (CONTROL_ROT_RIGHT)){
            AngularMotor.x += ((gTurnRatio/gTurnMulti)*1);
            AngularMotor.z -= ((gTurnRatio*gTurnMulti)/1);
        }

        if (held & (CONTROL_ROT_LEFT)){
            AngularMotor.x -= ((gTurnRatio/gTurnMulti)*1);
            AngularMotor.z += ((gTurnRatio*gTurnMulti)/1);
         }
        llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, AngularMotor);
    }
}
