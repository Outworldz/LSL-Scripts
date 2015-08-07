// :CATEGORY:Games
// :NAME:Go_Game
// :AUTHOR:Jonathan Shaftoe
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:54
// :ID:357
// :NUM:486
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// As with the sensors, we need a utility script to create the grid, GoTileGridScript.
// :CODE:
// GoTileGridScript
// Jonathan Shaftoe
// Utility script to create a linked grid of GoTile prims, each with a unique index.
// To use, rez a previously created GoTile from your inventory (see GoTileScript), then
// put a GoTile into the inventory of the one you rezzed, then put this script into it.
// It will spend a while rezing and linking all the GoTiles required, then once finished
// the script will delete itself from the object, now called GoTileGrid, which you take
// into your inventory and save for later.

// By default, this creates 33 sensors to make a total of 34, needed to cover a 19x19 board.
// If you only want to support smaller board sizes, you can reduce the totalTiles variable
// below to reduce the prim usage. For example, a 9x9 board just uses 10 tiles, so you can
// set totalTiles to 9.


integer gNumTiles = 0; // how many have we created
integer gCountRez = 0; // how many are waiting to be rezzed and linked.

default
{
    state_entry()
    {
        llSetObjectName("GoTileGrid");
        llRequestPermissions(llGetOwner(), PERMISSION_CHANGE_LINKS);
    }
    
    run_time_permissions(integer perms) {
        state start;
    }
}

state start {
    state_entry() {
        llWhisper(0, "Creating tiles, please wait ...");
        // 19x19 board needs 34, 6x2 sensors, minus the one we're in to start with
        integer totalTiles = 33;
//        integer totalTiles = 9; // just 9x9 for testing
        while (gNumTiles < totalTiles) {
            llRezObject("GoTile", llGetPos(), ZERO_VECTOR, ZERO_ROTATION, gNumTiles + 1);
            gNumTiles++;
            gCountRez++;
        }
    }
    
    object_rez(key id) {
        llCreateLink(id, TRUE);
        gCountRez--;
        if (gCountRez == 0) {
            llRemoveInventory(llGetScriptName());
        } else if (gCountRez % 4 == 0) {
            llWhisper(0, "... " + (string)gCountRez + " more tiles to make ...");
        }
    }

}
