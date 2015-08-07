// :CATEGORY:Door
// :NAME:swing
// :AUTHOR:Eloise Pasteur
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:06
// :ID:859
// :NUM:1196
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// swing.lsl
// :CODE:

// Swing script by Eloise Pasteur.
// Sold full perms by her - but please make at LEAST no mod before you pass it on
// Please only pass on in items for sale, not as the bare script.
// This script is as end-user friendly as possible. Moving the swing will make it reset to it's new position and orientation. Occasionally JUST rotating it won't work, so in that case you will need to nudge it sideways just a little (1mm will do). This is a quirk of LSL and it intermittent.
// Put this script in the pivot - the thing the swing swings around (it doesn't have to be a long rod). That needs to be the root of the prim set that actually swings - if you want/need a frame that needs to be a separate item. SL doesn't yet allow us hierarchical linking.

// Play with these bits - the orange comments tell you what's going on with each line I hope.

integer swing=FALSE;        //So it starts out NOT swinging
float time=0.4;             //Decreasing this (on it's own) makes the swing move FASTER and vice versa
integer steps=5;           //The total number of steps in the swing's path. More steps=smoother swing. More steps (alone) means slower swing too - time for a complete swing cycle is steps * time (so 4.8 s with the default settings).
integer swingDegrees = 20;  //How far from the vertical the swing moves

//If you play from here on down you might break the script. Do so at your own risk. There are no comments - just to encourage you NOT to play.

integer i=1;
float swingRad;
vector normal;

rotation Inverse(rotation r)
{
    r.x = -r.x;
    r.y = -r.y;
    r.z = -r.z;
    return r;
}
rotation GetParentRot()
{
    return Inverse(llGetLocalRot())*llGetRot();  
}
SetLocalRot(rotation x)
{
    llSetRot(x*Inverse(GetParentRot()));
}

default 
{
    state_entry()
    { 
        normal = llRot2Euler(llGetRot());
        swingRad=DEG_TO_RAD*swingDegrees;
        llSetTouchText("Swing");
    }
    touch_start(integer num)
    {
        if(swing)
        {
            swing=FALSE;
            llSetTouchText("Swing");
        }
        else
        {
            swing=TRUE;
            llSetTouchText("Stop Swing");
            llSetTimerEvent(time);
        }
    }
    timer()
    {
        float stepOffset=(float)i/steps*TWO_PI;
        if(i>steps) i=1;
        if(swing==FALSE && (i==steps || i==steps/2))
        {
            llSetTimerEvent(0.0);
            SetLocalRot(llEuler2Rot(<normal.x, normal.y, normal.z + swingRad*llSin(stepOffset)>));
        } else
        {
            SetLocalRot(llEuler2Rot(<normal.x, normal.y, normal.z + swingRad*llSin(stepOffset)>));
            i++;
        }
    }
    moving_end()
    {
        normal=llRot2Euler(llGetRot());
    }
}// END //
