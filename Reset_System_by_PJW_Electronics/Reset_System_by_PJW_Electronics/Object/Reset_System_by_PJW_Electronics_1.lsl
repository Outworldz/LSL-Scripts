// :CATEGORY:Reset
// :NAME:Reset_System_by_PJW_Electronics
// :AUTHOR:Pjanoo Windlow
// :CREATED:2011-09-25 08:53:45.800
// :EDITED:2013-09-18 15:39:01
// :ID:698
// :NUM:952
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Put this script here into your reset button. It should already be in a link set.  
// :CODE:
//Put this in your Reset button.

integer RESETME = 1;
list reset = ["Reset"];
string msg = "What would you like to do?";
key ToucherID;
integer channel_dialog;
integer listen_id;

default {
    state_entry()
    {
        //  llRequestPermissions(llGetOwner(), PERMISSION_TAKE_CONTROLS);
        //     }
        //   run_time_permissions(integer perms)
        //      {
        //  llTakeControls(CONTROL_BACK, FALSE, TRUE);
        // need this to work in no script areas? Remove the forward slashes :)
        channel_dialog = ( -1 * (integer)("0x"+llGetSubString((string)llGetKey(),-5,-1)) );
    }

    touch_start(integer total_number) {
        llPlaySound("2b2ab242-239f-2a68-2043-95d2a1ec06ea", 1.0);
        ToucherID = llDetectedKey(0);
        llDialog(ToucherID, msg, reset, channel_dialog);
        listen_id = llListen( channel_dialog, "", ToucherID, "");
    }

    listen(integer channel, string name, key id, string choice) {
        if (choice == "Reset") {
            llMessageLinked(LINK_SET, RESETME, "", NULL_KEY);
//do any other really cool stuff you want here, like make the button glow
            llSleep(10);
            state default;

        }
    }
}
