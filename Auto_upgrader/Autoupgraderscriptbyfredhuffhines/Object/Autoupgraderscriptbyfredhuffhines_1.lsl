// :CATEGORY:Upgrade Script
// :NAME:Auto_upgrader
// :AUTHOR:Fred Huffhines
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:48
// :ID:65
// :NUM:92
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Auto-upgrader-script-by-fred-huffhines.lsl
// :CODE:




////////////// 
// auto-upgrader, by fred huffhines, distributed under GPL license. 
//   partly based on the self-upgrading scripts from markov brodsky and jippen fadoul. 
// the function auto_upgrade() should be added to a version numbered script that you wish 
// to give the capability of self-upgrading.  see example invocation at end of file. 
//   this script supports a notation for versions where a 'v' character and a number in the 
// form "major.minor" reside at the end of script names, e.g. "grunkle script by ted v8.2". 
// when the script is dropped into an object with a different version, the most recent 
// version eats any existing one. 

integer posn; 

auto_upgrade() 
{ 
    string self = llGetScriptName();  // the name of this script. 
    string basename = self;  // script name with no version attached.    
    
if (llSubStringIndex(self, " ") >= 0) 
    { 
         
        // minimum script name is 2 characters plus version. 
        for (posn = llStringLength(self) - 1; (posn >= 2) && (llGetSubString(self, posn, posn) != " "); posn--) 
            { 
                // find the space. 
            } 
            
        if (posn < 2) return;  // no space found. 
        string suffix = llGetSubString(self, posn, -1); 
        // ditch the space character for our numerical check. 
        string chopped_suffix = llGetSubString(suffix, 1, llStringLength(suffix) - 1); 
        // strip out a 'v' if there is one. 
        if (llGetSubString(chopped_suffix, 0, 0) == "v") 
            chopped_suffix = llGetSubString(chopped_suffix, 1, llStringLength(chopped_suffix) - 1); 
        // if it's a valid floating point number and is greater than zero, that works for our version. 
        if ((float)chopped_suffix > 0.0) 
            basename = llGetSubString(self, 0, -llStringLength(suffix) - 1); 
    } 
     
    // find any scripts that match the basename.  they are variants of this script. 
    for (posn = llGetInventoryNumber(INVENTORY_SCRIPT) - 1; posn >= 0; posn--) 
    { 
        string curr_script = llGetInventoryName(INVENTORY_SCRIPT, posn); 
        // remove scripts with same name (except myself, of course). 
        if ( (curr_script != self) && (llSubStringIndex(curr_script, basename) == 0) ) 
        { 
            llRemoveInventory(curr_script); 
        } 
    } 
} 
////////////// 

// example usage of the upgrader: 
default 
{ 
    state_entry() 
    { 
        auto_upgrade(); 
    } 
}      // end 
