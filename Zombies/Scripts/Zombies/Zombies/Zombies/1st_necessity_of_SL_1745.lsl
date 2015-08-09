float   distance = 30.0;   // scan range
integer delay = 10;      // repeat scan every 10 seconds.

// added
// (gnore specific scripts, some scripts need to be off after initial setups
// There's a bug that resets scripts in off state after a sim restart, so when activated again they re-initialise.
// I've no fix for that.
//
list ignore_scripts = [];

integer debug = FALSE;   // for debugging purposes, set it to TRUE to see what it's controlling


//////////////////////////////////////
// no need to modify the code below //
//////////////////////////////////////

integer g_active = FALSE;  // if FALSE disable all other scripts
// changed TRUE into FALSE cos of some bug with rezzing, thank you LordGregGreg Back :)
list control_scripts;      // list for all scriptnames

active_scripts( integer active )
{
    if(g_active == active) return; else g_active = active;  //flip TRUE/FALSE

    integer a;
    for ( a = 0; a < llGetListLength(control_scripts); a++)
    {
        llSetScriptState(llList2String(control_scripts, a), g_active); //(de)activate scripts

    }
    if (debug) llOwnerSay("Changed: " + llList2CSV(control_scripts) + " to: " + (string)g_active );
}

default
{
    state_entry()
    {
        string myname = llGetScriptName(); //don't add myself into the list
        control_scripts = [];

        integer i;
        integer n = llGetInventoryNumber(INVENTORY_SCRIPT); //count scripts

        if (n == 1) { llOwnerSay("No other scripts found!"); } else //dont be silly ;)

            for(i = 0; i < n; ++i)
            {
                string name = llGetInventoryName(INVENTORY_SCRIPT, i); //parse scriptnames
                if(name != myname) //not my name then continue
                {
                    //catch states
                    if ( llGetScriptState(name) == TRUE) //not on ignore list & running add it
                    {
                        control_scripts += [name];
                    }
                    else ignore_scripts += [name];
                }
            }
        if (debug) llOwnerSay("Controlling: " + llList2CSV(control_scripts) + "\nIgnoring: " + llList2CSV(ignore_scripts));
        llSensorRepeat("", NULL_KEY, AGENT, distance, PI, delay); // how far and how often we scan for avatars
    }

    on_rez(integer s)
    {
        if (llGetListLength(control_scripts)== 0 && g_active == TRUE) llResetScript();
        //first time use or reset only when scripts are still active or they'll be added to the ignorelist
    }

    changed(integer change)
    {
        if (change & CHANGED_OWNER) llResetScript(); // catch new owner
        if (change & CHANGED_INVENTORY) llResetScript(); // catch new scripts
    }

    sensor(integer num_detected)
    {
        active_scripts(TRUE); //activate the scripts
    }

    no_sensor()  //no-one around? turn off all controlled scripts except myself
    {
        active_scripts(FALSE); //deactivate the scripts
    }

}



// Look for updates at : http://www.outworldz.com/freescripts.plx?ID=1567
// __END__


