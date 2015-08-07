// :CATEGORY:OpenSim NPC
// :NAME:OpenSim NPC Fish
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2014-02-14 12:33:23
// :EDITED:2014-02-15 13:46:29
// :ID:1024
// :NUM:1590
// :REV:1.1
// :WORLD:OpenSim
// :DESCRIPTION:
//  This is a fish NPC follower.
// License: http://creativecommons.org/licenses/by-nc
// :CODE:

// Redv 1.1 Added wait timer, adjustments for great white

integer debug = FALSE;

// tunables
float max_distance = 40; //distance for sensoring a real avatar, 96 is max
string fName = "Great";
string lName = "White";

float XY = 10;




float gTimer;
// stuff
integer nobody = FALSE;
integer iWaitCounter = 10;
integer channel; // dialog channel
integer listener; // holds the listener handle;
key npc;    // npc key
integer npc_on = FALSE;
vector Dest;
string lastAnim;
  
Play(string anima)
{
    if (anima == lastAnim)
        return;

    
    osNpcPlayAnimation(npc,anima);
    osNpcStopAnimation(npc,lastAnim);
    lastAnim = anima;
}




walk_to_master(vector myPos)
{
    vector myVector = <randBetween(-XY,XY),randBetween(-XY,XY),-randBetween(1,3)> ;

    iWaitCounter = 60;
    Play("FishSlowSwim");
    
        
    float water = llWater(<0,0,0>) - 0.5;
    float z = myPos.z;
    if (z  > water) {
       return;
    }

    osNpcMoveToTarget(npc, myPos + myVector, OS_NPC_FLY );
    llSetTimerEvent(1.0);
    
    Dest = myPos + myVector;
    
}

float randBetween(float min, float max)
{
    return llFrand(max - min) + min ;
}
dialog(key avi)
{
    channel = llCeil(llFrand(5000) + 5000);
    listener = llListen(channel,"","","");
    llDialog(avi, "Choose:",["Start","Remove","-"],channel);
}
Start()
{
    vector npcPos = llGetPos() + <0,0.0,1.0>;
    npc = osNpcCreate(fName,lName, npcPos, "Appearance", OS_NPC_NOT_OWNED);
    llSetObjectDesc(npc);
    npc_on = TRUE;
    llSensorRepeat("", NULL_KEY, AGENT, max_distance, PI, 5);  
}

default
{ 
    
    state_entry()
    {
        llSetText(llGetObjectName(),<1,1,1>,1.0);
        llSetAlpha(1.0, ALL_SIDES);
        gTimer = llFrand(2) + 1;
        osNpcRemove(llGetObjectDesc());
    }
    
    changed (integer what)
    {
        if (what & CHANGED_REGION_START)
        {
            if (npc_on)
            {
                Start();
            }
        } 
    }
    
    on_rez(integer p)
    {
        llSetText("",<1,1,1>,1.0);
        llResetScript();
    }
    
    touch_start(integer x)
    {
        if (llDetectedKey(0) == llGetOwner())  {
            dialog(llDetectedKey(0));
        }
    }
    
    listen(integer channel, string name, key id, string msg) {
        llListenRemove (listener);
        if (msg == "Start")
        {
            if( !npc_on ) {
               Start();
            } else {
                llOwnerSay("Aready running");
            }
        } else if (msg == "Remove")  {
            npc_on = FALSE;
            osNpcRemove(llGetObjectDesc());
            llSetTimerEvent(0);
        } else if (msg ==  "-") {
            osAgentSaveAppearance(llGetOwner(), "Appearance");
            llOwnerSay("Your appearance has been saved");
        }
    
    }

    sensor(integer num)
    {
        llSetText("",<1,1,1>,1.0);
        llSetAlpha(0.0, ALL_SIDES);

        if (nobody)   
        {
           
            Start();
            nobody = FALSE;
            return;
        }
        
        Dest = llDetectedPos( 0 );
        if (debug) llOwnerSay((string) Dest);
        

        walk_to_master(Dest);
    }
    
    no_sensor()
    {
        if (debug) llOwnerSay("nobody");
        llSetTimerEvent(0);
        
        osNpcRemove(llGetObjectDesc());
        nobody = TRUE; 
    }
   
    timer()
    {
        vector pos;
        if (--iWaitCounter)  {
        
            list Poses = llGetObjectDetails(npc,[OBJECT_POS]);
            pos = llList2Vector(Poses, 0);
            
            if (llVecDist(pos, Dest ) > 4) {
                 if (debug) llOwnerSay("swimming");
                return;
            }
        }
        
         if (debug) llOwnerSay("arrived");

        Play("FishStand");    
        gTimer = llFrand(2) + 1;
        llSleep(gTimer);
        llSetTimerEvent(0);
        
    }
}
