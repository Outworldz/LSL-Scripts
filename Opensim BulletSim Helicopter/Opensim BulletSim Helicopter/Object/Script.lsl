// :SHOW:
// :CATEGORY:Vehicle
// :NAME:Opensim BulletSim Helicopter
// :AUTHOR:Shin Ingen @ http://ingen-lab.com:8002
// :KEYWORDS:
// :CREATED:2015-03-17 10:26:26
// :EDITED:2015-03-17  09:26:26
// :ID:1071
// :NUM:1727
// :REV:1
// :WORLD:OpenSim
// :DESCRIPTION:
// The helicopter is also available in an IAR
// :CODE:

//Physics Engine:
//
//You’ll notice that the script itself is configured to take on an ODE settings or BulletSim settings by changing the variable gPhysEng (line 105) to “0” for ODE or “1” for BulletSim. This option was really meant for vehicle type CAR since BulletSim flying objects have functions that do not exist in ODE. It may or may not work in ODE.
//
//Camera Settings:
//
//You also have the option to use Fixed Cam or  Dynamic Cam by changing the variable gCamFixed to “0” for Dynamic Cam or “1” for Fixed Cam.
//
//Controls:
//
//Hover Mode: Page UP and Page Down Keys controls elevation, Up and Down Arrow Keys to move forward or backward and finally Left and Right Arrow Keys to spin left or right.
//
//Fly Mode: UP and Page Down Keys controls elevation, Up and Down Arrow Keys to move forward or backward and finally Left and Right Arrow Keys to roll left or right.
//
//Speed: Shift + Right Arrow Key to gear up and Shift + Left Arrow Key to gear down.
//
//Rotor Blade Rotation: This is a scriptless rotation and works by renaming your rotors spin_x,  spin_y or spin_z. It all depends on your rotor blade’s true center  when you upload it. Your rotor blade should be one piece for this to work, for example, the Apache Helicopter’s rotor blade and shaft are one piece so it appears that both are rotating.
//
//That’s about it, the rest should be self explanatory within the script itself. I hope that you can find it useful and  sharing back your improvements will be greatly appreciated.
//
//Happy Scripting Everyone!

//*******************************************************
// Shin Ingen @ http://ingen-lab.com:8002
// LSL | OPENSIM | BulletSim | Varregion
// iTEC + e3s + DC (ENGINE SPEED SENSITIVE STEERING WITH DYNAMIC CAMERA)
// JANUARY 28, 2013
// TODO: KEYWORD PROCESSOR FOR ** PRIM ANIMATION | AVATAR ANIMATION | SOUNDS | MENU | HUD | DYNAMIC CAMERA
//*******************************************************
 
//---PERMISSION VARIABLES---------------------------------------------
integer         gDrivePermit = 1; // 0=EVERYONE 1=OWNERONLY
string          gSitMessage = "Ride";
string          gUrNotAllowedMessage = "Vehicle is Locked";
vector          gSitTarget_Pos = <2.5,1.6,1.9>;
vector          gSitTarget_Rot;
key             gOldAgent;
key             gAgent;
integer         gRun;     //ENGINE RUNNING
integer         gMoving;  //VEHICLE MOVING
//integer        gIdle;
//---END PREMISSION----------------------------------------------------
 
//---ANIMATION VARIABLES-----------------------------------------------
string      gDrivingAnim = "driverLH-64-64";
//---------------------------------------------------------------------
 
//---CAMERA VARIABLES--------------------------------------------------
//***CONSTANT**********************************************************
integer         gCamFixed=0;            // INITVAL=0            0=FOLLOW CAM 1=FIXED CAM
//integer       gCamAct;                // INITVAL=1            0=INACTIVE  1=ACTIVE
//integer       gCamFocLocked;          // INITVAL=FALSE        (TRUE or FALSE)
//integer       gCamPoslocked;          // INITVAL=FALSE        (TRUE or FALSE)
//***SLIDERS***********************************************************
//float         gCamBAng;               // INITVAL=2.0            (0 to 180) DEGREES
//float         gCamBLag;               // INITVAL=0.1            (0 to 3) SECONDS
//float         gCamDist;               // INITVAL=8.0            (0.5 to 10) METERS
//float         gCamFocLag;             // INITVAL=0.1            (0 to 3) SECONDS
//float         gCamFocThresh;          // INITVAL=0.5            (0 to 4) METERS
//float         gCamPitch;              // INITVAL=20.0           (-45 to 80) DEGREES
//float         gCamPoslag;             // INITVAL=0.1            (0 to 3) SECONDS
//float         gCamPosthresh;          // INITVAL=0.5            (0 to 4) METERS
//vector        gCamFocOff;             // INITVAL=<0.10,0,0>     <-10,-10,-10> to <10,10,10> METERS
//----END CAMERA-------------------------------------------------------
 
//---SOUND VARIABLES---------------------------------------------------
string       gSoundFlight =          "s_flight";
string       gSoundHorn =            "s_horn";
string       gSoundStartup =         "BLACKHAWK-HELI-START";
string       gSoundIdle =            "BLACKHAWK-HELI-IDLE";
string       gSoundSlow =            "BLACKHAWK-HELI-RUN";
string       gSoundAggressive =      "BLACKHAWK-HELI-RUNFAST";
string       gSoundGearUp =          "s_gearup";
string       gSoundGearDown =        "s_geardown";
string       gSoundRev =             "s_rev";
string       gSoundAlarm =           "s_alarm";
string       gSoundStop =            "s_rev";
//NEED KEYWORD SOUND PROCESSOR
integer      gOldSound=3;   //variable for sound function
integer      gNewSound=3;
//---------------------------------------------------------------------
 
//---iTEC - STOCK ENGINE GLOBAL VARIABLES------------------------------
list        gTSvarList;
float       gVLMT=0.90;                  //INITVAL=0.90   
float       gVLMDT=0.10;                 //INITVAL=0.10  
vector      gVLFT=<8.0, 3000.0, 8.0>;    //INITVAL=<8.0, 3000.0, 8.0>
vector      gVAFT=<0.10, 0.10, 0.10>;    //INITVAL=<0.10, 0.10, 0.10>
float       gVADE=0.20;                  //INITVAL=0.20
float       gVADT=0.50;                  //INITVAL=0.10
float       gVAMT=1.0;                   //INITVAL=0.10 
float       gVAMDT=0.10;                 //INITVAL=0.10
float       gVLDE=1.0;                   //INITVAL=1.0
float       gVLDT=0.10;                  //INITVAL=0.10
float       gVVAE=0.50;                  //INITVAL=0.50
float       gVVAT=5.0;                   //INITVAL=5.0
float       gVHE=0.0;                    //INITVAL=0.0
float       gVHT=0.0;                    //INITVAL=0.0
float       gVHH=0.0;                    //INITVAL=0.0
float       gVB=0.9;                     //INITVAL=0.0
float       gVBE=1.0;                    //INITVAL=1.0
float       gVBM=0.5;                    //INITVAL=0.5
float       gVBT=0.5;                    //INITVAL=0.5
float       gVerticalThrust=7.0;
//---------------------------------------------------------------------
 
//---iTEC POWERTRAIN + (e3s) GLOBAL VARIABLES -------------------------
integer      gGear;
integer      gNewGear;
float        gGearPower;
float        gReversePower            =     -5;
list         gGearPowerList           = [     5,    //  HOVER
                                             15,    //  15-KNOTS
                                             30,    //  30-KNOTS
                                             40,    //  40-KNOTS
                                             50,    //  50-KNOTS
                                             60,    //  60-KNOTS
                                             70,    //  70-KNOTS
                                            100,    //  100-KNOTS
                                            150,    //  150-KNOTS
                                            200,    //  200-KNOTS
                                            225,    //  225-KNOTS
                                            250     //  250-KNOTS
                                         ];
//integer     gGearCount;
string      gPhysEngDesc;
integer     gPhysEng=1; // 0=ODE| 1=Bullet
float       gTurnMulti=1.012345;
float       gTurnRatio;
list        gTurnRatioList;
string      gGearName;
list        gGearNameList                 =[   "HOVER",
                                               "15-KNOTS",
                                               "20-KNOTS",
                                               "40-KNOTS",
                                               "50-KNOTS",
                                               "60-KNOTS",
                                               "70-KNOTS",
                                               "100-KNOTS",
                                               "150-KNOTS",
                                               "200-KNOTS",
                                               "225-KNOTS",
                                               "250-KNOTS"
                                         ];
float         gSpeed=0;
//---------------------------------------------------------------------
 
//---------------------------------------------------------------------
//NEED A KEYWORD PRIM ANIMATION PROCESSOR
integer            gTurnCount;
string             gTurnAngle =               "NoTurn";          // LeftTurn or RightTurn or NoTurn
string             gNewTurnAngle =            "NoTurn";
string             gTireSpin =                "ForwardSpin";       // ForwardSpin or BackwardSpin or NoSpin
string             gNewTireSpin =             "ForwardSpin";
string             gRotorSpin =               "NoRotate";         // NoRotate or SlowRotate or FastRotate
 
integer            gTcountL; //for cornerFX
integer            gTcountR;
 
//---------------------------------------------------------------------
 
//---MENU HANDLER------------------------------------------------------
list            MENU_MAIN = ["Align", "Hello"]; // up to 12 items in list
integer         menu_handler;
integer         menu_channel;
//---------------------------------------------------------------------
 
//=======================================================================
//==== E N D   G L O B A L   V A R I A B L E   D E C L A R A T I O N ====
//=======================================================================
init_TSvar(integer i){
    if (i==0){
        gTSvarList = [  3.0,                    // how fast to reach max speed
                        0.10,                   // how fast to reach min speed or zero
                        <7.0,3000.0,100.0>,     // XYZ linear friction
                        <0.10,0.10,0.20>,       // XYZ angular friction
                        0.90,                   // how fast turning force is applied 
                        0.50,                   // how fast turning force is released
                        1.0,                    // adjusted on 0.7.6
                        0.10,
                        0.20,
                        0.10,
                        0.50,
                        5.0,
                        0.0,
                        0.0,
                        0.0,
                        0.9,
                        1.0,
                        0.5,
                        0.5
                     ];
    }else{
        gTSvarList = [  0.50,                   // how fast to reach max speed
                        10,                     // how fast to reach min speed or zero
                        <1.0,1.0,1.0>,          // XYZ linear friction
                        <1.0,1000.0,1000.0>,    // XYZ angular friction
                        0.20,                   // how fast turning force is applied 
                        0.1,                    // how fast turning force is released
                        0.1,                    // adjusted on 0.7.6
                        10.0,
                        0.10,
                        10.0,
                        1.0,
                        2.0,
                        0.0,
                        0.0,
                        0.0,
                        0.99,
                        1.0,
                        0.5,
                        0.5
                    ];
    }
    gVLMT=llList2Float(gTSvarList,0);
    gVLMDT=llList2Float(gTSvarList,1);
    gVLFT=llList2Vector(gTSvarList,2);
    gVAFT=llList2Vector(gTSvarList,3);
    gVAMT=llList2Float(gTSvarList,4);
    gVAMDT=llList2Float(gTSvarList,5);
    gVLDE=llList2Float(gTSvarList,6);
    gVLDT=llList2Float(gTSvarList,7);
    gVADE=llList2Float(gTSvarList,8);
    gVADT=llList2Float(gTSvarList,9);
    gVVAE=llList2Float(gTSvarList,10);
    gVVAT=llList2Float(gTSvarList,11);
    gVHE=llList2Float(gTSvarList,12);
    gVHT=llList2Float(gTSvarList,13);
    gVHH=llList2Float(gTSvarList,14);
    gVB=llList2Float(gTSvarList,15);
    gVBE=llList2Float(gTSvarList,16);
    gVBM=llList2Float(gTSvarList,17);
    gVBT=llList2Float(gTSvarList,18);
}
 
init_PhysEng(){
    string msg;
    if(gPhysEng==0){
        msg =":: is tuned for OpenDynamicsEngine";
    }else if(gPhysEng==1){
        msg =":: is tuned for BulletSim";
    }
    
    if(gPhysEng==0){
        gTurnMulti=gTurnMulti;
        init_TSvar(0);
        gTurnRatioList            = [   2.4,    // HOVER
                                        2.4,    // 15-KNOTS
                                        2.4,    // 30-KNOTS
                                        2.5,    // 40-KNOTS
                                        4.5,    // 50-KNOTS
                                        5.0,    // 60-KNOTS
                                        5.5,    // 70-KNOTS
                                        6.5,    // 100-KNOTS
                                        7.5,    // 150-KNOTS
                                        10.0,   // 200-KNOTS
                                        10.0,   // 225-KNOTS
                                        10.0    // 250-KNOTS
                                    ];    
       gGearPowerList             = [   5,    // HOVER
                                        15,   // 15-KNOTS
                                        30,   // 30-KNOTS
                                        40,   // 40-KNOTS
                                        50,   // 50-KNOTS
                                        60,   // 60-KNOTS
                                        70,   // 70-KNOTS
                                        100,  // 100-KNOTS
                                        150,  // 150-KNOTS
                                        200,  // 200-KNOTS
                                        225,  // 225-KNOTS
                                        250   // 250-KNOTS
                                   ];
 
    
    }else{
        gTurnMulti=1.12345;
        init_TSvar(1);
        gTurnRatioList            = [   1.3,    // HOVER
                                        1.5,    // 15-KNOTS
                                        2.0,    // 30-KNOTS
                                        2.5,    // 40-KNOTS
                                        2.9,    // 50-KNOTS
                                        3.3,    // 60-KNOTS
                                        5.0,    // 70-KNOTS
                                        6.0,    // 100-KNOTS
                                        7.0,    // 150-KNOTS
                                        8.0,    // 200-KNOTS
                                        9.0,    // 225-KNOTS
                                        10.0    // 250-KNOTS
                                    ];
 
       gGearPowerList             = [   5,    // HOVER
                                        15,   // 15-KNOTS
                                        30,   // 30-KNOTS
                                        40,   // 40-KNOTS
                                        50,   // 50-KNOTS
                                        60,   // 60-KNOTS
                                        70,  // 70-KNOTS
                                        100,  // 100-KNOTS
                                        150,  // 150-KNOTS
                                        200,  // 200-KNOTS
                                        225,  // 225-KNOTS
                                        250   // 250-KNOTS
                                   ];
 
    }
        llSay(0,msg);
}
 
preload_sounds(){
    llPreloadSound(gSoundFlight);
    llPreloadSound(gSoundHorn);
    llPreloadSound(gSoundStartup);
    llPreloadSound(gSoundIdle);
    llPreloadSound(gSoundSlow);
    llPreloadSound(gSoundAggressive);
    llPreloadSound(gSoundGearUp);
    llPreloadSound(gSoundGearDown);
    llPreloadSound(gSoundRev);
    llPreloadSound(gSoundAlarm);
}
 
init_engine(){
    gRun = 0;
    llSetSitText(gSitMessage);
    llCollisionSound("", 0.0);
    gSitTarget_Rot = llRot2Euler( llGetRootRotation() ); // SIT TARGET IS BASED ON VEHICLE'S ROTATION.
    llSitTarget(gSitTarget_Pos, llEuler2Rot(DEG_TO_RAD * gSitTarget_Rot));
    gOldSound=3; 
    gNewSound=3;
    gTireSpin = "NoSpin";
    gTurnAngle = "NoTurn";
    gRotorSpin = "NoRotate";
    llSetLinkPrimitiveParamsFast(LINK_ALL_CHILDREN, [PRIM_PHYSICS_SHAPE_TYPE, PRIM_PHYSICS_SHAPE_NONE]);
    llMessageLinked(LINK_SET, 0, gTireSpin, NULL_KEY);      // NO SPIN
    llMessageLinked(LINK_SET, 0, gTurnAngle, NULL_KEY);     // NO TURN
    llMessageLinked(LINK_SET, 0, gRotorSpin, NULL_KEY);     // SLOW SPIN
}
 
init_followCam(){
    
    powershift(0);
    llSetCameraParams([
                       CAMERA_ACTIVE, 1,                     // 0=INACTIVE  1=ACTIVE
                       CAMERA_BEHINDNESS_ANGLE, 15.0,         // (0 to 180) DEGREES
                       CAMERA_BEHINDNESS_LAG, 1.0,           // (0 to 3) SECONDS
                       CAMERA_DISTANCE, 30.0,                 // ( 0.5 to 10) METERS
                       CAMERA_PITCH, 6.0,                    // (-45 to 80) DEGREES
                       CAMERA_POSITION_LOCKED, FALSE,        // (TRUE or FALSE)
                       CAMERA_POSITION_LAG, 0.01,             // (0 to 3) SECONDS
                       CAMERA_POSITION_THRESHOLD, 30.0,       // (0 to 4) METERS
                       CAMERA_FOCUS_LOCKED, FALSE,           // (TRUE or FALSE)
                       CAMERA_FOCUS_LAG, 0.01 ,               // (0 to 3) SECONDS
                       CAMERA_FOCUS_THRESHOLD, 0.01,          // (0 to 4) METERS
                       CAMERA_FOCUS_OFFSET, <0.0,0.0,0.0>   // <-10,-10,-10> to <10,10,10> METERS
                      ]);
}
 
init_fixedCam(float degrees) {
    rotation sitRot = llAxisAngle2Rot(<0, 0, 1>, degrees * PI);
    llSetCameraEyeOffset(<-20.0, 0, 8> * sitRot);
    llSetCameraAtOffset(<4, 0, 0> * sitRot);
    llForceMouselook(FALSE);
}
 
set_engine(){
    integer vfW = VEHICLE_FLAG_HOVER_WATER_ONLY | VEHICLE_FLAG_HOVER_TERRAIN_ONLY | VEHICLE_FLAG_HOVER_GLOBAL_HEIGHT;
    integer vfG = VEHICLE_FLAG_NO_DEFLECTION_UP | VEHICLE_FLAG_LIMIT_ROLL_ONLY | VEHICLE_FLAG_HOVER_UP_ONLY | VEHICLE_FLAG_LIMIT_MOTOR_UP;
    integer vfA = VEHICLE_FLAG_HOVER_GLOBAL_HEIGHT;
    llSetVehicleType(VEHICLE_TYPE_AIRPLANE);
    llSetVehicleRotationParam(VEHICLE_REFERENCE_FRAME, <0.00000, 0.00000, 0.00000, 0.00000>);
    llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_TIMESCALE, gVLMT);
    llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, gVLMDT);
    llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, gVLFT );
    llSetVehicleVectorParam(VEHICLE_ANGULAR_FRICTION_TIMESCALE, gVAFT );
    llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_TIMESCALE, gVAMT);
    llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, gVAMDT);
    llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, gVLDE);
    llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_TIMESCALE, gVLDT);
    llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, gVADE);
    llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, gVADT);
    llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, gVVAE);
    llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, gVVAT);
    llSetVehicleFloatParam(VEHICLE_HOVER_EFFICIENCY, gVHE );
    llSetVehicleFloatParam(VEHICLE_HOVER_TIMESCALE, gVHT );
    llSetVehicleFloatParam(VEHICLE_HOVER_HEIGHT, gVHH );
    llSetVehicleFloatParam(VEHICLE_BUOYANCY, gVB );
    llSetVehicleFloatParam( VEHICLE_BANKING_EFFICIENCY, gVBE );
    llSetVehicleFloatParam( VEHICLE_BANKING_MIX, gVBM );
    llSetVehicleFloatParam( VEHICLE_BANKING_TIMESCALE, gVBT );
 
    // llRemoveVehicleFlags(vfW);      // NOT FOR OPENSIM
    // llRemoveVehicleFlags(vfA);      // NOT FOR OPENSIM
    // llSetVehicleFlags(vfG);        // NOT FOR OPENSIM
    gRotorSpin = "SlowRotate";
    llMessageLinked(LINK_SET, 0, gRotorSpin, NULL_KEY);     // SLOW SPIN
}
 
powershift(integer g){
    if(gRun & ~gMoving){
        if(gCamFixed==0){
            llSetCameraParams([CAMERA_DISTANCE,20.0]);
        }
    }
    else {
    vector vel = llGetVel();
    float speed = llVecMag(vel);
    if (speed <=20){
         if(gCamFixed==0){
            llSetCameraParams([CAMERA_DISTANCE,20.0]);
            }
        }
        else if ((speed >=21) || (speed <=50)){
            if(gCamFixed==0){    
                llSetCameraParams([CAMERA_DISTANCE,20.0]);
            }
        }
        else  if (speed >=51) {
             if(gCamFixed==0){   
                llSetCameraParams([CAMERA_DISTANCE,10.0]);
                    }
        
        }
    }
    gGearPower = llList2Integer(gGearPowerList, g);
}
 
gearshift(integer g){
    gGearName = llList2String(gGearNameList, g);
    enginesound();
    llSay(0,gGearName);
}
 
nearestpi(){
    // ALIGNS THE VEHICLE EAST WEST SOUTH NORTH BASED ON CURRENT ROTATION (PRESTAGE AND STAGE DURING DRAG MODE)    
    vector Rad = llRot2Euler( llGetRootRotation() );
    llSetRot( llEuler2Rot( <Rad.x, Rad.y, llRound( Rad.z / PI_BY_TWO ) * PI_BY_TWO > ) );
}
 
menu(key user,string title,list buttons)
{
    llListenRemove(menu_handler);
    menu_channel = (integer)(llFrand(99999.0) * -1);
    menu_handler = llListen(menu_channel,"","","");
    llDialog(user,title,buttons,menu_channel);
    llSetTimerEvent(30.0); 
}
 
showdata(string s){
    llSetText(s+"\n.\n.\n.\n.",<1,1,.6>,1.0);
    //llSetText("",<0,0,0>,1.0);
}
 
enginesound(){
    vector vel = llGetVel();
    float speed = llVecMag(vel);
    if (speed <=15){
        gNewSound = 0;
        }
        else if (speed >=50){
            gNewSound = 2;
        }
        else {
            gNewSound = 1;
        }
        
    if (gOldSound != gNewSound){
        if (speed <=15){
            llLoopSound(gSoundIdle,1.0);
            }
            else if (speed >=50){
                llLoopSound(gSoundAggressive,1.0);
            }
            else {
                llLoopSound(gSoundSlow,1.0);
            }    
    gOldSound = gNewSound;
    }
}
 
cornerFXR(){
    vector vel = llGetVel();
    float speed = llVecMag(vel);
    if (speed >50){
    llMessageLinked(LINK_SET, 0, "letsburnR", NULL_KEY);
        }
}
 
cornerFXL(){
    vector vel = llGetVel();
    float speed = llVecMag(vel);
    if (speed >50){
    llMessageLinked(LINK_SET, 0, "letsburnL", NULL_KEY);
        }
}
 
default {
    state_entry()
    {
        init_engine();
        state Air;
    }
}
 
state Air{
 
    state_entry(){
    }
    on_rez(integer param) {
        llResetScript();
        preload_sounds();
        init_PhysEng();
    }
    
    changed(integer change){
        if ((change & CHANGED_LINK) == CHANGED_LINK){
            gAgent = llAvatarOnSitTarget();
            if (gAgent != NULL_KEY){
                if( (gAgent != llGetOwner()) && (gDrivePermit == 1)){
                    llSay(0, gUrNotAllowedMessage);
                    llUnSit(gAgent);
                    llPlaySound(gSoundAlarm,1.0);
                    llPushObject(gAgent, <0,3,20>, ZERO_VECTOR, FALSE);
                }
                else {
                    llSetStatus(STATUS_PHYSICS, TRUE);
                    llSetStatus(STATUS_ROTATE_Y,TRUE);
                    gOldAgent = gAgent;
                    init_PhysEng();
                    set_engine();
                    llRequestPermissions(gAgent, PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS | PERMISSION_CONTROL_CAMERA | PERMISSION_TRACK_CAMERA);
                    gRun = 1;
                }
            }
            else {
                llSetStatus(STATUS_PHYSICS, FALSE); 
                gRun = 0;
                init_engine();
                llTriggerSound(gSoundStop,1);
                llStopAnimation(gDrivingAnim);
                llPushObject(gAgent, <0,3,20>, ZERO_VECTOR, FALSE);
                llSetTimerEvent(0.0);
                llStopSound();
                llReleaseControls();
                llClearCameraParams();
                llSetCameraParams([CAMERA_ACTIVE, 0]);
                llSetText("",<0,0,0>,1.0);
            }
        }
    }
    run_time_permissions(integer perm){
        if (perm) {
            gGear = 0; // LIST INDEX STARTS @ 0
            //gNewGear = 2;  
            llTakeControls(CONTROL_FWD | CONTROL_BACK | CONTROL_DOWN | CONTROL_UP | CONTROL_RIGHT | CONTROL_LEFT | CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT, TRUE, FALSE);
            if (gCamFixed == 1) {
                init_fixedCam(0);
            }else{
                init_followCam();
            }
            llMessageLinked(LINK_SET, 0, "pipeflame", NULL_KEY);
            llMessageLinked(LINK_SET, 0, "headlight", "0");
            llStartAnimation(gDrivingAnim);
            llTriggerSound(gSoundStartup,1.0);
            llSleep(1.5);
            enginesound();
        }
    }
 
    control(key id, integer held, integer change){
        if(gRun == 0){
            return;
        }
        integer reverse=1;
        vector vel = llGetVel();
        vector speedvec = llGetVel() / llGetRot();
        gSpeed = llVecMag(vel);
        gTurnRatio = llList2Float(gTurnRatioList,gGear);
 
        if ((held & change & CONTROL_RIGHT) || ((gGear >= 11) && (held & CONTROL_RIGHT))){
            gGear=gGear+1;
            if (gGear < 0) gGear = 0;
            if (gGear > 11) gGear = 11;
            gearshift(gGear);
        }
 
        if ((held & change & CONTROL_LEFT) || ((gGear >= 11) && (held & CONTROL_LEFT))){
            gGear=gGear-1;
            if (gGear < 0) gGear = 0;
            if (gGear > 11) gGear = 11;
            gearshift(gGear);
            
        }
        if (held & CONTROL_FWD){
            if(gGear == 0) {
                //llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <1.0, 2.0, 8.0>);
            }else{
                //llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, gVLFT);
            }
            if(gGear == 1)  {
                //llMessageLinked(LINK_SET, 0, "letsburn", NULL_KEY);
                //llMessageLinked(LINK_SET, 0, "letsscreech", NULL_KEY);
                //llMessageLinked(LINK_SET, 0, "pipeflame", NULL_KEY);
            }
            if(gGear == 2)  {
            }
            if(gGear == 3)  {
            }
            if(gGear == 4)  {
            }
            if(gGear == 5)  {
            }
            if(gGear == 6)  {
                llMessageLinked(LINK_SET, 0, "pipeflame", NULL_KEY);
            }
            if(gGear == 7)  {
            }
            if(gGear == 8)  {
            }
            if(gGear == 9)  {
            }
            if(gGear == 10) {
            }
            if(gGear == 11) {
            }
            powershift(gGear);
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <gGearPower,0,0>);
            gMoving=1;
            reverse=1;
            gNewTireSpin = "ForwardSpin";
            
        }
 
        if (held & CONTROL_BACK){
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <gReversePower,0,0>);
            llSetCameraParams([CAMERA_BEHINDNESS_ANGLE,-45.0]);
            llSetCameraParams([CAMERA_DISTANCE,20.0]);
            gTurnRatio = -2.0;
            reverse = -1;
            gNewTireSpin = "BackwardSpin";
            llMessageLinked(LINK_SET, 0, gTireSpin, NULL_KEY);
        }
         if (~held & change & CONTROL_FWD){
            //llSay(0,"CONTROL_FWD:Released");
            llMessageLinked(LINK_SET, 0, gTireSpin, NULL_KEY);             
            gNewTireSpin = "NoSpin";
            gNewTurnAngle = "NoTurn";
            
            if (gGear > 9){
                gGear = 3;
            }
 
                }
         if (~held & change & CONTROL_BACK){
            //llSay(0,"CONTROL_BACK:Released");
            llMessageLinked(LINK_SET, 0, gTireSpin, NULL_KEY);             
            gNewTireSpin = "NoSpin";
            gNewTurnAngle = "NoTurn";
        }
         if (~held & ~change & CONTROL_FWD){
            //llSay(0,"CONTROL_FWD:Inactive");
            llMessageLinked(LINK_SET, 0, gTireSpin, NULL_KEY);             
        }
         if (~held & ~change & CONTROL_BACK){
            //llSay(0,"CONTROL_BACK:Inactive");
            llMessageLinked(LINK_SET, 0, gTireSpin, NULL_KEY);             
        }
       
       showdata("Speed Vector:" + (string)speedvec + " Speed:" + (string)(gSpeed*2.23692912) + " mph");
       enginesound();
 
         vector AngularMotor;
        if (held & (CONTROL_ROT_RIGHT)){
            if (gGear==0){
            AngularMotor.z -= 1.5*gTurnMulti;
            }else{
            AngularMotor.x += 1.5*gTurnMulti;
            }
            gNewTurnAngle = "RightTurn";
            gTurnCount = 10;
            gTcountR = 2;
        }
 
        if (held & (CONTROL_ROT_LEFT)){
            if (gGear==0){
            AngularMotor.z += 1.5*gTurnMulti;
            }else{
            AngularMotor.x -= 1.5*gTurnMulti;
            }
            gNewTurnAngle = "LeftTurn";
            gTurnCount = 10;
            gTcountL = 2;
         }
         
          // going up or stop going up
        if(held & CONTROL_UP) {
                if(gGear!=0){
                    llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <gGearPower,0,gVerticalThrust*gGear>);
                }else{
                 llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <0,0,gVerticalThrust>);
                }
        } else if (change & CONTROL_UP) {
                 if(gGear!=0){
                    llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <gGearPower,0,0>);
                }else{
                 llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <0,0,0>);
                }
                       }
        
        // going down or stop going down
        
        if(held & CONTROL_DOWN) {
                if(gGear!=0){
                    llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <gGearPower,0,-gVerticalThrust*gGear>);
                }else{
                 llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <0,0,-gVerticalThrust>);
                }
        } else if (change & CONTROL_DOWN) {
                 if(gGear!=0){
                    llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <gGearPower,0,0>);
                }else{
                 llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <0,0,0>);
                }
        }
 
        AngularMotor.y = 0;       
 
        llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, AngularMotor);
            if(gTcountL > 0){
                gTcountL--;
                //llSay(0,(string)gTcountL);
            }
            if(gTcountL == 1){
                cornerFXL();
            }
            if(gTcountR > 0){
                gTcountR--;
               // llSay(0,(string)gTcountR);
            }
            if(gTcountR == 1){
                cornerFXR();
            }
       
        if(gTurnCount > 0){
            gTurnCount--;
        }
        if(gTurnCount == 1){
            gNewTurnAngle = "NoTurn";
        }
        if(gTurnAngle != gNewTurnAngle){
            gTurnAngle = gNewTurnAngle;
            llMessageLinked(LINK_ALL_OTHERS, 0, gTurnAngle, NULL_KEY);
        }
        if(gTireSpin != gNewTireSpin){
            gTireSpin = gNewTireSpin;
            //llMessageLinked(LINK_ALL_OTHERS, 0, gTireSpin, NULL_KEY);
           llMessageLinked(LINK_SET, 0, gTireSpin, NULL_KEY);
        }
 
    }
 
    touch_start(integer total_number){
        if (gAgent != NULL_KEY){
            menu(llDetectedKey(0), "\nDriver's Menu.", MENU_MAIN);
        }
    }
 
    listen(integer channel,string name,key id,string message){
        if (channel == menu_channel){
            llListenRemove(menu_handler);
            llSetTimerEvent(0);
            if (message == "Align"){
                llSay(0, "Car is lined up...");
                nearestpi();
            }
            else if (message == "Hello"){
                llSay(0, "Hello yourself");
            }
            // else if (message == "Button"){
            // do something
            //}
        }
    }
 
 
    link_message(integer sender, integer num, string str, key id){
 
        integer i = llGetLinkNumber() != 0;   // Start at zero (single prim) or 1 (two or more prims)
        integer x = llGetNumberOfPrims() + i; // [0, 1) or [1, llGetNumberOfPrims()]
 
        for (; i < x; ++i)
        {
        
            if (llGetLinkName(i) == "spin"){
                rotation rootRot = llGetRootRotation();
                vector rootPos = llGetRootPosition();
                
                list params = llGetLinkPrimitiveParams(i,[PRIM_POSITION,PRIM_ROT_LOCAL,PRIM_SIZE]);
                rotation childRot = llList2Rot(params,1);
                vector childPos = (llList2Vector(params,0)-rootPos)/rootRot;
                vector childSize = llList2Vector(params,2);
 
                    if(str == "ForwardSpin"){
                    llSetLinkPrimitiveParamsFast(i, [PRIM_OMEGA, <0.0,90.0,0.0>*DEG_TO_RAD*childRot, TWO_PI, 1.0]);
                    }else if (str == "BackwardSpin"){
                    llSetLinkPrimitiveParamsFast(i, [PRIM_OMEGA, <0.0,90.0,0.0>*DEG_TO_RAD*childRot, -TWO_PI, 1.0]);
                    }else if (str == "NoSpin"){
                    llSetLinkPrimitiveParamsFast(i, [PRIM_OMEGA, <0.0,00.0,0.0>*DEG_TO_RAD*childRot, 0, 1.0]);
                    }
            }else if (llGetLinkName(i) == "spin_y"){
                    if(str == "NoRotate"){
                    llSetLinkPrimitiveParamsFast(i, [PRIM_OMEGA, <0.0,00.0,0.0>*DEG_TO_RAD*0, 0, 0.987654]);
                    }else if (str == "SlowRotate"){
                    llSetLinkPrimitiveParamsFast(i, [PRIM_OMEGA, <0.0,90.0,0.0>*DEG_TO_RAD*1, TWO_PI*2, 0.987654]); 
                    }else if (str == "FastRotate"){
                    llSetLinkPrimitiveParamsFast(i, [PRIM_OMEGA, <0.0,90.0,0.0>*DEG_TO_RAD*1, TWO_PI*4, 0.987654]);
                    }
            }else if (llGetLinkName(i) == "spin_x"){
                    if(str == "NoRotate"){
                    llSetLinkPrimitiveParamsFast(i, [PRIM_OMEGA, <0.0,00.0,0.0>*DEG_TO_RAD*0, 0, 0.987654]);
                    }else if (str == "SlowRotate"){
                    llSetLinkPrimitiveParamsFast(i, [PRIM_OMEGA, <90.0,0.0,0.0>*DEG_TO_RAD*1, TWO_PI*2, 0.987654]); 
                    }else if (str == "FastRotae"){
                    llSetLinkPrimitiveParamsFast(i, [PRIM_OMEGA, <90.0,0.0,0.0>*DEG_TO_RAD*1, TWO_PI*4, 0.987654]);
                    }
            }else if (llGetLinkName(i) == "spin_z"){
                    if(str == "NoRotate"){
                    llSetLinkPrimitiveParamsFast(i, [PRIM_OMEGA, <0.0,00.0,0.0>*DEG_TO_RAD*0, 0, 0.987654]);
                    }else if (str == "SlowRotate"){
                    llSetLinkPrimitiveParamsFast(i, [PRIM_OMEGA, <0.0,0.0,90.0>*DEG_TO_RAD*1, TWO_PI*2, 0.987654]); 
                    }else if (str == "FastRotate"){
                    llSetLinkPrimitiveParamsFast(i, [PRIM_OMEGA, <0.0,0.0,90.0>*DEG_TO_RAD*1, TWO_PI*4, 0.987654]);
                    }
 
                }
        }
    }
 
    timer(){
        llListenRemove(menu_handler);
        if(gRun == 1){
 
        }else{
                llSetTimerEvent(0.0);
        }
    }
}
