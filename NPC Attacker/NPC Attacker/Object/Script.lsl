// :SHOW:
// :CATEGORY:OpenSim NPC
// :NAME:NPC Attacker
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2015-08-28 23:27:14
// :EDITED:2015-08-28  22:27:14
// :ID:1085
// :NUM:1825
// :REV:1.1
// :WORLD:OpenSim
// :DESCRIPTION:
//  This is a  NPC attacker for Opensim. I use it in a RAM to butt people.
// License: http://creativecommons.org/licenses/by-nc
// :CODE:

// 8-1-2014 for Rambo, the attack Ram
// 8-11-2014 make a round prim, set it to phantom, add this script.  Yotouch it to record your appearance as a RAM
// Set the prim to 4 X 4 meters and the Ram will stay ontop of it and attack anyone that steps on it.

integer debug = FALSE;
key avatarKey;
vector vRandSpot ;

DEBUG(string msg)
{
    if (debug) 
        llOwnerSay(msg);
}
     
// tunables
float max_distance; //distance for sensoring a real avatar
string fName = "Cobra";
string lName = "";
float  SenseTime = 10;
integer JamTimer = 10;

// OS_NPC_CREATOR_OWNED will create an 'owned' NPC that will only respond to osNpc* commands issued from scripts that have the same owner as the one that created the NPC.
// OS_NPC_NOT_OWNED will create an 'unowned' NPC that will respond to any script that has OSSL permissions to call osNpc* commands.
integer  NPCOptions = OS_NPC_CREATOR_OWNED;    // only the owner of this box can control this NPC.
integer iWaitCounter ;    // 10 second attack counter
integer iListenChannel; // dialog channel
integer iListenHandle; // holds the listener handle;
key kNPCKey;    // npc key
integer off = FALSE;
string lastAnim;            // thw last animation played
vector vSensedPos ;    // the last place we sensed an avatar
vector vDestination;    // where we are headed

// animations list
string Stand = "SnakeStand";
string Idle = "SnakeStand";
string Run = "SnakeStand";
string Walk = "SnakeWalk";

// Sounds
string AttackSound = "Hiss";
string YouLose = "sad-trombone";

Restart() {
            // we must have fallen down and  can't get up

    osNpcRemove((key) KeyValueGet("key"));

    // reboot
    
    Start();
    llSleep(2);
    iWaitCounter = JamTimer;

    
}
// this function is  Copyright (C) 2013 Wizardry and Steamworks - License: GNU GPLv3    //

string KeyValueGet(string var) {
    list dVars = llParseString2List(llGetObjectDesc(), ["&"], []);
    do {
        list data = llParseString2List(llList2String(dVars, 0), ["="], []);
        string k = llList2String(data, 0);
        if(k != var) jump continue;
        //DEBUG("got " + var + " = " +  llList2String(data, 1));
        return llList2String(data, 1);
        @continue;
        dVars = llDeleteSubList(dVars, 0, 0);
    } while(llGetListLength(dVars));
    return "";
}
// this function is  Copyright (C) 2013 Wizardry and Steamworks - License: GNU GPLv3    //
KeyValueSet(string var, string val) {

    //DEBUG("set " + var + " = " + val);
    list dVars = llParseString2List(llGetObjectDesc(), ["&"], []);
    if(llGetListLength(dVars) == 0)
    {
        llSetObjectDesc(var + "=" + val);
        return;
    }
    list result = [];
    do {
        list data = llParseString2List(llList2String(dVars, 0), ["="], []);
        string k = llList2String(data, 0);
        if(k == "") jump continue;
        if(k == var && val == "") jump continue;
        if(k == var) {
            result += k + "=" + val;
            val = "";
            jump continue;
        }
        string v = llList2String(data, 1);
        if(v == "") jump continue;
        result += k + "=" + v;
        @continue;
        dVars = llDeleteSubList(dVars, 0, 0);
    } while(llGetListLength(dVars));
    if(val != "") result += var + "=" + val;
    llSetObjectDesc(llDumpList2String(result, "&"));
}


Play(string anima)
{
    if (anima == lastAnim)
        return;
   
    if (anima == Stand && llFrand(3) < 1)
    {
        anima = Idle;   
    }
    
    DEBUG(anima);
    osNpcPlayAnimation(kNPCKey,anima);
    osNpcStopAnimation(kNPCKey,lastAnim);
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
    DEBUG(name);
}

 
GoTo(vector myPos)
{
    DEBUG("Walk to " + (string) myPos);
    myPos.z += .5;
    
    osNpcMoveToTarget(kNPCKey, myPos, OS_NPC_NO_FLY  );
}

float randBetween(float min, float max)
{
    return llFrand(max - min) + min ;
}


dialog(key avi)
{
    iListenChannel = llCeil(llFrand(5000) + 5000);
    iListenHandle = llListen(iListenChannel,"","","");
    llDialog(avi, "Choose:",["Start","Remove","Save Appearance"],iListenChannel);
}

Start()
{
    vector size = llGetScale();
    max_distance = size.x/2;
    iWaitCounter = JamTimer;
    vDestination = llGetPos();


    osNpcRemove((key) KeyValueGet("key"));
    llSleep(1);
    vector npcPos = llGetPos() + <0.0,0.0,1.0>;
    kNPCKey = osNpcCreate(fName,lName, npcPos, "Appearance",NPCOptions);
    KeyValueSet("key",(string) kNPCKey);
    off = FALSE;
    llSensorRepeat("", NULL_KEY, AGENT, max_distance, PI,SenseTime);
}


vector CirclePoint(float radius) {
    float x = llFrand(radius *2) - radius;        // +/- radius, randomized
    float y = llFrand(radius *2) - radius;        // +/- radius, randomized
    return <x, y, 0>;        // so this should always happen
}


default
{ 
    
    state_entry()
    {
        Start();
    }
    
    changed (integer what)
    {
        if (what & CHANGED_REGION_RESTART)
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
        if (llDetectedKey(0) == llGetOwner())  {
            dialog(llDetectedKey(0));
        }
    }
    
    listen(integer channel, string name, key id, string msg) {
        llListenRemove (iListenHandle);
        if (msg == "Start")
        {
            if( off ) {
               Start();
            } else {
                llOwnerSay("Already running");
            }
        } else if (msg == "Remove")  {
            off = TRUE;
            osNpcRemove((key) KeyValueGet("key"));
            llSetTimerEvent(0);
        } else if (msg ==  "Save Appearance") {
            osAgentSaveAppearance(llGetOwner(), "Appearance");
            llOwnerSay("Your appearance has been saved");
        } 
    
    }

    sensor(integer num)
    {
        DEBUG("sensed");
        
        vector Dest = llDetectedPos(0);
        avatarKey = llDetectedKey(0);
        iWaitCounter = JamTimer;        // 10 second attacks

        vSensedPos = Dest; // make a backup, no trashing the 'real' Dest we will walk to
        vSensedPos.z = 0;
        
        GoTo(Dest);
        llPlaySound(AttackSound,1.0);

        llSetTimerEvent(2);    // check Positions every couple of seconds
        
    }
    
    no_sensor()
    {
        DEBUG("noone");

        llSetTimerEvent(0);
        
        list npcPosition = llGetObjectDetails(kNPCKey,[OBJECT_POS]);
        vector vNpcPos = llList2Vector(npcPosition, 0);

        float Distance = llVecDist(vNpcPos, vDestination )  ;
        DEBUG("Distance: " + (string) Distance);
            
        if (Distance > 1.0)  {
            
            Play(Walk);
            DEBUG("idlectr: " + iWaitCounter);
            if (! --iWaitCounter) { 
                Restart();
            } 

        }  else {
            // new destination
            Play(Idle);    // munchies
            vRandSpot = CirclePoint(max_distance);
            vDestination = llGetPos() + vRandSpot;
            iWaitCounter = JamTimer;
        }        
         GoTo(vDestination);
    }
    

    timer()
    {
        
        llPreloadSound(YouLose);
        Play(Run);

            // we only have so many seconds to get there
        if (! --iWaitCounter) { 
            Restart();
        } 
  
        list npcPosition = llGetObjectDetails(kNPCKey,[OBJECT_POS]);
        vector vNpcPos = llList2Vector(npcPosition, 0);
        vNpcPos.z = 0; // ignore height by using z = 0
    
        list aviPosition = llGetObjectDetails(avatarKey,[OBJECT_POS]);
        vector vAviPos = llList2Vector(aviPosition, 0);
        vAviPos.z = 0; // ignore height by using z = 0
         
        
        if (llVecDist(vNpcPos, vAviPos ) < 1.5 ) {

            llTriggerSound(YouLose,1.0);
            DEBUG("Dead");
            llSleep(5.0);
            llMessageLinked(LINK_SET,0,"DEAD",avatarKey);
            Play(Stand);          // cancel the hot ramming action
        }        
    }    
}
