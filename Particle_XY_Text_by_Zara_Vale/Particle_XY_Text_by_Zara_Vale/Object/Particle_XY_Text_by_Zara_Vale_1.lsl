// :CATEGORY:XY Text
// :NAME:Particle_XY_Text_by_Zara_Vale
// :AUTHOR:Zara Vale
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:59
// :ID:612
// :NUM:836
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Particle XY Text by Zara Vale.lsl
// :CODE:

//********************************************************
//This Script was pulled out for you by YadNi Monde from the SL FORUMS at http://forums.secondlife.com/forumdisplay.php?f=15, it is intended to stay FREE by it s author(s) and all the comments here in ORANGE must NOT be deleted. They include notes on how to use it and no help will be provided either by YadNi Monde or it s Author(s). IF YOU DO NOT AGREE WITH THIS JUST DONT USE!!!
//********************************************************







//Particle XY Text by Zara Vale
//Howdy everyone,
//
//What is it?
//It is a signboard made out of particles, I've done 120 characters from a single prim before
//
//How do I use it?
//REZ a BOX, create and script and put the following code in:
//You can use channel 99 to change the text from the sign. Note that particles are slightly unreliable and it depends on the SIM, how many people are there, the weather in your country, etc.... But in a low load SIM it almost always appears for me. Do let me know if you find any improvements 




// Default text
string TEXT = "I @ ASL!";

// Interface between letters
float LETTER_INTERVAL = 1.2;

// Modified values
integer IS_ON = TRUE;
string CUR_TEXT = "";
integer LISTEN_HANDLE;

// Characters
list CHARACTERS = [
    // A - Z
    "05fb8c9a-2ace-8c64-6688-9a08f535e87b",
    "c68b3416-1b02-76f4-8295-5170f2a430fc",
    "ab55d18b-f220-7dad-2036-9dbe6d9d24ae",
    "bb14e17f-48e2-b0de-2d3a-f3fc919d3455",
    "81d319dc-08a1-70ff-7d08-d2d5e8521d90",
    "993b9e32-77cd-17c6-b9d5-aa0950eeeedc",
    "4bbbec6c-26c7-b28c-8e2b-b95fd6b4c73e",
    "5c52c7da-7443-8d03-1493-94a167981f74",
    "7bfad861-8374-84fb-f71f-2a58fb6dd64a",
    "e79f9242-17d9-1377-f8b1-59812df58def",
    "6121cbf7-45dd-81d1-5983-bb4da8bb6cbd",
    "b9c2b4f6-2dd2-f05e-2ebe-8291a1c8208c",
    "e4c16f2e-5589-4dab-d658-2d8f8e78e212",
    "3dd9c930-88cb-80cd-04df-a146429166ba",
    "aa61ecc4-59c6-d390-b0e2-770abd463037",
    "702072b1-a14a-c1c2-7e96-ec69044989ef",
    "ed6b8c52-2540-df1e-2fb1-5c2d74d52951",
    "50ceb1e2-bf65-43d1-14b9-f7c6baab856f",
    "d1684b98-25c3-6d6d-9517-cc5b15264a5d",
    "d2daf814-6aa7-7a59-54b2-3110bf0d9dee",
    "367def79-30ef-5de7-cade-55fb1973dec4",
    "02e99a90-31c8-b50b-8b16-2c182d67a2d4",
    "722b77a3-8513-9537-c0cb-00978c85745e",
    "ea2aa90d-4a98-8d3b-3815-4505113a5a90",
    "ebe59dea-4a23-d415-1503-9c789c68d0f5",
    "9fbdeb14-7814-2c21-ab27-ee1867e349a3",
    
    // Special characters
    "701917a8-d614-471f-13dd-5f4644e36e3c",  // Space
    "d3f39664-ec05-92f0-1b45-db3acfe276e3",  // Period
    "3ff82ed4-c521-dc69-b1ad-5d70f4b89da1",  // Question
    "eaa3ec1a-d071-285e-7058-14ce838e8e25",  // Semicolon
    "c0eeefcc-fa2c-0ff9-c9b9-babc365643ea",  // Exclamation
    "8ccd81a4-ac36-7618-d7b4-b40fc2a548f0",  // Comma
    "f81176b3-32b8-86bf-3613-a9f89895c1ad",  // Colon
    
    // Numbers
    "1494e996-a91b-f770-bd10-ad788642d859",
    "f545e486-2a2e-730d-845a-cbe9d4bcb9fd",
    "16a84092-421f-3225-bb36-4071b55fab2d",
    "4b0a62c4-65f4-932e-d440-7fe3cf5a1540",
    "e0e7eacd-e956-14e6-df65-3bc3b7d4e679",
    "6f579c89-bf1f-71d7-854d-b08341edf51e",
    "a5063c9b-377c-1244-62b4-7ce5d1dbfafe",
    "b055ba6a-d2ff-d67d-066c-ccb8a9e8300d",
    "42b58e86-e83c-bc1b-4d73-ab3603d00d98",
    "872560f2-d964-ab22-d558-1607366666c1",
    
    // Zara's
    "fcdac14d-6128-ce47-66bc-a3d0d27f6d3d", // Hearts
    
    // ADD yours here.  
    // Note that if you add more you need to put a comma in
    // but leave the last line with out a comma
    ""
];

string CHARACTER_INDEX = "ABCDEFGHIJKLMNOPQRSTUVWXYZ .?;!,:0123456789@";

letter(string char) {
    string TEXTURE = llList2Key(CHARACTERS, llSubStringIndex(CHARACTER_INDEX, llToUpper(char)));
    
    llParticleSystem([
        PSYS_PART_FLAGS, 0 | PSYS_PART_EMISSIVE_MASK |
        PSYS_PART_INTERP_COLOR_MASK | PSYS_PART_INTERP_SCALE_MASK,
        PSYS_SRC_PATTERN,PSYS_SRC_PATTERN_ANGLE_CONE,
        
        // Texture / Size / Alpha / Color
        PSYS_SRC_TEXTURE, TEXTURE,
        PSYS_PART_START_SCALE,<0.2000, 0.2000, 0.0000>,
        PSYS_PART_END_SCALE,<0.3000, 0.3000, 0.0000>,
        PSYS_PART_START_ALPHA,0.000000,
        PSYS_PART_END_ALPHA,1.000000,
        PSYS_PART_START_COLOR, <1.0,1.0,1.0>,
        PSYS_PART_END_COLOR, <1.0,1.0,1.0>,    
        
        // Flow
        PSYS_PART_MAX_AGE,10.0,
        PSYS_SRC_BURST_RATE,1.200000,
        PSYS_SRC_BURST_PART_COUNT,1,
        PSYS_SRC_MAX_AGE,0.000000,
        
        // Rez position
        PSYS_SRC_BURST_RADIUS,0.0,
        PSYS_SRC_INNERANGLE,0.0000,
        PSYS_SRC_OUTERANGLE,0.0000,
        PSYS_SRC_OMEGA,<0.00000, 0.00000, 0.00000>,
        PSYS_SRC_ACCEL, <0,0,0.0>,               
        PSYS_SRC_BURST_SPEED_MIN,0.250000,
        PSYS_SRC_BURST_SPEED_MAX,0.250000
    ]);
}

stop() {
    llParticleSystem([]);
}

default {
    state_entry() {
        if(IS_ON) {
            llSetTimerEvent(LETTER_INTERVAL);
            LISTEN_HANDLE = llListen(99, "", llGetOwner(), "");
        }
    }
    
    touch_start(integer num_detected) {
        if(IS_ON) {
            stop();
            llSetTimerEvent(0.0);
            //llListenControl(LISTEN_HANDLE, FALSE);
            llWhisper(0, "Signboard has stopped");
            
        } else {
            llWhisper(0, "Signboard has started");
            //LISTEN_HANDLE = llListen(99, "", llGetOwner(), "");
            llSetTimerEvent(LETTER_INTERVAL);
        }
        IS_ON = !IS_ON;
    }
    
    listen( integer channel, string name, key id, string message) {
        TEXT = message;
        CUR_TEXT = message;
        llOwnerSay("Setting text:" + message);
    }
    
    timer() {
        if(CUR_TEXT == "") {
            CUR_TEXT = TEXT;
        }
        string char = llGetSubString(CUR_TEXT, 0, 0);
        letter(char);
        if(llStringLength(CUR_TEXT) == 1) {
            if(CUR_TEXT != " ") {
                CUR_TEXT = " ";
            } else {
                CUR_TEXT = "";
            }
        } else {
            CUR_TEXT = llGetSubString(CUR_TEXT, 1, -1);
        }
    }
} // END //
