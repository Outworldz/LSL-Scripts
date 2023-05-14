// Jacuzzi Engine v1.0 by Tech Guy
// Configuration

// Menus
list MainMenu = ["Fill", "Empty", "Steam On", "Steam Off", "Jets On", "Jets Off", "Exit"]; // Main Menu Options

// Variables
integer ListenChannel; // Listen Channel Variable Initializer
integer ListenHandle; // Listen Handle

// Constants
string EMPTY = "";
vector FullSizeWater = <2.11000, 3.06800, 1.2>;
vector NoWater = <2.11000, 3.06800, 0.00073>;
float NumWaterLevels = 30;
list JetLink = [14, 15, 16, 11, 12, 13];
list JetTarget = ["9fdd5d24-7801-4f16-8c85-c9a7d8fff952", "8259c797-bd86-4157-b65d-a68781626864", "b67326c0-d279-4af5-b692-670532c130fe", "f553d16c-26e1-48dd-a553-205bb7d71296", "f8220e96-bbf7-4df2-9588-c8b374c6af9e", "203df0d7-8910-436f-a46a-0a50b854e3ae"];

// System States
integer JetState = FALSE;
integer WaterState = FALSE;
integer SteamState = FALSE;

// Functions
Water(integer ISON){
    float StepSize = (FullSizeWater.z - NoWater.z) / NumWaterLevels; // Size to Change prim each Step
    integer i;
    if(ISON){
        llSetLinkTextureAnim(2,  TRUE | LOOP, ALL_SIDES, 8, 8, 0.0, 64.0, 24.5 );
        llSetLinkAlpha(2, 1.0, ALL_SIDES);
        for(i=0;i<=NumWaterLevels;i++){
            vector Size = llList2Vector(llGetLinkPrimitiveParams(2, [PRIM_SIZE]), 0);
            Size.z = Size.z + StepSize;
            llSetLinkPrimitiveParams(2, [PRIM_SIZE, Size]);
        }
        SteamState = TRUE;
        Steam(TRUE);
    }else{
        Steam(FALSE);
        Jets(FALSE);
        for(i=0;i<=NumWaterLevels;i++){
            vector Size = llList2Vector(llGetLinkPrimitiveParams(2, [PRIM_SIZE]), 0);
            Size.z = Size.z - StepSize;
            llSetLinkPrimitiveParams(2, [PRIM_SIZE, Size]);
        }
        llSetLinkAlpha(2, 0.0, ALL_SIDES);
        llSetLinkTextureAnim(2,  FALSE | LOOP, ALL_SIDES, 8, 8, 0.0, 64.0, 24.5 );
        
    }
}

Steam(integer ISON){
    if(ISON){
        llLinkParticleSystem(2, [
            PSYS_PART_FLAGS,( 0 
                |PSYS_PART_INTERP_COLOR_MASK
                |PSYS_PART_INTERP_SCALE_MASK ), 
            PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE ,
            PSYS_PART_START_ALPHA,0.501961,
            PSYS_PART_END_ALPHA,0.0117647,
            PSYS_PART_START_COLOR,<1,1,1> ,
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
        llLinkParticleSystem(2, []);
    }
}

Jets(integer ISON){
    integer i;
    if(ISON){
        for(i=0;i<=2;i++){
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
                PSYS_PART_START_COLOR,<0.501961,0.501961,1> ,
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
                PSYS_SRC_TARGET_KEY, llList2Key(JetTarget, i)
             ]);
        }
        for(i=3;i<=5;i++){
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
                PSYS_PART_START_COLOR,<0.501961,0.501961,1> ,
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
                PSYS_SRC_TARGET_KEY, llList2Key(JetTarget, i)
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

default{
    state_entry(){
        llListenRemove(ListenHandle);
        ListenChannel = (integer)(llFrand(-1000000000.0) - 1000000000.0);
    }
    
    touch(integer num){
        key id = llDetectedKey(0);
        llSetTimerEvent(30.0);
        ListenHandle = llListen(ListenChannel, EMPTY, EMPTY, EMPTY);
        llDialog(id, "Please select option...", MainMenu, ListenChannel);
    }
    
    listen(integer channel, string num, key id, string msg){
        llSetTimerEvent(30.0);
        if(msg=="Fill"){
            WaterState = TRUE;
            Water(TRUE);
        }else if(msg=="Empty"){
            WaterState = FALSE;
            Water(FALSE);
        }else if(msg=="Steam On"){
            if(!WaterState){
                llSay(0, "You must have water in the tub to turn the Steam On.");
                return;
            }
            Steam(TRUE);
        }else if(msg=="Steam Off"){
            Steam(FALSE);
        }else if(msg=="Jets On"){
            if(!WaterState){
                llSay(0, "You must have water in the tub to turn the Jets On.");
                return;
            }
            Jets(TRUE);
        }else if(msg=="Jets Off"){
            Jets(FALSE);
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