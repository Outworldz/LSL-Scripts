// :SHOW:
// :CATEGORY:Rider
// :NAME:Opensim Ridable NPC
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2015-03-17 10:28:24
// :EDITED:2015-03-17  09:28:24
// :ID:1073
// :NUM:1733
// :REV:1
// :WORLD:OpenSim
// :DESCRIPTION:
// PoseBall for back of dragon
// :CODE:

// Rev 0.1 2014-12-08 Compiles

integer gDebug = TRUE;         // set to TRUE or FALSE for debug chat on various actions

DEBUG(string str)
{
    if (gDebug)
        llOwnerSay(llGetScriptName() + ":" +  str);                    // Send the owner debug info so you can chase NPCS
}


default
{
    state_entry()
    {
        llSitTarget(<0,0,0.1>,ZERO_ROTATION);
        llSay(0, "Hello, sit on the dragon pose ball to fly!");
        llSetSitText("Fly");
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
            key agent = llAvatarOnSitTarget();
            if (agent != NULL_KEY)
            {                
                DEBUG("Seated");
                llMessageLinked(LINK_SET,0,"Seated",agent);
                llSetAlpha(0.0,ALL_SIDES);               
            }
            else
            {
                llSetAlpha(1.0,ALL_SIDES);
                llMessageLinked(LINK_SET,0,"Unseated","");
            }
        }
    }
}
