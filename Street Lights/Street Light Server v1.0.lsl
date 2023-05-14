// Street Light Control Server v1.0
// Created by Tech Guy

// Configuration

    // Constants
integer ServerComChannel; // Secret Negative Channel for Server Communication
integer MenuComChannel; // Channel for Menu Communication
integer ComHandle; // Hold Handle to Control Server Com Channel
integer MenuComHandle; // Handle for Menu Communications Listener
list AuthedUsers = []; // Wil Contain List of Authorized Users (For Menu)
string EMPTY = "";
float LightHoldLength = 0.1;
string cName = ".config"; // Name of Configuration NoteCard

        // Indicator Light Config
    float GlowOn = 0.10;
    float GlowOff = 0.0;
    list ONColorVectors = [<0.0,1.0,0.0>,<1.0,0.5,0.0>,<1.0,0.0,0.0>];
    list ColorNames = ["Green", "Orange", "Red"];
    list OFFColorVectors = [<0.0,0.5,0.0>,<0.5,0.25,0.0>,<0.5,0.0,0.0>];
    integer PWRLIGHT = 2;
    integer CFGLIGHT = 3;
    integer INLIGHT = 4;
    integer OUTLIGHT = 5;
    
    // Variables
integer cLine; // Holds Configuration Line Index for Loading Config Loop
key cQueryID; // Holds Current Configuration File Line during Loading Loop
integer lightsOn = FALSE;
string PropertiesString; // Hold Compiled String of Light Properties and Colors 
float HoldTimer; // Length of Timer before rerunning Sky Check after a manual light mode change.
        // Light Parameters
        vector LightColor = <1.0,1.0,0.0>; // Yellow
        vector WhiteColor = <1.0,1.0,1.0>; // White
        float Intensity = 1.0;
        float Radius = 20.0;
        float FallOff = 0.5;
        
        // Light Pole Parameters
        vector PoleColor = <1.0,1.0,0.851>;
        float Alpha = 0.0; // Alpha Used with Color Parameters

    // Switches
integer DebugMode = FALSE; // Are we running in with Debug Messages ON?
    // Flags

// Configuration Directives
float CheckTimer = 30.0; // Frequency of Sun Angle Check Routine
    
    // Functions

Initialize(){
    llSleep(LightHoldLength);
    llListenRemove(ComHandle);
    llListenRemove(MenuComChannel);
    llSleep(0.5);
    ComHandle = llListen(ServerComChannel, EMPTY, EMPTY, EMPTY);
    MenuComChannel = (integer)(llFrand(-1000000000.0) - 1000000000.0);
    DebugMessage(llGetObjectName()+" Server Online");
    llOwnerSay("Configuring...");
    cQueryID = llGetNotecardLine(cName, cLine);
}

LightToggle(integer LinkID, integer ISON, string Color){
    if(ISON){
        vector ColorVector = llList2Vector(ONColorVectors, llListFindList(ColorNames, [Color]));
        llSetLinkPrimitiveParamsFast(LinkID, [
            PRIM_COLOR, ALL_SIDES, ColorVector, 1.0,
            PRIM_GLOW, ALL_SIDES, GlowOn,
            PRIM_FULLBRIGHT, ALL_SIDES, TRUE
        ]);
    }else{
        vector ColorVector = llList2Vector(OFFColorVectors, llListFindList(ColorNames, [Color]));
        llSetLinkPrimitiveParamsFast(LinkID, [
            PRIM_COLOR, ALL_SIDES, ColorVector, 1.0,
            PRIM_GLOW, ALL_SIDES, GlowOff,
            PRIM_FULLBRIGHT, ALL_SIDES, FALSE
        ]);
    }
}

LoadConfig(string data){
    LightToggle(CFGLIGHT, TRUE, "Orange");
    if(data!=""){ // If Line is not Empty
        //  if the line does not begin with a comment
        if(llSubStringIndex(data, "#") != 0)
        {
        //  find first equal sign
            integer i = llSubStringIndex(data, "=");
 
        //  if line contains equal sign
            if(i != -1){
                //  get name of name/value pair
                string name = llGetSubString(data, 0, i - 1);
 
                //  get value of name/value pair
                string value = llGetSubString(data, i + 1, -1);
 
                //  trim name
                list temp = llParseString2List(name, [" "], []);
                name = llDumpList2String(temp, " ");
 
                //  make name lowercase
                name = llToLower(name);
 
                //  trim value
                temp = llParseString2List(value, [" "], []);
                value = llDumpList2String(temp, " ");
 
                //  Check Key/Value Pairs and Set Switches and Lists
                if(name=="debugmode"){
                    if(value=="TRUE" || value=="true"){
                        DebugMode = TRUE;
                        llOwnerSay("Debug Mode: Enabled!");
                    }else if(value=="FALSE" || value=="false"){
                        DebugMode = FALSE;
                        llOwnerSay("Debug Mode: Disabled!");
                    }
                }else if(name=="lightcolor"){ // Set Color of Light during On State
                    LightColor = (vector)value;
                    DebugMessage("Light Color: "+(string)LightColor);
                }else if(name=="whitecolor"){
                    WhiteColor = (vector)value;
                    DebugMessage("White Color: "+(string)WhiteColor);
                }else if(name=="intensity"){
                    Intensity = (float)value;
                    DebugMessage("Light Intensity: "+(string)Intensity);
                }else if(name=="radius"){
                    Radius = (float)value;
                    DebugMessage("Light Radius: "+(string)Radius);
                }else if(name=="falloff"){
                    FallOff = (float)value;
                    DebugMessage("Light FallOff: "+(string)FallOff);
                }else if(name=="polecolor"){
                    PoleColor = (vector)value;
                    DebugMessage("Pole Color: "+(string)PoleColor);
                }else if(name=="user"){
                    AuthedUsers = AuthedUsers + [value];
                    DebugMessage("New Machine Authed User: "+value);
                }else if(name=="servercomchannel"){
                    ServerComChannel = (integer)value;
                    DebugMessage("Server Com Channel: "+(string)ServerComChannel);
                }else if(name=="checktimer"){
                    CheckTimer = (float)value;
                    DebugMessage("Check Timer: "+(string)CheckTimer);
                }else if(name=="holdtimer"){
                    HoldTimer = (float)value;
                    DebugMessage("Hold Timer: "+(string)HoldTimer);
                }
                LightToggle(CFGLIGHT, FALSE, "Orange");
        }else{ //  line does not contain equal sign
                llOwnerSay("Configuration could not be read on line " + (string)cLine);
            }
        }
    }
}

// Check Sun Angle Routine (If Below Horizon, Toggle Lights) 
CheckSun()
{
    vector sun = llGetSunDirection();
    integer turnLightsOn = (sun.z < 0);
    if(turnLightsOn != lightsOn)
    {
        DebugMessage("Sun Position Changed...");
        lightsOn = turnLightsOn;
        MessageLights(lightsOn); // Send Message to Lights
    }
}

// Check if Light Should be on/off and send appropriate message
MessageLights(integer LightState){
    string StateMessage;
    if(LightState==TRUE){
       DebugMessage("SunSet Detected, Messaging Lights...");
       StateMessage = "TRUE";
    }else if(LightState==FALSE){
       DebugMessage("SunRise Detected, Messaging Lights...");
       StateMessage = "FALSE";
    }
    string SendString = StateMessage + "||" + PropertiesString;
    llRegionSay(ServerComChannel, SendString);
    DebugMessage("Sending String: "+SendString+"\rOn Channel: "+(string)ServerComChannel);
}

DebugMessage(string msg){
    if(DebugMode){
        llOwnerSay(msg);
    }
}

CompileProperties(){
    DebugMessage("Compiling Properties String...");
    list Properties = [LightColor, WhiteColor, Intensity, Radius, FallOff, PoleColor];
    PropertiesString = llDumpList2String(Properties, "||");
    DebugMessage("Properties String:\r"+PropertiesString);
}

// Main Program
default{
    on_rez(integer params){
        llResetScript();
    }
    
    state_entry(){
        LightToggle(PWRLIGHT, TRUE, "Red");
        llSleep(LightHoldLength);
        LightToggle(INLIGHT, TRUE, "Green");
        llSleep(LightHoldLength);
        LightToggle(INLIGHT, FALSE, "Green");
        LightToggle(OUTLIGHT, TRUE, "Green");
        Initialize();
    }
    
    dataserver(key query_id, string data){       // Config Notecard Read Function Needs to be Finished
        if (query_id == cQueryID){
            if (data != EOF){ 
                LoadConfig(data); // Process Current Line
                ++cLine; // Incrment Line Index
                cQueryID = llGetNotecardLine(cName, cLine); // Attempt to Read Next Config Line (Re-Calls DataServer Event)
            }else{ // IF EOF (End of Config loop, and on Blank File)
                LightToggle(CFGLIGHT, TRUE, "Green");
                llSleep(LightHoldLength);
                LightToggle(CFGLIGHT, FALSE, "Green");
                CompileProperties();
                // CHECK HERE
                llSetTimerEvent(CheckTimer);
            }
        }
    }
    
    touch(integer num){
        if(num>1){
            return;
        }
        llSetTimerEvent(HoldTimer);
        if(lightsOn){
            DebugMessage("Turning Lights OFF for "+(string)CheckTimer+" Seconds!");
            MessageLights(FALSE);
            lightsOn = FALSE;
        }else{
            DebugMessage("Turning Lights ON for "+(string)CheckTimer+" Seconds!");
            MessageLights(TRUE);
            lightsOn = TRUE;
        }
    }
    
    timer(){
        llSetTimerEvent(CheckTimer);
        if(DebugMode){
            llOwnerSay("Checking Sun Angle...");
        }
        CheckSun();
    }
    
    changed(integer c){
        if(c & CHANGED_INVENTORY){
            llResetScript();
        }
    }
}