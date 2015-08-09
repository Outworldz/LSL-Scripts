// :CATEGORY:Pet
// :NAME:Moving_Tentacle
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:57
// :ID:528
// :NUM:713
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Moving Tentacle.lsl
// :CODE:

default
{
    state_entry()
    {
        llSensorRepeat("",NULL_KEY,AGENT,10,PI,1.0);
    }

    sensor(integer num)
    {
        key target = llDetectedKey(0);
        vector mypos = llGetPos();
        vector targetpos = llDetectedPos(0);
        vector test = llVecNorm(targetpos-mypos);
        llSetPrimitiveParams([PRIM_FLEXIBLE, TRUE, 3,0.55,0.0,0.0,5.0,test]);
        //llOwnerSay("Test: " + (string)test);
        
    }
    no_sensor()
    {
       key target = llDetectedKey(0);
        vector mypos = llGetPos();
        vector targetpos = llDetectedPos(0);
        vector test = llVecNorm(targetpos-mypos);

 llSetPrimitiveParams([PRIM_FLEXIBLE, FALSE, 3,0.5,0.0,0.0,1.0,test]);
    }
    link_message(integer sn, integer num, string str, key id)
    {
        if(str == "OFF")
        {
            state off;
        }
    }
}

state off
{
      state_entry()
    {
        key target = llDetectedKey(0);
        vector mypos = llGetPos();
        vector targetpos = llDetectedPos(0);
        vector test = llVecNorm(targetpos-mypos);
           
        llSensorRemove();
        llSetPrimitiveParams([PRIM_FLEXIBLE, FALSE, 3,0.5,0.0,0.0,1.0,test]);
    }
    
    link_message(integer sn, integer num, string str, key id)
    {
        if(str == "ON")
        {
            state default;
        }   
    } 
}// END //
