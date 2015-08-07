// :CATEGORY:Vehicle
// :NAME:OpenSim Boat
// :AUTHOR:Sherrie Melody
// :KEYWORDS:
// :CREATED:2014-02-10
// :EDITED:2014-02-08 08:13:30
// :ID:1020
// :NUM:1584
// :REV:1
// :WORLD:OpenSim
// :DESCRIPTION:
// Full-perm OpenSim boat with tunable parameters
// :CODE:
// Gotten from MineThere Always.
// It came from a full-perm boat that is given away on Osgrid, on Wright Plaza.
// The original is a really great script, except it had a few things hard coded throughout the script.
// I modified it slightly to allow these things to be enabled/disabled and configured in variables toward the top of the script.
// See my comments at the top of the script. I've tested the modified script and it works nicely.

    //############################ OpenSim - Physical Boat Script v2.2 ###############################

    //Possibly authored by Nebadon from OsGrid, not sure. The boat the script originated in was
    // originally given out on OsGrid, on Wright Plaza, full-perms, no limitations
    //11/4/2013 Sherrie Melody modified slightly so that a couple of things are configurable, instead of hard-coded:
    //        1. whether to play the motor sound. See instructions under GLOBAL VARIABLES FOR MOTOR SOUND
    //        2. whether to enable particle-system jet spray prims, and if so, the names of those prims (4)
    //                 See instructions under GLOBAL VARIABLES FOR THE JET SPRAY PRIMS           
    //        3. whether to enable monitor prim, and if so, the prim name
    //                 See instructions under GLOBAL VARIABLES FOR MONITOR PRIM
    //---------------------- Set Aktion-Range here (Simborder-crossing Protection) -------------------

    integer EN = 1; // Switcher:  EN = 1 (enables Protection),  EN = 0 (disables Protection)
    integer RX = 2; // how many Regions in X-Direction (West  to East)  default for single Region is 1
    integer RY = 2; // how many Regions in Y-Direction (South to North) default for single Region is 1
    integer VL =10; // Minimum Distance to a Simborder (is one length of the Vehicle in Meters)
    float   HH =21; // Hoverhigh of the Vehicle in Meters ( default is Waterhigh + 1 Meter)

    //------------------------------------------------------------------------------------------------
    // GLOBAL VARIABLES FOR MOTOR SOUND
    integer SOUND_ENABLED = 0;//if set to one, plays sound named below
    string MOTOR_SOUND = "Motor-05";         // motor sound (sm added variable for the name)

    // GLOBAL VARIABLES FOR THE JET SPRAY PRIMS
    // There are 4, front-left, front-right, back-left, back-right.
    // In the original boat, these were placed toward the back of the boat, on the bottom, two at the back on either side
    // of the boat, and two more about 2 meters forward of the back prims. 
    // The script rotates the two front prims so that their top faces forward.
    // The script rotates the two rear prims so that their top faces backward.
    // the HE_texture variable (further down) is used for the water spray texture.
    integer JS_ENABLED = 0;//if 1, jetspray particle system enabled, 0 to disable
    string JS_FR = "jet spray front-right";
    string JS_FL = "jet spray front-left";
    string JS_BR = "jet spray back-right";
    string JS_BL = "jet spray back-left";
    integer JS_FRL=0;//don't touch, set by script, link number for JS_FR
    integer JS_FLL=0;//don't touch, set by script, link number for JS_FL
    integer JS_BRL=0;//don't touch, set by script, link number for JS_BR
    integer JS_BLL=0;//don't touch, set by script, link number for JS_BL

    // GLOBAL VARIABLES FOR MONITOR PRIM
    // There is a prim that receives link messages from the boat:
    //    "on-1" when the pilot sits
    //    "[speed value] Km/h" every 0.2 seconds after pilot sits
    //    "Standby" when the pilot gets up
    // If you want to script a prim that does things in response to
    // these messages, enable monitor and set the name of that prim below
    integer MON_ENABLED = 0;// if one, script will send messages to prim named below
    string MON_NAME = "monitor";//name of prim to receive link messages from this script
    integer MON_NUM=0;//set by script, monitor link number
    
    // GLOBAL VARIABLES FOR PILOT SEATING AND CAMERA VIEWPOINT
    //
    string PILOT_ANIM = "cartdriver3";       // current Sit-Animation (must be in Vehicle Content)
    vector SIT_POSITION =<0.0, -2.7, 0.63> ; // position of pilot on sit prim
    vector SIT_ROTATION = <0, 0, 90>;        // rotation of pilot on sit prim
    integer Private = 0;                     // 1= Owner Only Pilot. 0= Anyone can be Pilot.
    float CAM_ZOOM  = 12.0;                  // How far back the pilot's camera follows
    float CAM_ANGLE = 12.0;                  // Vertical angle pilot's camera follows
    float CZ;
    //
    // GLOBAL VARIABLES FOR TEXT & DIALOG
    //
    string sit_message = "Ride !";
    string not_owner_message = "Sorry. You are not the owner.";
    string TITLE="";
    string StartUpText = "  Use Arrows:    Fwd/Rew,  Left/Right,  PageUp/Down";
    //
    // GLOBAL VARIABLES FOR VEHICLE MOTION
    //
    integer hps = 4;                         // Minimum horizontal Power-Rate
    float hpm = 32;                          // Maximum horizontal Power-Rate
    float hpr = 4;                           // Power change Factor
    float hp;
    float hp_old;
    float vmin = 0.75;                       // minimum Hoverhigh over Water
    float Curveangl = 7.5;                   // Angle of Vihicle at Curves
    float angz = 0.5;                        // Sharpness of turns/curves (practical values 0.5 to 1.0)
    float angz_low = 0.2;
    float angz_high = 0.5;
    //
    //  GLOBAL VARIABLES FOR PARTICLES
    //
    vector  HE_start_color = <1.0, 1.0, 1.0>;
    vector  HE_end_color;
    float   HE_start_alpha = 1.0;
    float   HE_end_alpha;
    vector  HE_start_scale;
    vector  HE_end_scale;
    string  HE_texture      = "Light Flare";
    float   HE_source_max_age = 0.0;
    float   HE_particle_max_age;
    float   HE_burst_rate = 0.0;
    integer HE_burst_particle_count;
    float   HE_burst_radius = 0.25;
    float   HE_angle_begin = 0;
    float   HE_angle_end = 20 * DEG_TO_RAD;
    float   HE_speed_min;
    float   HE_speed_max;
    //------------------------------------
    integer H_dir = 1; // Indicator for Vihicle Horizontal moving Back = -1 or FWD = 1 or stop = 0
    float HS;
    integer HPC;
    //
    //  GENEREL GLOBAL VARIABLES  (DO NOT CHANGE !!!)
    //
    float ALTITUDE;
    vector ANGULAR_MOTOR;
    integer RUN;
    key AVATAR;
    float SPEED;
    float OFFSET;
    integer HELD;
    integer P;
    integer H_Gear;
    float SB;
    float HGfac = 2.0;
    float PXY_S;
    integer ME = 1;
    integer dir;                  // Indicator for Vehicle Direction FWD/BACK used at XYrotation
    float HF = DEG_TO_RAD * 90;
    float HB = DEG_TO_RAD * 270;
    float L2;

    //----------------------------------- Subroutines ----------------------------------------
    getJSprims() {
        integer numPrims = llGetNumberOfPrims();
        integer i;
        for(i=1;i<=numPrims;i++) {
            if(llGetLinkName(i) == JS_FR && JS_ENABLED == 1) {
                JS_FRL = i;
            }
            else if(llGetLinkName(i) == JS_FL && JS_ENABLED == 1) {
                JS_FLL = i;
            }
            else if(llGetLinkName(i) == JS_BR && JS_ENABLED == 1) {
                JS_BRL = i;
            }
            else if(llGetLinkName(i) == JS_BL && JS_ENABLED == 1) {
                JS_BLL = i;
            }
            else if(llGetLinkName(i) == MON_NAME && MON_ENABLED == 1) {
                MON_NUM = i;
            }
        }           
    }
    
    
    MOVE_ENABLE_FWD()
    {
     vector R_Pos = llGetPos(); vector R_Rot = llRot2Euler(llGetRot()); float AZ = R_Rot.z * RAD_TO_DEG;
     float sin = llFabs(llSin(R_Rot.z)); float cos = llFabs(llCos(R_Rot.z));
     
     float PXL = VL + PXY_S * sin; float PXH = RX * 256 - (VL + PXY_S * sin);
     float PYL = VL + PXY_S * cos; float PYH = RY * 256 - (VL + PXY_S * cos);
     
     if((AZ >= 0) && (AZ < 90))
     {
      if((R_Pos.x <= PXL) || (R_Pos.y >= PYH)) {ME = 0;}
     }
     
     if(AZ >= 90)
     {
      if((R_Pos.x <= PXL) || (R_Pos.y <= PYL)) {ME = 0;}
     }

     if((AZ < 0) && (AZ > -90))
     {
      if((R_Pos.x >= PXH) || (R_Pos.y >= PYH)) {ME = 0;}
     }
     
     if(AZ <= -90)
     {
      if((R_Pos.x >= PXH) || (R_Pos.y <= PYL)) {ME = 0;}
     }
     
    }


    MOVE_ENABLE_REW()
    {
     vector R_Pos = llGetPos(); vector R_Rot = llRot2Euler(llGetRot()); float AZ = R_Rot.z * RAD_TO_DEG;
     float sin = llFabs(llSin(R_Rot.z)); float cos = llFabs(llCos(R_Rot.z));
     
     float PXL = VL + PXY_S * sin; float PXH = RX * 256 - (VL + PXY_S * sin);
     float PYL = VL + PXY_S * cos; float PYH = RY * 256 - (VL + PXY_S * cos);
     
     if((AZ >= 0) && (AZ < 90))
     {
      if((R_Pos.x >= PXH) || (R_Pos.y <= PYL)) {ME = 0;}
     }
     
     if(AZ >= 90)
     {
      if((R_Pos.x >= PXH) || (R_Pos.y >= PYH)) {ME = 0;}
     }

     if((AZ < 0) && (AZ > -90))
     {
      if((R_Pos.x <= PXL) || (R_Pos.y <= PYL)) {ME = 0;}
     }
     
     if(AZ <= -90)
     {
      if((R_Pos.x <= PXL) || (R_Pos.y >= PYH)) {ME = 0;}
     }
     
    }

     
    SetParticle_HL()
    {
        llLinkParticleSystem(JS_BLL,[
     
            //System Behaviour
            PSYS_PART_FLAGS, PSYS_PART_EMISSIVE_MASK
                             | PSYS_PART_FOLLOW_SRC_MASK
                             | PSYS_PART_FOLLOW_VELOCITY_MASK
                             | PSYS_PART_INTERP_COLOR_MASK
                             | PSYS_PART_INTERP_SCALE_MASK
                             ,
     
            //System Presentation
            PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_ANGLE_CONE,
            PSYS_SRC_BURST_RADIUS, HE_burst_radius,
            PSYS_SRC_ANGLE_BEGIN,  HE_angle_begin,
            PSYS_SRC_ANGLE_END,    HE_angle_end,
     
            //Particle appearance
            PSYS_PART_START_COLOR, HE_start_color,
            PSYS_PART_END_COLOR,   HE_end_color,
            PSYS_PART_START_ALPHA, HE_start_alpha,
            PSYS_PART_END_ALPHA,   HE_end_alpha,
            PSYS_PART_START_SCALE, HE_start_scale,
            PSYS_PART_END_SCALE,   HE_end_scale,
            PSYS_SRC_TEXTURE,      HE_texture,
     
            //Particle Flow
            PSYS_SRC_MAX_AGE,          HE_source_max_age,
            PSYS_PART_MAX_AGE,         HE_particle_max_age,
            PSYS_SRC_BURST_RATE,       HE_burst_rate,
            PSYS_SRC_BURST_PART_COUNT, HE_burst_particle_count,
     
            //Particle Motion
            PSYS_SRC_BURST_SPEED_MIN, HE_speed_min,
            PSYS_SRC_BURST_SPEED_MAX, HE_speed_max
     
            ]);
    }

    SetParticle_HR()
    {
        llLinkParticleSystem(JS_BRL,[
     
            //System Behaviour
            PSYS_PART_FLAGS, PSYS_PART_EMISSIVE_MASK
                             | PSYS_PART_FOLLOW_SRC_MASK
                             | PSYS_PART_FOLLOW_VELOCITY_MASK
                             | PSYS_PART_INTERP_COLOR_MASK
                             | PSYS_PART_INTERP_SCALE_MASK
                             ,

            //System Presentation
            PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_ANGLE_CONE,
            PSYS_SRC_BURST_RADIUS, HE_burst_radius,
            PSYS_SRC_ANGLE_BEGIN,  HE_angle_begin,
            PSYS_SRC_ANGLE_END,    HE_angle_end,
     
            //Particle appearance
            PSYS_PART_START_COLOR, HE_start_color,
            PSYS_PART_END_COLOR,   HE_end_color,
            PSYS_PART_START_ALPHA, HE_start_alpha,
            PSYS_PART_END_ALPHA,   HE_end_alpha,
            PSYS_PART_START_SCALE, HE_start_scale,
            PSYS_PART_END_SCALE,   HE_end_scale,
            PSYS_SRC_TEXTURE,      HE_texture,
     
            //Particle Flow
            PSYS_SRC_MAX_AGE,          HE_source_max_age,
            PSYS_PART_MAX_AGE,         HE_particle_max_age,
            PSYS_SRC_BURST_RATE,       HE_burst_rate,
            PSYS_SRC_BURST_PART_COUNT, HE_burst_particle_count,
     
            //Particle Motion
            PSYS_SRC_BURST_SPEED_MIN, HE_speed_min,
            PSYS_SRC_BURST_SPEED_MAX, HE_speed_max
     
            ]);
    }


    SetParticle_HFL()
    {
        llLinkParticleSystem(JS_FLL,[
     
            //System Behaviour
            PSYS_PART_FLAGS, PSYS_PART_EMISSIVE_MASK
                             | PSYS_PART_FOLLOW_SRC_MASK
                             | PSYS_PART_FOLLOW_VELOCITY_MASK
                             | PSYS_PART_INTERP_COLOR_MASK
                             | PSYS_PART_INTERP_SCALE_MASK
                             ,
     
            //System Presentation
            PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_ANGLE_CONE,
            PSYS_SRC_BURST_RADIUS, HE_burst_radius,
            PSYS_SRC_ANGLE_BEGIN,  HE_angle_begin,
            PSYS_SRC_ANGLE_END,    HE_angle_end,
     
            //Particle appearance
            PSYS_PART_START_COLOR, HE_start_color,
            PSYS_PART_END_COLOR,   HE_end_color,
            PSYS_PART_START_ALPHA, HE_start_alpha,
            PSYS_PART_END_ALPHA,   HE_end_alpha,
            PSYS_PART_START_SCALE, HE_start_scale,
            PSYS_PART_END_SCALE,   HE_end_scale,
            PSYS_SRC_TEXTURE,      HE_texture,
     
            //Particle Flow
            PSYS_SRC_MAX_AGE,          HE_source_max_age,
            PSYS_PART_MAX_AGE,         HE_particle_max_age,
            PSYS_SRC_BURST_RATE,       HE_burst_rate,
            PSYS_SRC_BURST_PART_COUNT, HE_burst_particle_count,
     
            //Particle Motion
            PSYS_SRC_BURST_SPEED_MIN, HE_speed_min,
            PSYS_SRC_BURST_SPEED_MAX, HE_speed_max
     
            ]);
    }


    SetParticle_HFR()
    {
        llLinkParticleSystem(JS_FRL,[
     
            //System Behaviour
            PSYS_PART_FLAGS, PSYS_PART_EMISSIVE_MASK
                             | PSYS_PART_FOLLOW_SRC_MASK
                             | PSYS_PART_FOLLOW_VELOCITY_MASK
                             | PSYS_PART_INTERP_COLOR_MASK
                             | PSYS_PART_INTERP_SCALE_MASK
                             ,

            //System Presentation
            PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_ANGLE_CONE,
            PSYS_SRC_BURST_RADIUS, HE_burst_radius,
            PSYS_SRC_ANGLE_BEGIN,  HE_angle_begin,
            PSYS_SRC_ANGLE_END,    HE_angle_end,
     
            //Particle appearance
            PSYS_PART_START_COLOR, HE_start_color,
            PSYS_PART_END_COLOR,   HE_end_color,
            PSYS_PART_START_ALPHA, HE_start_alpha,
            PSYS_PART_END_ALPHA,   HE_end_alpha,
            PSYS_PART_START_SCALE, HE_start_scale,
            PSYS_PART_END_SCALE,   HE_end_scale,
            PSYS_SRC_TEXTURE,      HE_texture,
     
            //Particle Flow
            PSYS_SRC_MAX_AGE,          HE_source_max_age,
            PSYS_PART_MAX_AGE,         HE_particle_max_age,
            PSYS_SRC_BURST_RATE,       HE_burst_rate,
            PSYS_SRC_BURST_PART_COUNT, HE_burst_particle_count,
     
            //Particle Motion
            PSYS_SRC_BURST_SPEED_MIN, HE_speed_min,
            PSYS_SRC_BURST_SPEED_MAX, HE_speed_max
     
            ]);
    }


    SetPartVar_H0()
    {
     HE_end_color   = <1.0,1.0,1.0>;
     HE_end_alpha   = 1.0;
     HE_start_scale = <0.2, 0.2, 0.2>;
     HE_end_scale   = <0.3, 0.3, 0.3>;
     HE_particle_max_age     = 0.5;
     HE_burst_particle_count = 1;
     HE_speed_min    = 0.0;
     HE_speed_max    = 0.2;
    }


    SetPartVar_H1()
    {
     HE_end_color   = <1.0,1.0,1.0>;
     HE_end_alpha   = 0.0;
     HE_start_scale = <0.0, 0.0, 0.0>;
     HE_end_scale   = <0.7, 0.7, 0.7>;
     HE_particle_max_age     = 1.0;
     HE_burst_particle_count = 16 + HPC;
     HE_speed_min    = 0.5;
     HE_speed_max    = 0.5 + HS;
    }


    SETUP_CAMERA()
    {
        llSetCameraParams([
            CAMERA_ACTIVE, 1,                     // 1 is active, 0 is inactive
            CAMERA_BEHINDNESS_ANGLE, 0,           // (0 to 180) degrees
            CAMERA_BEHINDNESS_LAG, 0.0,           // (0 to 3) seconds
            CAMERA_DISTANCE, CZ,                  // ( 1 to 30) meters
            CAMERA_FOCUS_LAG, 0.0 ,               // (0 to 3) seconds
            CAMERA_FOCUS_LOCKED,FALSE,            // (FALSE)
            CAMERA_FOCUS_THRESHOLD, 0.0,          // (0 to 4) meters
            CAMERA_PITCH, CAM_ANGLE,              // (-45 to 80) degrees
            CAMERA_POSITION_LAG, 0.0,             // (0 to 3) seconds
            CAMERA_POSITION_LOCKED, FALSE,        // (TRUE or FALSE)
            CAMERA_POSITION_THRESHOLD, 0.0,       // (0 to 4) meters
            CAMERA_FOCUS_OFFSET, <0.0, 0.0, 0.5>  // <-10,-10,-10> to <10,10,10> meters
        ]);
    }


    SETUP_VEHICLE()
    {
            // Vehicle Type
            llSetVehicleType(VEHICLE_TYPE_BOAT);                                         // in use
           
            // Type Vector --------------------------------------------------------------
           
            // friction
            llSetVehicleVectorParam(VEHICLE_ANGULAR_FRICTION_TIMESCALE, <1.0, 1.0, 1.0>);// z in use
            llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <1.0, 1.0, 1.0>); // x,y in use
            // motor
            llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, <0, 0, 0>);         // in use
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <0, 0, 0>);          // in use
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_OFFSET, <0, 0, 0>);             // ???
           
            // Type Float -------------------------------------------------------
           
            // hover
            llSetVehicleFloatParam(VEHICLE_HOVER_HEIGHT, ALTITUDE);              // in use
            llSetVehicleFloatParam(VEHICLE_HOVER_EFFICIENCY, 1.0);               // ???
            llSetVehicleFloatParam(VEHICLE_HOVER_TIMESCALE, 1.0);                // ???
            llSetVehicleFloatParam(VEHICLE_BUOYANCY, 1.0);                       // ???
            // friction
            llSetVehicleFloatParam(VEHICLE_ANGULAR_FRICTION_TIMESCALE, 1.0);     // ???
            // motor
            llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_TIMESCALE, 0.1);         // in use
            llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 0.2);   // in use
            llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_TIMESCALE, 0.1);        // in use
            llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, 1.0);  // in use
            //deflection
            llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 1.0);   // ???
            llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 1.0);    // ???
            llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 1.0);  // ???
            llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, 1.0);   // ???
            // attraction
            llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, 1.0); // ???
            llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 1.0);  // ???
            // banking
            llSetVehicleFloatParam(VEHICLE_BANKING_EFFICIENCY, 1.0);             // ???
            llSetVehicleFloatParam(VEHICLE_BANKING_MIX, 1.0);                    // ???
            llSetVehicleFloatParam(VEHICLE_BANKING_TIMESCALE, 1.0);              // ???
    }

    //------------------------------------ Default Programm -----------------------------------------

    default
    {
        state_entry()
        {
         llSetStatus(STATUS_PHANTOM, FALSE);
         llSetLinkPrimitiveParams(LINK_ALL_OTHERS, [PRIM_PHANTOM,FALSE]);
         llSetStatus(STATUS_PHYSICS, FALSE);
         llSetLinkPrimitiveParams(LINK_ALL_OTHERS, [PRIM_PHYSICS,FALSE]);
         llSetSitText(sit_message);
         llSetText(TITLE, <0.5, 0.5, 1.0>, 1.0);
         llSitTarget(SIT_POSITION,llEuler2Rot(DEG_TO_RAD * SIT_ROTATION));
        }


       on_rez(integer rn)
        {
         llResetScript();
        }


    //----------------------------------- Changed Watcher ---------------------------------------------       
               
        changed(integer change)
        {
            if ((change & CHANGED_LINK) == CHANGED_LINK)
            {
                getJSprims();//gets jet-spray prim numbers if JS_ENABLED, and monitor prim if MON_ENABLED
                AVATAR = llAvatarOnSitTarget();
                if (AVATAR != NULL_KEY)
                {               
                    if( (AVATAR != llGetOwner()) & (Private == 1))
                    {
                        llSay(0, not_owner_message);
                        llUnSit(AVATAR);   
                    }
                    else
                    {
                     vector posv = llGetPos(); ALTITUDE = (posv.z - 20.00);
                     SETUP_VEHICLE(); llSleep(0.3);
                     llSetStatus(STATUS_PHANTOM, FALSE);
                     llSetLinkPrimitiveParams(LINK_ALL_OTHERS, [PRIM_PHANTOM,FALSE]);
                     llSetStatus(STATUS_PHYSICS, TRUE);
                     llSetLinkPrimitiveParams(LINK_ALL_OTHERS, [PRIM_PHYSICS, TRUE]);
                     llRequestPermissions(AVATAR,
                     PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS | PERMISSION_CONTROL_CAMERA);
                     
                     RUN = 1; OFFSET=0; L2 = llLog(2); hp = hps; H_Gear = 1;
                     PXY_S = HGfac * llPow(2, llLog(hps) / L2 - 2);
                     dir = 1; H_dir = 0; angz = angz_high; P = 1;
                     HS = llLog(hp) / L2 - 1; HPC = llRound(2 * llPow(2, HS));
                     llStartAnimation(PILOT_ANIM);
                     llSay(0, StartUpText);
                     llSetText("", <0.5, 0.5, 1.0>, 1.0);
                    if(MON_ENABLED == 1) { llMessageLinked(MON_NUM, 0, "on-1", "");}
                     CZ  = 4.0; SETUP_CAMERA(); llSleep(3.5); CZ = CAM_ZOOM; SETUP_CAMERA();
                     llSetTimerEvent(0.2);
                       if(JS_ENABLED == 1) {
                        llSetLinkPrimitiveParamsFast(JS_BLL, [PRIM_ROT_LOCAL, llEuler2Rot(<HB, 0, 0>)]); llSleep(0.1);
                        llSetLinkPrimitiveParamsFast(JS_BLL, [PRIM_ROT_LOCAL, llEuler2Rot(<HF, 0, 0>)]);
                        llSetLinkPrimitiveParamsFast(JS_BRL, [PRIM_ROT_LOCAL, llEuler2Rot(<HB, 0, 0>)]); llSleep(0.1);
                        llSetLinkPrimitiveParamsFast(JS_BRL, [PRIM_ROT_LOCAL, llEuler2Rot(<HF, 0, 0>)]);
                        llSetLinkPrimitiveParamsFast(JS_FLL, [PRIM_ROT_LOCAL, llEuler2Rot(<HF, 0, 0>)]); llSleep(0.1);
                        llSetLinkPrimitiveParamsFast(JS_FLL, [PRIM_ROT_LOCAL, llEuler2Rot(<HB, 0, 0>)]);
                        llSetLinkPrimitiveParamsFast(JS_FRL, [PRIM_ROT_LOCAL, llEuler2Rot(<HF, 0, 0>)]); llSleep(0.1);
                        llSetLinkPrimitiveParamsFast(JS_FRL, [PRIM_ROT_LOCAL, llEuler2Rot(<HB, 0, 0>)]);
                        SetPartVar_H0();
                        SetParticle_HL(); SetParticle_HR();
                        SetParticle_HFL(); SetParticle_HFR();
                      }
                    }
                }
                else
                {
                    RUN = 0;
                    llReleaseControls();
                    llStopAnimation(PILOT_ANIM);
                    if(MON_ENABLED == 1) {llMessageLinked(MON_NUM, 0, "Standby", "");}
                    llSetText(TITLE, <0.5, 0.5, 1.0>, 1.0);
                    llSetStatus(STATUS_PHYSICS, FALSE);
                    llSetLinkPrimitiveParams(LINK_ALL_OTHERS, [PRIM_PHYSICS, FALSE]);
                    llSetVehicleType(VEHICLE_TYPE_NONE);
                    vector pos = llGetPos(); llSetPos(<pos.x, pos.y, HH>);
                    llSetTimerEvent((float)FALSE);
                    if(JS_ENABLED==1) {
                        llLinkParticleSystem(JS_BLL,[]); llLinkParticleSystem(JS_BRL,[]);
                        llLinkParticleSystem(JS_FLL,[]); llLinkParticleSystem(JS_FRL,[]);
                    }
                }
            }
        }
       
    //------------------------------------- Runtime declaration --------------------------------

        run_time_permissions(integer perm)
        {
         if (perm)
         {
          llTakeControls(CONTROL_FWD | CONTROL_BACK |
                         CONTROL_DOWN | CONTROL_UP |
                         CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT | CONTROL_RIGHT, TRUE, FALSE);
         }
        }
       

    //---------------------------------------- Speed - metering -------------------------------------
       
    timer()
    {
        if(RUN == 1)
        {
         SPEED = llVecMag(llGetVel());
         string SpeedText = ((string)llRound(SPEED * 1.852) + " Km/h");
        if(MON_ENABLED == 1) {llMessageLinked(MON_NUM, 0, SpeedText, "");}
        }
    }

     
    //-------------------------------------- Keybord Control --------------------------------------------
       
        control(key id, integer level, integer edge)
        {
            if(RUN == 0) {return;}
           
    //------------------ Parking Mode on/off

            if(level & CONTROL_RIGHT)
            {
             if(angz == angz_low)
             {
              angz = angz_high; hp = H_Gear * hpr; P = 0;
              HS = llLog(hp) / L2 - 1; HPC = llRound(2 * llPow(2, HS));
              llWhisper(0, "Driving !");
             }
           
             if((angz == angz_high) && (P == 1))
             {
              angz = angz_low; hp = 4;
              HS = llLog(hp) / L2 - 1; HPC = llRound(2 * llPow(2, HS));
              llWhisper(0, "Parking !");
             }
             P = 1;           
            }

    //------------------- Speed change

            if (level & CONTROL_UP)
            {
             H_Gear += 1; hp = H_Gear * hpr;
             if(hp >= hpm) {hp = hpm; H_Gear = 8;}
             PXY_S = HGfac * llPow(2, llLog(hp) / L2 - 2);
             HS = llLog(hp) / L2 - 1; HPC = llRound(2 * llPow(2, HS));
             llWhisper(0, " Speed-Gear: " + (string)H_Gear );
            }
           
            if (level & CONTROL_DOWN)
            {
             H_Gear -= 1; hp = H_Gear * hpr;
             if(hp < hps) {hp = hps; H_Gear = 1;}
             PXY_S = HGfac * llPow(2, llLog(hp) / L2 - 2);
             HS = llLog(hp) / L2 - 1; HPC = llRound(2 * llPow(2, HS));
             llWhisper(0, " Speed-Gear: " + (string)H_Gear );
            }
           
    //------------------ move Fwd/Back

            if(level & CONTROL_FWD)
            {
             if(EN == 1) {MOVE_ENABLE_FWD();}
           
               if(ME == 1)
               {
                H_dir = 1; dir = 1;
                llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <0, hp,0>);
               }
            }
           
            if(level & CONTROL_BACK)
            {
             if(EN == 1) {MOVE_ENABLE_REW();}
           
               if(ME == 1)
               {
                H_dir = -1; dir = -1;
                llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <0,-hp,0>);
               }
            } 

    //------------------ turn Right/Left

            if(level & CONTROL_ROT_RIGHT)
            {
             ANGULAR_MOTOR = <0, 0, -(angz + SPEED / (4 * hp))>;
             OFFSET = Curveangl; HELD=1;
             llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, ANGULAR_MOTOR);
             ANGULAR_MOTOR = <0, 0, 0>;
            }
                           
            if(level & CONTROL_ROT_LEFT)
            {
             ANGULAR_MOTOR = <0, 0, (angz + SPEED / (4 * hp))>;
             OFFSET = -Curveangl; HELD=1;
             llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, ANGULAR_MOTOR);
             ANGULAR_MOTOR = <0, 0, 0>;
            }

    //--------------------------------------------------------------------------------------------------

            if(HELD==0) {OFFSET=0;}
            vector rot = llRot2Euler(llGetRot());
            llSetRot(llEuler2Rot(<0, DEG_TO_RAD * OFFSET * dir, 0>)* llEuler2Rot(<0 ,0, rot.z>));
           
            if(H_dir == 0)
            {
             if(OFFSET == 0 && JS_ENABLED==1)
             {
              SetPartVar_H0(); SetParticle_HL(); SetParticle_HR(); SetParticle_HFL(); SetParticle_HFR();
             }
             
             if(OFFSET < 0)
             {
              hp_old = hp; hp = hps;
              HS = llLog(hp) / L2 - 1; HPC = llRound(2 * llPow(2, HS));
              if(JS_ENABLED==1) {
                SetPartVar_H0(); SetParticle_HL(); SetParticle_HFR();
                SetPartVar_H1(); SetParticle_HFL(); SetParticle_HR();
              }
              hp = hp_old;
              HS = llLog(hp) / L2 - 1; HPC = llRound(2 * llPow(2, HS));
             }
             
             if(OFFSET > 0)
             {
              hp_old = hp; hp = hps;
              HS = llLog(hp) / L2 - 1; HPC = llRound(2 * llPow(2, HS));
              if(JS_ENABLED==1) {
                SetPartVar_H1(); SetParticle_HL(); SetParticle_HFR();
                SetPartVar_H0(); SetParticle_HFL(); SetParticle_HR();
              }
              hp = hp_old;
              HS = llLog(hp) / L2 - 1; HPC = llRound(2 * llPow(2, HS));
             }
               
            }
           
            if(H_dir == 1 && JS_ENABLED==1)
            {
             SetPartVar_H1(); SetParticle_HL(); SetParticle_HR();
             SetPartVar_H0(); SetParticle_HFL(); SetParticle_HFR();
            }
           
            if(H_dir == -1 && JS_ENABLED==1)
            {
             SetPartVar_H0(); SetParticle_HL(); SetParticle_HR();
             SetPartVar_H1(); SetParticle_HFL(); SetParticle_HFR();
            }
           
            if((H_dir != 0) || (OFFSET != 0)) {    if(SOUND_ENABLED == 1) {llPlaySound(MOTOR_SOUND, 1.0); } }
           
            dir = 1; HELD = 0; ME = 1; H_dir = 0;
           

        } // End Keybord Control
       
    }// End Default
