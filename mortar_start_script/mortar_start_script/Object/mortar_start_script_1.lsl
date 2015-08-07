// :CATEGORY:Fireworks
// :NAME:mortar_start_script
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:57
// :ID:521
// :NUM:705
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// mortar start script.lsl
// :CODE:

integer counter = 0;


default
{
    state_entry()
    {
        llShout(55, "**:stop");
        llSetText("Click for Fireworks!", <0.0, 0.0, 1.0>, 2.0);
    }

    touch_start(integer total_number)
    {
        llShout(55, "**:start");
        llShout(0,"Fireworks Show starts now!");
        llSetTimerEvent(15);
    }
    
    timer()
    {
        counter++;
        if (counter>4)
        {
            counter = 0;
            llShout(55, "**:stop");
            llSetTimerEvent(0);
        }
        if (counter == 1)
            llShout(55, "**:blue");
        if (counter == 2)
            llShout(55, "**:green");
        if (counter == 3)
            llShout(55, "**:red");
            
    }
}
// END //
