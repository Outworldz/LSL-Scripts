// :CATEGORY:Door
// :NAME:Ultra_Deluxe_Door_Script
// :AUTHOR:Ezhar Fairlight
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:08
// :ID:933
// :NUM:1339
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Ultra Deluxe Door Script.lsl
// :CODE:
// deluxe door script by Ezhar Fairlight
// features: one prim, no building skills required, automatic closing, workaround for rotation drift,
// doesn't mess up when moved, adjustable direction (inwards/outwards) and sound volume, HHGG quotes!
// updated for SL 1.4

// just rez a cube primitive and put this script inside - it will shape and texture itself into a door

// ********** SETTINGS HERE ************
float       TIMER       = 30.0;      // automatically close the door after this many seconds,
// set to 0 to disable automatic closing

integer     DIRECTION   = -1;       // direction door opens in. Either 1 (outwards) or -1 (inwards);

float       VOLUME      = 0.8;      // sound volume, 1.0 loudest, 0.0 to disable sound
// ********** END OF SETTINGS **********


key         SOUND_OPEN  = "cb340647-9680-dd5e-49c0-86edfa01b3ac";
key         SOUND_CLOSE = "e7ff1054-003d-d134-66be-207573f2b535";

vector      gPos;      // door position (objects move a tiny amount
// away from their position each time they are rotated,
// thus we need to workaround this by resetting
// the position after rotating)

door(integer open) {
    if (open) {
        llTriggerSound(SOUND_OPEN, VOLUME);
        llSetRot(llEuler2Rot(<0, 0, -DIRECTION * PI_BY_TWO>) * llGetRot());
    } else { // close
            llSetRot(llEuler2Rot(<0, 0, DIRECTION * PI_BY_TWO>) * llGetRot());
        llTriggerSound(SOUND_CLOSE, VOLUME);
    }
}


default {   // first time startup
    state_entry() {
        if (llGetTexture(0) == "89556747-24cb-43ed-920b-47caed15465f") { // is default texture, set it up
            llSetPos(llGetPos() + <0, 0, 3.325 / 2 - 0.25>);
            llSetPrimitiveParams([PRIM_TYPE, PRIM_TYPE_BOX,0, <0.375, 0.875, 0>, 0.0,<0, 0, 0>, <1, 1, 0>, <0, 0, 0>, 
                PRIM_SIZE, <0.2, 4, 3.325>,
                PRIM_TEXTURE, 0, "086c7e6b-bdd6-7388-f146-f3d1b353ed15", <2.000000, 0.060000, 0.000000>, <0.500015, 0.469985, 0.000000>, 1.570840,
                PRIM_TEXTURE, 1, "086c7e6b-bdd6-7388-f146-f3d1b353ed15", <-2.000000, 1.000000, 0.000000>, <0.500015, 0.000000, 0.000000>, 0.000000,
                PRIM_TEXTURE, 2, "086c7e6b-bdd6-7388-f146-f3d1b353ed15", <0.100000, 1.000000, 0.000000>, <0.599994, 0.000000, 0.000000>, 0.000000,
                PRIM_TEXTURE, 3, "086c7e6b-bdd6-7388-f146-f3d1b353ed15", <2.000000, 1.000000, 0.000000>, <0.500015, 0.000000, 0.000000>, 0.000000,
                PRIM_TEXTURE, 4, "086c7e6b-bdd6-7388-f146-f3d1b353ed15", <2.000000, 0.080000, 0.000000>, <0.500015, 0.550005, 0.000000>, 1.570840,
                PRIM_TEXTURE, 5, "086c7e6b-bdd6-7388-f146-f3d1b353ed15", <0.100000, 1.000000, 0.000000>, <0.449995, 0.000000, 0.000000>, 0.000000,
                PRIM_TEXTURE, 6, "086c7e6b-bdd6-7388-f146-f3d1b353ed15", <0.100000, 1.000000, 0.000000>, <0.449995, 0.000000, 0.000000>, 0.000000]
                    );
            llSetObjectName("Door Deluxe");
            llSay(0, "Thank you for making a simple door very happy.");
        }
        gPos = llGetPos();  // remember where we're supposed to be
        door(TRUE);
        state closed;
    }
}

state closed {  // door is closed
    on_rez(integer start_param) {
        gPos = llGetPos();
    }

    state_entry() {
        door(FALSE);
    }

    touch_start(integer total_number) {
        state open;
    }

    moving_end() {  // done moving me around, store new position
        gPos = llGetPos();
    }
}

state open {    // door is open
    on_rez(integer start_param) {
        gPos = llGetPos();
        state closed;
    }

    state_entry() {
        llSetTimerEvent(TIMER);
        llSetPos(gPos); // rotation drift workaround
        door(TRUE);
    }

    touch_start(integer num) {
        state closed;
    }

    timer() { // auto-close
        state closed;
    }

    moving_start() { // close when being moved
        state closed;
    }

    state_exit() {
        llSetTimerEvent(0);
    }
}// END //


