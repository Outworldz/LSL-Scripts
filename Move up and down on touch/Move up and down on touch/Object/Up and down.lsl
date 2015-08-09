// :CATEGORY:Movement
// :NAME:Move up and down on touch
// :AUTHOR:Ferd Frederix
// :CREATED:2013-12-09 11:43:19
// :EDITED:2013-12-09 11:43:19
// :ID:1005
// :NUM:1547
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Moves a prim repeatedly up and down. Stop start via touch
// :CODE:

// if you take a -1  and complement it with ~, it become 0, and vice versa. 0 is False, everything else is True
integer toggle = -1;
integer toggle2 = -1;


// make a function call and send it a direction to move
move(vector direction)
{    
    integer p = 0;
    integer n = 10;
    for (; p < n; ++p) {
        llSetPos(llGetPos() + direction);  
    }
}

default {

    // I hate states. They are slow to change and memory intensive.  We don't even need the default state.
    
    touch_start(integer total_number)
    {
        toggle = ~ toggle;    // 0 = -1 = 0 = -1 = 0 and so on
        if (toggle)           // if True, as in not zero
            llSetTimerEvent(0.2);    // 5 times a second
        else
            llSetTimerEvent(0);    // shit off
        
    }
    timer()
    {        toggle2 = ~ toggle2;

        if (toggle2)
            move(<0,0,0.05>);
        else
            move(<0,0,-0.05>);
    }
}



