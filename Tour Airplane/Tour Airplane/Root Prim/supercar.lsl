// :CATEGORY:Vehicle
// :NAME:Tour Airplane
// :AUTHOR:Shin Ingen
// :KEYWORDS:
// :CREATED:2014-12-04 12:44:16
// :EDITED:2014-12-04
// :ID:1060
// :NUM:1698
// :REV:1
// :WORLD:OpenSim
// :DESCRIPTION:
// Opensim Supercar
// :CODE:
//*******************************************************
// Shin Ingen @ http://ingen-lab.com:8002
// LSL | OPENSIM | BulletSim and ODE | ACDC
// iTEC + e3s + DC (ENGINE SPEED SENSITIVE STEERING WITH DYNAMIC CAMERA)
// JANUARY 28, 2013
// TODO: KEYWORD PROCESSOR FOR ** PRIM ANIMATION | AVATAR ANIMATION | SOUNDS | MENU | HUD | DYNAMIC CAMERA
//*******************************************************
 
//---PERMISSION VARIABLES---------------------------------------------
integer         gDrivePermit = 1; // 0=EVERYONE 1=OWNERONLY
string          gSitMessage = "Drive";
string          gUrNotAllowedMessage = "Vehicle is Locked";
vector          gSitTarget_Pos = <-0.25,2.1,1.25>;
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
integer         gCamFixed=0;          // INITVAL=0           0=FOLLOW CAM 1=FIXED CAM
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
string       gSoundStartup =         "s_startup";
string       gSoundIdle =            "s_idle";
string       gSoundSlow =            "s_slow";
string       gSoundAggressive =      "s_fast";
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
float       gVAMT=1.0;                  //INITVAL=0.10 
float       gVAMDT=0.10;                 //INITVAL=0.10
float       gVLDE=1.0;                   //INITVAL=1.0
float       gVLDT=0.10;                  //INITVAL=0.10
float       gVVAE=0.50;                  //INITVAL=0.50
float       gVVAT=5.0;                   //INITVAL=5.0
float       gVHE=0.0;                    //INITVAL=0.0
float       gVHT=0.0;                    //INITVAL=0.0
float       gVHH=0.0;                    //INITVAL=0.0
float       gVB=0.0;                     //INITVAL=0.0
//---------------------------------------------------------------------
 
//---iTEC POWERTRAIN + (e3s) GLOBAL VARIABLES -------------------------
integer      gGear;
//integer      gNewGear;
float        gGearPower;
float        gReversePower            =     -15;
list         gGearPowerList           = [     2,    //  STAGER
                                             15,    //  BURNOUT
                                             20,    //  1ST
                                             40,    //  2ND
                                             70,    //  3RD
                                             80,    //  4TH
                                            100,    //  5TH
                                            110,    //  6TH
                                            155,    //  PRO-STOCK (START-DRAG-CLASS)
                                            170,    //  PRO-MOD
                                            198,    //  TOP-FUEL
                                            256     //  OPEN-PRO
                                         ];
//integer     gGearCount;
//string      gPhysEngDesc;
integer     gPhysEng=1; // if os function is off set this to 0=ODE| 1=Bullet
float       gTurnMulti=1.012345;
float       gTurnRatio;
list        gTurnRatioList;
string      gGearName;
list        gGearNameList                 =[   "STAGER",
                                               "BURNOUT",
                                               "1ST-GEAR",
                                               "2ND-GEAR",
                                               "3RD-GEAR",
                                               "4TH-GEAR",
                                               "5TH-GEAR",
                                               "6TH-GEAR",
                                               "PRO-STOCK",
                                               "PRO-MOD",
                                               "TOP-FUEL",
                                               "OPEN-PRO"
                                         ];
float         gSpeed=0;
//---------------------------------------------------------------------
 
//---------------------------------------------------------------------
//NEED A KEYWORD PRIM ANIMATION PROCESSOR
integer            gTurnCount;
string             gTurnAngle =               "NoTurn";  // LeftTurn or RightTurn or NoTurn
string             gNewTurnAngle =            "NoTurn";
string             gTireSpin =                "ForwardSpin";   // ForwardSpin or BackwardSpin or NoSpin
string             gNewTireSpin =             "ForwardSpin";
 
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
        gTSvarList = [  3.0,               // how fast to reach max speed
                        0.10,               // how fast to reach min speed or zero
                        <7.0,3000.0,100.0>,   // XYZ linear friction
                        <0.10,0.10,0.20>,   // XYZ angular friction
                        0.90,               // how fast turning force is applied 
                        0.50,               // how fast turning force is released
                        1.0,                // adjusted on 0.7.6
                        0.10,
                        0.20,
                        0.10,
                        0.50,
                        5.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0
                     ];
    }else{
        gTSvarList = [  1.0,               // how fast to reach max speed
                        0.10,               // how fast to reach min speed or zero
                        <8.0,3000.0,8.0>,   // XYZ linear friction
                        <0.10,0.10,0.10>,   // XYZ angular friction
                        0.20,               // how fast turning force is applied 
                        0.20,               // how fast turning force is released
                        0.80,               // adjusted on 0.8.0
                        0.10,
                        1.0,
                        0.10,
                        0.50,
                        5.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0
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
 
}
 
init_PhysEng(){
    string msg;
    //gPhysEngDesc=osGetPhysicsEngineType();
    //if(gPhysEngDesc=="OpenDynamicsEngine"){
    //    msg ="Your Vehicle is tuned for OpenDynamicsEngine";
    //    gPhysEng=0;
    //}else if(gPhysEngDesc=="BulletSim"){
    //    msg ="Your Vehicle is tuned for BulletSim";
    //    gPhysEng=1;
    //}else{
    //    msg ="WARNING:Automatic Detection of Physics Engine is off.";
    //}
    if(gPhysEng==0){
        msg =":: is tuned for OpenDynamicsEngine";
    }else if(gPhysEng==1){
        msg =":: is tuned for BulletSim";
    }
    
    if(gPhysEng==0){
       // gTurnMulti=gTurnMulti;
        init_TSvar(0);
        gTurnRatioList            = [   2.4,    //  STAGER
                                        2.4,    //  BURNOUT
                                        2.4,    //  1ST
                                        2.5,    //  2ND
                                        4.2,    //  3RD
                                        4.7,    //  4TH
                                        5.5,    //  5TH
                                        6.5,    //  6TH
                                        7.5,    //  PRO-STOCK (START-DRAG-CLASS)
                                        10.0,    //  PRO-MOD
                                        10.0,    //  TOP-FUEL
                                        10.0    //  OPEN-PRO
                                    ];    
       gGearPowerList             = [   2,    //  STAGER
                                        10,    //  BURNOUT
                                        15,    //  1ST
                                        30,    //  2ND
                                        60,    //  3RD
                                        70,    //  4TH
                                        90,    //  5TH
                                        110,    //  6TH
                                        155,    //  PRO-STOCK (START-DRAG-CLASS)
                                        170,    //  PRO-MOD
                                        200,    //  TOP-FUEL
                                        256     //  OPEN-PRO
                                   ];
 
    
    }else{
        gTurnMulti=0.987654;
        init_TSvar(1);
        gTurnRatioList            = [   1.3,    //  STAGER
                                        1.5,    //  BURNOUT
                                        1.5,    //  1ST
                                        2.5,    //  2ND
                                        3.9,    //  3RD
                                        4.0,    //  4TH
                                        4.1,    //  5TH
                                        4.5,    //  6TH
                                        10.0,   //  PRO-STOCK (START-DRAG-CLASS)
                                        10.0,   //  PRO-MOD
                                        10.0,   //  TOP-FUEL
                                        10.0    //  OPEN-PRO
                                    ];
 
       gGearPowerList             = [   2,    //  STAGER
                                        15,    //  BURNOUT
                                        20,    //  1ST
                                        40,    //  2ND
                                        70,    //  3RD
                                        80,    //  4TH
                                        100,    //  5TH
                                        110,    //  6TH
                                        155,    //  PRO-STOCK (START-DRAG-CLASS)
                                        170,    //  PRO-MOD
                                        198,    //  TOP-FUEL
                                        256     //  OPEN-PRO
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
    llSetLinkPrimitiveParamsFast(LINK_ALL_CHILDREN, [PRIM_PHYSICS_SHAPE_TYPE, PRIM_PHYSICS_SHAPE_NONE]);
    llMessageLinked(LINK_SET, 0, gTireSpin, NULL_KEY);      // NO SPIN
    llMessageLinked(LINK_SET, 0, gTurnAngle, NULL_KEY);     // NO TURN
}
 
init_followCam(float degrees){
    llSetCameraParams([
                       CAMERA_ACTIVE, 1,                 // 0=INACTIVE  1=ACTIVE
                       CAMERA_BEHINDNESS_ANGLE, 4.0,     // (0 to 180) DEGREES
                       CAMERA_BEHINDNESS_LAG, 0.02,       // (0 to 3) SECONDS
                       CAMERA_DISTANCE, 8.0,             // ( 0.5 to 10) METERS
                       CAMERA_PITCH, 8.0,                // (-45 to 80) DEGREES
                       CAMERA_POSITION_LOCKED, FALSE,    // (TRUE or FALSE)
                       CAMERA_POSITION_LAG, 0.000,         // (0 to 3) SECONDS
                       CAMERA_POSITION_THRESHOLD, 8.0,   // (0 to 4) METERS
                       CAMERA_FOCUS_LOCKED, FALSE,       // (TRUE or FALSE)
                       CAMERA_FOCUS_LAG, 0.00 ,           // (0 to 3) SECONDS
                       CAMERA_FOCUS_THRESHOLD, 8.0,      // (0 to 4) METERS
                       CAMERA_FOCUS_OFFSET, <0.10,0,0>   // <-10,-10,-10> to <10,10,10> METERS
                      ]);
                        rotation sitRot = llAxisAngle2Rot(<0, 0, 1>, degrees * PI);
                        llSetCameraEyeOffset(<-10, 0, 3.5> * sitRot);
                        llSetCameraAtOffset(<4, 0, 3> * sitRot);
                        llForceMouselook(FALSE);
}
 
init_fixedCam(float degrees) {
    rotation sitRot = llAxisAngle2Rot(<0, 0, 1>, degrees * PI);
    llSetCameraEyeOffset(<-10, 0, 3.5> * sitRot);
    llSetCameraAtOffset(<4, 0, 3> * sitRot);
    llForceMouselook(FALSE);
}
 
set_engine(){
    integer vfW = VEHICLE_FLAG_HOVER_WATER_ONLY | VEHICLE_FLAG_HOVER_TERRAIN_ONLY | VEHICLE_FLAG_HOVER_GLOBAL_HEIGHT;
    integer vfG = VEHICLE_FLAG_NO_DEFLECTION_UP | VEHICLE_FLAG_LIMIT_ROLL_ONLY | VEHICLE_FLAG_HOVER_UP_ONLY |
        VEHICLE_FLAG_LIMIT_MOTOR_UP;
    integer vfA = VEHICLE_FLAG_HOVER_GLOBAL_HEIGHT;
    llSetVehicleType(VEHICLE_TYPE_CAR);
    llSetVehicleRotationParam(VEHICLE_REFERENCE_FRAME, <2.00000, 0.00000, 0.00000, 0.00000>);
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
 
    llRemoveVehicleFlags(vfW);      
    llRemoveVehicleFlags(vfA);      
    llSetVehicleFlags(vfG);       
}
 
powershift(integer g){
    if(!gMoving){
        if(gCamFixed==0){
        //enter your cam logic here
        }
    }
    else {
    vector vel = llGetVel();
    float speed = llVecMag(vel);
    if (speed <=20){
         if(gCamFixed==0){
            //enter your cam logic here
            }
        }
        else if ((speed >=21) || (speed <=50)){
            if(gCamFixed==0){    
            //enter your cam logic here
            }
        }
        else  if (speed >=51) {
             if(gCamFixed==0){   
            //enter your cam logic here
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
    if (speed <=20){
        gNewSound = 0;
        }
        else if (speed >=50){
            gNewSound = 2;
        }
        else {
            gNewSound = 1;
        }
        
    if (gOldSound != gNewSound){
        if (speed <=20){
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
        state Ground;
    }
}
 
state Ground{
 
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
                    llPushObject(gAgent, <0,0,20>, ZERO_VECTOR, FALSE);
                }
                else {
                    llSetStatus(STATUS_PHYSICS, TRUE);
                    gOldAgent = gAgent;
                    init_PhysEng();
                    set_engine();
                    llRequestPermissions(gAgent, PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS | PERMISSION_CONTROL_CAMERA);
                    gRun = 1;
                }
            }
            else {
                llSetStatus(STATUS_PHYSICS, FALSE); //SHOULD THIS BE THE LAST THING YOU SET??
                gRun = 0;
                init_engine();
                llTriggerSound(gSoundStop,1);
                llStopAnimation(gDrivingAnim);
                llSetTimerEvent(0.0);
                llStopSound();
                llReleaseControls();
                llClearCameraParams();
                llSetText("",<0,0,0>,1.0);
            }
        }
    }
    run_time_permissions(integer perm){
        if (perm) {
            gGear = 2; // GEAR#0 IS STAGER | GEAR#1 IS BURNOUT | GEAR#2 IS THE FIRST GEAR (LIST INDEX STARTS @ 0)
            //gNewGear = 2;  
            llTakeControls(CONTROL_FWD | CONTROL_BACK | CONTROL_DOWN | CONTROL_UP | CONTROL_RIGHT | CONTROL_LEFT | CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT, TRUE, FALSE);
            if (gCamFixed == 1) {
                init_fixedCam(0);
            }else{
                init_followCam(0);
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
 
        if ((held & change & CONTROL_UP) || ((gGear >= 11) && (held & CONTROL_UP))){
            gGear=gGear+1;
            if (gGear < 0) gGear = 0;
            if (gGear > 11) gGear = 11;
            gearshift(gGear);
        }
 
        if ((held & change & CONTROL_DOWN) || ((gGear >= 11) && (held & CONTROL_DOWN))){
            gGear=gGear-1;
            if (gGear < 0) gGear = 0;
            if (gGear > 11) gGear = 11;
            gearshift(gGear);
        }
        if (held & CONTROL_FWD){
            if(gGear == 0) {
                llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <1.0, 2.0, 8.0>);
            }else{
                    llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, gVLFT);
            }
            if(gGear == 1)  {
                llMessageLinked(LINK_SET, 0, "letsburn", NULL_KEY);
                llMessageLinked(LINK_SET, 0, "letsscreech", NULL_KEY);
                llMessageLinked(LINK_SET, 0, "pipeflame", NULL_KEY);
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
            llSetCameraParams([CAMERA_DISTANCE,8.0]);
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
        if (held & (CONTROL_RIGHT|CONTROL_ROT_RIGHT)){
            if (gGear==0){
            AngularMotor.z -= gSpeed / ((gTurnRatio/gTurnMulti)*1);
            }else{
            AngularMotor.z -= gSpeed / ((gTurnRatio/gTurnMulti)*gGear);
            }
            gNewTurnAngle = "RightTurn";
            gTurnCount = 10;
            gTcountR = 2;
        }
 
        if (held & (CONTROL_LEFT|CONTROL_ROT_LEFT)){
            if (gGear==0){
            AngularMotor.z += gSpeed / ((gTurnRatio/gTurnMulti)*1);
            }else{
            AngularMotor.z += gSpeed / ((gTurnRatio/gTurnMulti)*gGear);
            }
            gNewTurnAngle = "LeftTurn";
            gTurnCount = 10;
            gTcountL = 2;
         }
 
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
        
            if (llGetLinkName(i) == "spin")
            {
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
