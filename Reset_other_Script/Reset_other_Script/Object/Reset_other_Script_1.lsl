// :CATEGORY:Reset
// :NAME:Reset_other_Script
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:01
// :ID:697
// :NUM:951
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Reset other Script.lsl
// :CODE:

integer rocking = TRUE;
default
{
    state_entry()
    {
        llListen( 2, "", NULL_KEY, "reset" ); // Listens on Channel 2 for command 'reset'.
                                              // Owner controlled only!
                                              // Change the channel to channels 2-254 only!
                                              // and "reset" to anything.
        llSay(0, "Reset script active!");
    }

    listen(integer channel, string name, key id, string m)
    {
        if(m == "reset")
            
    llSay(0, "Initializing...");
    llResetOtherScript("SCRIPTtoRESEThere");       // Make sure you rename this to the
                                            // script you want to reset!
    llSay(0, "Done!");
    
        }

    }// END //
