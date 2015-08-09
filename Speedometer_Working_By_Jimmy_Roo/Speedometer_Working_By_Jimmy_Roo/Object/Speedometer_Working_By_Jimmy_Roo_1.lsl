// :CATEGORY:Speedometer
// :NAME:Speedometer_Working_By_Jimmy_Roo
// :AUTHOR:Jimmy Roo
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:05
// :ID:821
// :NUM:1131
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Speedometer Working By Jimmy Roo.lsl
// :CODE:

// Speedometer Working By Jimmy Roo
//Here is a Speedometer I made this morning, because I got bored. It will Give your speed in KPH, rounded to the nearest KPH. It works by subtracting the x, y, z values of the current pos, and the pos from 0.5 seconds ago. it then works out the horizontal distance traveled,


//square root of (square root of( (x1*x2) + (y1*y2) ) * square root of ( z1 * z2 )))




vector current;
vector new;
float xvalue;
float yvalue;
float zvalue;

default
{
    state_entry()
    {
        vector current = llGetPos();
        llSetTimerEvent(0.5);
    }
    
    timer()
    {
        new = llGetPos();
        if ( new. x < current .x)
        {
 xvalue = current .x - new .x;
        }
        if ( new .x > current .x)
        {
         xvalue =  new .x - current .x ;
        }
          if ( new .x == current .x)
        {
         xvalue =  new .x - current .x ;
        }
        
        
                if ( new.y < current .y)
        {
 yvalue = current .y  - new .y  ;
        }
        if ( new .y > current .y)
        {
         yvalue =  new .y - current .y ;
        }
         if ( new .y == current .y)
        {
         yvalue =  new .y - current .y ;
        }
        
        
                        if ( new.z < current .z)
        {
 zvalue = current .z  - new .z  ;
        }
        if ( new .z > current .z)
        {
         zvalue =  new .z - current .z ;
        }
         if ( new .z == current .z)
        {
         zvalue =  new .z - current .z ;
        }
        
        float beforevalue = llSqrt((yvalue * yvalue) + (xvalue * xvalue));
        float aftervalue =  llSqrt((beforevalue * beforevalue) + (zvalue * zvalue));
        
        llSetText((string)llRound((7.2 * aftervalue)) + " kph", <1,0,0>, 1);
        current = new;
    }
 
}// END //
