// :CATEGORY:Rider
// :NAME:Tiger Rider
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-13 13:22:59
// :EDITED:2013-09-18 15:39:07
// :ID:996
// :NUM:1494
// :REV:1.0
// :WORLD:OpenSim
// :DESCRIPTION:
// Vehicle code for the Tiger Rider.   

// :CODE:

////////////////////////////////////////////////////////////////////////////////////
// comment these lines out for Opensim, leave uncommented for testing in LSLEditor
integer OS_NPC_SIT_NOW = 1;
integer OS_NPC_SENSE_AS_AGENT = 2;
integer OS_NPC_NO_FLY = 3;
vector vDestPos;

osNpcStand(key npc) {
    llOwnerSay("Standing");
}
vector osNpcGetPos(key id) {
    vDestPos.x += llFrand(1.0);        // some randomness for debugging
    llOwnerSay("Reached " + (string) vDestPos);
    return vDestPos;
}
osNpcMoveToTarget(key npc, vector target, integer options){
    llSay(0,"Moving to " + (string) target);
}
key osNpcCreate(string firstname, string lastname, vector position, string cloneFrom, integer option) {
    llSay(0,"Creating NPC " + firstname + " " + lastname + " at " + (string) position);
    return (key) "12345000-0000-0000-0000-0000000000002";
}
osNpcLoadAppearance(key npc, string notecard) {
    llSay(0,"Load notecard " + notecard);
}
osNpcPlayAnimation(key npc, string animation) {
    llSay(0,"Playing animation " + animation);
}
osNpcStopAnimation(key npc, string animation) {
    llSay(0,"Stopped animation " + animation);
}
osNpcSay(key npc, integer iChannel, string message) {
    llSay(0,"Saying " + message);
}
osNpcWhisper(key npc, integer iChannel, string message) {
    llSay(0,"Whispering " + message);
}
osNpcShout(key npc, integer iChannel, string message) {
    llSay(0,"Shouting " + message);
}
osNpcSit(key npc, key target, integer options) {
    llSay(0,"Sat on " +target);
}
osNpcSetRot(key npc, rotation rot) {
    llSay(0,"Set rotation of NPC to " + (string) rot);
}
osAgentSaveAppearance(key avatar, string notecard) {
    llSay(0,"Created Notecard " + notecard);
}
osNpcRemove (key  target) {
    llSay(0,"NPC removed");
}
list osGetAvatarList () {
    list lStuff = [(key) "12345000-0000-0000-0000-0000000000002", vDestPos, "Digit Gorilla"];
    return lStuff;
}
osMakeNotecard(string notecardName, string contents) {
    llOwnerSay("Make Notecard " + notecardName + "Contents:" +  (string) contents);
}
string osGetNotecard(string name) {
    // sample notecard for testing
    string str = "@spawn=Digit Gorilla|<645, 128, 25>\n"
        + "@walk=<645, 120, 25>\n"
        + "REPEAT\n"
        + "@cmd=0|Hello on channel 0\n"
        + "@wander=3|5\n"
        + "@say=say , walking is so tiresome...\n"
        + "@whisper=whisper, walking is so tiresome...\n"
        + "@shout=shout, walking is so tiresome...\n"
        + "@goto=REPEAT\n"
        + "@goto=NEXT\n"
        + "@say=i will never say this...\n"
        + "NEXT\n"
        + "@sound=somesound\n"
        + "@randsound\n"
        + "@pause=5\n"
        + "@rotate=90\n"
        + "@wander=3|1\n"
        + "@say=Uff, I'm done...\n"
        + "@delete\n";
    return str;
}

// END commented code for OpenSim vs Editor environments
//******************************************************


integer debug = TRUE;         // set to TRUE or FALSE for debug chat on various actions
integer NPC = TRUE;  // set to TRUE to get a NPC
 
// OpenSim & ODE
 
// avatar control animations
string AvatarSit = "Ride_Tiger";
string AvatarWalk = "Ride_Tiger";

// NOPC animations

string NPCSit = "Stand";
string NPCStand = "Stand";
string NPCWalk = "Walk";

string whatsplaying = "";      // the currentply playing NPC automation

integer Private = 0;    // Change to 1 to prevent others riding.

vector Sitpos = <0.35,0,0.35>;
vector SitrotV = <0,-20,0>;
rotation Sitrot; 
integer animation_allowed = FALSE;
key Agent;

float forward_power = 16; //Power used to go forward (1 to 30)
float reverse_power = -8; //Power ued to go reverse (-1 to -30)
float turning_ratio = 1.5; //How sharply the vehicle turns. Less is more sharply. (.1 to 10)

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


SetMaterial()
{
    llSetPrimitiveParams([PRIM_MATERIAL, PRIM_MATERIAL_GLASS]);
    llMessageLinked(LINK_ALL_OTHERS, 0, "SetMat", NULL_KEY);    // Tell daughter pims on ground to be glass
}

// pipeline for animations for the owner
AvatarAnimate(string animation)
{
    if (animation != last_animation) {
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
        llSleep(howlong);
        whatsplaying = what;
    }       
}

// Make the mouth move and play a sound
Growl()
{
    DEBUG("Growl");
    llTriggerSound("Tiger growl 1",1.0);
    NPCPlay("Tiger_Growl" ,5);   
}




setVehicle()
{
    //car
    llSetVehicleType(VEHICLE_TYPE_CAR);
    llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 0.2);
    llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 0.80);
    llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, 0.10);
    llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 0.10);
    llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_TIMESCALE, 1.0);
    llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 0.1);
    llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_TIMESCALE, 0.1);
    llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, 0.1);
    llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <10.0, 2.0, 1000.0>);
    llSetVehicleVectorParam(VEHICLE_ANGULAR_FRICTION_TIMESCALE, <0.1, 0.1, 0.1>);
    llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, 0.1);
    llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 5.0);
}

    
Init()
{
    
    llSetStatus(STATUS_PHYSICS, FALSE);
    vector here = llGetPos();
//    float h = llGround(<0,0,0>) + 0.52;
    vector rotv = llRot2Euler(llGetRot());
    rotation rot = llEuler2Rot(<0,0,rotv.z>);
  //  llSetPos(<here.x, here.y,h>);
    llSetRot(rot);
    Sitrot = llEuler2Rot(DEG_TO_RAD * SitrotV);
    llSetVehicleType(VEHICLE_TYPE_NONE);
    Run = 0;
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
        SetMaterial();
        llSetSitText(sit_message);
        // forward-back,left-right,updown
        llSitTarget(Sitpos, Sitrot);

        osNpcRemove(KeyValueGet("key"));
        if (NPC)  KeyValueSet("key", osNpcCreate("Tiger", "Rider", llGetPos(), "Appearance", OS_NPC_SENSE_AS_AGENT));    // no OS_NPC_SENSE_AS_AGENT allowed due to llSensor Use
       if (NPC)  osNpcLoadAppearance(KeyValueGet("key"), "Appearance");
        
        if (NPC)  osNpcSit(KeyValueGet("key"), llGetKey(), OS_NPC_SIT_NOW);

        whatsplaying = NPCSit;
        
    }
    
    on_rez(integer rn)
    {
        llResetScript();
    }

    link_message(integer sender_number, integer number, string message, key id)
    {
        DEBUG(" Main script heard:" + message + " with key " + (string) id);
        if (message == "Seated")
        {
            Agent = id; 
            setVehicle();
            
            llSleep(.4);
            llSetStatus(STATUS_PHYSICS, TRUE);
            llSleep(.1);
            Run = 1;
            llSetTimerEvent(0.3);
            llRequestPermissions(Agent, PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS);
            
            DEBUG("Starting platform");
        } else if (message == "Unseated")    {

            Init(); // shut down physics
            llReleaseControls();
            animation_allowed = FALSE;
            Run = 0;            
            NPCPlay(NPCSit,1); 
            llSetTimerEvent(0.0);
        }

    }
    
    changed(integer change)
    {
        if (change & CHANGED_LINK)
        {
            key  tiger = llAvatarOnSitTarget();
            if (tiger  != NULL_KEY)
            {                
                if( (tiger != llGetOwner())  )
                {
                    DEBUG("Tiger Seated");
                    // tiger
                    
                }
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
                
                
                Growl();

                NPCPlay(NPCStand,1);
                
                llTakeControls(CONTROL_FWD | CONTROL_BACK | CONTROL_DOWN | CONTROL_UP | CONTROL_RIGHT |
                    CONTROL_LEFT | CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT, TRUE, FALSE);
            }

            if (perm & PERMISSION_TRIGGER_ANIMATION)
            {
                animation_allowed = TRUE;
                AvatarAnimate(AvatarSit);
            }
            
        }
    }
    
    
    control(key id, integer level, integer edge)
    {
        integer reverse=1;
        vector angular_motor;
        
        //get current speed
        vector vel = llGetVel();
        Speed = llVecMag(vel);
        //DEBUG((string)Speed);

        //car controls
        if(level & CONTROL_FWD)
        {
            llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <10.0, 2.0, 1000.0>);
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <forward_power,0,0>);
            reverse=1;
        }
        if(level & CONTROL_BACK)
        {
            llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <10.0, 2.0, 1000.0>);
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <reverse_power,0,0>);
            reverse = -1;
        }

        if(level & (CONTROL_RIGHT|CONTROL_ROT_RIGHT))
        {
            angular_motor.z -= Speed / turning_ratio * reverse;
            turncount = 10;
        }
        
        if(level & (CONTROL_LEFT|CONTROL_ROT_LEFT))
        {
            angular_motor.z += Speed / turning_ratio * reverse;
            
            turncount = 10;
        }

        llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, angular_motor);
        if(turncount > 0)
        {
            turncount--;
        }

    } //end control       

    timer(){
        if(Run == 1){
            vector vel = llGetVel();

            Speed = llVecMag(vel);
            //DEBUG("vecMag Speed " + (string)Speed);            

            if(Speed > 0.0)
            {
                NPCPlay(NPCWalk,1);
                AvatarAnimate(AvatarWalk);
                
                llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <1.0, 2.0, 1000.0>);
                llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <0,0,0>);
            }
            else {
                AvatarAnimate(AvatarSit);
                NPCPlay(NPCStand,1);
            }
            
            llSetTimerEvent(0.3);          // If restarted timer() appears to keep working  
        }else{
            llSetTimerEvent(0.0);
        }
    }
    
} //end default
