// :CATEGORY:Rider
// :NAME:Tiger Rider
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-13 13:20:22
// :EDITED:2013-09-25 14:05:55
// :ID:996
// :NUM:1493
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// PoseBall for back of rider
// :CODE:

key agent;
integer debug = TRUE;         // set to TRUE or FALSE for debug chat on various actions

DEBUG(string str)
{
    if (debug)
        llOwnerSay( str);                    // Send the owner debug info so you can chase NPCS
}


default
{
    state_entry()
    {
        llSitTarget(<0,0,1>,ZERO_ROTATION);
        llSay(0, "Hello, sit on me!");
        llSetAlpha(1.0,ALL_SIDES);
    }

    on_rez(integer o)
    {
        llResetScript();
    }
    
    changed(integer change)
    {
        if (change & CHANGED_LINK)
        {
            agent = llAvatarOnSitTarget();
            if (agent != NULL_KEY)
            {                
                if( (agent != llGetOwner())  )
                {
                    llUnSit(agent);
                    llSay(0,"Sorry, you cannot ride the tiger. Get your own tiger in the Virunga Mountains in OSGrid");
                    DEBUG("Non-owner Seated");
                }
                else
                {
                    DEBUG("Seated");
                    llMessageLinked(LINK_SET,0,"Seated",agent);
                    llSetAlpha(0.0,ALL_SIDES);

                }
                
            }
            else
            {
                llSetAlpha(1.0,ALL_SIDES);
                llMessageLinked(LINK_SET,0,"Unseated","");
            }
        }
    }
    
}
