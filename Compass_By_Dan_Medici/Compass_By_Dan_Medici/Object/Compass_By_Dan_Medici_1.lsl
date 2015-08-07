// :CATEGORY:Compass
// :NAME:Compass_By_Dan_Medici
// :AUTHOR:Dan Medici
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:51
// :ID:200
// :NUM:273
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Compass By Dan Medici.lsl
// :CODE:

// Compass By Dan Medici
//Description: This script finds the cardinal direction that an object is currently pointing towards, and sets it in text above the object that the script is in.

//Edit: Now fixed to work even when avatar is standing still.

//How to use: Put inside an object either attached to your avatar or on a moving object.





default
{
    state_entry()
    {
        llSetTimerEvent(0.1); // set a timer event for every tenth of a second
    }
    
    timer()
    {
        string direction; // this is the variable we will set the text with
        vector vel = llRot2Fwd(llGetRot());// get the current velocity
        integer x = llRound(vel.x); // round the x value of the velocity and assign it to a new variable
        integer y = llRound(vel.y); // round the y value of the velocity and assign it to a new variable
        
        
        //Keep in mind the following when reading the following part of this script: when one travels perfectly east at a speed of 1.0, their velocity is <1.0,0,0>. Therefore, if they were traveling west,
        //it would be <-1.0,0,0>. If they were traveling north, it would be <0.0,1.0,0.0>. If they were traveling south, it would be <0.0,-1.0,0.0>. We dont deal with the Z value of the velocity at all
        //because cardinal directions are based on a two-dimensional coordinate plane.
        if((llAbs(x) > llAbs(y)) && (x > 0)) // if the absolute value of X is greater than Y, then we are traveling mostly east or west. If X is positive, then we are traveling east.
        {
                direction="East";
        }
        else if((llAbs(x) > llAbs(y)) && (x < 0)) // if the absolute value of X is greater than Y, then we are traveling mostly east or west. If X is negative, then we are traveling west.
        {
            
                direction = "West";
        }
        else if((llAbs(y) > llAbs(x)) && (y > 0)) // if the absolute value of Y is greater than X, then we are traveling mostly north or south. If Y is positive, then we are traveling north.
        {
            
                direction = "North";
        }
         else if((llAbs(y) > llAbs(x)) && (y < 0)) // if the absolute value of Y is greater than X, then we are traveling mostly north or south. If Y is negative, then we are traveling south.
        {
           
                direction = "South";
        }
         else if((llAbs(y) == llAbs(x)) && (x > 0 && y > 0)) // if the absolute value of Y is equal to X, then we are in an intermediate direction. If both X and Y are positive, then we are traveling nort                                                             //heast, because EAST is positive on the X axis and north is positive on the Y axis.
        {
           
                direction = "Northeast";
        }
        else if((llAbs(y) == llAbs(x)) && (x < 0 && y > 0)) // if the absolute value of Y is equal to X, then we are in an intermediate direction. If X is negative and Y is positive, then we are traveling                                                              //northwest
        {
           
                direction = "Northwest";
        }
        else if((llAbs(y) == llAbs(x)) && (x < 0 && y < 0)) // if the absolute value of Y is equal to X, then we are in an intermediate direction. If X is negative and Y is negative, then we are traveling                                                              //southwest
        {
           
                direction = "Southwest";
        }
        else if((llAbs(y) == llAbs(x)) && (x > 0 && y < 0)) // if the absolute value of Y is equal to X, then we are in an intermediate direction. If X is positive and Y is negative, then we are traveling                                                            //southeast
        {
           
                direction = "Southeast";
        }
        else // not moving
        {
            direction = "Stationary";
        }
        llSetText(direction, <1,1,1>, 1.0); // set text on the object to what direction we are moving in
    }
}
   // END //
