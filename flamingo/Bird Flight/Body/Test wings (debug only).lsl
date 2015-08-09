// :CATEGORY:Bird
// :NAME:flamingo
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:53
// :ID:314
// :NUM:414
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// test wing flap
// :CODE:

default
{
    state_entry()
    {

        llMessageLinked(LINK_SET,2,"fly","");
         llSleep(10);

         llMessageLinked(LINK_SET,-2,"land","");
    }
    
    link_message(integer from, integer num, string str, key id)
    {    
        llOwnerSay(str);
    }
}

