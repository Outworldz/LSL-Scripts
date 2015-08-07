// :CATEGORY:Train
// :NAME:Train_brain
// :AUTHOR:Barney Boomslang
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:08
// :ID:912
// :NUM:1310
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Train_brain
// :CODE:
// copyright 2007 Barney Boomslang
//
// this is under the CC GNU GPL
// http://creativecommons.org/licenses/GPL/2.0/
//
// prim-based builds that just use this code are not seen as derivative
// work and so are free to be under whatever license pleases the builder.
//
// Still this script will be under GPL, so if you build commercial works
// based on this script, keep this script open!
//
// This is the main engine script that is driven by the content of a notecard.
// It implements a simple touring language with a very simple command format -
// the first character denotes the main command, the second char (optionally)
// denotes the subcommand, the rest is parameters. Empty lines are skipped.
//
// Commands implemented:
//
// ;<text>                  this is a comment line and is ignored
//
// CS<text>                 say the text on channel 0
// CW<text>                 whisper the text on channel 0
// CH<text>                 shout the text on channel 0
//
// B<num>                   sets the announcement channel to <num>
// AR<text>                 announces (llRegionSay) <text> on channel <num> (see B command)
// AS<text>                 say <text> on channel <num> (see B command)
// AW<text>                 whisper <text> on channel <num> (see B command)
// AH<text>                 shout <text> on channel <num> (see B command)
//
// D<text>                  waits for an announcement of <text> on the channel set with B
//
// L<num>,<text>            link message with the number <num> and text <text>
// L<text>                  link message with the text <text> and number 0
//
// T<num>                   wait the given number of seconds
//
// S<num>                   set the "speed" of steps - how large a single step is
// P<coord>                 move to <coord> in steps of size <speed> (see S command)
// W<coord>                 warp to <coord> in one big hop
// Z<coord>                 zoom to <coord> (zooming is llSetPos in a tight loop)
// R<rel-coord>             move to <current-pos> + <rel-coord> in <speed> sized steps
//
// Xdie                     kill the running object
// Xrestart                 restart the running notecard

string notecard = "";
integer nLine = 0;
key qLine = NULL_KEY;

integer channel = -324543;  // the channel to operate on for announcements
integer trace = -65432;     // the channel to announce positions on

float speed = 1.0;          // speed is the size of steps for normal movement
float slack = 0.2;          // slack is the allowed distance on the last step

vector AXIS_UP = <0,0,1>;
vector AXIS_LEFT = <0,1,0>;
vector AXIS_FWD = <1,0,0>;

vector base_rot = <180,0,180>;
vector after_rot = <270,0,0>;

// variables for the automatic rezzing of cars
vector offset = <0,0,0.434>;    // direct offset to the current position of the engine
float distance = 7.0;           // distance to move the engine after rezzing one car

// what we are waiting for when D executes
string waitForString;

// a timeout for notecard reading - if the line doesn't arrive in time, the train will derez
float tourtimeout = 180.0;  // this is in seconds

// a timeout counter for the default state
integer waitcount;

// rez the named object at the current position plus offset with current rotation
rezit(string name, integer channel)
{
    vector dir = llRot2Fwd(llGetRot());
    vector pos = llGetPos()+offset+dir*distance;
    llRezAtRoot(name, pos, ZERO_VECTOR, llGetRot(), channel);
}

// move the engine the predefined distance in the current direction
movit()
{
    vector dir = llRot2Fwd(llGetRot());
    vector pos = llGetPos()-dir*distance;
    llSetPos(pos);
}


// jump to a target in one big swipe
llWarp2Pos( vector d, rotation rot )
{
        if ( d.z > 768 )
        d.z = 768;
        integer s = (integer)(llVecMag(d-llGetPos())/10)+1;
        if ( s > 100 )
        s = 100;
        integer e = (integer)( llLog( s ) / llLog( 2 ) );
        list rules = [ PRIM_POSITION, d ];
        integer i;
        for ( i = 0 ; i < e ; ++i )
        rules += rules;
        integer r = s - (integer)llPow( 2, e );
        if ( r > 0 )
        rules += llList2List( rules, 0, r * 2 + 1 );
        llSetPrimitiveParams( [ PRIM_ROTATION, rot ] + rules );
        llShout(trace, (string)(llGetPos()+llGetRegionCorner())+"|"+(string)llGetRot());
}

// tight moving loop ("zooming")
moveto(vector dest, rotation r)
{
    list l = [ PRIM_ROTATION, r, PRIM_POSITION, dest ];
    while (llVecDist(llGetPos(), dest) > 9)
    {
        llSetPrimitiveParams(l);
        llShout(trace, (string)(llGetPos()+llGetRegionCorner())+"|"+(string)llGetRot());
    }
    if (llVecDist(llGetPos(), dest) > slack)
    {
        llSetPos(dest);
        llShout(trace, (string)(llGetPos()+llGetRegionCorner())+"|"+(string)llGetRot());
    }
}

// loose moving loop - moving in defined steps
movetostepped(vector dest, rotation r)
{
    integer first = TRUE;
    vector pos = llGetPos();
    vector step = llVecNorm(dest - llGetPos()) * speed;
    while (llVecDist(pos, dest) > speed)
    {
        pos += step;
        if (first)
        {
            llSetPrimitiveParams([PRIM_ROTATION, r, PRIM_POSITION, pos]);
            llShout(trace, (string)(llGetPos()+llGetRegionCorner())+"|"+(string)llGetRot());
        }
        else
        {
            llSetPos(pos);
            llShout(trace, (string)(llGetPos()+llGetRegionCorner())+"|"+(string)llGetRot());
        }
    }
    if (llVecDist(pos, dest) > slack)
    {
        llSetPos(dest);
        llShout(trace, (string)(llGetPos()+llGetRegionCorner())+"|"+(string)llGetRot());
    }
}

// simple function to calculate the needed rotation to point a given axis at a target
rotation getRotToPointAxisAt(rotation root, vector axis, vector target) {
    return root * llRotBetween(axis * root, target - llGetPos());
}

// calculate the "prime" (left/right and up/down) rotations to point at a target
rotation getPrimeRotation(vector dest)
{
    vector p1 = llGetPos();
    rotation brot = llEuler2Rot(base_rot*DEG_TO_RAD);
    // calculate left/right rotation
    vector p2 = dest;
    p2.z = p1.z;
    rotation rleft = getRotToPointAxisAt(brot, AXIS_FWD, p2);
    vector r2 = llRot2Euler(rleft);
    r2.x = 0;
    r2.y = 0;
    rleft = llEuler2Rot(r2);
    // calculate up/down rotation
    p2 = dest;
    p2.x = p1.x + llVecDist(p1, dest);
    p2.y = p1.y;
    rotation rup = getRotToPointAxisAt(brot, AXIS_FWD, p2);
    r2 = llRot2Euler(rup);
    r2.x = 0;
    r2.z = 0;
    rup = llEuler2Rot(r2);
    // return combined rotations
    return llEuler2Rot(after_rot*DEG_TO_RAD) * rup * rleft * brot;
}

// this state waits for a notecard to be dropped into inventory to start
// the tour. Before starting it, it will decide on the comms channel and will
// rez the actual cars of the train.
default
{
    state_entry()
    {
        waitcount = 0;
        speed = 1.0;
        slack = 0.2;
        llSetTimerEvent(10.0);
    }
    
    state_exit()
    {
        // create a random trace channel for the engine->car communication
        trace = (integer)(-1*(llFrand(100000) + 100000));
        // rez the cars (this needs to be copied from the rez cars script)
        // and adapted to one-car rezzing or two-car rezzing (depending on inventory)
        if (llGetInventoryType("car") == INVENTORY_OBJECT)
        {
            rezit("car", trace-1);
            movit();
            rezit("car", trace);
        }
        else
        {
            rezit("car2", trace-1);
            movit();
            rezit("car1", trace);
        }
    }

    on_rez(integer param)
    {
        llResetScript();
    }
    
    changed(integer change)
    {
        if (change & CHANGED_INVENTORY)
        {
            if (llGetInventoryNumber(INVENTORY_NOTECARD) > 0)
            {
                notecard = llGetInventoryName(INVENTORY_NOTECARD, 0);
                nLine = 0;
                state running;
            }
        }
    }
    
    timer()
    {
        if (llGetInventoryNumber(INVENTORY_NOTECARD) > 0)
        {
            notecard = llGetInventoryName(INVENTORY_NOTECARD, 0);
            nLine = 0;
            state running;
        }
        waitcount++;
        if (waitcount > 30)
        {
            llSay(0, "Sorry, there are problems with the grid, this tour is canceled!");
            llDie();
        }
    }
}

// this state is the actually running state for the engine
state running
{
    state_entry()
    {
        qLine = llGetNotecardLine(notecard, nLine);
        llSetTimerEvent(tourtimeout);
    }
    
    on_rez(integer start_param)
    {
        llResetScript();
    }
    
    timer()
    {
        // emergency shutdown of the train in case of notecard timeouts
        llSay(0, "Sorry, there are problems with the grid, this tour is canceled!");
        llShout(trace, "!DIE!");
        llDie();
    }
    
    dataserver(key id, string data)
    {
        if (id == qLine)
        {
            if (data != EOF)
            {
                llSetTimerEvent(0.0);
                string cmd = llGetSubString(data, 0, 0);
                string parm = llGetSubString(data, 1, -1);
                if (cmd == "C")
                {
                    string range = llGetSubString(parm, 0, 0);
                    parm = llGetSubString(parm, 1, -1);
                    if (range == "S")
                    {
                        llSay(0, parm);
                    }
                    else if (range == "W")
                    {
                        llWhisper(0, parm);
                    }
                    else if (range == "H")
                    {
                        llShout(0, parm);
                    }
                    else
                    {
                        llOwnerSay("bad chat range: " + range);
                    }
                }
                else if (cmd == "B")
                {
                    channel = (integer)parm;
                }
                else if (cmd == "A")
                {
                    string range = llGetSubString(parm, 0, 0);
                    parm = llGetSubString(parm, 1, -1);
                    if (range == "S")
                    {
                        llSay(channel, parm);
                    }
                    else if (range == "W")
                    {
                        llWhisper(channel, parm);
                    }
                    else if (range == "H")
                    {
                        llShout(channel, parm);
                    }
                    else if (range == "R")
                    {
                        llRegionSay(channel, parm);
                    }
                    else
                    {
                        llOwnerSay("bad chat range: " + range);
                    }
                }
                else if (cmd == "L")
                {
                    integer p = llSubStringIndex(parm, ",");
                    if (p >= 0)
                    {
                        integer num = (integer)llGetSubString(parm,0,p-1);
                        string str = llGetSubString(parm,p+1,-1);
                        llMessageLinked(LINK_SET, num, str, NULL_KEY);
                    }
                    else
                    {
                        llMessageLinked(LINK_SET, 0, parm, NULL_KEY);
                    }
                }
                else if (cmd == "T")
                {
                    llSleep((float)parm);
                }
                else if (cmd == "S")
                {
                    speed = (float)parm;
                    slack = speed / 5.0;
                }
                else if ((cmd == "R") ||\xA0(cmd == "P") || (cmd == "W") ||\xA0(cmd == "Z"))
                {
                    vector p1 = llGetPos();
                    vector p2 = (vector)parm;
                    if (cmd == "R")
                    {
                        p2 = llGetPos() + p2;
                    }
                    if (p2 != ZERO_VECTOR)
                    {
                        rotation r = getPrimeRotation(p2);
                        if ((cmd == "P") || (cmd == "R"))
                        {
                            movetostepped(p2, r);
                        }
                        else if (cmd == "Z")
                        {
                            moveto(p2, r);
                        }
                        else if (cmd == "W")
                        {
                            llWarp2Pos(p2, r);
                        }
                    }
                    else
                    {
                        llOwnerSay("bad vector: " + parm);
                    }
                }
                else if (cmd == "X")
                {
                    if (parm == "die")
                    {
                        // propagate the die to the cars
                        llShout(trace, "!DIE!");
                        llDie();
                    }
                    else if (parm == "restart")
                    {
                        nLine = -1;
                    }
                }
                else if (cmd == "D")
                {
                    waitForString = parm;
                    state waiting;
                }
                else
                {
                    if ((cmd != "") && (cmd != ";"))
                    {
                        llOwnerSay("bad command: " + cmd + "(" + parm + ")");
                    }
                }
                ++nLine;
                qLine = llGetNotecardLine(notecard, nLine);
                llSetTimerEvent(tourtimeout);
            }
            else
            {
                llRemoveInventory(notecard);
                state paused;
            }
        }
    } 
}

// this is the state for the D command - it just waits for a string on the broadcast channel
state waiting
{
    state_entry()
    {
        llListen(channel, "", NULL_KEY, waitForString);
        llSetTimerEvent(60.0);
    }
    
    state_exit()
    {
        // on receiving the expected line, we just jump back to the next line in the notecard
        ++nLine;
    }
    
    listen(integer chan, string name, key id, string message)
    {
        if (chan == channel)
        {
            // if we got the broadcast we wait for, continue script
            state running;
        }
    }
    
    timer()
    {
        // this keeps the cars around as long as the engine lives and sends beacons
        llShout(trace, "!NOP!");
    }
}

// this state is used at the end of a tour that doesn't end with Xdie. It will just
// wait for a new notecard and while doing so, will send "!NOP!" just like a D command.
state paused
{
    state_entry()
    {
        llSetTimerEvent(60.0);
    }
    
    on_rez(integer start_param)
    {
        llResetScript();
    }
    
    changed(integer change)
    {
        if (change & CHANGED_INVENTORY)
        {
            if (llGetInventoryNumber(INVENTORY_NOTECARD) > 0)
            {
                notecard = llGetInventoryName(INVENTORY_NOTECARD, 0);
                nLine = 0;
                state running;
            }
        }
    }
    
    timer()
    {
        // this keeps the cars around as long as the engine lives and sends beacons
        llShout(trace, "!NOP!");
    }
}
