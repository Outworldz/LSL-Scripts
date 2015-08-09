// :CATEGORY:Reset
// :NAME:Reset_System_by_PJW_Electronics
// :AUTHOR:Pjanoo Windlow
// :CREATED:2011-09-25 08:53:45.800
// :EDITED:2013-09-18 15:39:01
// :ID:698
// :NUM:953
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Put this script here into the prim you want to reset stuff in :)
// :CODE:
//Put this in the prim you want to reset scripts in

integer RESETME = 1;

default {
    state_entry()
    {

        //  llRequestPermissions(llGetOwner(), PERMISSION_TAKE_CONTROLS);
        //     }
        //   run_time_permissions(integer perms)
        //      {
        //  llTakeControls(CONTROL_BACK, FALSE, TRUE);
        // need this to work in no script areas? Remove the forward slashes

    }
    link_message(integer sender, integer num, string params, key id)
    {
        if (num == RESETME)
        {
            llResetOtherScript("A"); //rename it to your needs
            // llResetOtherScript("B");//sometimes we have more than one script.
            // llResetOtherScript("C");//so you need to define each one that needs reset.
            //  ~ other fun things you can do with this include ~
            // llSetScriptState("A", FALSE); //to turn stuff off
            // llSetScriptState("B", TRUE); //to turn it back on.
        }
    }
}
