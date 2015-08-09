//Final code and animations and sounds by Christy Lock OSGRID 4/23/2014
//Maegan OMally standalone alt may be listed also

//Special Thanks to Robert Adams and all those who worked on BulletSim!
//BulletSim Required for this to work
//Thanks to Cory and ANdrew Linden as their work and instructions contributed to this code

//EVERYTHING in the scooter is opensource free to use as you like


integer debug = FALSE;

DEBUG(string msg) {
    if (debug) llSay(0,llGetScriptName() + ":" + msg);
}

 
integer LINK_CMD = 0;
integer LINK_ANIMATE = 1;
integer LINK_POSITION   = 2;
integer LINK_RL = 3;
integer LINK_UP = 4;
integer LINK_DOWN = 5;
integer LINK_SPEED = 6;

float LR = 10.0;    // mutiplier for Left/right

//if the root primitive of your airplane does not have the same orientation as the whole airplane 
//(i.e. local x-axis = forward, local y-axis = left, local z-axis = up) then the script will not push
//your airplane in the "correct" direction. 
//
//You need to either: 
//
//1. orient your root primitive to agree with the airplane's axes of motion 
//2. pick a different primitive to be the root (one whose local axes agree with those of the airplane's motion) 
//3. use the VEHICLE_REFERENCE_FRAME parameter (this is an advanced topic and is outside the scope of a _simple_ airplane script) 



float forward_power = 35.0; //Power used to go forward 
float reverse_power = -25.0; //Power ued to go reverse
float turn_rate = 15.0;//rotation (twist) around angular.z 

vector linear;
vector angular;

float xfactor ;//Normal velocity all three axis
float yfactor ;
float zfactor ;




init()
{

        
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



 
default
{
    state_entry()
    {
        llSetStatus(STATUS_PHYSICS, FALSE);
        xfactor = 28.0;
        yfactor = 8.0;
        zfactor = 12.0;
    }



    link_message(integer sender_number, integer number, string message, key id)
    {
        //DEBUG("N:" + (string) number + ":" + message);        

        if (number  == LINK_CMD && message == "cStart") {
            
            llSetStatus(STATUS_PHYSICS, TRUE);
            llSleep(.01);
            init();

            
        
        } else if (number  == LINK_CMD && message == "cStop") {
            // stop the motors
            linear = <0, 0, 0>;
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, linear);
            llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, linear);

            // use friction to stop the vehicle rather than pinning it in place
            llSetStatus(STATUS_PHYSICS, FALSE);
            llSetVehicleFloatParam(VEHICLE_LINEAR_FRICTION_TIMESCALE,5.0);
            llSetVehicleFloatParam(VEHICLE_ANGULAR_FRICTION_TIMESCALE, 1.0);
            
        } else if (number == LINK_SPEED){
                                   
            if (linear.x < 40)    // maximum of 40 from the wiki
                linear.x += (float) message;
            
            if (linear.x < 0)
                 linear.x = 0;       
            
             DEBUG("SPEED:" + (string) linear.x );

            
        } else if (number == LINK_RL) {
                        
            //  from 0 to PI which is behind you
            float angle = (float) message; 
            DEBUG("Angle:" + (string) angle);
           
            if( angle >  0) {
                angular.z -= turn_rate;               
                angular.x += PI * 3;
                DEBUG("Left:" + (string) angular.x);
            } else  {
                angular.z += turn_rate;
                angular.x -= PI * 3;
                DEBUG("Right:" + (string) angular.x);                
            }
                                            
        } else if (number == LINK_UP) {
            DEBUG("Z:" + (string) linear.z);
            linear.z += zfactor;
        } else if (number == LINK_DOWN) {
            DEBUG("Z:" + (string) linear.z);
            linear.z -= zfactor;

        }



        llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, linear);
        llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, angular);
    }


    
} 