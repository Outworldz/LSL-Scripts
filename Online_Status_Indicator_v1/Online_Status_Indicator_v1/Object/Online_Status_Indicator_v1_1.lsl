// :CATEGORY:Online Indicator
// :NAME:Online_Status_Indicator_v1
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:59
// :ID:583
// :NUM:799
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Online Status Indicator v1.lsl
// :CODE:

integer glow = TRUE;
integer bounce = FALSE; 
integer interpColor = TRUE;
integer interpSize = TRUE;     
integer wind = FALSE;
integer followSource = FALSE;
integer followVel = FALSE;

// Choose a pattern from the following:
// PSYS_SRC_PATTERN_EXPLODE
// PSYS_SRC_PATTERN_DROP
// PSYS_SRC_PATTERN_ANGLE_CONE_EMPTY
// PSYS_SRC_PATTERN_ANGLE_CONE
// PSYS_SRC_PATTERN_ANGLE
integer pattern = PSYS_SRC_PATTERN_ANGLE_CONE;

key target =        ""; 

float age =         4;
float minSpeed =    0;
float maxSpeed =    0;
string texture =    ""; 
float startAlpha =  1; 
float endAlpha =    1;
vector startColor = <1,1,1>;
vector endColor =   <1,1,1>;
vector startSize =  <.1,.1,.02>;
vector endSize =    <.1,.1,.6>;
vector push =       <0,0,0>;


float rate =        .01;      
float radius =      .2;       
integer count =     50;   
float outerAngle =  0;  
float innerAngle =  PI;   
vector omega =      <5,5,5>;

integer flags;

updateParticles()
{
    if (target == "owner")  target = llGetOwner();
    if (target == "self")   target = llGetKey();
    if (glow)               flags = flags | PSYS_PART_EMISSIVE_MASK;
    if (bounce)             flags = flags | PSYS_PART_BOUNCE_MASK;
    if (interpColor)        flags = flags | PSYS_PART_INTERP_COLOR_MASK;
    if (interpSize)         flags = flags | PSYS_PART_INTERP_SCALE_MASK;
    if (wind)               flags = flags | PSYS_PART_WIND_MASK;
    if (followSource)       flags = flags | PSYS_PART_FOLLOW_SRC_MASK;
    if (followVel)          flags = flags | PSYS_PART_FOLLOW_VELOCITY_MASK;
    if (target != "")       flags = flags | PSYS_PART_TARGET_POS_MASK;
   
    llParticleSystem([  PSYS_PART_MAX_AGE,          age,
                        PSYS_PART_FLAGS,            flags,
                        PSYS_PART_START_COLOR,      startColor,
                        PSYS_PART_END_COLOR,        endColor,
                        PSYS_PART_START_SCALE,      startSize,
                        PSYS_PART_END_SCALE,        endSize, 
                        PSYS_SRC_PATTERN,           pattern,
                        PSYS_SRC_BURST_RATE,        rate,
                        PSYS_SRC_ACCEL,             push,
                        PSYS_SRC_BURST_PART_COUNT,  count,
                        PSYS_SRC_BURST_RADIUS,      radius,
                        PSYS_SRC_BURST_SPEED_MIN,   minSpeed,
                        PSYS_SRC_BURST_SPEED_MAX,   maxSpeed,
                        PSYS_SRC_TARGET_KEY,        target,
                        PSYS_SRC_INNERANGLE,        innerAngle, 
                        PSYS_SRC_OUTERANGLE,        outerAngle,
                        PSYS_SRC_OMEGA,             omega,
                        PSYS_SRC_TEXTURE,           texture,
                        PSYS_PART_START_ALPHA,      startAlpha,
                        PSYS_PART_END_ALPHA,        endAlpha
                            ]);
}

integer gIsOnline = FALSE;
integer gLandOwner = FALSE;
key gKey = NULL_KEY;
string gName = "";
float UPDATE_INTERVAL = 5.0; 

updateStatus(string s){
    key k = llGetLandOwnerAt(llGetPos());
    if(s=="1"){
        gIsOnline = TRUE;
    }else{
        gIsOnline = FALSE;
    }
}

key getWhom(){
    if(gKey == NULL_KEY){
        if(gLandOwner){
            return llGetLandOwnerAt(llGetPos());
        }else{
            return llGetOwner();
        }
    }else{
        return gKey;
    }
}

doUpdate(){
    llRequestAgentData(getWhom(),DATA_ONLINE);
}

updateName(){
    llRequestAgentData(getWhom(),DATA_NAME);
}

enable(){
    updateName();
    doUpdate();
    llSetTimerEvent(1);
    llWhisper(0,"Online status display enabled.");
    
}
disable(){
    llSetTimerEvent(0);
    llSetText("Display Disabled",<1,1,1>,1);
    llSetColor(<0,0,1>,ALL_SIDES);
    startColor = <0,0,1>;
    endColor = <0,0,1>;
    updateParticles();
    llWhisper(0,"Online status display disabled.");
}

default
{
    state_entry()
    {
        llListen(0, "", llGetOwner(), "");
        enable();
        llWhisper(0,"Type /ol help for a list of commands");
    }
    on_rez(integer n){
        llResetScript();
    }
    dataserver(key req, string data){
        if(data == "1" || data == "0"){
            updateStatus(data);
        }else{
            gName = data;
            llSetText("Getting online status for " + gName,<1,1,1>,1);
            llSetColor(<0,0,1>,ALL_SIDES);
            startColor = <0,0,1>;
            endColor = <0,0,1>;
            updateParticles();
            llSetTimerEvent(UPDATE_INTERVAL);
        }
    }
    timer(){
        doUpdate();
        if(gIsOnline){
            llSetText(gName + " is Online",<1,1,1>,1);
            llSetColor(<0,1,0>,ALL_SIDES);
            startColor = <0,1,0>;
            endColor = <0,1,0>;
            updateParticles();
        }else{
            llSetText(gName + " is Offline",<1,1,1>,1);
            llSetColor(<1,0,0>,ALL_SIDES);
            startColor = <1,0,0>;
            endColor = <1,0,0>;
            updateParticles();
        }
    }
    listen(integer number, string name, key id, string msg){
        if (llGetSubString(msg, 0,0) != "/"){
            return;
        }
        list argv = llParseString2List(msg, [" "], []);
        integer argc = llGetListLength(argv);
        string cmd = llToLower(llList2String(argv, 0));
        if(cmd == "/ol"){
            string arg =  llToLower(llList2String(argv, 1));
            if(arg=="on"){
                enable();
            }else if(arg=="off"){
                disable();
            }else if(arg=="land"){
                gLandOwner = TRUE;
                gKey = NULL_KEY;
                updateName();
            }else if(arg=="key"){
                gKey = llList2Key(argv,2);
                updateName();
            }else if(arg=="me"){
                gLandOwner = FALSE;
                gKey = NULL_KEY;
                updateName();
            }else if(arg=="help"){
                llWhisper(0,"/ol on - activate online status display");
                llWhisper(0,"/ol off - disable online status display");
                llWhisper(0,"/ol land - display online status for owner of this land");
                llWhisper(0,"/ol me - display your online status");
            }
        }
    }
    
}
// END //
