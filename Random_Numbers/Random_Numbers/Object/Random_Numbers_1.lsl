// :CATEGORY:Random Numbers
// :NAME:Random_Numbers
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:00
// :ID:679
// :NUM:922
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Random Numbers.lsl
// :CODE:

default
{
    state_entry()
    {
        llSay(0, "Hello, Avatar!");
    }

    touch_start(integer total_number)
    {
        float   FloatValue;
        integer IntValue;
        string  StringValue;
        
        FloatValue  = llFrand(100);
        IntValue    = llRound(FloatValue);
        StringValue = (string)IntValue;
        
        llSay(0, StringValue);
    }
}
// END //
