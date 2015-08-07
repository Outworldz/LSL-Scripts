// :CATEGORY:Pet
// :NAME:Mesh_Frog_Project
// :AUTHOR:Ferd Frederix
// :CREATED:2012-05-11 16:43:46.393
// :EDITED:2013-09-18 15:38:57
// :ID:512
// :NUM:687
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Frog script
// :CODE:
// ______           _  ______            _           _
// |  ___|         | | |  ___|          | |         (_)
// | |_ ___ _ __ __| | | |_ _ __ ___  __| | ___ _ __ ___  __
// |  _/ _ \ '__/ _` | |  _| '__/ _ \/ _` |/ _ \ '__| \ \/ /
// | ||  __/ | | (_| | | | | | |  __/ (_| |  __/ |  | |>  <
// \_| \___|_|  \__,_| \_| |_|  \___|\__,_|\___|_|  |_/_/\_\
//
// fred@mitsi.com
// hopping animal  script
//
//Revisions:
// 3/16/2012 initial release
// 6/8/2012 tweks to names

string SIT = "SIT";        // the prim animator name to sit down
string EAT = "EAT";        // the prim animator name to eat something
string HOP = "HOP";        // the prim animator name to hop

string foodName = "Bug";        // the name of the object we will eat.

// tunable constants

float roam_range = 5;          // default roaming range

float atimer = 10;

vector rezpoint;                // home point
rotation rezrot;                // our original rez rotation
integer flightCounter;        // boolean, true if we are moving

// menu
integer listen_chan;            // random channel for menu
integer listener;                // stoarge for menu listener


string flag ;                 // what menu item thay need integers for
vector nextDestination;        // Where we are heading
integer seekingFood = FALSE;    // boolean if we are looking for food

Dialog()
{
    listener = llListen(listen_chan,"","","");
    llDialog(llGetOwner(),"Flight Controls: Home: Set the home location\nTime: How often to hop when no one is near\nRange: Distance to roam\nHelp: get notecard",["Range","Help","Home","Time", "Off"],listen_chan);
}

// This is an OpenSim compatible llLookAt()!
face_target(vector lookat)
{
    rotation rot = llGetRot() * llRotBetween(<0.0 ,0.0 ,1.0 > * llGetRot(), lookat - llGetPos());

    vector n = <0,0,90>  * DEG_TO_RAD;

    rotation rot_xyzq = llEuler2Rot(n); // Change to a Rotation

    llSetRot(rot * rot_xyzq); //add 90
}


DoMove()
{

    face_target(nextDestination);
    llSleep(.5);

    // amimate and hop thataway
    llMessageLinked(LINK_SET,1,HOP,"");       // hop up

    llSetPos(nextDestination);

    // stand still
    llMessageLinked(LINK_SET,1,SIT,"");       // hop up


}


setNewDestination()
{
    // random direction
    nextDestination = llGetPos();
    nextDestination.x += llFrand(1) +.5 - 0.75 ;
    nextDestination.y += llFrand(1) +.5 - 0.75 ;

}


// start to hop routine
startHopping()
{


    flightCounter = 0;


    setNewDestination();

    seekingFood = FALSE;
    llSensorRepeat(foodName,"", ACTIVE|PASSIVE|SCRIPTED, 10, PI, 5.0);
    ;

    llSetTimerEvent(2);        // fast
}

default
{

    on_rez(integer a)
    {
        llResetScript();
    }

    state_entry()
    {
        llMessageLinked(LINK_SET,1,SIT,"");       // hop down to default position
        llSetStatus(STATUS_DIE_AT_EDGE,FALSE);        // return to nventory instead of poofing

        rezpoint = llGetPos();
        rezrot = llGetRot();
        nextDestination = rezpoint;

    }

    touch_start(integer p)
    {
        if (llDetectedKey(0) == llGetOwner())
        {
            listen_chan=llCeil(llFrand(10000) + 10000);
            Dialog();

            state moving;
        }

    }
}


state moving
{

    on_rez(integer a)
    {
        llResetScript();
    }


    state_entry()
    {
        seekingFood = FALSE;
        startHopping();      // startHopping at startup
    }


    timer()
    {

        llSetTimerEvent(3);

        if (!flightCounter++)
            llSensorRepeat(foodName,"", ACTIVE|PASSIVE|SCRIPTED, 10, PI, 5.0);

        // too far
        if ((llVecDist(rezpoint,llGetPos()) > roam_range)  )
        {

            nextDestination = rezpoint;
        }

        DoMove();

        if (seekingFood && llVecDist(nextDestination,llGetPos()) < .1)
        {


            llWhisper(2222,"eat");        // tell the food to poof
            llMessageLinked(LINK_SET,1,EAT,"");       // grab the fish
            setNewDestination();
            seekingFood = FALSE;
        }
        else if (llVecDist(nextDestination,llGetPos()) < .1)       // get within a meter of dest is okay
        {
            setNewDestination();
        }

        if (flightCounter == 28)
        {
            // back home
            nextDestination = rezpoint;
        }



        if (flightCounter == 30)
        {
            nextDestination = rezpoint;

            llSetRot(rezrot);
            llSetPos(rezpoint);

            llSensorRemove();

            llMessageLinked(LINK_SET,1,SIT,"");       // hop up

            llSetTimerEvent(atimer);

            seekingFood = FALSE;
            flightCounter = 0;

            setNewDestination();

        }
    }



    sensor(integer total_number)
    {

        vector where  = llDetectedPos(0);

        nextDestination.x = where.x;
        nextDestination.y = where.y;

        seekingFood = TRUE;

    }

    touch_start(integer a)
    {
        if (llDetectedKey(0) == llGetOwner())
        {
            listen_chan=llCeil(llFrand(10000) + 10000);
            Dialog();
        }
    }

    listen(integer channel,string name, key id, string msg)
    {
        if (msg == "Range")
        {
            llDialog(llGetOwner(),"Range from Home in meters",["5","10","15"],listen_chan);
            flag = "R";
        }
        else if ((integer) msg >= 10 && flag == "R")
        {
            roam_range = (integer) msg;
            flag = "";
            Dialog();
        }

        else if (msg == "Help")
        {
            llLoadURL(llGetOwner(),"Get Help", "http://www.outworldz.com/secondlife/posts/Mesh-Frog");
        }
        else if (msg == "Home")
        {
            rezpoint = llGetPos();
            llOwnerSay("Position is set to " + (string) rezpoint);
            Dialog();
        }
        else if (msg =="Time")
        {
            llDialog(llGetOwner(),"How often to in seconds",["Off","10s","30s","60s"],listen_chan);
        }
        else if (msg =="Off")
        {
            llSetTimerEvent(0);
        }
        else if (msg =="60s")
            atimer = 60;
        else if (msg =="10s")
            atimer = 10;
        else if (msg =="30s")
            atimer = 30;


        llOwnerSay("Hop range is " + (string) roam_range + " meters. ");
        if (atimer)
            llOwnerSay("Jump every " + (string) atimer + " seconds");

        if (! flightCounter)
        {
            llSetTimerEvent(atimer);
        }
    }
}


