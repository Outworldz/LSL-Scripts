// :CATEGORY:Floating Text
// :NAME:Floating_text_remove
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:53
// :ID:325
// :NUM:434
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Floating text remove.lsl
// :CODE:

default
{
    state_entry()
    {
        llSay(0, "Remove floating text");
        llSetText("",<0,0,0>,0.0);
    }

    on_rez(integer start_param)
    {
        llResetScript();
    } 
}
// END //
