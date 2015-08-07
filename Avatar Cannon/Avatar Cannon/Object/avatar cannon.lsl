// :CATEGORY:Cannon
// :NAME:Avatar Cannon
// :AUTHOR:Olly Butters
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:48
// :ID:69
// :NUM:96
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// This script moves an object via the avatars key strokes. It has a power variable which is controls the speed the avatar is shot.
// :CODE:

//Person Cannon v0.9.4
//Author: Olly Butters
//13 February 2007
//Part of the schome initiative. (www.schome.ac.uk)
//You may copy/edit this, but please credit us.
//This script moves an object via the avatars key strokes. It has a power variable which is controls the speed the avatar is shot.
//Controls:
//Left/Right - rotate cannon left/right 
//Forward/Back - rotate cannon up/down
//Up/Down - increase/decrease the power the avatar is shot out.
//Mouse-click - FIRE!!


//These are variables that could concievibly be altered.
float muzzle_velocity = 50;             //speed of the avatar
float angle_increment = 10;             //amount the cannon rotates by


//Nothing to edit below here at all, so don't even look!
integer no_of_inclination_moves = 0;    //keeps track of how much the cannon inclination
integer no_of_rotation_moves = 0;       //keeps track of the cannons rotation
integer first_touch = 0;                //keeps track of wether avatar is in the cannon
key id;                                 //avatar id.

//function to explain how to use.
instructions()
{
    llSay(0, "Hello.\n This is the person cannon - the best way to get around!\n To move the cannon use forward/back/left/right.\n To change the power of the cannon use up/down.\n\n To fire yourself click on the cannon.");
}

//function to specify the precision of a float when converted to a string
string fixedPrecision(float input, integer precision)
{
    if((precision = (precision - 7 - (precision < 1))) & 0x80000000)
        return llGetSubString((string)input, 0, precision);
    return (string)input;
}

default 
{
    state_entry() 
    {
        //sets up the initial position
        vector eul = <0, 0, 0>;
        eul *= DEG_TO_RAD; //convert to radians rotation
        rotation quat = llEuler2Rot( eul ); //convert to quaternion
        llSetRot(quat); //rotate the object 
        llSitTarget(<0,0,0.1>, ZERO_ROTATION); //this needs to be tweeked! shooting straight up is no longer straight up!
        llSetSitText("Climb in");//makes it say climb in istead of sit on in the pie menu.
    }

   
     
    //Move the cannon around and keeps track of the movement.
    control( key ida, integer held, integer change )  // event for processing key press
    {
        vector position = llGetPos();
        
        if ( change & held & (CONTROL_LEFT | CONTROL_ROT_LEFT) ) 
        {                         
            rotation new_rot = llGetRot()*llAxisAngle2Rot(<0,0,1>, angle_increment*DEG_TO_RAD);
            llSetRot(new_rot); 
            no_of_rotation_moves = no_of_rotation_moves+1;
        } 
        else if ( change & held & (CONTROL_RIGHT |CONTROL_ROT_RIGHT) ) 
        {  
            rotation new_rot = llGetRot()*llAxisAngle2Rot(<0,0,1>, -angle_increment*DEG_TO_RAD);
            llSetRot(new_rot); 
            no_of_rotation_moves = no_of_rotation_moves - 1;
        }
         else if ( change & held & CONTROL_FWD ) 
        {  
            rotation z_inc = llEuler2Rot( <0, angle_increment * DEG_TO_RAD, 0> );
            rotation new_rot =  z_inc*llGetRot();           
            
            llSetRot(new_rot);          
            
            no_of_inclination_moves = no_of_inclination_moves - 1;
        }
         else if ( change & held & CONTROL_BACK ) 
        {  
            rotation z_inc = llEuler2Rot( <0, -angle_increment * DEG_TO_RAD, 0> );
            rotation new_rot = z_inc*llGetRot();
            
            llSetRot(new_rot);          
            
            no_of_inclination_moves = no_of_inclination_moves + 1;
        }
         else if ( change & held & CONTROL_UP ) 
        {
              muzzle_velocity = muzzle_velocity + 50;
              string mv = "muzzle velocity=" + fixedPrecision(muzzle_velocity,0) + "m/s";
              llSay(0, mv);
        }
        else if ( change & held & CONTROL_DOWN ) 
        {
            muzzle_velocity = muzzle_velocity - 50;
            if(muzzle_velocity<0)
            {
                muzzle_velocity=0;
            }
            string mv = "muzzle velocity=" + fixedPrecision(muzzle_velocity,0) + "m/s";
            llSay(0, mv);
        }       
    }

    //Invoked when the avatar 'sits' on the cannon.
    //Explains how to use,
    //Sets a time limit,
    //Gets permission for stuff,
    //Moves the camera
    //changes 'first_touch' to 1 indicating that avatar is in the cannon.    
    changed(integer change) 
    {
        if (change & CHANGED_LINK)
        {
            instructions();
            llSetTimerEvent(60); //makes it reset itself after 1 minute
 //           integer number;
            id = llAvatarOnSitTarget();
    
            integer desired_controls =
                CONTROL_FWD |
                CONTROL_BACK |
                CONTROL_LEFT |
                CONTROL_RIGHT |
                CONTROL_ROT_LEFT |
                CONTROL_ROT_RIGHT |
                CONTROL_UP |
                CONTROL_DOWN;


             llRequestPermissions(id, PERMISSION_TAKE_CONTROLS );
             llTakeControls(desired_controls, TRUE, FALSE);
             llRequestPermissions(id,PERMISSION_CONTROL_CAMERA);

             llSetCameraParams([
                CAMERA_ACTIVE, 1, // 1 is active, 0 is inactive
                CAMERA_BEHINDNESS_ANGLE, 0.0, // (0 to 180) degrees
                CAMERA_BEHINDNESS_LAG, 0.0, // (0 to 3) seconds
                CAMERA_DISTANCE, 8.0, // ( 0.5 to 10) meters
                //CAMERA_FOCUS, <0,0,5>, // region relative position
                CAMERA_FOCUS_LAG, 0.05 , // (0 to 3) seconds
                CAMERA_FOCUS_LOCKED, FALSE, // (TRUE or FALSE)
                CAMERA_FOCUS_THRESHOLD, 0.0, // (0 to 4) meters
                CAMERA_PITCH, 00.0, // (-45 to 80) degrees
                //CAMERA_POSITION, <0,0,0>, // region relative position
                CAMERA_POSITION_LAG, 0.1, // (0 to 3) seconds
                CAMERA_POSITION_LOCKED, FALSE, // (TRUE or FALSE)
                CAMERA_POSITION_THRESHOLD, 0.0, // (0 to 4) meters
                CAMERA_FOCUS_OFFSET, <3,0,2> // <-10,-10,-10> to <10,10,10> meters
                ]);
           
            first_touch=1; //indicates that am inside
        }
    }
    
    //If touching from the outside it explains that you have to get inside to use it. If touching from the inside it shoots.
    touch(integer dave)
    {
        if(first_touch==0)
        {
            llSay(0, "Hello.\n This is the person cannon - the best way to get around!\n To use me simply right click, climb inside and follow the instructions.");
        }
        else
        {
            
            llUnSit(id);
            llPushObject(id,  <muzzle_velocity*llCos(no_of_rotation_moves*angle_increment*DEG_TO_RAD)*llCos((no_of_inclination_moves*angle_increment)*DEG_TO_RAD),
                               muzzle_velocity*llSin(no_of_rotation_moves*angle_increment*DEG_TO_RAD)*llCos((no_of_inclination_moves*angle_increment)*DEG_TO_RAD),
                               muzzle_velocity*llSin((no_of_inclination_moves*angle_increment)*DEG_TO_RAD)>, <1,1,1>, FALSE);
            llSleep(2);
            llResetScript();
        }                                               
    }
    
    
    //resets the script
    timer()
    {
        llSay(0, "You've had your fun, script resetting.");
        llResetScript();
    }   
        
}
// END //


