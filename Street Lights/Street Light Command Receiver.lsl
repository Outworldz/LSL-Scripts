// Street Light Command Receiver v1.0
// Created by Tech Guy of IO 2015

// Configuration

    // Constants
    integer ComChannel = -8000;
    string EMPTY = "";
    list LightFaces = [2, 3];
    list Poles = [1, 4];
    
    // Input Message Reference IDS
    integer STATE = 0;
    integer LIGHTCOLOR = 1;
    integer WHITECOLOR = 2;
    integer INTENSITY = 3;
    integer RADIUS = 4;
    integer FALLOFF = 5;
    integer POLECOLOR = 6;
    
        // Light Parameters
        vector LightColor = <1.0,1.0,0.0>; // Yellow
        vector WhiteColor = <1.0,1.0,1.0>; // White
        float Intensity = 1.0;
        float Radius = 20.0;
        float FallOff = 0.5;
        float GlowON = 0.10;
        float GlowOFF = 0.0;
        // Light Pole Parameters
        vector PoleColor = <1.0,1.0,0.851>;
        float Alpha = 1.0; // Alpha Used with Color Parameters
        
    // Variables
    integer LightState = FALSE;
    integer ComHandle;
    // Switches
    integer DebugMode = FALSE;
    // Flags
    
    // Menus
    
// Functions

Initialize(){
    llOwnerSay("Initializing...");
    ComChannel = (integer)llGetObjectDesc();
    DebugMessage("Com Channel: "+(string)ComChannel);
    llListenRemove(ComHandle);
    llSleep(0.1);
    ComHandle = llListen(ComChannel, EMPTY, EMPTY, EMPTY);
}

ProcessMessage(string msg){
   list IncomingProperties = llParseString2List(msg, ["||"], []);
   string tempstate = llList2String(IncomingProperties, STATE);
   if(tempstate=="TRUE"){
       LightState = TRUE;
    }else{
        LightState = FALSE;
    }
   DebugMessage("Light State: "+(string)LightState);
   LightColor = llList2Vector(IncomingProperties, LIGHTCOLOR);
   DebugMessage("Light Color: "+(string)LightColor);
   WhiteColor = llList2Vector(IncomingProperties, WHITECOLOR);
   DebugMessage("White Color: "+(string)WhiteColor);
   Intensity = llList2Float(IncomingProperties, INTENSITY);
   DebugMessage("Radius: "+(string)Radius);
   Radius = llList2Float(IncomingProperties, RADIUS);
   DebugMessage("Fall Off: "+(string)FallOff);
   FallOff = llList2Float(IncomingProperties, FALLOFF);
   DebugMessage("Pole Color: "+(string)PoleColor);
   PoleColor = llList2Vector(IncomingProperties, POLECOLOR);
    LightSwitch(LightState);
}

LightSwitch(integer Mode){
    integer i;
    if(Mode){
        DebugMessage("Turning Light On...");
        for(i=0;i<llGetListLength(LightFaces);i++){
            llSetLinkPrimitiveParamsFast(llList2Integer(LightFaces, i), [
                PRIM_FULLBRIGHT, ALL_SIDES, TRUE,
                PRIM_POINT_LIGHT, TRUE, LightColor, Intensity, Radius, FallOff,
                PRIM_GLOW, ALL_SIDES, GlowON,
                PRIM_COLOR, ALL_SIDES, LightColor, Alpha
            ]);
        }
        for(i=0;i<llGetListLength(Poles);i++){
            llSetLinkPrimitiveParamsFast(llList2Integer(Poles, i), [
                PRIM_FULLBRIGHT, ALL_SIDES, TRUE,
                PRIM_COLOR, ALL_SIDES, PoleColor, Alpha
            ]);
        }
    }else{
        DebugMessage("Turning Light Off...");
        for(i=0;i<llGetListLength(LightFaces);i++){
            llSetLinkPrimitiveParamsFast(llList2Integer(LightFaces, i), [
                PRIM_FULLBRIGHT, ALL_SIDES, FALSE,
                PRIM_POINT_LIGHT, FALSE, WhiteColor, Intensity, Radius, FallOff,
                PRIM_GLOW, ALL_SIDES, GlowOFF,
                PRIM_COLOR, ALL_SIDES, WhiteColor, Alpha
            ]);
        }
        for(i=0;i<llGetListLength(Poles);i++){
            llSetLinkPrimitiveParamsFast(llList2Integer(Poles, i), [
                PRIM_FULLBRIGHT, ALL_SIDES, FALSE,
                PRIM_COLOR, ALL_SIDES, WhiteColor, Alpha
            ]);
        }
    }
}

DebugMessage(string msg){
    if(DebugMode){
        llOwnerSay(msg);
    }
}

// Main Program Operation

default{
    on_rez(integer params){
        llResetScript();
    }
    
    state_entry(){
        Initialize();   
    }
    
    listen(integer chan, string server, key id, string message){
        if(chan==ComChannel){
            ProcessMessage(message);
        }
    }
}    