// :CATEGORY:Sensor
// :NAME:Script_controller
// :AUTHOR:Beer Dailey
// :CREATED:2010-12-27 12:34:11.310
// :EDITED:2013-09-18 15:39:01
// :ID:722
// :NUM:987
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Ever since I noticed that many sims contain 1000's of wonderful objects with fancy effects and 1000's active scripts that use valuable simresources while no-one is around to enjoy it, I wanted to script something simple to offload those resources and give the visitor a better experience.// // That's why I made this little script: '1st necessity of SL' that could and should be used in any project that doesn't need to be active all the time. 
// :CODE:
// Improve SecondLife's performance!
// Start with your own(ned) modifyable scripts/objects.
//
// This will disable your rootprim's script(s) when no-one is around to use/admire it
// thus stop wasting valuable sim-resources
// 
// Measured script time is 0.002 ms on average. 
//
// - don't use it for rental stuff or sorts, not everything is suitable -
//
// Free to use, please use it. Improvements are welcome.
// // Thank you Norton Burns for the testing and feedback :)
//
// Beer Dailey
//
// Don't reset this script or take it back in inventory when you're not within the set distance 
// or you'll get unpredictable results !!
// 
// modify below to suit your needs
 
//////////////////////////////////
float   distance = 48;   // scan range 
integer delay = 10;      // repeat scan every 10 seconds.
 
// added 
// (gnore specific scripts, some scripts need to be off after initial setups
// There's a bug that resets scripts in off state after a sim restart, so when activated again they re-initialise.
// I've no fix for that.
//
list ignore_scripts = ["major script", "even worse script"]; 
 
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
