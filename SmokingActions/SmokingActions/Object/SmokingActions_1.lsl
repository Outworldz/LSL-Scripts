// :CATEGORY:Animation
// :NAME:SmokingActions
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:04
// :ID:807
// :NUM:1117
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// SmokingActions.lsl
// :CODE:


integer gTimeout = 10;

default
{
    state_entry()
    {

    }

    attach(key on)
    {
        if (on != NULL_KEY)
        {
            llRequestPermissions(on, PERMISSION_TRIGGER_ANIMATION);
            llSetTimerEvent(0.0);
            llSetTimerEvent(gTimeout);
        }
        else
        {
            llSetTimerEvent(0.0);
        }        
    }
    
    timer()
    {
        float choice;
        choice = llFrand(3.0);
        if (choice < 2.5)
        {
            llStartAnimation("smoke_inhale");
        }
        else
        {
            llStartAnimation("smoke_inhale");
        }
    }
    
}
// END //
