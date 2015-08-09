// :CATEGORY:Useful Subroutines
// :NAME:Scripting_Tips_Put_object_descripti
// :AUTHOR:Micheil Merlin
// :CREATED:2010-02-01 19:52:35.347
// :EDITED:2013-09-18 15:39:01
// :ID:724
// :NUM:989
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Following the llGetObjectDesc code, the script goes through a series of if and else if statements comparing the string to my special selected settings.  In this case, ‘debug on’ and ‘debug off’.  Finding either of those, the script turns a debug flag on or off.  You can get as complex as you want here as long as you don’t go past the 127 character limit. The object description could hold several keywords to be used to set several options within your script.
// :CODE:

// Config Demo - Read Object Desc
//
// Script to demonstrate the use of the object description to supply
// parameters.
//
// The object description is checked to see if it says either 'debug on'
// or 'debug off'.  Set the gDebug flag accordingly.
//
// Micheil Merlin/SL - 1/1/2010


integer gDebug = 0;                 // Debug flag.

readdesc()
{
     string objdesc;             // Object description.
    // Read the description field for the object.
    // Translate to lower case and trim blanks from the end.
    objdesc = llToLower(llStringTrim(llGetObjectDesc(), STRING_TRIM));
    // Look for an object description of 'debug on' in lower case.
    if (objdesc == "debug on")
    {
        gDebug = 1;
    // Look for an object description of 'debug off' in lower case.
    } else if (objdesc == "debug off")
    {
        gDebug = 0;
    // Check for an empty object description.
    // Empty object descriptions could either be blanks or the string
    // '(no description)'.  Earlier, we trimmed blanks from the string
    // so if it was blanks, it is now a null string.
    } else if (objdesc == "" || objdesc == "(no description)")
    {
        llSay(0, "No object description exists.");
    // If the object description is not one of our choices or empty, then
    // say the string.
    } else
    {
        llSay(0, "Object Description of '" + objdesc +
            "' found. We weren't expecting this.");
    }
    llSay(0, "Debug is set to " + (string)gDebug);
    //
    // The object description processing is complete. Other code could be
    // inserted here.
    //
}

default
{
    state_entry()
    {
        readdesc();                 // Process object description.
    }

    // This event is triggered when the object is rezzed.
    on_rez(integer num)
    {
        llResetScript();            // Reset script when object rezzed.
    }

    // This event is triggered when the object is touched.
    touch_start(integer total_number)
    {
        readdesc();                 // Go check the object description.
    }
}
