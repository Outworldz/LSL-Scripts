// :CATEGORY:Vehicles
// :NAME:A_flight_script_with_more_realistic
// :AUTHOR:Fritz Kakapo
// :CREATED:2010-12-28 21:16:02.003
// :EDITED:2013-09-18 15:38:46
// :ID:8
// :NUM:12
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// My more elaborate airplane and bird scripts are also available free in world, but I suggest that this is the place to start.  This scrpt is public domain "Copyleft!".  My others are distributed under GNU Free Public Licenses, so only the ideas and short sections of script should be used in proprietary flight scripts, not long sections verbatim.  Direct derivatives of the others should remain open source.// // I am anxious for others to use my new methods.  I realize that most sl residents don't have strong backgrounds in physical analysis and modeling, numerical methods and real time programming, so I have tried to make this a script that others will be able to use as a starting place and adapt to their own requirements.  One can look at the other scripts when ready to add more details and  features.
// :CODE:
//====================================================================================================================================
// PIETENPOL AIR CAMPER FLIGHT SCRIPT MK1, with F. t. C.'s extensive changes
//
// Portions of this script are influenced by or based on work from Alex Linden, Cubey Terra, Eoin Widget, Kerian Bunin, Ronald Krugman
// Script by Ezekiel Bailly 2005-2008
// New, more physical, flight behavior and other changes by Fritz t. Cat (Fritz Kakapo), April--May 2010.
// Copyleft!
//--------------------------------------------------------------------------------------------------------------------------------------
//              Some of Fritz's changes:
//      Making it act like an airplane, maybe even like a Model A engined Air Camper,
//          but keeping it simple and as compatible as I can with what other sl flight scripters are doing.
//      Explaining how this new script relates to the simplified physics of airplanes.
//      Separated aileron and rudder controls.  (The variables controlling the prim angles were already separate.)
//      Some improvements in response time.
//      Pulling loose wires.  When I was a student, they used to send me up to trace signal cables and remove them if open.
//      Trying to make it easier for the next person (or robot?) who works on it.
//      Took out HUD control, for simplicity and efficiency. (Each listen puts a lot of load on the server, or used to at least.)
//      More concise, clearer and more efficient code.  Tables of if statements could be replaced by formulas, for example.
//      Formatting.  I prefer less blank lines, dashes instead.  More consistent and standard indenting.
//          Deleting long obsolete comments, better variable names.
//
//      Wikipedia says stall speed 35 mph, top 100 mph, rate of climb 500 ft/min (152 m/min).
//      It lists the Model as as 40 horsepower (30 kW), and the Camper loaded weight as 995 lb (452 kg).
//      Because of sl limitattions, I have modeled that at half speed.
//      The stall here is not realistic and is too slow, to keep it easy to fly and simple.
//          Too slow can be fixed by increasing LINEAR_FRICTION_TIMESCALE.z to decrease lift.
//          The stall is too gentle because of the approximation that the lift is proportional to the angle of incidence
//              times the square of the speed, which breaks down in a stall because of boundary layer separation.
//          It would be somewhat improved by making the linear friction increase (LINEAR_FRICTION_TIMESCALE decrease) with speed,
//              but this is a simple script, and it is easier to fly without that.
//
//  Come the revolution, there'll be no more flying level, just the same, with the wings vertical!
//  Come the revolution, airplanes will turn toward the low wing, even when up side down!
//======================================================================================================================================
//
//
//  *AC control flags that we set later (It won't do logic in the initialization of variables.)
integer gAngularControls;
// *AC  we may keep track of angular history for more responsive turns
integer gOldAngularLevel;
// Landing Gear Weight on Wheels-Collision Integer
integer onground =  TRUE;
// THROTTLE (SPEED) Sensitive Declarations
// Thrust variables:
// thrust = forward * thrust_multiplier
// Edit the maxThrottle and thrustMultiplier to determine max speed.
integer forward =  0; // this changes when pilot uses throttle controls
integer maxThrottle = 5; // Number of "clicks" in throttle control. Arbitrary, really.
float thrustMultiplier = 11.; // Amount thrust increases per click.
//
// Lift and speed
//float cruiseSpeed = 19.0; // knots, speed at which plane achieves full lift, knots!
float speed =  0.;      // speed in m/s
float requested_timer_interval = 0.5;  // timer call requested rate, it can be much slower
integer sit = FALSE;    // pilot sitting
integer ignition = FALSE;   // engine running, object physical
//
// Control Surface Motion Declarations
string last_aileron_direction;
string cur_aileron_direction;
//
string last_elevator_direction;
string cur_elevator_direction;
string last_rudder_direction;
string cur_rudder_direction;
//
// CAMERA DECLARATIONS
list drive_cam =
[
        CAMERA_ACTIVE, TRUE,
        CAMERA_BEHINDNESS_ANGLE, 0.0,
        CAMERA_BEHINDNESS_LAG, 0.6,
        CAMERA_DISTANCE, 10.0,//3.0,
        CAMERA_PITCH, 10.0,
        // CAMERA_FOCUS,
        CAMERA_FOCUS_LAG, 0.05,
        CAMERA_FOCUS_LOCKED, FALSE,
        CAMERA_FOCUS_THRESHOLD, 0.0,
        // CAMERA_POSITION,
        CAMERA_POSITION_LAG, 0.3,
        CAMERA_POSITION_LOCKED, FALSE,
        CAMERA_POSITION_THRESHOLD, 0.0,
        //
        CAMERA_FOCUS_OFFSET,<0,0,1>//<0,0,1>
];
integer camon = FALSE;
integer camPermed;
//
key pilot =  NULL_KEY;
vector angular_motor;       //
vector global_vel;             // velocity in the sim coordinate system
vector local_vel;   // velocity in the coordinate system pointed as the airplane
integer thrustPercent =  0;
float ANGULAR_MOTOR_TIMESCALE_0 =  4.;          // strength of angular motor and angular damping
float VERTICAL_ATTRACTION_TIMESCALE_0 =  17.;
//--------------------------------------------------------------------------------------------------------------------------
integer HUDon =  TRUE;  //"Heads Up Display" variables
string HUDtext =  "";
vector HUDcolor;
//==========================================================================================================================
//
init()
{
    llListen(0, "", llGetOwner(), "" );
    //
    llSetCameraEyeOffset( < -12, 0., 3.5 > ); // Position of camera, relative to parent.
    llSetCameraAtOffset( <0, 0, 1.9 > );   // Point to look at, relative to parent.
    //
    llSetSitText( "AirCamper" ); // Text that appears in pie menu when you sit
    //
    llCollisionSound( "", 0.0 ); // Remove the annoying thump sound from collisions 
    //
    //SET VEHICLE PARAMETERS -- See www.secondlife.com/badgeo for an explanation
    llSetVehicleType( VEHICLE_TYPE_AIRPLANE );
    //
    // angular deflection, fin and rudder
    llSetVehicleFloatParam( VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 0.3 );
    llSetVehicleFloatParam( VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, 1.0 );
    //
    // linear deflection
    llSetVehicleFloatParam( VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 0. ); // fuselage lift, both pitch and yaw cause lift
    llSetVehicleFloatParam( VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 1000. ); // but we use LINEAR_FRICTION instead.
    //
    // angular friction
    llSetVehicleVectorParam( VEHICLE_ANGULAR_FRICTION_TIMESCALE, < 1.5, 3., 6. > );  // Caused by drag of extremities.
    //
    // linear friction
    llSetVehicleVectorParam( VEHICLE_LINEAR_FRICTION_TIMESCALE, < 37., 9., 0.15 > );
    //  This is the all-important trick to get the physics engine to handle the wing lift.
    //  The x and y components contribute to parasite drag and to fuselage lift.
    //  I have a note card explaining how the dependence of both lift and drag on pitch angle
    //      are accurately and efficiently modeled by this parameter.
    //  (To get a realistic depenence of lift and drag on speed, this parameter should decrease with speed.)
    //
    llSetVehicleVectorParam( VEHICLE_LINEAR_MOTOR_DIRECTION, <0, 0, 0> );   // Start with the Model A off.
    //
    llSetVehicleFloatParam( VEHICLE_LINEAR_MOTOR_TIMESCALE, 24. );      // loose control to feel like air
    llSetVehicleFloatParam( VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 10. );     // 20 times the timer interval.
    //  If this is too long, it gets lost between sims more often.  If it is too short, it falls in busy sims.
    //
    // angular motor
    llSetVehicleVectorParam( VEHICLE_ANGULAR_MOTOR_DIRECTION, <0, 0, 0> );  // control surfaces
    //
    llSetVehicleFloatParam( VEHICLE_ANGULAR_MOTOR_TIMESCALE, ANGULAR_MOTOR_TIMESCALE_0/5. );   // strength of " and angular damping
    //
    llSetVehicleFloatParam( VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, 3. );    // can be refreshed in timer or not
    //
    // hover
    llSetVehicleFloatParam( VEHICLE_HOVER_HEIGHT, 0. ); // useful for sea planes
    llSetVehicleFloatParam( VEHICLE_HOVER_EFFICIENCY, 0. ); // or for taking off from bare ground
    llSetVehicleFloatParam( VEHICLE_HOVER_TIMESCALE, 1000. );
    //
    // vertical attractor
    //  This tends to keep the airplane right side up.
    //  More technically, it gives it dynamic stability against spiral dive.
    //  In rl airplanes, this stability is provided largely by dihedral and by
    //      the vertical distance between the aerodynamic center and the center of gravity.
    //  This vertical attractor is less realistic but simpler than the dihedral approximation I use in Li'l Stinker.
    llSetVehicleFloatParam( VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY,  0.1 );
    llSetVehicleFloatParam( VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, VERTICAL_ATTRACTION_TIMESCALE_0 );
    //  The /10. is to fix leaning over on ground, probably caused by the lack of a good sit animation.
    //
    // banking      I don't know much what this does yet, so I am not using it.
    //      Used in a straightforward way, it is partly responsible for the
    //  un-airplanelike behavior of other sl airplanes.
    //  It was obviously not introduced with airplanes in mind (at least not in a rational mind).
    //  (I tried reversing it when up side down, but did not understand the result.)
    llSetVehicleFloatParam( VEHICLE_BANKING_EFFICIENCY, 0. );
    llSetVehicleFloatParam( VEHICLE_BANKING_TIMESCALE, 1000. );
    //
    //  Falls half as fast, as though the space and speed were twice as big,
    //      to deal with the small size of sims and the slowness of handoffs between sims.
    llSetVehicleFloatParam( VEHICLE_BUOYANCY, 0.5 );    // This and must be a constant (for any flight mode).
    //
    // default rotation of local frame
    llSetVehicleRotationParam( VEHICLE_REFERENCE_FRAME, <0,0,0,1> );    // A noop, I think.
    //
    // remove these flags
    llRemoveVehicleFlags(   VEHICLE_FLAG_NO_DEFLECTION_UP
                          | VEHICLE_FLAG_HOVER_WATER_ONLY
                          | VEHICLE_FLAG_HOVER_TERRAIN_ONLY
                          | VEHICLE_FLAG_HOVER_GLOBAL_HEIGHT
                          | VEHICLE_FLAG_HOVER_UP_ONLY
                          | VEHICLE_FLAG_LIMIT_MOTOR_UP
                          | VEHICLE_FLAG_CAMERA_DECOUPLED);
    //-----------------------------------------------------------------------------------------------------------------
    //
    gAngularControls = CONTROL_RIGHT | CONTROL_LEFT | CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT | CONTROL_BACK | CONTROL_FWD;
    //
    refreshHUD();
    //
    llSay(0, "Cogito ergo sum." );  // "I think therefore I am.", Descartes.  Variant on "Hello world!"
    //
}   //  End init.
//
//-----------------------------------------------------------------------------------------------------------------------------------
//
refreshHUD()        // from the VICE test airplane
{
    if ( !sit )
    {
        HUDtext="Take a copy, or buy for l$ 0. \n Full permissions,
        Revolutionary flight script.
        Public domain, no restrictions on use.
        Open the airplane as a box to get the documentation.";
        HUDcolor =  < 0.2, 0.4, 1. >;
        jump GOTO;
    }
    //
    if ( !HUDon )
    {
        HUDtext="";
        jump GOTO;
    }
    //
        HUDtext =  "Airpeed: " + (string)llFloor( (local_vel.x + 0.5) ) + " m/s"
        + " = "+(string)llFloor(  ( local_vel.x*1.94 + 0.5 )  ) + " kts."
        + " = "+(string)llFloor(  ( local_vel.x * 100./2.54/12./5280. *60.*60. + 0.5 )  ) + " mi./hr."
        + "\n " +" = "+(string)llFloor(  local_vel.x *100. /2.54/12. /5280. *60.*60. * 2.  +  0.5  ) + " scaled mi./hr."
        + "\n Rate of climb: " + " = " +
            (string)(  llFloor(  global_vel.z *100. /2.54 /12. *60. * 2.  /10.  +  0.5  ) * 10  ) + " scaled foot/min."
        + "\n " +
        "Throttle: " + (string)thrustPercent + "%";
        //
        HUDcolor =  < 1.0, 1.0, 1.0 >;  // white when combat is disabled
    //
    @GOTO;
    //
    llSetText( "", HUDcolor, 1.0);
    //llSetText(HUDtext+"\n \n \n \n \n \n \n ", HUDcolor, 1.0);
    //
    llMessageLinked( 2, 333, (string)HUDcolor, NULL_KEY );
    llMessageLinked( 2, 137, HUDtext+"\n \n \n ", NULL_KEY );
    //
}   // End refreshHUD().
//
//-----------------------------------------------------------------------------------------------------------------------------------
//
default
{
    state_entry()
    {
        init();
    }
//
    //----------------------------------------------------------------------------------------------------------------------
    on_rez(integer num)
    {
        llOwnerSay("Welcome to the Pietenpol Air Camper, type 'help' for the manual.");
        llOwnerSay("These controls can be typed in chat:");
        llOwnerSay("Start, stop the engine: 'contact' ,  'cutoff' ");
        //llOwnerSay("Seat position: 'seatup'  'seatdown'  (You will need to Re-sit) ");
        llOwnerSay("'smoke' turns colored smoke off and on.");
        //
        llOwnerSay(" ");
        llOwnerSay( "The arrow keys or a, d work the ailerons.");
        llOwnerSay( "Shift arrow or shift a, d controls the rudder." );
        llOwnerSay( "Up, down arrow or s, w controls the elevator, as usual." );
        llOwnerSay( "Page up, down or e, c changes the throttle, as usual." );
        llOwnerSay( "For a good turn, start the turn with the ailerons, then continue it with the rudder and elevator." );
        llOwnerSay( "But the elevator and ailerons don't work at the same time as the rudder, sorry." );
        llOwnerSay( "Use full throttle for take off." );
        //
        init();
    }
    //
    // DETECT AV SITTING/UNSITTING AND TAKE CONTROLS
//-----------------------------------------------------------------------------------------------------------------------------------
    changed( integer change )
    {
        //
        if ( change & CHANGED_LINK )
        {
            pilot = llAvatarOnSitTarget();
            //
            if ( pilot )
            {
                if ( pilot != llGetOwner() )
                //if ( FALSE )
                {
                    // only the owner can use this vehicle
                    llWhisper(0,
                    "Please take a copy of this airplane and fly your own copy.
                    (If it is not set \"free to copy\" or \"for sale 0 l$\" contact the owner or the creator.)
                    You aren't the owner -- only the owner can fly this plane.");
                    llUnSit( pilot );
                    //llPushObject(pilot, <0,0,10>, ZERO_VECTOR, FALSE);
                }
                else
                {   // Pilot sits on vehicle
                   
                    llRequestPermissions(pilot, PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION | PERMISSION_CONTROL_CAMERA);
                    llSetTimerEvent( requested_timer_interval );
                    llMessageLinked( LINK_SET, 0, "seated", "" );
                    llMessageLinked( LINK_ALL_CHILDREN , 0, "CONTROLS_FLYING", NULL_KEY );
                    sit = TRUE;
                    forward =  0;
                    thrustPercent =  0;
                    //llSetStatus(STATUS_PHYSICS, TRUE);
                    //
                    llSay(0, "Seated." );
                }
            }   // End pilot.
            //
            else if ( sit ) 
            // When changed is called with flying and CHANGED_LINK, it is usually that the avatar is getting up.
            {
                // Pilot is getting up.
                //
                llSetStatus( STATUS_PHYSICS, FALSE );
                llSetTimerEvent( 0 );
                llMessageLinked( LINK_SET, 0, "unseated", "" );
                llStopSound();
                llReleaseControls();
                //
                llClearCameraParams();                            
                sit = FALSE;
                //
                llSay(0, "Unseated." );
                //
                //llPushObject( pilot, <0,0, 10. >, ZERO_VECTOR, FALSE );           <<  This goes in the pilot seat script.
                //llSetStatus(STATUS_PHANTOM, TRUE);    // It falls through the floor.
                //llSleep(4.0);
                //llSetStatus(STATUS_PHANTOM, FALSE );
                //
            }   // End sit.
            else llSay(0, "??" );   //  for debugging
        }
        refreshHUD();
        //
    }   // End changed.
    //
    //------------------------------------------------------------------------------------------------------------------------
    //CHECK PERMISSIONS AND TAKE CONTROLS
    run_time_permissions( integer perm )
    {
        if ( perm & PERMISSION_TAKE_CONTROLS )
        {           
            llTakeControls( CONTROL_UP | CONTROL_DOWN | CONTROL_FWD | CONTROL_BACK
            | CONTROL_RIGHT | CONTROL_LEFT | CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT
            // |  CONTROL_ML_LBUTTON | CONTROL_LBUTTON
            , TRUE, FALSE);
        }
    }   // End run_time_permissions.
    //
    //----------------------------------------------------------------------------------------
    //
    listen( integer channel, string name, key id, string message )
    {
        //Aircraft Start Watcher
         //if(  (message == "contact")  &&  (ignition == FALSE)  )
         if(  message == "contact"  )
        {
            ignition = TRUE;
            llOwnerSay( "Starting Engine" );
            llSetStatus( STATUS_PHYSICS, TRUE );
            llMessageLinked( LINK_SET, 0, "start", NULL_KEY );
            //thrustPercent =  (integer) llFloor(  (float)(forward+1) / (float)maxThrottle * 100.  +  0.5  );
        }
        //else if( ( message == "cutoff" ) && (ignition == TRUE) )
        else if( message == "cutoff" )
        {
            ignition = FALSE;
            llOwnerSay( "Engine Stop" );
            llSetStatus( STATUS_PHYSICS, FALSE );
            llMessageLinked( LINK_SET, 0, "stop", NULL_KEY );
        }
        //
          else if( (message=="c") && (camon==FALSE) )       // No tested.
        {
             llSetCameraParams(drive_cam);
             camon=TRUE;
             llOwnerSay("Dynamic Camera on");
            }
       
        else if( (message=="c") && (camon==TRUE) )
        {
             llClearCameraParams();
             camon=FALSE;
             llOwnerSay("Dynamic Camera off");
        }
        else if( message == "smoke" )
        // Added by FtC, because I can't feel the acceleration in the seat of my pants.
        {
            llMessageLinked( LINK_SET, 0, "smoke", NULL_KEY );
            //  (The smoke script starts and stops the smoke with the engine but remembers this command.)
        }
    }     // End listen. 
    //
    //----------------------------------------------------------------------------------------
    //            
    //FLIGHT CONTROLS
    control( key id, integer levels, integer edge )
    {
        // OBC DECLARATIONS
        integer throttle_up = CONTROL_UP;
        integer throttle_down = CONTROL_DOWN;
        //
        //               
        if ( (levels & (throttle_up+throttle_down)) && ignition )
        {           
      ////////////// THROTTLE INCREASE ////////////////
            if ( levels & throttle_up )
            {
                if ( forward < maxThrottle-1 )
                {
                    forward += 1;
                }
            }
            //
    ////////////// THROTTLE DECREASE ////////////////
            else if ( levels & throttle_down )
            {
                if ( forward > 0 )
                {
                    forward -= 1;
                }
            }
            llSetVehicleVectorParam( VEHICLE_LINEAR_MOTOR_DIRECTION, <  forward * thrustMultiplier, 0, 0 > );
            //
            // Calculate percent of max throttle and send to child prims as link message
            thrustPercent =  (integer) llFloor(  (float)(forward+1) / (float)maxThrottle * 100.  +  0.5  );
            //
            llMessageLinked( LINK_SET, thrustPercent, "throttle", "" );
            //
            llOwnerSay( "Throttle at " + (string)thrustPercent + " %" );
            //
            refreshHUD();
            //
            llSleep( 0.15 ); // crappy kludge // This must be to avoid multiple clicks.
        }
        //
        // only change angular motor if the angular levels have changed
        //
        if (  (edge & gOldAngularLevel)  ||  (levels & gAngularControls)  )
        {
            //  This is not fly by wire or fly by light, so the controls work when the pilot is seated.
            //  The fact that they still have some effect at zero speed is an unrealistic convenience.
            //  By the standard simple approximation, both lift and control surface effectiveness are proportional
            //      to the square of the speed.  This is a compromise between that and flying ease.
            //
            angular_motor = <0,0,0>;
            cur_aileron_direction = "AILERON_NEUTRAL";  // Start neutral.
            cur_elevator_direction = "ELEVATOR_NEUTRAL";
            cur_rudder_direction = "RUDDER_NEUTRAL";
            //
            // ailerons
            if( levels & CONTROL_ROT_RIGHT )
            {
                cur_aileron_direction = "AILERON_RIGHT";
                angular_motor.x +=  2.5 * (0.5 + speed/10.);
            }
            //
             if( levels & CONTROL_ROT_LEFT )
            {
                cur_aileron_direction = "AILERON_LEFT";
                angular_motor.x -=  2.5 * (0.5 + speed/10.);
            }
            //
            // rudder
            if( levels & CONTROL_RIGHT )
            {
                cur_rudder_direction = "RUDDER_RIGHT";
                angular_motor.z -=  1.3 * (0.7 + speed/10.);
            }
            //
             if( levels & CONTROL_LEFT )
            {
                cur_rudder_direction = "RUDDER_LEFT";
                angular_motor.z +=  1.3 * (0.7 + speed/10.);
            }
            //
            //  elevator
            if( levels & CONTROL_BACK )
            {
                // add pitch component ==> causes vehicle lift nose (in local frame)
                cur_elevator_direction = "ELEVATOR_UP";
                angular_motor.y -=  1.2 * (0.7 + speed/10.);
            }
            if( levels & CONTROL_FWD  )
            {
                cur_elevator_direction =  "ELEVATOR_DOWN";
                angular_motor.y +=  1.2 * (0.7 + speed/10.);
            }
             llSetVehicleVectorParam( VEHICLE_ANGULAR_MOTOR_DIRECTION, angular_motor );
             //
            //  These are moved from timer to reduce the delay.
            //
            if ( cur_aileron_direction != last_aileron_direction )
            {
             llMessageLinked( LINK_ALL_CHILDREN , 0, cur_aileron_direction, NULL_KEY );
             last_aileron_direction = cur_aileron_direction;
            }
            if ( cur_elevator_direction != last_elevator_direction )
            {
                llMessageLinked( LINK_ALL_CHILDREN , 0, cur_elevator_direction, NULL_KEY );
                last_elevator_direction = cur_elevator_direction;
            }
            if ( cur_rudder_direction != last_rudder_direction )
            {
                llMessageLinked( LINK_ALL_CHILDREN , 0, cur_rudder_direction, NULL_KEY );
                last_rudder_direction = cur_rudder_direction;
            }
        //
        }   // End angular controls.
        // store the angular levels history for the next control callback
        gOldAngularLevel = levels & gAngularControls;
        //
    }   // End control.
    //
    //----------------------------------------------------------------------------------------------------------------------------
    // LAND COLLISION FILTER FOR turn BEHAVIOR  //  Used now only for unrealistic convenience.
    //
    collision_start(integer num_detected) {
        //llOwnerSay( "Down." );
        llSetVehicleFloatParam( VEHICLE_ANGULAR_MOTOR_TIMESCALE, ANGULAR_MOTOR_TIMESCALE_0/10. );   // More torque needed on ground.
        llSetVehicleFloatParam( VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, VERTICAL_ATTRACTION_TIMESCALE_0 / 20.  );
        // The wheel keep us right side up.
        onground = TRUE;
    }
    collision_end(integer num_detected){
        //llOwnerSay( "Up." );
        //llSetVehicleFloatParam( VEHICLE_ANGULAR_MOTOR_TIMESCALE, ANGULAR_MOTOR_TIMESCALE_0 );   // Less torque needed in air.
        onground = FALSE;
    }       
    land_collision_start(vector pos) {
        //llOwnerSay( "Down." );
        llSetVehicleFloatParam( VEHICLE_ANGULAR_MOTOR_TIMESCALE, ANGULAR_MOTOR_TIMESCALE_0/10. );   // More torque needed on ground.
        llSetVehicleFloatParam( VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, VERTICAL_ATTRACTION_TIMESCALE_0 / 20.  );
        // The wheel keep us right side up.
        onground = TRUE;
    }                    
    land_collision_end(vector pos) {
        //llOwnerSay( "Up." );
        //llSetVehicleFloatParam( VEHICLE_ANGULAR_MOTOR_TIMESCALE, ANGULAR_MOTOR_TIMESCALE_0 );   // Less torque needed in air.
        onground = FALSE;
    }
    //----------------------------------------------------------------------------------------
    //Aircraft Start Watcher                                        // I took this out for efficiency and simplicity.
    //link_message( integer send, integer num, string msg, key id )
    //{                
    //    if(( msg == "contact" ) && (ignition == FALSE))
    //    {
    //        ignition= TRUE;
    //        llOwnerSay("Starting Engine");
    //        llSetStatus(STATUS_PHYSICS, TRUE);
    //    }
    //    else if(( msg == "cutoff" ) && (ignition == TRUE) )
    //    {
    //        ignition = FALSE;
    //        llOwnerSay("Engine Stop");
    //        llSetStatus(STATUS_PHYSICS, FALSE);
    //    }
    //}
    //------------------------------------------------------------------------------------------------------------------------
    //
    timer()
    {
        global_vel =  llGetVel();
        speed =  llVecMag( global_vel );
        float speed_kt =  speed * 1.94384449;   // Calculate speed in knots.
        local_vel =  global_vel / llGetRot();          // to coordinate frame alligned with body
        //
        llSetVehicleVectorParam( VEHICLE_LINEAR_MOTOR_DIRECTION, < forward*thrustMultiplier, 0, 0 > );    // Keep engine running.
        llSetVehicleVectorParam( VEHICLE_ANGULAR_MOTOR_DIRECTION, angular_motor );  // Keeps friction constant.
        //
        if ( onground )
            ;
            //llSetVehicleFloatParam( VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, VERTICAL_ATTRACTION_TIMESCALE_0 / 10.  );
        else
            llSetVehicleFloatParam( VEHICLE_ANGULAR_MOTOR_TIMESCALE, ANGULAR_MOTOR_TIMESCALE_0 / (1.5 + 0.5*speed/10.)  );
            // More torque needed at higher speed.
            llSetVehicleFloatParam( VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, VERTICAL_ATTRACTION_TIMESCALE_0 / (1.5 + 0.5*speed/10.)  );
        //  Dihedral and wing sweep are more effective at higher speed.
        //
        refreshHUD();
        //
    }  // End timer.
}   // End default.
// 
//=======================================================================================
//

 
