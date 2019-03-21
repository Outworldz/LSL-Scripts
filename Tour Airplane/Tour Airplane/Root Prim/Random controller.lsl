// :CATEGORY:Tour Guide
// :NAME:Tour Airplane
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2014-12-04 12:26:04
// :EDITED:2014-12-04
// :ID:1060
// :NUM:1693
// :REV:1.2
// :WORLD:OpenSim
// :DESCRIPTION:
// Tour conteoller for airplane
// :CODE:


// Revision:
// 0.1 8-17-2014 Initial Porting
// 0.2 8-22-2014 SL version 
// 0.3 8-23-2014 Opensim Bulletsim


integer debug = FALSE;
integer LSLEDITOR = FALSE;


integer LINK_CMD = 0;
integer LINK_ANIMATE = 1;
integer LINK_POSITION   = 2;
integer LINK_RL = 3;
integer LINK_UD = 4;
integer LINK_SPEED = 5;

float TIMER = 1;
integer MAX_TIME = 60;

float MAX_DIST = 10.0;          // how close to the target we have to be to consider it a successful trip.
      
integer timeout = 0;      // if we cannot reach a spot, then move on
vector TargetLocation;    // where we are headed, my be NULL_VECTOR


DEBUG(string msg) {    if (debug) llSay(0,llGetScriptName() + ":" + msg); }

vector New()
{
    float x = llFrand(150) + 50;
    float y = llFrand(150) + 50;
    float z = llFrand(50) + 35;
    return <x,y,z>;
    
}

default
{
    
    on_rez(integer param)
    {
        llResetScript();
    }
        
       
    changed(integer what)
    {
        if (what & CHANGED_LINK)
        {
            key avatarKey = llAvatarOnSitTarget();
            if (avatarKey != NULL_KEY)  {
                llSay(0,"Please stay seated");
                llMessageLinked(LINK_THIS,LINK_CMD,"cStart","");
            
                llSetTimerEvent(TIMER);

            } else {
                    llSay(0,"Please stay seated, click the airplane!");
                   
                    llMessageLinked(LINK_THIS,LINK_CMD,"cStop","");
                    llSetTimerEvent(0);
            }
                
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
                TargetLocation = New();
               
                llMessageLinked(LINK_THIS,2,(string) TargetLocation,"");
                
            }
            
        } else {
            
            timeout = 0;            
            TargetLocation = New();
            
            DEBUG("*************** FlyTo: " + (string) TargetLocation);
            llMessageLinked(LINK_THIS,LINK_POSITION,(string) TargetLocation,"");
        }
    }
}
