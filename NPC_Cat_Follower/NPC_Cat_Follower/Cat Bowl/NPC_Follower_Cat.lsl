// :SHOW:1
// :CATEGORY:OpenSim NPC
// :NAME:NPC_Cat_Follower
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2013-11-27 13:33:04
// :EDITED:2016-07-09  14:33:57
// :ID:1004
// :NUM:785
// :REV:2.0
// :WORLD:OpenSim
// :DESCRIPTION:
// A NPC follower. Will follow close to any avatar.
//  Touch to turn on or off.
// Has lots of mods by Fred Beckhusen (Ferd Frederix)
// License: http://creativecommons.org/licenses/by-nc
// some code bits from author: jpvdgiessen
// You are free:
// to Share — to copy, distribute and transmit the work
// to Remix — to adapt the work
// :CODE:


// Rev 2 - remove timers.
// tunables
integer debug = FALSE;

string fName = "Orana";
string lName = "Kthxbye";

float MIN = 5;
float MAX = 10;  // how long the cat waits or sits, is beteween these two values
float TimerTick = 1;    // keep this around a second
float TIME = 5; // how often to look for avatar (keep this slow)
float max_distance = 35; //distance for sensoring a real avatar
float near_distance= 3; // how close the cat stays around
float claw_distance= 1 ;// will claw you hen this close
 
// stuff
integer iWaitCounter = 60;  // if we cannot get there in time,
integer channel; // dialog channel
integer listener; // holds the listener handle;
key npc;    // npc key
integer npc_on = FALSE;
vector Dest;
string lastAnim;
float gTimer;
  
DEBUG(string str)
{
    if (debug) llOwnerSay(str);
}

Remove()
{
    lastAnim = "";
    npc_on = TRUE;
     osNpcRemove(llGetObjectDesc());
}

Play(string anima)
{
    if (anima == lastAnim) {
        DEBUG("Same");
        return;
    }
   
   // 1/5 the time, ionstead of standing, we lay down
    if (anima == "Stand" && llFrand(5) < 1)
    {
        anima = "Sit1";   
    }
    
    gTimer =randBetween(MIN,MAX);
    llSensorRepeat("", NULL_KEY, AGENT_BY_LEGACY_NAME, max_distance, PI, gTimer);     
    DEBUG(anima + " time = " + (string) gTimer);

    osNpcPlayAnimation(npc,anima);
    osNpcStopAnimation(npc,lastAnim);
    lastAnim = anima;
}

Sound()
{
    if (llFrand(2) > 0.5)
        return;
        
    integer n = llGetInventoryNumber(INVENTORY_SOUND);
    integer n2 = llCeil(llFrand(n));

    string name = llGetInventoryName(INVENTORY_SOUND,n2);
    llTriggerSound(name,1.0);
}


walk_to_master(vector myPos)
{
    DEBUG( "walk to " + (string) Dest);
    vector myVector = <randBetween(-near_distance,near_distance),randBetween(-near_distance,near_distance),myPos.z> ;
    myPos.z = 0;

    iWaitCounter = 60;
    Play("Walk");
    osNpcMoveToTarget(npc, myPos + myVector, OS_NPC_NO_FLY );
    llSetTimerEvent(TimerTick);
    if (llFrand(5) < .5)
        Sound();
}

float randBetween(float min, float max)
{
    return llFrand(max - min) + min ;
}
dialog(key avi)
{
    channel = llCeil(llFrand(5000) + 5000);
    listener = llListen(channel,"","","");
    llDialog(avi, "Choose:",["Start","Remove","Appearance"],channel);
}

Start()
{
    Remove();
    vector npcPos = llGetPos() + <0.0,0.0,1.0>;
    npc = osNpcCreate(fName,lName, npcPos, "Appearance");
    llSetObjectDesc(npc);
    npc_on = TRUE;
    osSetSpeed(npc,0.8);
    llSensorRepeat("", NULL_KEY, AGENT_BY_LEGACY_NAME, max_distance, PI, TIME);     
    llSetTimerEvent(TimerTick);
}

default
{ 
    state_entry()
    {
        llSay(0,"starting");
        Start();
    }
    
    changed (integer what)
    {
        if (what & CHANGED_REGION_START)
        {
            Start();
        } 
    }
    
    on_rez(integer p)
    {
        llResetScript();
    }
    
    touch_start(integer x)
    {
        if (llDetectedKey(0) == llGetOwner() || llSameGroup(llDetectedKey(0)))  {
            dialog(llDetectedKey(0));
        }
    }
    
    listen(integer channel, string name, key id, string msg) {
        llListenRemove (listener);
        if (msg == "Start")
        {
           Start();  
        } else if (msg == "Remove")  {
            npc_on = FALSE;
            Remove();
            llSensorRemove();
            llSetTimerEvent(0);
        } else if (msg ==  "-") {
            osAgentSaveAppearance(llGetOwner(), "Appearance");
            llOwnerSay("Your appearance has been saved");
            Start();
        }
    
    }

    sensor(integer num)
    {
        Dest = llDetectedPos( 0 );
        walk_to_master(Dest);
    }
    
    no_sensor()
    {
         Play("Sit1");
         llSensorRepeat("", NULL_KEY, AGENT_BY_LEGACY_NAME, max_distance, PI, TIME);     
         llSetTimerEvent(0);
    }
   
    timer()
    {
        // for safety
        if (--iWaitCounter == 0)  {
            DEBUG("Lost cat, rerezzing");
            Start();
            return;
        }
        
        // get NPC position
        list P = llGetObjectDetails(npc,[OBJECT_POS]);
        vector Npcpos;
        Npcpos = llList2Vector(P, 0);           
        
        if (llVecDist(Npcpos, Dest ) > 1) {
            Play("Stand");
            return;
        }

        if (llVecDist(Npcpos, Dest ) < claw_distance) 
        {
            Play("Claw");
            llTriggerSound("kitten4",1.0);
        }  else {
            Play("Stand");
        }   
    }
}
