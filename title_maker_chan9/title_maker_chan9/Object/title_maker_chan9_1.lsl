// :CATEGORY:HoverText
// :NAME:title_maker_chan9
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:07
// :ID:899
// :NUM:1275
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// title maker chan9.lsl
// :CODE:

integer CommandIs(string msg,string cmd)
{
    return llSubStringIndex(msg,cmd) == 0;
}
ParseAndIssueCommand(string cmd)
{

    if (CommandIs(cmd,"title"))
    {
        string name = llGetSubString(cmd,6,-1);
        if (name == "title")
            llSetText("",<0,1,0>,1.0);
        else
            llSetText(name,<0,1,0>,1.0);   
    }
}
default
{
    state_entry()
    {
         llListen(9,"",llGetOwner(),"");
    }
        on_rez(integer start_param)
        {
        llResetScript();
        }  
        listen(integer channel, string name, key id, string msg)
    {
        ParseAndIssueCommand(msg);
    }
}
// END //
