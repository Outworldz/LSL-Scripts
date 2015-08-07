// :CATEGORY:Vehicle
// :NAME:Tour Airplane
// :AUTHOR:Christy Lock
// :KEYWORDS:
// :CREATED:2014-12-04 12:27:44
// :EDITED:2014-12-04
// :ID:1060
// :NUM:1694
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Opensim Scooter
// :CODE:
//Final code and animations and sounds by Christy Lock OSGRID 4/23/2014
//Maegan OMally standalone alt may be listed also

//Special Thanks to Robert Adams and all those who worked on BulletSim!
//BulletSim Required for this to work
//Thanks to Cory and ANdrew Linden as their work and instructions contributed to this code

//EVERYTHING in the scooter is opensource free to use as you like


key agent;

integer handle;

float forward_power = 35.0; //Power used to go forward 
float reverse_power = -25.0; //Power ued to go reverse
float turn_rate = 15.0;//rotation (twist) around angular.z 

string sit_message = "Scoot"; //Sit message

vector linear;
vector angular;

float xfactor = 28.0;//Normal velocity all three axis
float yfactor = 8.0;
float zfactor = 12.0;

dialog(key user)
{
    handle = llListen(-2,"",user,"");
    llDialog(user,"Options",["normal","slow"],-2);
}

cam()
{     
//extra camera code for testing
    llSetCameraParams([
        CAMERA_ACTIVE, 1, // 1 is active, 0 is inactive
        CAMERA_BEHINDNESS_ANGLE, 95.0, // (0 to 180) degrees
        CAMERA_BEHINDNESS_LAG, 0.0, // (0 to 3) seconds
        CAMERA_DISTANCE, 10.0, // ( 0.5 to 10) meters
        //CAMERA_FOCUS, <0,0,5>, // region relative position
        CAMERA_FOCUS_LAG, 0.1 , // (0 to 3) seconds
        CAMERA_FOCUS_LOCKED, FALSE, // (TRUE or FALSE)
        CAMERA_FOCUS_THRESHOLD, 0.0, // (0 to 4) meters
        CAMERA_PITCH, 20.0, // (-45 to 80) degrees
        //CAMERA_POSITION, <0,0,0>, // region relative position
        CAMERA_POSITION_LAG, 0.1, // (0 to 3) seconds
        CAMERA_POSITION_LOCKED, FALSE, // (TRUE or FALSE)
        CAMERA_POSITION_THRESHOLD, 2.0, // (0 to 4) meters
        CAMERA_FOCUS_OFFSET, <0.0,0.0,0.0> // <-10,-10,-10> to <10,10,10> meters        
    ]);    
}
camfixed()
{
    //actual camera used....Camera_Position_Lag should be 0.0  0.1 makes the cam bump a little
    //and look like the physics engine is on off on off - same for Camera_behindness_lag        
    llSetCameraParams([
        CAMERA_ACTIVE, 1, // 1 is active, 0 is inactive
        CAMERA_BEHINDNESS_ANGLE, 95.0, // (0 to 180) degrees
        CAMERA_BEHINDNESS_LAG, 0.0, // (0 to 3) seconds
        CAMERA_DISTANCE, 7.0, // ( 0.5 to 10) meters
        //CAMERA_FOCUS, <0,0,5>, // region relative position
        CAMERA_FOCUS_LAG, 0.0 , // (0 to 3) seconds
        CAMERA_FOCUS_LOCKED, FALSE, // (TRUE or FALSE)
        CAMERA_FOCUS_THRESHOLD, 0.0, // (0 to 4) meters
        CAMERA_PITCH, 20.0, // (-45 to 80) degrees
        //CAMERA_POSITION, <0,0,0>, // region relative position
        CAMERA_POSITION_LAG, 0.0, // (0 to 3) seconds
        CAMERA_POSITION_LOCKED, FALSE, // (TRUE or FALSE)
        CAMERA_POSITION_THRESHOLD, 2.0, // (0 to 4) meters
        CAMERA_FOCUS_OFFSET, <0.0,0.0,0.0> // <-10,-10,-10> to <10,10,10> meters        
    ]);    
}
driving_cam360()
{    
//extra camera code for testing
    llSetCameraParams([
        CAMERA_ACTIVE, 1, // 1 is active, 0 is inactive
        CAMERA_BEHINDNESS_ANGLE, 180.0, // (0 to 180) degrees
        CAMERA_BEHINDNESS_LAG, 0.0, // (0 to 3) seconds
        CAMERA_DISTANCE, 10.0, // ( 0.5 to 10) meters
        //CAMERA_FOCUS, <0,0,5>, // region relative position
        CAMERA_FOCUS_LAG, 0.1 , // (0 to 3) seconds
        CAMERA_FOCUS_LOCKED, FALSE, // (TRUE or FALSE)
        CAMERA_FOCUS_THRESHOLD, 0.0, // (0 to 4) meters
        CAMERA_PITCH, 20.0, // (-45 to 80) degrees
        //CAMERA_POSITION, <0,0,0>, // region relative position
        CAMERA_POSITION_LAG, 0.1, // (0 to 3) seconds
        CAMERA_POSITION_LOCKED, FALSE, // (TRUE or FALSE)
        CAMERA_POSITION_THRESHOLD, 0.0, // (0 to 4) meters
        CAMERA_FOCUS_OFFSET, <0,0,-2.0> // <-10,-10,-10> to <10,10,10> meters        
    ]);    
}
driving_cam90()
{    
//extra camera code for testing
    llSetCameraParams([
        CAMERA_ACTIVE, 1, // 1 is active, 0 is inactive
        CAMERA_BEHINDNESS_ANGLE, 95.0, // (0 to 180) degrees
        CAMERA_BEHINDNESS_LAG, 0.0, // (0 to 3) seconds
        CAMERA_DISTANCE, 10.0, // ( 0.5 to 10) meters
        //CAMERA_FOCUS, <0,0,5>, // region relative position
        CAMERA_FOCUS_LAG, 0.1 , // (0 to 3) seconds
        CAMERA_FOCUS_LOCKED, FALSE, // (TRUE or FALSE)
        CAMERA_FOCUS_THRESHOLD, 0.0, // (0 to 4) meters
        CAMERA_PITCH, 20.0, // (-45 to 80) degrees
        //CAMERA_POSITION, <0,0,0>, // region relative position
        CAMERA_POSITION_LAG, 0.1, // (0 to 3) seconds
        CAMERA_POSITION_LOCKED, FALSE, // (TRUE or FALSE)
        CAMERA_POSITION_THRESHOLD, 0.0, // (0 to 4) meters
        CAMERA_FOCUS_OFFSET, <0,0,0> // <-10,-10,-10> to <10,10,10> meters        
    ]);    
}

init()
{
        llPreloadSound("jetstartupfinal"); 
        llPreloadSound("jetloopfinal");   
        llPreloadSound("jetshutdownfinal");    
        
        llSetVehicleType(VEHICLE_TYPE_AIRPLANE); 
        
        //ANGULAR MOTOR **
        // somewhat responsive angular motor, but with 3 second decay timescale
        llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_TIMESCALE, 1);     
        llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, 3);        
     
        // weak angular deflection
        llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 0.1);       
        llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, 1.0);
       
        //weak friction all 3 axis  
        llSetVehicleVectorParam(VEHICLE_ANGULAR_FRICTION_TIMESCALE, <1000,1000,1000>);
     
      ; 
       
        //* LINEAR MOTOR **
        llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_TIMESCALE, 1.0);//0.5
        llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 5);
        
        //moderate - weakish linear deflection
        llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 0.1);
        llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 3);//0.1
        
        //weak friction for linear motor also
        llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <1000,1000,1000>);//1000,0.8,1
        
        
        
        
        //** VERTICAL ATTRACTOR **
         llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, 0.25);  // almost wobbly
         llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 1.5);    // mediocre response 
        
        //** BANKING STRENGTH and MIX for speed
        llSetVehicleFloatParam(VEHICLE_BANKING_EFFICIENCY, 0.4);//0.4    // medium strength
        llSetVehicleFloatParam(VEHICLE_BANKING_TIMESCALE, 0.8);//0.1//0.8     // very responsive
        llSetVehicleFloatParam(VEHICLE_BANKING_MIX, 0.95);//0.95          // more banking when moving
       
        
        //** 1.0 floats and turn on physics **
        llSetVehicleFloatParam(VEHICLE_BUOYANCY, 1.0);//0.9    
        llSetStatus(STATUS_PHYSICS, TRUE);
   
}

release_camera_control()
{
    llSetCameraParams([CAMERA_ACTIVE, 0]); // 1 is active, 0 is inactive  
}
 
default
{
    state_entry()
    {
        llMessageLinked(LINK_SET,-1,"Tstop","");//stop particles and turbine spin
        llSetSitText(sit_message);
        llSitTarget(<-0.02,0.0,-0.15>, ZERO_ROTATION );
        llSetStatus(STATUS_PHYSICS, FALSE);
        llStopSound();
    }
    touch_start(integer touched)
    {
        key avatar = llDetectedKey(0);
        dialog(avatar);
    } 
    listen(integer chan,string name,key id , string msg)
    {
        if ( msg == "normal")
        {
            llOwnerSay( "Normal speed");
            xfactor = 28.0;
            yfactor = 8.0;
            zfactor = 12.0;
            llListenRemove(handle);
        }
        else if ( msg == "slow")
        {
            llOwnerSay( "Slow speed");
            xfactor = 10.0;
            yfactor = 4.0;
            zfactor = 4.0;
            llListenRemove(handle);
        }
    }
    changed(integer change)
    {
        if (change & CHANGED_LINK)
        {          
            agent = llAvatarOnSitTarget();
         
            if (agent != NULL_KEY)
            {
                  llRequestPermissions(agent, PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS | PERMISSION_CONTROL_CAMERA);
                  llStartAnimation("Moto6 p4 loop");
                 
                  llTriggerSound("jetstartupfinal",1.0);
                  llLoopSound("jetloopfinal",1.0);
                  
                  init();               
                  camfixed(); 
                  llMessageLinked(LINK_SET,-1,"Tstart","");                
            }
            else 
            {                           
               llMessageLinked(LINK_SET,-1,"Tstop","");
               llTriggerSound("jetshutdownfinal",1.0);
               llSleep(0.2);
               release_camera_control();
               llReleaseControls();
               llResetScript();
            }
        }
    }
    run_time_permissions(integer perm)
    {
        if (perm)
        {
            llTakeControls(CONTROL_FWD | CONTROL_BACK | CONTROL_RIGHT | CONTROL_LEFT | CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT | CONTROL_UP | CONTROL_DOWN, TRUE, FALSE);
            
        }
    }
 
    control(key name, integer levels, integer edges)
    {
        if ((edges & levels & CONTROL_UP)) 
        {
            linear.z += zfactor;
        } 
        else if ((edges & ~levels & CONTROL_UP)) 
        {
            linear.z -= zfactor;
        }
        if ((edges & levels & CONTROL_DOWN)) 
        {          
            linear.z -= zfactor;
        } 
        else if ((edges & ~levels & CONTROL_DOWN)) 
        {
            linear.z += zfactor;
        }        
        if ((edges & levels & CONTROL_FWD)) 
        {          
            linear.x += xfactor;
        } 
        else if ((edges & ~levels & CONTROL_FWD)) 
        {
            linear.x -= xfactor;
        }
        if ((edges & levels & CONTROL_BACK)) 
        {           
            linear.x -= xfactor;
        } 
        else if ((edges & ~levels & CONTROL_BACK)) 
        {
            linear.x += xfactor;
        }
        
        if ((edges & levels & CONTROL_LEFT)) 
        {        
            linear.y += yfactor;                    
            llStartAnimation("Moto6_left_Remake1 p4 nl");
        }
        else if ((edges & ~levels & CONTROL_LEFT)) 
        {
            linear.y -= yfactor;            
        }
        if ((edges & levels & CONTROL_RIGHT)) 
        {          
            linear.y -= yfactor;           
            llStartAnimation("Moto6_right_Remake1 p4 nl");
        } 
        else if ((edges & ~levels & CONTROL_RIGHT)) 
        {
            linear.y += yfactor;
        }     
        if ((edges & levels & CONTROL_ROT_LEFT)) 
        {              
           
            angular.z += turn_rate;        
            angular.x -= PI * 3;
            llStartAnimation("Moto6_left_Remake1 p4 nl");           
        } 
        else if ((edges & ~levels & CONTROL_ROT_LEFT))
        {           
            angular.z -= turn_rate;               
            angular.x += PI * 3;           
        } 
        if ((edges & levels & CONTROL_ROT_RIGHT))
        {         
            angular.z -= turn_rate;
            angular.x += PI * 3;
            llStartAnimation("Moto6_right_Remake1 p4 nl");            
        } 
        else if ((edges & ~levels & CONTROL_ROT_RIGHT)) 
        {
            angular.z += turn_rate;
            angular.x -= PI * 3;
        }
        llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, linear);
        llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, angular);
    } 
} 
