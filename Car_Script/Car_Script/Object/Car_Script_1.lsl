// :CATEGORY:Vehicles
// :NAME:Car_Script
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:50
// :ID:154
// :NUM:222
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Car Script.lsl
// :CODE:

float theta_func()
{
    if (speed < 1) return 0.02;
    if (speed < 4) return 0.1;
    if (speed < 6) return .4;
    if (speed < 10) return .6;
    if (speed < 15) return .5;
    if (speed < 20) return .5;
    if (speed < 25) return .4;
     return .3;
    
}  

float power_curve()
{
    if (speed < 1) return 15.0;
    if (speed < 4) return 15.0;
    if (speed < 6) return 15.0;
    if (speed < 10) return 15.0;
    if (speed < 15) return 10.0;
    if (speed < 20) return 4.0;
    if (speed < 30) return 2.0;
    return 2.0;
}
 

float THROTTLE = 1.2;
float STEERING = 1;
float TIMER = .05;
float ANGULAR_TAU = .1;            // decrease for faster turn
float ANGULAR_DAMPING = 3;        // not sure what this should be yet
float THETA_INCREMENT = 0.05;        // increase for bigger turn response


//float C_FRICTION = 40;
//float FRONTAL_AREA = 20;
//float TOT_FRICTION;


float mass;
float speed;
vector velocity;


float turn;
float counter = 0;
float brake = 1;
// linear constants


integer a = 10;


integer LEVELS = 0;                 // we'll set this later

// global variables
vector gTargetPos;
float gTargetTheta;
key gToucher;


default
{
    state_entry()
    {
        llSay(0,"car starting");
        llSetStatus(STATUS_PHYSICS, FALSE);
        llSetStatus(STATUS_ROTATE_X | STATUS_ROTATE_Y, FALSE);
        llCollisionFilter("", "", TRUE);
        llStopSound();
        mass = llGetMass();
        
        
        llSleep(0.1);
        //SetHoverHeight(1,1,10);
        llSetStatus(STATUS_ROTATE_X | STATUS_ROTATE_Y | STATUS_ROTATE_Z , TRUE);
        
        llMoveToTarget(llGetPos() + <0,0,1>, 0);
        llRotLookAt(llGetRot(), 0, 0);
        
        
        LEVELS = CONTROL_FWD | CONTROL_BACK | CONTROL_ROT_LEFT | CONTROL_ROT_RIGHT | CONTROL_UP | CONTROL_DOWN | CONTROL_LEFT | CONTROL_RIGHT;
    }
    
    
    touch_start(integer total_number)
    {
        
        llStopSound();
        gToucher = llDetectedKey(0);
        integer perm = llGetPermissions();
        
        
        if (perm)
        {
            llReleaseControls();
        }
        else
        {
            state StateDriving;
        }
    }
}

state StateDriving
{
    state_entry()
    {
        llSetTimerEvent(TIMER);
        brake = 1;
        
        llSetStatus(STATUS_PHYSICS, TRUE);
        llSetStatus(STATUS_ROTATE_X | STATUS_ROTATE_Y | STATUS_ROTATE_Z , TRUE);
        llWhisper(0, "StateDriving");
        //llSetHoverHeight(a,1,.4);
        llRequestPermissions(gToucher, PERMISSION_TAKE_CONTROLS);
        //llMoveToTarget(llGetPos(), LINEAR_TAU);
        llRotLookAt(llGetRot(), ANGULAR_TAU, 1.0);        
    }
    touch_start(integer total_number)
    {
        llWhisper(0, "Touched.");
        integer perm = llGetPermissions();
        if (perm)
        {
            llReleaseControls();
        }
        state default;
    }
    run_time_permissions(integer perm)
    {
        if (perm == PERMISSION_TAKE_CONTROLS)
        {
            llTakeControls(LEVELS, TRUE, FALSE);        }
        else
        {
             state default;
        }
    }
    control(key driver, integer levels, integer edges)
    {
//llWhisper(0, "l = " + (string)levels + "  e = " + (string)edges);
        // linear control
        //llSetHoverHeight(a,1,.4);
        
        integer nudge = FALSE;
        float direction = 0;
        gTargetTheta *= theta_func();
        
        
        if (levels & CONTROL_FWD)
        {
            direction = 1;
            brake = 0;
        }
        if (levels & CONTROL_BACK)
        {
            direction = -.1;
            brake = 5;
            gTargetTheta *= 2;
        }
        if (levels & CONTROL_LEFT)
        {
            
        }
        if (levels & CONTROL_RIGHT)
        {
           
        }
        if (levels & CONTROL_UP)
        {
            a +=1;
        }
        if (levels & CONTROL_DOWN)
        {
           a-=1;
        }
        // angular control
        if (levels & CONTROL_ROT_LEFT)
        {
            if (gTargetTheta < 0)
            {
                gTargetTheta = 0;
            }
            else
            {
                gTargetTheta += THETA_INCREMENT;
            }
            nudge = TRUE;
        }
        if (levels & CONTROL_ROT_RIGHT)
        {
            if (gTargetTheta > 0)
            {
                gTargetTheta = 0;
            }
            else
            {
                gTargetTheta -= THETA_INCREMENT;
            }
            nudge = TRUE;
        }
        
        if (direction)
        {
            //sound control
            if (speed < 24) { llLoopSound("car accel", .4);}
            else { llLoopSound("car go",.4); }
            
            //applies forward boost
            
           // llSay( 0, (string) power + "  " + (string) direction + "  " + (string) mass + (string) power_curve() + (string) theta_func() );
            
            
            llApplyImpulse( <1,0,0> * direction * mass * power_curve()* THROTTLE , 1);
            
        }
    
        if (direction == 0)
        
        {llLoopSound("geardown", .4);
        }
        
        if (nudge)
        {
                
            // angular motion -- we compute the raw quaternion about z-axis
            counter++;
            float st = 0.5 * llSin(gTargetTheta*STEERING);
            float ct = 0.5 * llCos(gTargetTheta*STEERING);
            rotation rot = <0,0,st, ct> * llGetRot(); 
            llRotLookAt(rot, ANGULAR_TAU, ANGULAR_DAMPING);
        }
        
        else {counter = 0;}
    }

land_collision(vector position)
    {
      //llApplyImpulse( <0,0, .5> * mass, 1 );
     }

    
collision (integer total_number)
    {
      // llWhisper( 0, "collision 2");
       //llSetHoverHeight(4,1,.2);
    }
    

timer() //side ways supression
    {
    
      vector pos = llGetPos();
       
     if (llGround(<0,0,0>) > (pos.z - 3) )
    {
        velocity = llGetVel();
        speed = llVecMag(velocity);
        
        float l_speed = llRot2Left( llGetRot() ) * velocity;
        float f_speed = llRot2Fwd( llGetRot() ) * velocity;
      
      
        if (  l_speed > 8 || (brake > 1 && speed > 8) )   llTriggerSound("tires burn",10);
        if (speed < 1) llStopSound();
        
        
        if (counter * speed > 100)
        { 
         l_speed /= 4;
         brake = 2;
        }
        if (speed > 4) brake = 2;
        f_speed *= brake;
        
      
        llApplyImpulse( <0,-1,0> * l_speed * mass *.8, 1 );
        llApplyImpulse( <-1,0,0> * f_speed * mass *.05, 1 );
       }
     
    }
        
}

// END //
