// :CATEGORY:Prim
// :NAME:Prim_Animation_Compiler
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2014-07-15 10:23:29
// :EDITED:2014-07-15
// :ID:648
// :NUM:1618
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// simple owner-only chat to animator script.
// :CODE:

default
{
    on_rez(integer param) {
        llResetScript();
    }
    
    state_entry() {
        llListen(0,"","","");
    }
    listen(integer channel, string name, key id, string message)
    {
        if (llGetOwner() == id)
            llMessageLinked(LINK_SET,1,message,"");
    }
}