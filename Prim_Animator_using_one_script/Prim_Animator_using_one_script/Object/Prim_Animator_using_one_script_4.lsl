// :CATEGORY:Prim
// :NAME:Prim_Animator_using_one_script
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2010-10-23 21:23:45.047
// :EDITED:2013-09-18 15:39:00
// :ID:649
// :NUM:884
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Animated pet script requires recorded animatrions for left, stand , right, sit, wag// // You need to pre-record 5 animations to use this script:// // 'right' should put the right legs forward, as when walking, and 'left' should do the opposite.// 'sit should be the animal sitting down, or begging.
// 'stand' should be the position the animal is in when walking, with legs in a standing position.
// 'wag' is the tail wagging back and forth.
// :CODE:
////////////////////////////////////////// CUT HERE ////////////////////////////////////////////
// pet that wanders 


vector start_pos;
integer what;
vector Destination;
float roam_range = 10;
float STRENGTH = 4.0;  // how hard to turn, bigger = ?
float DAMPING = 0.2;    // and how soon
vector direction = <3,0,0>; // push 3 
vector last_pos = <0,0,0>;  // save last position so we can detect when to walk

list buttons = ["Sit","Stand","Wag","Range","Home","Help"];
integer listener;           // handle for menus to use
key Owner;                    // you
integer channel;            // random channel for listener

tMenu()
{
    channel = llCeil(llFrand(10000) + 876);
    listener = llListen(channel,"","","");
    llDialog(Owner,"Choose an item",buttons,channel);
}

// sets up the vehicle as a car
Physics()
{
    llSetBuoyancy(0.0);
    llSetVehicleFlags(-1);
    llSetVehicleType(VEHICLE_TYPE_CAR);
    llRemoveVehicleFlags(VEHICLE_FLAG_LIMIT_MOTOR_UP | VEHICLE_FLAG_LIMIT_ROLL_ONLY);
    llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 0.8);
    llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 0.8);
    llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, .1);
    llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_TIMESCALE, .1);
    llSetVehicleFloatParam(VEHICLE_HOVER_EFFICIENCY, 0.8);  // hover 
    llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_TIMESCALE, .1);
    llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, .1);
    llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_TIMESCALE, .1);
    llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, .1);
    llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <1.0, .1, 1000.0>);
    llSetVehicleVectorParam(VEHICLE_ANGULAR_FRICTION_TIMESCALE, <.1, .1, .1>);
    llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, .8);
    llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, .1);
    llSetVehicleFloatParam(VEHICLE_BANKING_EFFICIENCY, 0.25);
    llSetVehicleFloatParam(VEHICLE_BANKING_TIMESCALE, 0.1);
    
}

// points the animal in the correct diriction and give it a walk-like push
DoMove()
{
    llStopLookAt();
    llRotLookAt(llRotBetween(<1,0,0>, Destination - llGetPos()), STRENGTH, DAMPING);
    llSleep(DAMPING*3);
    llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, 1 * direction);
    llSleep(0.1);
    llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, ZERO_VECTOR);

}

// get a new destination
next_move()
{
     // random direction
    Destination = llGetPos();
    Destination.x += llFrand(roam_range);
    Destination.y += llFrand(roam_range);
}

DoMenu(string msg)
{
    if (msg == "Sit")
    {
       llMessageLinked(LINK_SET,1,"sit","");
       llListenRemove(listener);
    }
    else if (msg == "Wag")
    {
        llMessageLinked(LINK_SET,1,"wag","");
        llListenRemove(listener);
    }
    else if (msg == "Stand")
    {
        llMessageLinked(LINK_SET,1,"stand","");
        llListenRemove(listener);
    }
    else if (msg == "Range")
    {
        llDialog(Owner,"Range from Home:",["5","10","15","20","25","30","40","50","75"],channel);
    }
    else if (msg == "Home")
    {
        start_pos = llGetPos(); // remember our home
        llListenRemove(listener);
        llOwnerSay("Home is set, wander distance is set to " + (string) roam_range + " meters");
    }
    else if (msg == "Help")
    {
        llLoadURL(Owner,"Click for Help", "http://secondlife.mitsi.com/Secondlife/Posts/Prim-Animator");
        llListenRemove(listener);
    }
    else 
    {
        roam_range = (float) msg;
        llOwnerSay("Range set to " + (string) roam_range + " meters");
        llListenRemove(listener);
    }

}



// startup state where we sit, stand and wag tail
default
{
    state_entry()
    {
        Owner = llGetOwner();
        llOwnerSay("Range set to " + (string) roam_range + " meters");
        llOwnerSay("Home set here");
        llOwnerSay("Click me for help");
        start_pos = llGetPos(); // remember our home
        
        state sitting;
    }
}

state sitting
{
    state_entry()
    {
        llSetStatus(STATUS_PHYSICS, FALSE);
        llSetTimerEvent(5);
    }
    
    listen(integer channel,string name, key id, string msg)
    {
        DoMenu(msg);
    }
        
    touch_start(integer n)
    {
       if (llDetectedKey(0) == Owner)
            tMenu();
    }
    
    timer()
    {
       if (what++ %2 == 0)
       {
            llMessageLinked(LINK_SET,1,"stand","");
            llMessageLinked(LINK_SET,1,"wag","");
        }
        else
        {
            llMessageLinked(LINK_SET,1,"sit","");
        }
       
        if (what > 2)
        {
            what = 0;
            state  moving;
        }
    }
    on_rez(integer p)
    {
        llResetScript();
    }
}

// walking around
state moving
{
    state_entry()
    {
        
        Physics();              
        llMessageLinked(LINK_SET,1,"stand",""); // stand on all 4's
        llSetStatus(STATUS_PHYSICS, TRUE);      // get ready to move
        llSetTimerEvent(0.1);
    }
    
    listen(integer channel,string name, key id, string msg)
    {
        DoMenu(msg);
    }
    
    touch_start(integer n)
    {
        if (llDetectedKey(0) == Owner)
            tMenu();
    }

    
    timer()
    {
        DoMove();
        
        if (llVecDist(last_pos, llGetPos()) > .1)
        {
            llMessageLinked(LINK_SET,1,"left",""); // left foot forward
            llMessageLinked(LINK_SET,1,"stand",""); // stand on all 4's
            llMessageLinked(LINK_SET,1,"right",""); // right foot forward
            llMessageLinked(LINK_SET,1,"stand",""); // stand on all 4's
            last_pos = llGetPos();
        }
        if (llVecDist(start_pos,llGetPos()) > roam_range)
            Destination = start_pos;
        
        if (llVecDist(start_pos,llGetPos()) < .5)       // at home
            state sitting;
    
        if (llVecDist(Destination,llGetPos()) < .2)     // at destination
            next_move();
            
       
        
    } 
    
    on_rez(integer p)
    {
        llResetScript();
    }
    
}
