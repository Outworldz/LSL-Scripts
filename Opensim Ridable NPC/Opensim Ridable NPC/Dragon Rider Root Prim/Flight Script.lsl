// :SHOW:1
// :CATEGORY:Flying NPC's
// :NAME:Opensim Ridable NPC
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2015-03-17 10:27:54
// :EDITED:2015-04-14  11:57:50
// :ID:1073
// :NUM:1730
// :REV:0.5
// :WORLD:OpenSim
// :DESCRIPTION:
// Rideable NPC dragon ( and other rideable creatures) Original script by Shin Ingen
// :CODE:



// Rev 0.1 2014-12-08 compiles
// Rev 0.2 2014-12-09 sound files added
// Rev 0.3 2014-12-25 sit fixed
// Rev 0.4 2014-12-27 dragon collider activated
// Rev 0.5 2015-03-17 Archived version

//*******************************************************
// Original Vehicle by Shin Ingen @ http://ingen-lab.com:8002
// LSL | OPENSIM | BulletSim | Varregion
// iTEC + e3s + DC (ENGINE SPEED SENSITIVE STEERING WITH DYNAMIC CAMERA)
//*******************************************************

integer gInProduction = TRUE;  // Will die if in Production mode and avatar is unseated. Uses a Rezzer
integer gDebug = FALSE;         // set to TRUE or FALSE for debug chat on various actions
 
integer DragonChannelBack = 549898; // channel the dragon talks back on.
integer DragonChannel = 549897; // secret channel to comm with Dragons. set to zero to not care about them


 
 
// NPC Sit 
vector gSitPos = <0.35,0,0.85>;
vector gSitRot = <0,1,0>; 


string dragonState;        // flyingslow, flyingfast, or sitting
string whatsplaying;      // the currently playing NPC automation

integer turning  ; // set to true if we are turning, otherwaise, false

// Animation Control 
   
// NPC animations have times that they run, then they return to a state
key gNPCKey;

string      gDragonGrowlAnim = "DragonGrowl";
integer     gDragonGrowlAnimTimeout = 4;

string      gDragonFlySlowAnim = "DragonFlySlow";
integer     gDragonFlySlowAnimTimeout = 1;

string      gDragonFlyFastAnim = "DragonFlyFast";
integer     gDragonFlyFastAnimTimeout = 1;

string     gDragonSitAnim1 = "DragonStand1";
integer    gDragonSitAnim1Timeout = 1;

string     gDragonSitAnim2 = "DragonStand2";
integer    gDragonSitAnim2Timeout = 1;

///////////////////////// VEHICLE CODE BELOW /////////////////////////////
integer     gForward;    // tru for forward flight, false if backing up Beep Beep
integer     gSpeeding;  // TRUE if we are flying fast
integer     gPhysEng=1; // 0=ODE| 1=Bullet

//---HUMAN ANIMATION VARIABLES-----------------------------------------------
string     gAvatarState;    // sitting, right, left
string     gLastAnimation; // the last animation played on the owner

string     gDrivingAnim = "ride-carousel";
string     gAvatarSitAnim = "ride-carousel";
string     gAvatarRAnim = "ride-carousel";
string     gAvatarLAnim = "ride-carousel";

//---SOUND VARIABLES---------------------------------------------------
string       gSoundLoopIdle =           "wing-flap-3";    // 
string       gSoundLoopSlow =           "wing-flap-2";
string       gSoundLoopAggressive =     "wing-flap-1";
string       gSoundStop =               "monster-short-roar";    // Get off the dragon
string       gSoundStartup =            "monster-short-roar";    // Got permissions
string       gGrowlSound=               "GrowlSound";    // Menu
string       gFlameSound=               "flame whoosh";    // Menu
string       gSteamSound=               "whoosh-puff";    // Menu



string      gNewSound; // new sound to play
string      gOldSound;
//---------------------------------------------------------------------




//---PERMISSION VARIABLES---------------------------------------------
integer         gDrivePermit = 1; // 0=EVERYONE 1=OWNERONLY
string          gSitMessage = "Ride";
string          gUrNotAllowedMessage = "Dragon is Locked";
vector          gSitTarget_Pos = <2.5,1.6,1.9>;
key             gAgent;
integer         gRun;     //ENGINE RUNNING   
integer         gMoving;  //VEHICLE MOVING
//integer        gIdle;
//---END PREMISSION----------------------------------------------------
 
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

float       gTurnMulti=1;
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


//---MENU HANDLER------------------------------------------------------
list            MENU_MAIN = ["-","Align","-", "Steam", "Flame","Growl","-", "Help", "-"]; // up to 12 items in list
integer         menu_handler;
integer         menu_channel;
//--------------------------------------------------------------------- 

//=======================================================================
//==== E N D   G L O B A L   V A R I A B L E   D E C L A R A T I O N ====
//=======================================================================

DEBUG(string str)
{
    if (gDebug)
        llSay(0,llGetScriptName()+":" +  str);                    // Send the owner debug info so you can chase NPCS
}

// pipeline for animations for the owner
AvatarAnimate(string animation)
{
    return;
    
    if (animation != gLastAnimation) {
        DEBUG("*** Avatar start anim:" + animation);
        llStartAnimation(animation);
        
        if (llStringLength(gLastAnimation)) {
            llStopAnimation(gLastAnimation);
            DEBUG("stop anim:" + gLastAnimation);
        }
        gLastAnimation = animation;
    }
}

// and for the NPC
NPCAnimate(string what, float howlong)
{
    if (whatsplaying != what) {
        DEBUG("*** NPC start animation " + what + " for " + (string) howlong + " seconds");
        osNpcPlayAnimation(gNPCKey, what);
        
        if (llStringLength(whatsplaying)) {
            DEBUG("Stopping NPC animation " + whatsplaying);
            osNpcStopAnimation(gNPCKey, whatsplaying);
        }
        llSetTimerEvent(howlong);
        whatsplaying = what;
    }       
}


// Get a safe rotation
SafeMode() {
    vector here = llGetPos();
    vector rotv = llRot2Euler(llGetRot());
    rotation rot = llEuler2Rot(<0,0,rotv.z>);
    llSetRot(rot);
}


// Make the mouth move and play a sound
Growl()
{
    DEBUG("Growl");
    llTriggerSound(gGrowlSound,1.0);
    llMessageLinked(LINK_SET,1,"growl","");
    NPCAnimate(gDragonGrowlAnim ,gDragonGrowlAnimTimeout);   
}

// Make the mouth move and play a sound
Flame()
{
    DEBUG("Flame");
    llTriggerSound(gFlameSound,1.0);
    llMessageLinked(LINK_SET,1,"Flame","");
    NPCAnimate(gDragonGrowlAnim ,gDragonGrowlAnimTimeout);   
}

// Make the mouth move and play a sound
Steam()
{
    DEBUG("Steam");
    llTriggerSound(gSteamSound,1.0);
    llMessageLinked(LINK_SET,1,"Steam","");
    NPCAnimate(gDragonGrowlAnim ,gDragonGrowlAnimTimeout);   
}




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
        
        init_TSvar(0);
        gTurnRatioList            = [   1.4,    // HOVER
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
        gTurnMulti=1;
        init_TSvar(1);
        gTurnRatioList            = [   1.3,    // HOVER
                                        1.2,    // 15-KNOTS
                                        1.4,    // 30-KNOTS
                                        2.0,    // 40-KNOTS
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

}



init_engine(){
    gRun = FALSE;
    llSetSitText(gSitMessage);
    llCollisionSound("", 0.0);

   

    llSetLinkPrimitiveParamsFast(LINK_ALL_CHILDREN, [PRIM_PHYSICS_SHAPE_TYPE, PRIM_PHYSICS_SHAPE_NONE]);
    
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
}

powershift(integer g){
    if(gRun & ! gMoving){
        if(gCamFixed==0){
            llSetCameraParams([CAMERA_DISTANCE,20.0]);
        }
    } else {
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
    flightSound();
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
    llSetText(s,<1,1,.6>,1.0);
} 
 
flightSound(){
    vector vel = llGetVel();
    float speed = llVecMag(vel);
    if (speed <=15){
        //gTurnMulti=1.012345;
        gNewSound = gSoundLoopIdle;
     } else if (speed >=30){
        // gTurnMulti=2.012345;
        gNewSound = gSoundLoopSlow;
    } else {
      //  gTurnMulti=3.012345;
        gNewSound = gSoundLoopAggressive;
    }
    
    if (gOldSound != gNewSound){
        llLoopSound(gNewSound,1.0);
        gOldSound = gNewSound;
    }  
}

default {
    
     on_rez(integer param) {
        llResetScript();    
     }

    state_entry(){
        llListen(DragonChannel,"","","");
        rotation SitRot = llEuler2Rot(DEG_TO_RAD * gSitRot);
        llSitTarget(gSitPos, SitRot);
        llSetStatus(STATUS_PHYSICS, FALSE);
        init_engine();   
    }  
   
    changed(integer change){
        if (change & CHANGED_LINK) {
            dragonState = "sitting";
            key kWhoSat=  llAvatarOnSitTarget();
            if (osIsNpc(kWhoSat)){
                osNpcStopAnimation(kWhoSat,"sit"); // fkb
                NPCAnimate(gDragonSitAnim1 ,gDragonSitAnim1Timeout);
                llSay(0,"Ready!");
            }
        } else {
            llSetStatus(STATUS_PHYSICS, FALSE);
            gRun = FALSE;
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

    link_message(integer sender_number, integer number, string message, key id)
    {
        DEBUG("Link Msg : " + message);
        if (message == "Seated")
        {
            gAgent = id;  
            
            llSetStatus(STATUS_PHYSICS, TRUE);
            llSetStatus(STATUS_ROTATE_Y,TRUE);

            init_PhysEng();
            
            
            set_engine();
            DEBUG("Perms request");
            
            DEBUG("Agent: " + gAgent);
           llRequestPermissions(gAgent, PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS | PERMISSION_CONTROL_CAMERA | PERMISSION_TRACK_CAMERA);

        

        } else if (message == "Unseated")    {

            SafeMode(); // shut down physics
            llReleaseControls();
            llSetStatus(STATUS_PHYSICS, FALSE);
            
            DEBUG("NPC Key to delete = :" + (string) gNPCKey);
            
            if (gNPCKey != NULL_KEY)
                osNpcRemove(gNPCKey);

            llSetTimerEvent(0.0);
            llSetText("",<0,0,0>,1.0);
            
            if (gInProduction)
               llDie();
                   
        } else if (message == "NPCkey") {
            
            gNPCKey = id;
            DEBUG("NPC Key located:" + (string) gNPCKey);
        }  

    }
   
    run_time_permissions(integer perm){
        
        DEBUG("permissions = " + (string) perm);
        
        if (perm & PERMISSION_TRIGGER_ANIMATION) {
            DEBUG("Animation granted");
            llStopAnimation("sit");
            AvatarAnimate(gAvatarSitAnim);
        }
            
        if (perm & PERMISSION_TAKE_CONTROLS) {
            DEBUG("Controls granted");
            gGear = 0; // LIST INDEX STARTS @ 0
            llTakeControls(CONTROL_FWD | CONTROL_BACK | CONTROL_DOWN | CONTROL_UP | CONTROL_RIGHT | CONTROL_LEFT | CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT, TRUE, FALSE);
        }
            
        if (perm & PERMISSION_CONTROL_CAMERA) {
            DEBUG("Camera granted");
            if (gCamFixed == 1) {
                init_fixedCam(0);
            } else {
                init_followCam();
            }
        }
        gRun = TRUE;
        llTriggerSound(gSoundStartup,1.0);
        flightSound();
        llShout(3454,"rez");    
       
        llSay(0,"Page UP and Page Down Keys go up and down. Up and Down Arrow Keys move forward or backward and Left and Right Arrow Keys turn.");
        llSay(0,"Shift + Right Arrow Key to speed up and Shift + Left Arrow Key to slow down.");
        
        llSay(0,"Almost ready... please wait for your dragon to arrive.");
        
    }
    

    
    control(key id, integer held, integer change){
        if(! gRun) 
            return;
        
        vector vel = llGetVel();
        vector speedvec = llGetVel() / llGetRot();
        gSpeed = llVecMag(vel);
        vector linear;
        
        
        if (gSpeed > 3) {
            if (dragonState != "flyingfast")
                dragonState = "flyingfast";
                NPCAnimate(gDragonFlyFastAnim,gDragonFlyFastAnimTimeout);
        } else if (gSpeed > .1) {
            if (dragonState != "flyingslow")
                dragonState = "flyingslow";
            NPCAnimate(gDragonFlySlowAnim,gDragonFlySlowAnimTimeout);
        } 
        
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
        
            powershift(gGear);
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <gGearPower,0,0>);
            gMoving=1;
             
        }
 
        if (held & CONTROL_BACK){
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <gReversePower,0,0>);
            llSetCameraParams([CAMERA_BEHINDNESS_ANGLE,-45.0]);
            llSetCameraParams([CAMERA_DISTANCE,8.0]);
            gTurnRatio = -2.0;
        } 
         if (~held & change & CONTROL_FWD){            
            if (gGear > 9){
                gGear = 3;
            }
        }
        
       
       showdata(llGetSubString((string)(gSpeed*2.23692912),0,2) + " mph");

 
        vector AngularMotor;
        AngularMotor.y = 0;  
        if (held & (CONTROL_ROT_RIGHT)){
            if (gGear<3){
                AngularMotor.x += ((gTurnRatio/gTurnMulti)*1);
                AngularMotor.z -= ((gTurnRatio*gTurnMulti)/1);
            }else if(gGear==3){
                AngularMotor.x += ((gTurnRatio/gTurnMulti)*1.5);
                AngularMotor.z -= ((gTurnRatio/gTurnMulti)/2);
            }else{
                AngularMotor.x += ((gTurnRatio/gTurnMulti)*2);
                AngularMotor.z -= ((gTurnRatio/gTurnMulti)/8);
            }
            
        }
 
        if (held & (CONTROL_ROT_LEFT)){
            if (gGear<3){
                AngularMotor.x -= ((gTurnRatio/gTurnMulti)*1);
                AngularMotor.z += ((gTurnRatio*gTurnMulti)/1);
            }else if (gGear==3){
                AngularMotor.x -= ((gTurnRatio/gTurnMulti)*1);
                AngularMotor.z += ((gTurnRatio/gTurnMulti)/2);
            }else{
                AngularMotor.x -= ((gTurnRatio/gTurnMulti)*1);
                AngularMotor.z += ((gTurnRatio/gTurnMulti)/8);
            }

            
         }
          // going up or stop going up
        if(held & CONTROL_UP) {
                if(gGear!=0){
                    linear = <gGearPower,0,gVerticalThrust*gGear>;
                    llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, linear);
                    AngularMotor.y -= 0.5; //((gTurnRatio/gTurnMulti)*1);
                }else{
                    linear =<0,0,gVerticalThrust>;
                    llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, linear);
                }
        } else if (change & CONTROL_UP) {
             if(gGear!=0){
                 linear =  <gGearPower,0,0>;
                llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION,linear);
                AngularMotor.y = 0;
            }else{
                linear = <0,0,0>;
                llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, linear);
            }
        }
       
        
        
        // going down or stop going down
        
        if(held & CONTROL_DOWN) {
            if(gGear!=0){
                linear = <gGearPower,0,-gVerticalThrust*gGear>;
                llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, linear);
                AngularMotor.y += 0.5; //((gTurnRatio/gTurnMulti)*1);
            }else{
                linear = <0,0,-gVerticalThrust>;
                llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, linear);
            }
        } else if (change & CONTROL_DOWN) {
             if(gGear!=0){
                 linear = <gGearPower,0,0>;
                llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, linear);
                AngularMotor.y = 0;
            }else{
                linear = <0,0,0>;
                llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <0,0,0>); 
            }
        }
        llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, AngularMotor);
            
        if (gDebug)
        {
            showdata((string) AngularMotor + ":" + (string) linear);
        }
    }
    touch_start(integer total_number){
        if (gAgent != NULL_KEY){
            menu(llDetectedKey(0), "\nDriver's Menu.", MENU_MAIN);
        }
    }

    listen(integer channel,string name,key id,string message){       
        DEBUG(message);
        if (channel == DragonChannel && (key) message == llGetKey())
        {
            
            if (gAgent != NULL_KEY)
                llSay(DragonChannelBack, (string) gAgent);
            return;
        } 
         
     
        llListenRemove(menu_handler);
        llSetTimerEvent(0);
        
        if (message == "Align"){
            llSay(0, "All lined up.  Go!");
            nearestpi();
        }
        else if (message == "Steam"){
            llMessageLinked(LINK_SET,1, "steam","");
            Steam();
        }
        else if (message == "Flame"){
            llMessageLinked(LINK_SET,1, "flame","");
            Flame();
        }
        else if (message == "Growl"){
            llMessageLinked(LINK_SET,1, "flame","");
            Growl();
        }
        else if (message == "Help"){
            llWhisper(0,"Hover Mode: Page UP and Page Down Keys controls elevation, Up and Down Arrow Keys to move forward or backward and finally Left and Right Arrow Keys to spin left or right.");
            llWhisper(0,"Fly Mode: UP and Page Down Keys controls elevation, Up and Down Arrow Keys to move forward or backward and finally Left and Right Arrow Keys to roll left or right.");
            llWhisper(0,"Speed: Shift + Right Arrow Key to speed up and Shift + Left Arrow Key to slow down.");
        }
        else if (message == "Remove NPC"){
            osNpcRemove(llGetObjectDesc());
        }
    }

    timer(){
        llListenRemove(menu_handler);
        llSetTimerEvent(0.0);

        if (dragonState == "flyingslow")
        {
            NPCAnimate(gDragonFlySlowAnim,gDragonFlySlowAnimTimeout);
            
        } else if (dragonState == "flyingfast") {
            NPCAnimate(gDragonFlyFastAnim,gDragonFlyFastAnimTimeout );
        } else if (dragonState == "sitting"){
            float rand = llFrand(5);
            if (rand < 2.5)
                NPCAnimate(gDragonSitAnim1,gDragonSitAnim1Timeout);
            else
                NPCAnimate(gDragonSitAnim2,gDragonSitAnim2Timeout);
        }
    }
}



