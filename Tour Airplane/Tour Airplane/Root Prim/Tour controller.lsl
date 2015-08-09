// :CATEGORY:Tour Guide
// :NAME:Tour Airplane
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2014-12-04 12:44:16
// :EDITED:2014-12-04
// :ID:1060
// :NUM:1699
// :REV:1.3
// :WORLD:OpenSim
// :DESCRIPTION:
// Tour controller for airplane
// :CODE:


// Revision:
// 0.1 8-17-2014 Initial Porting
// 0.2 8-22-2014 SL version 
// 0.3 8-23-2014 Opensim Bulletsim

integer debug = TRUE;
integer LSLEDITOR = TRUE;

integer LINK_CMD = 0;
integer LINK_ANIMATE = 1;
integer LINK_POSITION   = 2;
integer LINK_RL = 3;
integer LINK_UP = 4;
integer LINK_DOWN = 5;
integer LINK_SPEED = 6;

float PAUSE = 5;    // PAUSE command time

float TIMER = 0.5;

integer MAX_TIME = 60;
integer running = FALSE;
integer ROGER = 1900; // channel we call for Roger with

string Route = "Route";
float MAX_DIST = 10.0;          // how close to the target we have to be to consider it a successful trip.
integer lineNumber;        // the line of the notecard we are using
integer nRoutes;             // how many valid notecard locations there are
key kGetIndexLines;        // the line we are reading from note card
 
list lLocations = [];
list lCommands= [];
      
integer timeout = 0;      // if we cannot reach a spot, then move on
vector TargetLocation;    // where we are headed, my be NULL_VECTOR


DEBUG(string msg) {    if (debug) llSay(0,llGetScriptName() + ":" + msg); }

Init() {
    lineNumber = 0;
    llSensorRepeat("","",AGENT,20,PI,5);
    llSetTimerEvent(0);
}


default
{
    on_rez(integer param)
    {
        
    }

    state_entry()
    {
        lLocations = [];
        lCommands = [];
        lineNumber = 0;
        kGetIndexLines = llGetNotecardLine(Route,lineNumber);
        DEBUG("Reading Notecard");
    }

    dataserver(key queryid, string data)
    {
        if (queryid == kGetIndexLines)
        {
            if (data == EOF) {
                state moving;
                
            } else {
                list  lLine = (llParseString2List(data, ["|"], []));
                string junk  = llList2String(lLine, 0);
                vector TempLocation = (vector) llList2String(lLine, 1);

                lLocations += [TempLocation];
                string TempDescription = llList2String(lLine, 2);
                lCommands += [TempDescription];

                lineNumber++;

                kGetIndexLines = llGetNotecardLine(Route, lineNumber);
            }     
        }
    }

   
    state_exit()
    {
        nRoutes = llGetListLength(lLocations);
        lineNumber = 0;
        llSetText("", <1,1,1>, 1.0);
        TargetLocation = llList2Vector(lLocations, 0);
        DEBUG("Ready");
    }
}

state moving
{

    link_message(integer sender_number, integer number, string message, key id)
    {
        //DEBUG("N:" + (string) number + ":" + message);
    }
    
    on_rez(integer param)
    {
        Init();    
    }
    
    state_entry()
    {
        Init();
    }
    
    sensor(integer N)
    {
        if (! running) {
            DEBUG("Someone is here");
            llMessageLinked(LINK_THIS,LINK_CMD,"StartNPC","");
            running ++;
        }
    }

    no_sensor()
    {
        if (running)
        {
            DEBUG("Person Ejected!");
            llMessageLinked(LINK_THIS,LINK_CMD,"StopNPC","");
            running = FALSE;
        }
    }
    
    changed(integer what)
    {
        if (what & CHANGED_LINK)
        {
            key avatarKey = llAvatarOnSitTarget();
            if (avatarKey != NULL_KEY)
            {
                llMessageLinked(LINK_THIS,0,"Seated","");
                
                llSetTimerEvent(5);
                llSetTimerEvent(TIMER);
                
            } else {
                llSay(0,"Please stay seated, click the airplane!");
            }
        } else if (what & CHANGED_INVENTORY) {
            llResetScript();
        }

    }

    
    timer()
    {
        
        DEBUG("Goto:" + (string) TargetLocation);
        vector myPos = llGetPos();


        if (LSLEDITOR)
            myPos = TargetLocation;
        
        if (llVecDist(myPos, TargetLocation) > MAX_DIST  && TargetLocation != ZERO_VECTOR)
        {
            if (timeout++ > MAX_TIME) // Time Out to contingency
            {
                timeout = 0;
                DEBUG("New Target");
                TargetLocation = llList2Vector(lLocations, lineNumber);
                lineNumber++;

                llMessageLinked(LINK_THIS,2,(string) TargetLocation,"");
                
                if (lineNumber  > nRoutes)
                {
                    state end;
                }
            }
            
        } else {
            
            DEBUG("Line Number:" + (string)lineNumber );     
            

            string Command = llList2String(lCommands,lineNumber);

            if (Command == "cPause")
            {
                DEBUG("Roger Called");
                llShout(ROGER,"Roger");    // Call for Roger
                llSensorRemove();
                llSleep(PAUSE);
            }

            
            if (llStringLength(Command)) {
                DEBUG("Cmd: " + (string) Command);
                llMessageLinked(LINK_THIS,LINK_CMD,Command,"");
            }

            timeout = 0;
            
            TargetLocation = llList2Vector(lLocations, lineNumber);
            lineNumber++;

            if (lineNumber  > nRoutes)
            {
                if (!debug)
                    llDie();
                llSetTimerEvent(0);
                
            }
            
            DEBUG("*************** FlyTo: " + (string) TargetLocation);
            llMessageLinked(LINK_THIS,LINK_POSITION,(string) TargetLocation,"");
        }
    }
}

