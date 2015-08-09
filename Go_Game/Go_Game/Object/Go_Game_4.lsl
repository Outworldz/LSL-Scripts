// :CATEGORY:Games
// :NAME:Go_Game
// :AUTHOR:Jonathan Shaftoe
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:54
// :ID:357
// :NUM:483
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// And here's the GoSensorGridScript
// :CODE:
// GoSensorGridScript
// Jonathan Shaftoe
// Creates the sensor grid by rezzing 19 sensors (to make 20, including the one we're in) and
// giving each one a unique index. Script removes itself once done. Will take a few seconds
// to run, as rezzing has a built in delay. Requires link permission as all the created
// sensors are linked together.
// To use, rez a previously created GoSensor (see GoSensorScript), then put a GoSensor
// in that GoSensor's inventory, then drop this script in. Wait until it has done its stuff,
// then take the resulting GoSensorGrid into your inventory for later.

// If you only wanted to support smaller game boards and use less prims, you could change
// totalSensors below to the relevent number. For a 9x9 board, you would only need 9
// sensors, so make totalSensors 8 - for a 13x13 board, you need 16 sensors, so make
// totalSensors 15.

integer gNumSensors = 0; // how many have we made
integer gCountRez = 0; // how many are still waiting to be linked.

default
{
    state_entry()
    {
        llSetObjectName("GoSensorGrid");
        llRequestPermissions(llGetOwner(), PERMISSION_CHANGE_LINKS);
    }
    
    run_time_permissions(integer perms) {
        state start;
    }
}

state start {
    state_entry() {
        llWhisper(0, "Creating sensors, please wait ...");
        // 19x19 board needs 4x5 sensors, so 19 plus the one we're in to start with..
        integer totalSensors = 19;
        while (gNumSensors < totalSensors) {
            llRezObject("GoSensor", llGetPos(), ZERO_VECTOR, ZERO_ROTATION, gNumSensors + 1);
            gNumSensors++;
            gCountRez++;
        }
    }
    
    object_rez(key id) {
        llCreateLink(id, TRUE);
        gCountRez--;
        if (gCountRez == 0) {
            llRemoveInventory(llGetScriptName());
        } else if (gCountRez % 4 == 0) {
            llWhisper(0, "... " + (string)gCountRez + " more sensors to make ...");
        }
    }

}
