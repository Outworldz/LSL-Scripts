//Hot Tube Engine V1.0
// Created by Tech Guy of IO

// Configuration

// Menus
list MainMenu = ["Lights", "Steam On", "Steam Off", "Jets On", "Jets Off", "Exit"]; // Main Menu Options
list LightsMenu = ["On/Off", "Color", "Main Menu", "Exit"];

string MenuFlag = "";

// Variables
integer ListenChannel; // Listen Channel Variable Initializer
integer ListenHandle; // Listen Handle

// Constants
string EMPTY = "";
vector FullSizeWater = <2.11000, 3.06800, 1.2>;
vector NoWater = <2.11000, 3.06800, 0.00073>;
float NumWaterLevels = 30;
list JetLink = [2, 4, 5, 6, 7, 8, 10];
key JetTarget = NULL_KEY;

    // Color Vectors
list colorsVectors = [<0.000, 0.455, 0.851>, <0.498, 0.859, 1.000>, <0.224, 0.800, 0.800>, <0.239, 0.600, 0.439>, <0.180, 0.800, 0.251>, <0.004, 1.000, 0.439>, <1.000, 0.522, 0.106>, <1.000, 0.255, 0.212>, <0.522, 0.078, 0.294>, <0.941, 0.071, 0.745>, <0.694, 0.051, 0.788>, <1.000, 1.000, 1.000>];
    // List of Names for Colors
list colors = ["BLUE", "AQUA", "TEAL", "OLIVE", "GREEN", "LIME", "ORANGE", "RED", "MAROON", "FUCHSIA", "PURPLE", "WHITE"];

    //Initial Light Configuration Values + Some Holders for Temp Values
    float Intensity = 1.0;
    float Radius = 10.0;
    float FallOff = 0.750;
    vector DefaultColor = <0.502, 1.0, 1.0>;
    float Glow = 0.06;
    float Alpha = 0.7;
        // PlaceHolders for Current Values of Same
    float CurIntensity;
    float CurRadius;
    float CurFallOff;
    vector CurColor;
    float CurGlow;

// Switches
integer LightState = FALSE; // Initial State of Tub Lights
integer SteamState = FALSE; // Initial Steam State
integer JetState = FALSE; // Initial Jet State

// Functions

DoMenu(string MFLAG, key userid){
    if(MFLAG==""){
        llSetTimerEvent(30.0);
        ListenHandle = llListen(ListenChannel, EMPTY, EMPTY, EMPTY);
        llDialog(userid, "Please select option...", MainMenu, ListenChannel);
    }else if(MFLAG=="Lights"){
        llSetTimerEvent(30.0);
        ListenHandle = llListen(ListenChannel, EMPTY, EMPTY, EMPTY);
        llDialog(userid, "Please select option...", LightsMenu, ListenChannel);
    }else if(MFLAG=="Color"){
        llSetTimerEvent(30.0);
        ListenHandle = llListen(ListenChannel, EMPTY, EMPTY, EMPTY);
        llDialog(userid, "Please select lighting color...", colors, ListenChannel); 
    }
}

Steam(integer ISON){
    if(ISON){ 
        llLinkParticleSystem(LINK_ROOT, [
            PSYS_PART_FLAGS,( 0 
                |PSYS_PART_INTERP_COLOR_MASK
                |PSYS_PART_INTERP_SCALE_MASK ), 
            PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE ,
            PSYS_PART_START_ALPHA,0.501961,
            PSYS_PART_END_ALPHA,0.0117647,
            PSYS_PART_START_COLOR,CurColor,
            PSYS_PART_END_COLOR,<1,1,1> ,
            PSYS_PART_START_SCALE,<3,3,0>,
            PSYS_PART_END_SCALE,<0.1875,0.1875,0>,
            PSYS_PART_MAX_AGE,2.14844,
            PSYS_SRC_MAX_AGE,0,
            PSYS_SRC_ACCEL,<0,0,-0.203125>,
            PSYS_SRC_BURST_PART_COUNT,2,
            PSYS_SRC_BURST_RADIUS,0.199219,
            PSYS_SRC_BURST_RATE,0.046875,
            PSYS_SRC_BURST_SPEED_MIN,0.796875,
            PSYS_SRC_BURST_SPEED_MAX,1,
            PSYS_SRC_ANGLE_BEGIN,0,
            PSYS_SRC_ANGLE_END,1.46875,
            PSYS_SRC_OMEGA,<0,0,0>,
            PSYS_SRC_TEXTURE, (key)"26321045-e218-49c8-9387-e7801c890e27",
            PSYS_SRC_TARGET_KEY, (key)"00000000-0000-0000-0000-000000000000"
         ]);
    }else{
        llLinkParticleSystem(LINK_ROOT, []);
    }
}

Jets(integer ISON){
    integer i;
    if(ISON){
        for(i=0;i<=5;i++){
            llLinkParticleSystem(llList2Integer(JetLink, i), [
                PSYS_PART_FLAGS,( 0 
                    |PSYS_PART_INTERP_COLOR_MASK
                    |PSYS_PART_INTERP_SCALE_MASK
                    |PSYS_PART_FOLLOW_SRC_MASK
                    |PSYS_PART_FOLLOW_VELOCITY_MASK
                    |PSYS_PART_TARGET_POS_MASK ), 
                PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_ANGLE_CONE ,
                PSYS_PART_START_ALPHA,1,
                PSYS_PART_END_ALPHA,0,
                PSYS_PART_START_COLOR,CurColor ,
                PSYS_PART_END_COLOR,<1,1,1> ,
                PSYS_PART_START_SCALE,<0,0,0>,
                PSYS_PART_END_SCALE,<0.28125,0.28125,0>,
                PSYS_PART_MAX_AGE,3,
                PSYS_SRC_MAX_AGE,0,
                PSYS_SRC_ACCEL,<0,0,0.046875>,
                PSYS_SRC_BURST_PART_COUNT,8,
                PSYS_SRC_BURST_RADIUS,0,
                PSYS_SRC_BURST_RATE,0.0585938,
                PSYS_SRC_BURST_SPEED_MIN,0.5,
                PSYS_SRC_BURST_SPEED_MAX,1,
                PSYS_SRC_ANGLE_BEGIN,2.09375,
                PSYS_SRC_ANGLE_END,0.4375,
                PSYS_SRC_OMEGA,<8,1.59375,1>,
                PSYS_SRC_TEXTURE, (key)"1c79c1db-7cc0-421f-a363-499725617068",
                PSYS_SRC_TARGET_KEY, llList2Key(JetTarget, 0)
             ]);
        }
    }else{
        for(i=0;i<=2;i++){
            llLinkParticleSystem(llList2Integer(JetLink, i), []);
        }
        for(i=3;i<=5;i++){
            llLinkParticleSystem(llList2Integer(JetLink, i), []);
        } 
    }
}

ToggleLights(){
    if(LightState){
        llSetPrimitiveParams([PRIM_FULLBRIGHT, ALL_SIDES, FALSE,
            PRIM_POINT_LIGHT, FALSE, CurColor, CurIntensity, CurRadius, CurFallOff,
            PRIM_COLOR, ALL_SIDES, DefaultColor, Alpha
        ]);
        if(SteamState){
            vector TempColor = CurColor;
            CurColor = <1.0,1.0,1.0>;
            Steam(FALSE);
            Steam(TRUE);
            CurColor = TempColor;
        }
        if(JetState){
            vector TempColor = CurColor;
            CurColor = <1.0,1.0,1.0>;
            Jets(FALSE);
            Jets(TRUE);
            CurColor = TempColor; 
        }
    }else{
        llSetPrimitiveParams([PRIM_FULLBRIGHT, ALL_SIDES, TRUE,
            PRIM_POINT_LIGHT, TRUE, CurColor, CurIntensity, CurRadius, CurFallOff,
            PRIM_COLOR, ALL_SIDES, CurColor, Alpha
        ]);
        if(SteamState){
            Steam(FALSE);
            Steam(TRUE);
        }
        if(JetState){
            Jets(FALSE);
            Jets(TRUE);
        }
    }
    LightState = !LightState;
}



default{
    state_entry(){
        llListenRemove(ListenHandle);
        ListenChannel = (integer)(llFrand(-1000000000.0) - 1000000000.0);
        // Set Light Config Defaults to Current Values Variables
        CurIntensity = Intensity;;
        CurRadius = Radius;
        CurFallOff = FallOff;
        CurColor = DefaultColor;
        CurGlow = Glow;
        JetTarget = llGetLinkKey(LINK_ROOT);
    }
    
    touch(integer num){
        key id = llDetectedKey(0);
        integer WhatTouched = llDetectedLinkNumber(0);
        if(WhatTouched!=16){
            return;
        }else{
            //llOwnerSay("Link Number: "+(string)WhatTouched);
            //return;
            DoMenu(EMPTY, id);
        }
    }
    
    listen(integer channel, string num, key id, string msg){
        llSetTimerEvent(0.0); // Clear Timer when listen event triggers, We will start timer again if we open another menu with DoMenu();
        if(msg=="Lights"){ // Open Lights Sub-Menu
            MenuFlag = "Lights";
            DoMenu(MenuFlag, id);
        }else if(msg=="Steam On"){
            SteamState = TRUE;
            if(!LightState){
                vector TempColor = CurColor;
                CurColor = <1.0,1.0,1.0>;
                Steam(FALSE);
                Steam(TRUE);
                CurColor = TempColor;
            }else{
                Steam(TRUE);
            }
        }else if(msg=="Steam Off"){
            SteamState = FALSE;
            Steam(FALSE);
        }else if(msg=="Jets On"){
            JetState = TRUE;
            if(!LightState){
                vector TempColor = CurColor;
                CurColor = <1.0,1.0,1.0>;
                Jets(FALSE);
                Jets(TRUE);
                CurColor = TempColor;
            }else{
                Jets(TRUE);
            }
        }else if(msg=="Jets Off"){
            JetState = FALSE;
            Jets(FALSE);
        }else if(msg=="On/Off"){
            ToggleLights();
        }else if(msg=="Color"){
            MenuFlag = msg;
            DoMenu(MenuFlag, id);
        }else if(msg=="Main Menu"){
            MenuFlag = "";
            DoMenu(EMPTY, id);
        }else if(llListFindList(colors, [msg])!=-1){
            integer ColorIndex = llListFindList(colors, [msg]);
            CurColor = llList2Vector(colorsVectors, ColorIndex);
            if(LightState){
                ToggleLights();
                ToggleLights();
            }
            if(SteamState){
                Steam(FALSE);
                Steam(TRUE);
            }
            if(JetState){
                Jets(FALSE);
                Jets(TRUE);
            }
        }else{
            llSetTimerEvent(0);
            llListenRemove(ListenHandle);
        }
    }
    
    timer(){
        llSetTimerEvent(0);
        llListenRemove(ListenHandle);
    }
}