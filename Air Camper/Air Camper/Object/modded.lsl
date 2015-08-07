
// PIETENPOL AIR CAMPER FLIGHT SCRIPT MK1
// Portions of this script are influenced by or based on work from Alex Linden, Cubey Terra, Eoin Widget, Kerian Bunin, Ronald Krugman 
// Script by Ezekiel Bailly 2005-2008
// Copyleft!


//  *AC control flags that we set later
integer gAngularControls = 0;


// *AC  we keep track of angular history for more responsive turns
integer gOldAngularLevel = 0;



// Landing Gear Weight on Wheels-Collision Integer
integer onground = FALSE;


// THROTTLE (SPEED) Sensitive Declarations
integer turnrate = 1;
integer pitchrate =1;



// Thrust variables:
// thrust = fwd * thrust_multiplier
// Edit the maxThrottle and thrustMultiplier to determine max speed.
integer fwd; // this changes when pilot uses throttle controls
integer maxThrottle = 10; // Number of "clicks" in throttle control. Arbitrary, really.*was 5
integer thrustMultiplier = 3; // Amount thrust increases per click. *was 7

// Lift and speed
float cruiseSpeed = 19.0; // speed at which plane achieves full lift
float lift;
float liftMax = 1.5; //Maximum allowable lift
float speed;
float vertat;

float timerFreq = 0.5;

integer fwdLast; 
integer sit;



integer acon = FALSE;
//integer lightson = FALSE;


integer flight;

// Control Surface Motion Declarations
string last_aileron_direction;
string cur_aileron_direction;

string last_elevator_direction;
string cur_elevator_direction;

string last_rudder_direction;
string cur_rudder_direction;



// CAMERA DECLARATIONS
list drive_cam =
[
        CAMERA_ACTIVE, TRUE,
        CAMERA_BEHINDNESS_ANGLE, 0.0,
        CAMERA_BEHINDNESS_LAG, 0.6,
        CAMERA_DISTANCE, 10.0,
        CAMERA_PITCH, 10.0,

        // CAMERA_FOCUS,
        CAMERA_FOCUS_LAG, 0.05,
        CAMERA_FOCUS_LOCKED, FALSE,
        CAMERA_FOCUS_THRESHOLD, 0.0,

        // CAMERA_POSITION,
        CAMERA_POSITION_LAG, 0.3,
        CAMERA_POSITION_LOCKED, FALSE,
        CAMERA_POSITION_THRESHOLD, 0.0, 
        
        CAMERA_FOCUS_OFFSET,<0,0,1>
];
integer camon = FALSE;




default 
{
      

       
        
 state_entry() 
    {

 llListen(0,"",llGetOwner(),"");
                                      
        llSetCameraEyeOffset(<-13, 0, 3.75>); // Position of camera, relative to parent. 
        llSetCameraAtOffset(<0, 0, 1.9>);   // Point to look at, relative to parent.
                

        llSetSitText("AirCamper"); // Text that appears in pie menu when you sit

        llCollisionSound("", 0.0); // Remove the annoying thump sound from collisions  
 
        //SET VEHICLE PARAMETERS -- See www.secondlife.com/badgeo for an explanation
        llSetVehicleType(VEHICLE_TYPE_AIRPLANE);
             
        // uniform angular friction 
        llSetVehicleFloatParam( VEHICLE_ANGULAR_FRICTION_TIMESCALE, 2 );
        
        // linear motor
        llSetVehicleVectorParam( VEHICLE_LINEAR_FRICTION_TIMESCALE, <200, 20, 20> );
        llSetVehicleVectorParam( VEHICLE_LINEAR_MOTOR_DIRECTION, <0, 0, 0> );
        llSetVehicleFloatParam( VEHICLE_LINEAR_MOTOR_TIMESCALE, 2 );
        llSetVehicleFloatParam( VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 120 );
        
        // agular motor
        llSetVehicleVectorParam( VEHICLE_ANGULAR_MOTOR_DIRECTION, <0, 0, 0> );
        llSetVehicleFloatParam( VEHICLE_ANGULAR_MOTOR_TIMESCALE, 0.5 ); 
        llSetVehicleFloatParam( VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, 2);
        
        // hover 
      // llSetVehicleFloatParam( VEHICLE_HOVER_HEIGHT, 0 );
      // llSetVehicleFloatParam( VEHICLE_HOVER_EFFICIENCY, 0 ); 
      // llSetVehicleFloatParam( VEHICLE_HOVER_TIMESCALE, 10 );
      // llSetVehicleFloatParam( VEHICLE_BUOYANCY, .90 );
        
        // no linear deflection 
        llSetVehicleFloatParam( VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 0.2 );
        llSetVehicleFloatParam( VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 0.5 ); 
        
        // no angular deflection 
 llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 0.1);
         llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, 1.0);
            
       // no vertical attractor 
       // llSetVehicleFloatParam active moved to motors/turning below 
        
       // llSetVehicleFloatParam( VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, 0.10); // almost wobbly
        
        llSetVehicleFloatParam( VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 3.5 );
        
       // banking
        
        
        llSetVehicleFloatParam( VEHICLE_BANKING_EFFICIENCY, 0.3);
        
        llSetVehicleFloatParam( VEHICLE_BANKING_MIX, 0.95);
     
        llSetVehicleFloatParam( VEHICLE_BANKING_TIMESCALE, 0.2);
       
        
        
       //  llSetVehicleFloatParam( VEHICLE_BANKING_EFFICIENCY, 0.4);
       //  llSetVehicleFloatParam( VEHICLE_BANKING_MIX, .95);
       //  llSetVehicleFloatParam( VEHICLE_BANKING_TIMESCALE, 0.1);
        
        
        
        
        // default rotation of local frame
        llSetVehicleRotationParam( VEHICLE_REFERENCE_FRAME, <0,0,0,1>);
        
        // remove these flags 
        llRemoveVehicleFlags( VEHICLE_FLAG_NO_DEFLECTION_UP 
                              | VEHICLE_FLAG_HOVER_WATER_ONLY 
                              | VEHICLE_FLAG_HOVER_TERRAIN_ONLY 
                              | VEHICLE_FLAG_HOVER_GLOBAL_HEIGHT 
                              | VEHICLE_FLAG_HOVER_UP_ONLY 
                              | VEHICLE_FLAG_LIMIT_MOTOR_UP 
                              | VEHICLE_FLAG_CAMERA_DECOUPLED);
                              
                              
                              
              gAngularControls = CONTROL_RIGHT | CONTROL_LEFT | CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT | CONTROL_BACK |    CONTROL_FWD;                    
                              

     //    set these flags 
     //    llSetVehicleFlags( VEHICLE_FLAG_LIMIT_ROLL_ONLY ); 

    }
    
    on_rez(integer num) 
    {

llOwnerSay("Welcome to the Pietenpol Air Camper, type 'help' for the manual.");
llOwnerSay("These controls can be typed in chat:");
llOwnerSay("Start the motor: 'contact' ,  'cutoff' ");

//  llOwnerSay("Seatposition: 'seatup'  'seatdown'  (You will need to Re-sit) ");
//  llOwnerSay("If you end up sitting on the cockpit side, stand up and ");
//  llOwnerSay("use 'seatup' or 'seatdown' to reset the seat position. ");




        llResetScript();
     
        
        
    } 

    // DETECT AV SITTING/UNSITTING AND TAKE CONTROLS
changed(integer change)
    {
       if(change & CHANGED_LINK)
       {
            key agent = llAvatarOnSitTarget();
           
           
    

           
           
           
           
           
            // Pilot gets off vehicle
           if((agent == NULL_KEY) && (sit))
            {
                llSetStatus(STATUS_PHYSICS, FALSE);
                llSetTimerEvent(0.0);
                llMessageLinked(LINK_SET, 0, "unseated", "");
                llStopSound();
                llReleaseControls();
            
                llClearCameraParams();                                
                sit = FALSE;
                llSetStatus(STATUS_PHANTOM, TRUE);
                llSleep(4.0);
                llSetStatus(STATUS_PHANTOM, FALSE);
            }
        
         
                     

          // Pilot sits on vehicle
            else if((agent == llGetOwner()) && (!sit))
            {
                llRequestPermissions(agent, PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION | PERMISSION_CONTROL_CAMERA);
                llSetTimerEvent(timerFreq);
                llMessageLinked(LINK_SET, 0, "seated", "");
                llMessageLinked(LINK_ALL_CHILDREN , 0, "CONTROLS_FLYING", NULL_KEY);
                sit = TRUE;
              //  llSetStatus(STATUS_PHYSICS, TRUE);
              }
         

            
        }
    }
    
   
    
  
    
    
    
    
    
    //CHECK PERMISSIONS AND TAKE CONTROLS
    run_time_permissions(integer perm) 
    
    
  

    {
        if (perm & (PERMISSION_TAKE_CONTROLS)) 
        {            
            llTakeControls(CONTROL_UP | CONTROL_DOWN | CONTROL_FWD | CONTROL_BACK | CONTROL_RIGHT | CONTROL_LEFT | CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT |  CONTROL_ML_LBUTTON | CONTROL_LBUTTON, TRUE, FALSE);
        }
    }
   

      
      
      
      
       // LAND COLLISION FILTER FOR STALL BEHAVIOR 
         collision_start(integer num_detected) {
        onground = TRUE;
      }
    
            collision_end(integer num_detected){
         onground = FALSE;
     } 
              
                  
        land_collision_start(vector pos) {             
          onground = TRUE;}                
                              
                                  
           land_collision_end(vector pos) {             
          onground = FALSE;}             
      
      
      
       //Aircraft Start Watcher
     link_message(integer send, integer num, string msg, key id)
       {  
      
 
               
                           
                                                   
                  
                     
                        
       if(( msg == "contact" ) && (acon == FALSE))
        {
            
            acon= TRUE;
            llOwnerSay("Starting Engine");
            llSetStatus(STATUS_PHYSICS, TRUE);
            
        }
        else if(( msg == "cutoff" ) && (acon == TRUE) )
        {
            
            acon = FALSE;
            llOwnerSay("Engine Stop");
            llSetStatus(STATUS_PHYSICS, FALSE);
            
        }
  
             
            
  
      
        
          
            
                }     
      
      
      
      

    listen( integer channel, string name, key id, string message )
    {     
 
        
     //Aircraft Start Watcher
        
         if(( message == "contact" ) && (acon == FALSE))
        {
            
            acon= TRUE;
            llOwnerSay("Starting Engine");
             llSetStatus(STATUS_PHYSICS, TRUE);
        }
        else if(( message == "cutoff" ) && (acon == TRUE) )
        {
            
            acon = FALSE;
            llOwnerSay("Engine Stop");
            llSetStatus(STATUS_PHYSICS, FALSE);
        }
        
          else if((message=="c") && (camon==FALSE))
        {
             llSetCameraParams(drive_cam);
             camon=TRUE;
             llOwnerSay("Dynamic Camera on");
            }
        
        else if((message=="c") && (camon==TRUE))
        {
             llClearCameraParams();
             camon=FALSE;
             llOwnerSay("Dynamic Camera off");
        }      



      
                
        
    }       
                                                                                                                        
                                                                                                       
                                    
    //FLIGHT CONTROLS     
    control(key id, integer level, integer edge) 
    {





          // OBC DECLARATIONS
            integer throttle_up = CONTROL_UP;
            integer throttle_down = CONTROL_DOWN;

            
            
       
            
              
                                          
      ////////////// THROTTLE INCREASE ////////////////      
      
      
      //      if ((level & throttle_up) && (acon == TRUE))
      //      {
      //          if (fwd < maxThrottle)
      //          {
      //              fwd += 1;
      //          }
                
                
      //          if (fwd == 0)
      //          { llOwnerSay("Idle 20%");
      //          llSleep(0.5); 
      //          llMessageLinked(LINK_ALL_CHILDREN , 0, "idle", NULL_KEY); }
                 
                
       //         if (fwd == 1)
      //          { llOwnerSay("Throttle 40%");
     //           llSleep(0.05); 
     //           llMessageLinked(LINK_ALL_CHILDREN , 0, "40", NULL_KEY); }

                                      
      //          if (fwd == 2)
      //          { llOwnerSay("Throttle 60%");
      //          llSleep(0.05); 
     //           llMessageLinked(LINK_ALL_CHILDREN , 0, "60", NULL_KEY);}
                
                
     //             if (fwd == 3)
     //           { llOwnerSay("Throttle 80%");
     //             llSleep(0.05); 
     //             llMessageLinked(LINK_ALL_CHILDREN , 0, "60", NULL_KEY);}
                
      //          
      //           if (fwd == 4)
     //           { llOwnerSay("Throttle 100%");
     //             llSleep(0.05); 
     //             llMessageLinked(LINK_ALL_CHILDREN , 0, "60", NULL_KEY);}
                    
                
                
                
                   
                
      //          }
        
            
     

     
    ////////////// THROTTLE DECREASE ////////////////
            
            
            
                
            //    else if ((level & throttle_down) && (acon == TRUE))
           // {
           //     if (fwd > 0)
           //     {
           //         fwd -= 1;
           //     }
                
                
            
           //    if (fwd == 0)
           //    { llOwnerSay("Idle 20%");
           //      llMessageLinked(LINK_ALL_CHILDREN , 0, "idle", NULL_KEY); }
              
               
                 
          //         if (fwd == 1)
         //      { llOwnerSay("Throttle 40%");
        //         llMessageLinked(LINK_ALL_CHILDREN , 0, "40", NULL_KEY); } 
              
            //          if (fwd == 2)
           //    { llOwnerSay("Throttle 60%"); 
          //       llMessageLinked(LINK_ALL_CHILDREN , 0, "60", NULL_KEY); }
                      
         //                   if (fwd == 3)
         //      { llOwnerSay("Throttle 80%"); 
        //         llMessageLinked(LINK_ALL_CHILDREN , 0, "60", NULL_KEY); }                       
               
               
       //     }
            
       //     if (fwd != fwdLast)
       //     {
       //         llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <(fwd * thrustMultiplier),0,0>);
                
                // calculate percent of max throttle and send to child prims as link message
        //        float thrustPercent = (((float)fwd/(float)maxThrottle) * 100);
       //         llMessageLinked(LINK_SET, (integer)thrustPercent, "throttle", "");
             //   llOwnerSay("Throttle at "+(string)((integer)thrustPercent)+"%");
                
       //         fwdLast = fwd;
      //          llSleep(0.15); // crappy kludge :P
      //      }


//////// NEW THROTTLE SETTINGS FROM HERE DOWN ////

   // THROTTLE CONTROL--------------
            if (level & throttle_up) 
            {
                if (fwd < maxThrottle)
                {
                    fwd += 1;
                }
            }
            else if (level & throttle_down) 
            {
                if (fwd > 0)
                {
                    fwd -= 1;
                }
            }
            
            if (fwd != fwdLast)
            {
                llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <(fwd * thrustMultiplier),0,0>);
                
                // calculate percent of max throttle and send to child prims as link message
                float thrustPercent = (((float)fwd/(float)maxThrottle) * 100);
                llMessageLinked(LINK_SET, (integer)thrustPercent, "throttle", "");
                llOwnerSay("Throttle at "+(string)((integer)thrustPercent)+"%");
                
                fwdLast = fwd;
                llSleep(0.15); // crappy kludge :P
            }
    
////// New THROTTLE SETTINGs END HERE /////        
   
            
      
       if(speed >= 1)
      {  turnrate = 1; 
         pitchrate =0;
         vertat =0.10  ;}     //was 0.15    
                          
                                    
      if(speed >= 5)
      {  turnrate = 1; 
         pitchrate =0;
         vertat =.11  ;}      //was 0.14
                
       if (speed >= 10)          
        {  turnrate = 1; 
         pitchrate =1;
         vertat =.12  ;}      //was 0.13                                    
                                                                  
                   
   if (speed >= 15)          
        {  turnrate = 1; 
         pitchrate =2; 
         vertat =.12  ;}                                                                               
   
      
            if (speed >= 20)          
        {  turnrate = 2; 
         pitchrate =2;  
          vertat =.11  ;}                                                                                            
      
   if (speed >= 25)          
        {  turnrate = 3; 
         pitchrate =3; 
          vertat =.08  ;} 
      
      
     if (speed >= 35)          
        {  turnrate = 3; 
         pitchrate =3; 
          vertat =.07  ;} 
      
      
        if (speed >= 40)          
        {  turnrate = 3; 
         pitchrate =4;
          vertat =.07  ;}       //was 0.06
      
   
         if (speed >= 45)          
        {  turnrate = 4; 
         pitchrate =4;
          vertat =.10  ;}      //was 0.08
      
      vector motor;
          integer motor_changed = level;
          
          
          
          llSetVehicleFloatParam( VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, vertat); 
          
      
        // only change angular motor if the angular levels have changed
        motor_changed = (edge & gOldAngularLevel) + (level & gAngularControls);
        if (motor_changed)
        {
            motor = <0,0,0>;
            if(level & (CONTROL_RIGHT|CONTROL_ROT_RIGHT) && (acon == TRUE))
            {
                    cur_aileron_direction = "AILERON_RIGHT";
                     cur_rudder_direction = "RUDDER_RIGHT";
                // add roll component ==> triggers banking behavior
               if(speed > 5)  motor.x +=(turnrate);  //was18
           
            //  if(geardown == FALSE)  motor.x += 4;
                
                 else if(speed <= 5) motor.z -= 2;   //was 18
                 
                 
            }
           
            
             
             if(level & (CONTROL_LEFT|CONTROL_ROT_LEFT) && (acon == TRUE))
            {
               cur_aileron_direction = "AILERON_LEFT";
                  cur_rudder_direction = "RUDDER_LEFT";
                if(speed > 5)  motor.x -=(turnrate);    //was 18
            
                //     if(geardown == FALSE)  motor.x -= 4;
                     
              
                    else if(speed <= 5)  motor.z += 2;    //was 18
                   
                
            }
            if(level & (CONTROL_BACK) && (acon == TRUE)) // CUBEY
            {
                // add pitch component ==> causes vehicle lift nose (in local frame)
                cur_elevator_direction = "ELEVATOR_UP";
                 motor.y -=(pitchrate);
            }
            if(level & (CONTROL_FWD) && (acon == TRUE)) // CUBEY
            {
               cur_elevator_direction = "ELEVATOR_DOWN";
                 motor.y +=(pitchrate);
            }
             llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, motor);
             
             
            if ((~level & edge) && (acon == TRUE))
            {
              cur_aileron_direction = "AILERON_NEUTRAL";
              cur_elevator_direction = "ELEVATOR_NEUTRAL";
              cur_rudder_direction = "RUDDER_NEUTRAL";
             } 
             
             
        }
        // store the angular level history for the next control callback
        gOldAngularLevel = level & gAngularControls;
    
  
      
      
      
            
    } 
    
    timer()
    {
        
        
              
           if (cur_aileron_direction != last_aileron_direction)
        {
            llMessageLinked(LINK_ALL_CHILDREN , 0, cur_aileron_direction, NULL_KEY);
            last_aileron_direction = cur_aileron_direction;
        }
        
        
           if (cur_elevator_direction != last_elevator_direction)
        {
            llMessageLinked(LINK_ALL_CHILDREN , 0, cur_elevator_direction, NULL_KEY);
            last_elevator_direction = cur_elevator_direction;
        }
        
            if (cur_rudder_direction != last_rudder_direction)
        {
            llMessageLinked(LINK_ALL_CHILDREN , 0, cur_rudder_direction, NULL_KEY);
            last_rudder_direction = cur_rudder_direction;
        }
        
        
        
        // Calculate speed in knots
        speed = (integer)(llVecMag(llGetVel()) * 1.94384449 + 0.5);
        
        // Provide lift proportionally to speed
        cruiseSpeed = 19.0; // speed at which you achieve full lift
        lift = (speed/cruiseSpeed); //Lift is varied proportionally to the speed
     
    
       if (lift > liftMax) lift = liftMax;
     
       
         
             if ((speed <= 8) && (onground == FALSE))
             
             {  lift = -2; 
               // llOwnerSay("STALL");
                flight = FALSE;  }               
        
        
        
  //      while (!flight)
  //    {
  //     if(speed >=20) 
  //   {
  //        flight = TRUE;
  //   }
  //      else
  //     {
  //       lift = -3;
  //     }
  //  }
        
   
        
            
                                    
                                                  
        llSetVehicleFloatParam( VEHICLE_BUOYANCY, lift );
       

 }

}


