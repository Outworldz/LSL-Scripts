// :CATEGORY:Elevator
// :NAME:Two floor keyframe elevator with sit
// :AUTHOR:Soen Eber
// :KEYWORDS:
// :CREATED:2014-12-04 12:44:45
// :EDITED:2014-12-04
// :ID:1061
// :NUM:1700
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:

// This is a simple 2 floor elevator, consisting of 3 scripts, one for the elevator itself, another for the elevator
// call button, and a 3rd for the elevator door to open and close. The door in this case is a hollowed cylinder,
// giving a slightly futuristic look.  Operation is intuitive and simple: Just stand on the elevator, and it will
// go up (or down) as necessary. If the elevator is not on your floor, the door will be closed and you will need
// to press the call button.
// The elevator is a simple, flattened disk, and the assumption going forward is the elevator will be a flattened
// prim you step onto.
// originally found at http://www.sluniverse.com/php/vb/script-library/68363-2-floor-key-framed-elevator.html
// :CODE:


// While operation is simple, there are enough complexities in the setup that you should probably have some experience
// with building and scripting, or have a friend available who is.

// Setup requires the following steps:

// 1. Edit the DESCRIPTION field of the prim or prims containing the elevator script to the word "setup" (without quotes),
// and then reset the script using tools -> reset. If the elevator is more than one prim, make sure the script is in the
//  root prim. THE ELEVATOR SHOULD NOT BE LINKED TO ANYTHING ELSE or strangeness will occur.

// 2. Follow the prompt to move the elevator to the first floor location, and then reset again with tools -> reset.
// You will be prompted to move the elevator to the 2nd floor location. Once you have done so, reset the script
//   again with tools -> reset. 

//3. Place the prim or prims containing the elevator call script on each floor. For the 1st floor change the
// DESCRIPTION to "1" (no quotes) and to "2" (again, no quotes) for the 2nd floor. If you link the prim(s//)
// containing the call button to anything, its probably not a good idea to make the prim with the call script
//  in it a root prim or strangeness will occur.

// 4. (optional) Place the prim or prims containing the elevator door script on each floor, changing the
// description as you did for the prim containing the call script. The door in this case will be a hollowed cylinder,
// hollowed to 95% with a path cut from .375 to .625. If you want a rectangular, non-curved door or a double door
//  that opens from the center, you will have to roll your own script or get someone to write it for you,
// using the existing elevator door script as a template.

// Altered by Vegaslon Plutonian to be a sit type elevator instead of stand
// from http://forums.osgrid.org/viewtopic.php?f=5&t=5201&hilit=lift

float wait;
integer ch = -11;
integer floor_start;
integer floor_dest;
vector pos_1;
vector pos_2;
vector elevator_scale;
float scan_radius;
string context;
integer CHANNEL = 42; // dialog channel
list MENU_MAIN = ["Floor 1", "Floor 2"];

calc_start()
{
    if       (llVecDist(llGetPos(), pos_1) < 3.5) floor_start = 1;
    else if  (llVecDist(llGetPos(), pos_2) < 3.5) floor_start = 2;
}
calc_dest()
{
    if (floor_start == 1) floor_dest = 2;
    else                  floor_dest = 1;
}
go()
{ 
    float move;
    vector v = llGetPos();
    if (floor_dest == 1) move = pos_1.z - v.z;
    if (floor_dest == 2) move = pos_2.z - v.z;
    if (llFabs(move) > 1.5) llWhisper(ch, (string)floor_start+" depart");
    wait = 3;
    context = "moving";
    llSetKeyframedMotion([<0,0,move>,ZERO_ROTATION,8],[]);
}
get_floor_pos()
{
    string s = llGetObjectDesc();
    pos_1=(vector)llList2String(llParseString2List(llList2String(llParseString2List(s,[";"],[]),0),["="],[]),1);
    llWhisper(0,"floor 1="+(string)pos_1);
    pos_2=(vector)llList2String(llParseString2List(llList2String(llParseString2List(s,[";"],[]),1),["="],[]),1);
    llWhisper(0,"floor 2="+(string)pos_2);
    llWhisper(0,"If these are not the correct positions, please change the elevator description to 'reset' (no quotes),");
    llWhisper(0,"reset its script using Tools -> Reset Scripts in Selection, and follow the prompts");
}
get_set_floor_pos()
{
    string s = llGetObjectDesc();
    if (s == "reset") {
        llWhisper(0, "Please move the elevator floor to first floor starting position, "
                   + "and then reset its script using Tools -> Reset Scripts in Selection"
        );
        llSetObjectDesc("setup");
    }
    else if (s == "setup") {
        s = "1="+(string)llGetPos();
        llWhisper(0,"Setting first floor to "+s);
        llWhisper(0,"Now please move the elevator floor to the second floor starting position and reset the script");
        llSetObjectDesc(s);
    }
    else if (llSubStringIndex(s,"2=") == -1) {
        s+=(";2="+(string)llGetPos());
        llWhisper(0,"Setting desc to "+s);
        llSetObjectDesc(s);
        get_floor_pos();
    }
    else {
        get_floor_pos();
    }
}
default
{
    state_entry()
    {
                llListen(CHANNEL, "", NULL_KEY, ""); 
                        llSitTarget(<0,-0.5,0.5>, llEuler2Rot(<0,0,-90>) );
        llSetText("Sit Here to Ride Elevator",<0,0,0>,1.0);

        elevator_scale = llGetScale();;
        if (elevator_scale.x >= elevator_scale.y) scan_radius = elevator_scale.x;
        else                                      scan_radius = elevator_scale.y;
        get_set_floor_pos();
        state operate;
    }
}
state operate
{
    state_entry()
    { 
        llListen(ch,"",NULL_KEY,"");
        if (context == "moving") {
            llShout(ch, (string)floor_dest+" arrived");
            context = "exiting";
            wait = 3;
            state idle;
        }
        else if (context == "exiting") {
            context = "";
        }
    }

    changed(integer Change) 
    {
        llDialog(llAvatarOnSitTarget(), "Where to?", MENU_MAIN, ch);
    }
    listen(integer ch,string name,key id,string msg)
    {
        integer idx = llListFindList(MENU_MAIN, [msg]);
        if( idx!=-1 )
        {
            llSay(0,"Elevator heading to " + msg + "." );
            calc_start();
            floor_dest = idx+1;
              go();
               state idle;
        } 
       else if (llListFindList(["1 call","2 call"],[msg]) != -1) {
            calc_start();
            floor_dest = (integer)llGetSubString(msg,0,0);
            go();
            state idle;
        } 
    }
}
state idle
{
    state_entry()
    {
        llSetTimerEvent(wait);
        
    }
        changed(integer Change) 
    {
        llUnSit(llAvatarOnSitTarget());
    }

    timer()
    {
        llSetTimerEvent(0);
        state operate;
    }
}
