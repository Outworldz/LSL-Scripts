// :CATEGORY:Useful Subroutines
// :NAME:integer_left_or_rightvector_baselin
// :AUTHOR:LSL Wiki
// :CREATED:2010-02-01 16:09:36.567
// :EDITED:2013-09-18 15:38:55
// :ID:401
// :NUM:557
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// integer_left_or_rightvector_baselin
// :CODE:
integer left_or_right(vector baseline, vector target)
{
    //Returns whether the target vector is to the left or right of the baseline vector
    //returns 0
    //straight ahead = 0 (baseline == target)
    //left  = 1
    //right = -1
    //directly behind = 2
    if (llVecNorm(baseline) == llVecNorm(target))
    {
        return 0;
    }
    if (llVecNorm(baseline) == llVecNorm(target) * -1)
    {
        return 2;
    }
    rotation rot_between = llRotBetween(baseline,target);
    vector euler_rot = llRot2Euler(rot_between);
    float z_rot = euler_rot.z;
    if (z_rot > 0)
    {
        return 1;
    }
    else
    {
        return -1;
    }    
}

//Example uses
default
{
    state_entry()
    {
        llOwnerSay("Left or Right example");
    }

    touch_start(integer total_number)
    {
        llOwnerSay("Detecting Avatar");
        llSensor("","",AGENT,60,PI);
    }
    sensor(integer num)
    {
        
        //Is the detected avatar to the left or the right of this object's current heading
        integer target_L_or_R = left_or_right(llRot2Fwd(llGetRot()),llDetectedPos(0) - llGetPos());     
        if (target_L_or_R == 1)
        {
            llOwnerSay("Avatar is to the left of me");
        }
        else
        {
            llOwnerSay("Avatar is to my right");
        }     
        
          
        //In relation to the object's heading, is the detected avatar facing to the left or right?
        integer moving_L_or_R = left_or_right(llRot2Fwd(llGetRot()),llRot2Fwd(llDetectedRot(0)));  
        if (moving_L_or_R == 1)
        {
            llOwnerSay("Avatar is facing to my left");
        }
        else
        {
            llOwnerSay("Avatar is facing to my right");
        }      
    }
}
