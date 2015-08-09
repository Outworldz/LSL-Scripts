// :CREATED: 9-8-2014
// :REV: 1.0
// :DESCRIPTION: 
// Vehicle code for the Tiger Rider.   

// :CODE:


integer debug = TRUE;         // set to TRUE or FALSE for debug chat on various actions
integer NPC = TRUE;  // set to TRUE to get a NPC
 
// OpenSim & ODE
 
// avatar control animations
string AvatarSit = "avatar_sit_generic";
string AvatarWalk = "avatar_sit_generic";


// NPC animations

 
string NPCSit = "Stand";
string NPCStand = "Stand";
string NPCWalk = "TigerRegularWalk";
string NPCFly = "Fly";
string NPCGrowl = "Tiger_Growl";

string whatsplaying = "";      // the currently playing NPC automation

integer Private = 0;    // Change to 1 to prevent others riding.
integer NPCAlive = FALSE;   // set to true when NPC is alive
vector Sitpos =<0.35,0,1>;
vector SitrotV = <0,-20,0>;
rotation Sitrot;
integer animation_allowed = FALSE;
key Agent;

float forward_power = 5; //Power used to go forward (1 to 30)
float reverse_power = 5; //Power ued to go reverse (-1 to -30)
float turning_ratio = .1; //How sharply the vehicle turns. Less is more sharply. (.1 to 10)
integer turncount;

float Speed;
integer Run;
string last_animation; // the last animation played on the owner
string sit_message = "Ride"; //Sit message


DEBUG(string str)
{
    if (debug)
        llOwnerSay(llGetScriptName()+":" +  str);                    // Send the owner debug info so you can chase NPCS
}

// TUNABLE CONSTANTS
float OFFSET = -1.0;         // how far below water to swim or ride
integer iPRIVATE = TRUE;    // if FALSE, anyone can drive
integer iDELETEME = FALSE;  // if FALSE, the vehicle will delete itselft if not PRIVATE
string SIT = "dz";          // you sit animation
vector vFWD = <0.5,0,0>;    // Up arrow
vector vBACK = <-0.5,0,0>;  // down arrow
vector vUP = <0,0,1.0>;     // Pg Up movement
vector vDOWN = <0,0,-1.0>;  // Pg down movement
vector vRIGHT = <0,0,-15.0>; // right turn
vector vLEFT = <0,0,15.0>;  // left turn
vector vBUMP = <0,0,0.1>;   // in case we hit the ground

// variables
integer iRunning;        // set to TRUE if vehicle is sat on by owner
key kDriver;            // the driver
rotation rRight;    // holds vRight in rotation format
rotation rLeft;     // ditto
    
setRotation(rotation rDegrees)
{
    llSetRot(llGetRot() * rDegrees);    // add the rotation (yes, add is a *)
}

FindGroundOrWater( vector direction)
{
    vector vTarget = llGetPos()+ direction * llGetRot();
    vTarget.z = llGround( ZERO_VECTOR );    
    float fWaterLevel = llWater( ZERO_VECTOR );

    if( vTarget.z < fWaterLevel ) 
        vTarget.z = fWaterLevel+OFFSET;
    llSetRegionPos(vTarget);
}



Walk ()
{
    NPCPlay(NPCWalk,1);
    AvatarAnimate(AvatarWalk);
    llSetTimerEvent(1.0);
}



Fly ()
{
    NPCPlay(NPCFly,1);
    AvatarAnimate(AvatarWalk);
}


// pipeline for animations for the owner
AvatarAnimate(string animation)
{
   
    if (animation != last_animation) {
         DEBUG("anim:" + animation);
        llStartAnimation(animation);
        llStopAnimation(last_animation);
        last_animation = animation;
    }
}

// and for the NPC
NPCPlay(string what, float howlong)
{
    if (whatsplaying != what) {
        DEBUG("Playing NPC animation " + what);

        if (NPC) osNpcPlayAnimation(KeyValueGet("key"), what);
        if (NPC) osNpcStopAnimation(KeyValueGet("key"), whatsplaying);
//        llSleep(howlong);
        whatsplaying = what;
    }       
}

// Make the mouth move and play a sound
Growl()
{
    DEBUG("Growl");
    llTriggerSound("Tiger growl 1",1.0);
    NPCPlay(NPCGrowl ,2);   
}




setVehicle()
{
   
}

    
Init()
{
    rLeft = llEuler2Rot(vLEFT *DEG_TO_RAD);        // do the math up front where it is free, and use quaternions later
    rRight = llEuler2Rot(vRIGHT *DEG_TO_RAD);

    llSetCameraEyeOffset(<-5.0,0.0,2.0>);// I nuu wanna be staring at every hair follicle in the back o my head.
    llSetCameraAtOffset(<0.0,0.0,2.0>);
}

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


KeyValueDelete(string var) {
    list dVars = llParseString2List(llGetObjectDesc(), ["&"], []);
    list result = [];
    list added = [];
    do {
        list data = llParseString2List(llList2String(dVars, 0), ["="], []);
        string k = llList2String(data, 0);
        if(k == var) jump continue;
        string v = llList2String(data, 1);
        if(v == "") jump continue;
        if(llListFindList(added, (list)k) != -1) jump continue;
        result += k + "=" + v;
        added += k;
        @continue;
        dVars = llDeleteSubList(dVars, 0 ,0);
    } while(llGetListLength(dVars));
    //DEBUG("del " + var );
    llSetObjectDesc(llDumpList2String(result, "&"));
}




default
{
    state_entry()
    {

        Init();
        llSetSitText(sit_message);
        // forward-back,left-right,updown
        llSitTarget(Sitpos, Sitrot);

        osNpcRemove(KeyValueGet("key")); 
    }
    
    on_rez(integer rn)
    {
        llResetScript();
    }

    link_message(integer sender_number, integer number, string message, key id)
    {
        DEBUG("heard:" + message);
        if (message == "Seated")
        {
            Agent = id;
            setVehicle();
            Run = 1;
            llRequestPermissions(Agent, PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS);
            DEBUG("Starting platform");
        } else if (message == "Unseated")    {

            Init(); // shut down physics
            llReleaseControls();
            animation_allowed = FALSE;
            Run = 0;            
            NPCPlay(NPCStand,1);

            Growl();
            osNpcRemove(KeyValueGet("key"));
            llSetTimerEvent(0.0);
            NPCAlive = FALSE;
        }

    }
    
    changed(integer change)
    {
        if (change & CHANGED_LINK)
        {
            Agent = llAvatarOnSitTarget();
            if (Agent != NULL_KEY)
            {                
                if( (Agent != llGetOwner())  )
                {
                    DEBUG("Tiger Seated");
                    // tiger
                    //Growl();
                    //NPCPlay(NPCSit,0);
                }
                
            }
            else
            {
                DEBUG("Rider Seated");
            }
        }
    }
     
    run_time_permissions(integer perm)
    {
        if (perm) 
        {
            llOwnerSay("Perms check");

            if (perm & PERMISSION_TAKE_CONTROLS)
            {
                llMessageLinked(LINK_SET,0,"PoseOff","");    // show pose ball
                
                if (! NPCAlive) {
                    if (NPC)  KeyValueSet("key", osNpcCreate("Tiger", "Rider", llGetPos(), "Appearance", OS_NPC_SENSE_AS_AGENT));    // no OS_NPC_SENSE_AS_AGENT allowed due to llSensor Use
                    if (NPC)  osNpcLoadAppearance(KeyValueGet("key"), "Appearance");
            
                    if (NPC)  osNpcSit(KeyValueGet("key"), llGetKey(), OS_NPC_SIT_NOW);
                    whatsplaying = NPCSit;
                    NPCAlive = TRUE;
                }
                
        
                
                llTakeControls(CONTROL_FWD | CONTROL_BACK | CONTROL_DOWN | CONTROL_UP | CONTROL_RIGHT |
                    CONTROL_LEFT | CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT, TRUE, FALSE);
                    
                llSetTimerEvent(0.10);
            }

            if (perm & PERMISSION_TRIGGER_ANIMATION)
            {
                animation_allowed = TRUE;
                AvatarAnimate(AvatarSit);
            }
            
        }
    }
    
    
    control(key n,integer level,integer e)
    {
        if(level & CONTROL_FWD)  {

            Walk();
            FindGroundOrWater(vFWD);
        }
        if(level & CONTROL_BACK) {
            Walk();
            FindGroundOrWater(vBACK);
        }
        if(level & CONTROL_LEFT || level & CONTROL_ROT_LEFT)    {
            Walk();
            setRotation(rLeft);
        }
        if(level & CONTROL_RIGHT|| level & CONTROL_ROT_RIGHT)  {
            Walk();
            setRotation(rRight); 
        }
        if(level & CONTROL_UP)                          {
            Fly();
            llSetRegionPos(llGetPos()+ vUP *llGetRot());
        }
        if(level & CONTROL_DOWN)                        {
            Fly();
            llSetRegionPos(llGetPos()+vDOWN *llGetRot());
        }        
        
    }

  
    timer(){
        NPCPlay(NPCStand,1);
        AvatarAnimate(AvatarWalk);
                
        llSetTimerEvent(0.0);
    }
    
} //end default

