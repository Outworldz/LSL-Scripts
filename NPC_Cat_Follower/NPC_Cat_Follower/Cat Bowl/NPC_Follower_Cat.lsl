// :SHOW:
// :CATEGORY:OpenSim NPC
// :NAME:NPC_Cat_Follower
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2013-11-27 13:33:04
// :EDITED:2015-05-29  11:26:02
// :ID:1004
// :NUM:785
// :REV:1.1
// :WORLD:OpenSim
// :DESCRIPTION:
// A NPC follower. Will follow close to any avatar.
//  Touch to turn on or off.
// Has lots of mods by Ferd Frederix
// License: http://creativecommons.org/licenses/by-nc
// original author: jpvdgiessen
// You are free:
// to Share — to copy, distribute and transmit the work
// to Remix — to adapt the work
// :CODE:


// tunables
float max_distance = 96; //distance for sensoring a real avatar
string fName = "Orana";
string lName = "Kitty";

// stuff
integer iWaitCounter = 60;
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
   
    if (anima == "Stand" && llFrand(5) < 1)
    {
        anima = "Sit1";   
    }
    
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
    vector myVector = <randBetween(-2,2),randBetween(-2,2),myPos.z> ;
    myPos.z = 0;

    iWaitCounter = 60;
    Play("Walk");
    osNpcMoveToTarget(npc, myPos + myVector, OS_NPC_NO_FLY );
    llSetTimerEvent(0.5);
    Sound();
}

float randBetween(float min, float max)
{
    return llFrand(max - min) + min ;
}
dialog()
{
    channel = llCeil(llFrand(5000) + 5000);
    listener = llListen(channel,"","","");
    llDialog(llGetOwner(), "Choose:",["Start","Remove","Appearance"],channel);
}
Start()
{
    vector npcPos = llGetPos() + <1.0,1.0,1.0>;
    npc = osNpcCreate(fName,lName, npcPos, "Appearance");
    llSetObjectDesc(npc);
    npc_on = TRUE;
    llSensor("", NULL_KEY, AGENT_BY_LEGACY_NAME, max_distance, PI);  
}

default
{ 
    
    state_entry()
    {
        llSay(0,"Ready");
         osNpcRemove(llGetObjectDesc());
         dialog();
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
        llResetScript();
    }
    
    touch_start(integer x)
    {
        if (llDetectedKey(0) == llGetOwner())  {
            dialog();
        }
    }
    
    listen(integer channel, string name, key id, string msg) {
        llListenRemove (listener);
        if (msg == "Start")
        {
            if( !npc_on ) {
               Start();
            } else {
                llOwnerSay("Already running");
            }
        } else if (msg == "Remove")  {
            npc_on = FALSE;
            osNpcRemove(llGetObjectDesc());
            llSetTimerEvent(0);
        } else if (msg ==  "Appearance") {
            osAgentSaveAppearance(llGetOwner(), "Appearance");
            llOwnerSay("Your appearance has been saved");
        }
    
    }

    sensor(integer num)
    {
        Dest = llDetectedPos( 0 );
        walk_to_master(Dest);
    }
    no_sensor()
    {
         Play("Stand");
         llSleep(10);
         llSensor("", NULL_KEY, AGENT_BY_LEGACY_NAME, max_distance, PI);
    }
   
    timer()
    {
        vector pos;
        if (--iWaitCounter)  {
           
            list Poses = llGetObjectDetails(npc,[OBJECT_POS]);
            pos = llList2Vector(Poses, 0);
            
            if (llVecDist(pos, Dest ) > 4) {
                return;
            }
        }
        
        if (llFrand(5) < 0.5) { 
             if (llVecDist(pos, Dest ) <1) {
                Play("Claw");
                llTriggerSound("kitten4",1.0);
                llSleep(1.5);
            } else {
                Play("Meow");
                llTriggerSound("kitten3",1.0);
                llSleep(1.5);
            }
            
            
        } 
        
        Play("Stand");

        llSleep(llFrand(5) + 1);
        llSetTimerEvent(0);
        llSensor("", NULL_KEY, AGENT_BY_LEGACY_NAME, max_distance, PI);
        
    }
}
// tunables
float max_distance = 96; //distance for sensoring a real avatar
string fName = "Orana";
string lName = "Kitty";

// stuff
integer iWaitCounter = 60;
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
   
    if (anima == "Stand" && llFrand(5) < 1)
    {
        anima = "Sit1";   
    }
    
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
    vector myVector = <randBetween(-2,2),randBetween(-2,2),myPos.z> ;
    myPos.z = 0;

    iWaitCounter = 60;
    Play("Walk");
    osNpcMoveToTarget(npc, myPos + myVector, OS_NPC_NO_FLY );
    llSetTimerEvent(0.5);
    Sound();
}

float randBetween(float min, float max)
{
    return llFrand(max - min) + min ;
}
dialog()
{
    channel = llCeil(llFrand(5000) + 5000);
    listener = llListen(channel,"","","");
    llDialog(llGetOwner(), "Choose:",["Start","Remove","Appearance"],channel);
}
Start()
{
    vector npcPos = llGetPos() + <1.0,1.0,1.0>;
    npc = osNpcCreate(fName,lName, npcPos, "Appearance");
    llSetObjectDesc(npc);
    npc_on = TRUE;
    llSensor("", NULL_KEY, AGENT_BY_LEGACY_NAME, max_distance, PI);  
}

default
{ 
    
    state_entry()
    {
        llSay(0,"Ready");
         osNpcRemove(llGetObjectDesc());
         dialog();
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
        llResetScript();
    }
    
    touch_start(integer x)
    {
        if (llDetectedKey(0) == llGetOwner())  {
            dialog();
        }
    }
    
    listen(integer channel, string name, key id, string msg) {
        llListenRemove (listener);
        if (msg == "Start")
        {
            if( !npc_on ) {
               Start();
            } else {
                llOwnerSay("Already running");
            }
        } else if (msg == "Remove")  {
            npc_on = FALSE;
            osNpcRemove(llGetObjectDesc());
            llSetTimerEvent(0);
        } else if (msg ==  "Appearance") {
            osAgentSaveAppearance(llGetOwner(), "Appearance");
            llOwnerSay("Your appearance has been saved");
        }
    
    }

    sensor(integer num)
    {
        Dest = llDetectedPos( 0 );
        walk_to_master(Dest);
    }
    no_sensor()
    {
         Play("Stand");
         llSleep(10);
         llSensor("", NULL_KEY, AGENT_BY_LEGACY_NAME, max_distance, PI);
    }
   
    timer()
    {
        vector pos;
        if (--iWaitCounter)  {
           
            list Poses = llGetObjectDetails(npc,[OBJECT_POS]);
            pos = llList2Vector(Poses, 0);
            
            if (llVecDist(pos, Dest ) > 4) {
                return;
            }
        }
        
        if (llFrand(5) < 0.5) { 
             if (llVecDist(pos, Dest ) <1) {
                Play("Claw");
                llTriggerSound("kitten4",1.0);
                llSleep(1.5);
            } else {
                Play("Meow");
                llTriggerSound("kitten3",1.0);
                llSleep(1.5);
            }
            
            
        } 
        
        Play("Stand");

        llSleep(llFrand(5) + 1);
        llSetTimerEvent(0);
        llSensor("", NULL_KEY, AGENT_BY_LEGACY_NAME, max_distance, PI);
        
    }
}
