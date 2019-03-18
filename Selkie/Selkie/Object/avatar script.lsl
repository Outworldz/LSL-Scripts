// :CATEGORY:Transmogrify
// :NAME:Selkie
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:02
// :ID:737
// :NUM:1017
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// avatar
// :CODE:

default
{
    state_entry()
    {
        llSetAlpha(1.0, ALL_SIDES); // 1= visible
    }
    
    on_rez(integer param)
    {
        llResetScript();
    }
    
    link_message(integer sender, integer num, string str, key id)
    {
        
        if (str == "pet")
            llSetTexture("43716e0b-8031-4dc9-8920-7afeb7a6c5c9",ALL_SIDES);
        else if (str == "avatar")
            llSetTexture("8dcd4a48-2d37-4909-9f78-f7a9eb4ef903", ALL_SIDES);  
        
    }
}
