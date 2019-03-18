// :CATEGORY:Animal
// :NAME:Zombies
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-03-06 15:24:19.483
// :EDITED:2013-09-18 15:39:11
// :ID:993
// :NUM:1488
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// See the article on <a href="http://www.outworldz.com/secondlife/posts/zombie">Zombies</a> to make this walking zombie
// :CODE:
// Animated wandering rideable zombie script.
// by Fred Beckhusen (Ferd Frederix)
//  Sets Home point where rezzed.
//  Will drive around like a vehicle so it works on most surfaces.

// Sounds:
// footstepmuffled when walking
// Zdeath when clicked
// Monster2 and Monster1 sounds when it reaches a destination

// Some tunables:

integer debug = FALSE;

float forward_power = 3; //Power used to go forward (1 to 30), massive objects may need larger number
float reverse_power = -2; //Power ued to go reverse (-1 to -30)
float turning_ratio = .5; //How sharply the vehicle turns. Le
vector start_pos;          // home point     

vector Destination;        // we head thataway
float roam_range = 10;     // and go no furtherfrom home than this
float STRENGTH = 4.0;  // how hard to turn, bigger = ?
float DAMPING = 0.2;    // and how soon
vector direction = <6,0,0>; // push 3
vector last_pos = <0,0,0>;  // save last position so we can detect when to walk
vector curpos;            // you are here
list buttons = ["Range","Home","Help"];
integer listener;           // handle for menus to use
key Owner;                    // you
integer channel;            // random channel for listener
integer counter = 0;       // l-r walk counter
key agent ;
float FORCE = 1;            // bigger numbers make us move faster
integer timeout;            // give us the gas if we are late


DEBUG(string str)
{
    if (debug)
    llOwnerSay(str);
}
// talk Menu to the client

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
    llSetVehicleFloatParam(VEHICLE_HOVER_EFFICIENCY, 0.8);  // hover for lightnes on massive objects
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
    llPlaySound("footstepmuffled",1.0);
    llRotLookAt(llRotBetween(<1,0,0>, Destination - llGetPos()), STRENGTH, DAMPING);
    llSleep(DAMPING*3);
    llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, FORCE * direction);
    llSleep(0.1);
    llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, ZERO_VECTOR);

}

// get a new destination
next_move()
{
    // random direction and height        // we will ignore Y
    Destination = llGetPos();
    Destination.x += llFrand(roam_range *2 ) - roam_range;    // +/- roam range
    Destination.y += llFrand(roam_range *2 ) - roam_range;
}

DoMenu(string msg)
{

    if (msg == "Range")
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

integer score;

// startup state where we sit, stand and wag tail
default
{
    state_entry()
    {
         llSetStatus(STATUS_PHYSICS, FALSE);

        Owner = llGetOwner();
        llOwnerSay("Range set to " + (string) roam_range + " meters");
        llOwnerSay("Home set to this spot");
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


        llOwnerSay("Animation test");
        llOwnerSay("stand");
        llMessageLinked(LINK_SET,1,"stand","");
        llSleep(1);

        llOwnerSay("attack");
        llMessageLinked(LINK_SET,1,"attack","");
        llSleep(1);

        llOwnerSay("walking");
        llMessageLinked(LINK_SET,1,"stand","");
        llMessageLinked(LINK_SET,1,"left","");
        llSleep(0.5);
        llMessageLinked(LINK_SET,1,"right","");
        llSleep(0.5);
        llMessageLinked(LINK_SET,1,"left","");
        llSleep(0.5);
        llMessageLinked(LINK_SET,1,"right","");
        llSleep(0.5);


        llOwnerSay("hit");
        llMessageLinked(LINK_SET,1,"hit","");
        llSleep(1);

        llOwnerSay("bighit");
        llMessageLinked(LINK_SET,1,"stand","");
        llMessageLinked(LINK_SET,1,"bighit","");
        llSleep(2);
        llMessageLinked(LINK_SET,1,"die","");
        llSleep(2);

        llMessageLinked(LINK_SET,1,"stand","");
        llOwnerSay("Test end");

        state  moving;
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
        llSetTimerEvent(0.5);
    }

    listen(integer channel,string name, key id, string msg)
    {
        DoMenu(msg);
    }

    touch_start(integer n)
    {
        if (llDetectedKey(0) == Owner)
            tMenu();
            
           
        if (llFrand(5.0)  < 3)
        {
            llPlaySound("Zdeath",1.0);
            llMessageLinked(LINK_SET,1,"hit",""); // smack it
            score++;
        }
        else
        {
            llPlaySound("Zdeath",1.0);
            llMessageLinked(LINK_SET,1,"hit",""); // smack it
            score+=3;
        }

        llSleep(1);
        llMessageLinked(LINK_SET,1,"stand","");

        if (score > 10) 
        {
            llMessageLinked(LINK_SET,1,"die","");
            llSleep(20.0);
            llMessageLinked(LINK_SET,1,"stand","");
            score = 0;
        }
    }


    timer()
    {
        DoMove();


        if (llVecDist(last_pos, llGetPos()) > .1)
        {
            
            llMessageLinked(LINK_SET,1,"left",""); // left foot forward
            llSleep(.3);
            llMessageLinked(LINK_SET,1,"right",""); // right foot forward;
            last_pos = llGetPos();
        }
        
        if (llVecDist(start_pos,llGetPos()) > roam_range + 2)
        {
            DEBUG("too far");
            timeout++;
            Destination = start_pos;
            FORCE = timeout /2;
            llPlaySound("Monster2",1.0);
            llMessageLinked(LINK_SET,1,"attack","");
        }
        else
        {
            timeout = 0;
            FORCE = 1;
        }

        if (llVecDist(start_pos,llGetPos()) < .5)       // at home
        {
            DEBUG("at home");
            llPlaySound("Monster2",1.0);
            llMessageLinked(LINK_SET,1,"attack","");

            next_move();
        }
        vector myPos = llGetPos();
        
        if (llVecDist(,myPos) < .5)     // at destination in X and Y only
        {
            
            DEBUG("at dest");
            llMessageLinked(LINK_SET,1,"attack","");
            llPlaySound("Monster1",1.0);
            llSleep(2);
            llMessageLinked(LINK_SET,1,"stand","");
            next_move();
        }


    }

    on_rez(integer p)
    {
        llResetScript();
    }

    link_message(integer sender,integer num,string str, key id)
    {
        if (num ==2)
        {
            if (str == "sit")
            {
                agent = id;
                state riding;
            }
            else
            {
                llSleep(.1);
                llReleaseControls();
                llMessageLinked(LINK_SET,1,"die","");
                llSleep(5);
                llMessageLinked(LINK_SET,1,"stand","");


                state moving;
            }
        }
    }


}

state riding
{
    state_entry()
    {
        Physics();
        llWhisper(0,"Use the arrow keys to control the zombie");
        llSetStatus(STATUS_PHYSICS, TRUE);      // get ready to move
        llStopLookAt();
        llRequestPermissions(agent, PERMISSION_TAKE_CONTROLS);
    }
    run_time_permissions(integer perm)
    {
        if (perm)
        {
            llTakeControls(CONTROL_FWD | CONTROL_BACK | CONTROL_DOWN | CONTROL_UP | CONTROL_RIGHT |
                CONTROL_LEFT | CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT, TRUE, FALSE);
            llSetTimerEvent(.5);
        }
    }

    timer()
    {
        if (llVecDist(curpos,llGetPos()) > 0.2)
        {
            curpos = llGetPos();
            if (counter++ %2 == 0)
                llMessageLinked(LINK_SET,1,"left",""); // left foot forward
            else
                llMessageLinked(LINK_SET,1,"right",""); // right foot forward
        }
    }

    control(key id, integer level, integer edge)
    {
        // llOwnerSay((string) edge);
        integer reverse=1;
        vector angular_motor;

        //get current speed
        vector vel = llGetVel();
        float speed = llVecMag(vel);

        //car controls
        if(level & CONTROL_FWD)
        {
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION,  );
            reverse=1;
        }
        if(level & CONTROL_BACK)
        {
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION,  );
            reverse = -1;
        }

        if(level & (CONTROL_RIGHT|CONTROL_ROT_RIGHT))
        {
            angular_motor.z -= speed / turning_ratio * reverse;
        }

        if(level & (CONTROL_LEFT|CONTROL_ROT_LEFT))
        {
            angular_motor.z += speed / turning_ratio * reverse;
        }

        llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, angular_motor);

    } //end control

    link_message(integer sender,integer num,string str, key id)
    {
        if (num ==2)
        {
            if (str == "sit")
            {
                agent = id;
                state riding;
            }
            else
            {
                llSleep(.1);
                llReleaseControls();
                llMessageLinked(LINK_SET,1,"die","");
                llSleep(5);
                
                state moving;
            }
        }
    }

    on_rez(integer p)
    {
        llResetScript();
    }
}
