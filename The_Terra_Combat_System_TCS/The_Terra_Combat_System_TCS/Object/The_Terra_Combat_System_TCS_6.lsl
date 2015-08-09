// :CATEGORY:Combat
// :NAME:The_Terra_Combat_System_TCS
// :AUTHOR:Cubey Terra
// :CREATED:2010-07-01 15:11:14.270
// :EDITED:2013-09-18 15:39:07
// :ID:887
// :NUM:1261
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// hovertext
// :CODE:
// TERRA COMBAT SYSTEM V2.5
// Heads-up Display
// Put in any prim where you want the HUD's hover text to appear.


integer combat;
integer hit_points;
integer max_hit_points;
vector hovertext_colour;
integer avatars_hit;
integer avatars_killed;
integer deaths;
integer regen_mode;
integer regen_sec;
integer tcFiring;
integer controlsTaken;


update_hovertext()
{
    
    if (hit_points > (max_hit_points/2))
    {
        hovertext_colour = <0,1,0>;
    }
    else
    {
        hovertext_colour = <1,0,0>;
    }
    
    if (combat)
    {
        llSetText("TERRA COMBAT:\nAvatars hit: " + (string)avatars_hit + 
        "\nTargets destroyed: "+(string)avatars_killed+
        "\nLosses: "+(string)deaths+
        "\nHit points: "+(string)hit_points,hovertext_colour,1);
    }
    else if (regen_mode)
    {
        if (regen_sec > 0)
        {
            llSetText("TERRA COMBAT: Regenerating...\n\ "+(string)regen_sec+" seconds remaining",hovertext_colour,1);
        }
        else
        {
            regen_mode = FALSE;
        }
    }
    else
    {
        llSetText("",hovertext_colour,1);
    }
}

default
{
    state_entry()
    {
        llMessageLinked(LINK_SET, 0, "tc hud startup", ""); // prompt main script to send stuff and things
    }
    
    on_rez(integer foo)
    {
        llSetText("", ZERO_VECTOR, 1);
    }
    
    link_message(integer sender_number, integer number, string message, key id)
    {
        if (message == "tc hit points")
        {
            hit_points = number;
            update_hovertext();
        }
        if (message == "tc init hit points")
        {
            max_hit_points = number;
            //hit_points = max_hit_points;
            update_hovertext();
        }
        if (message == "tc avatars hit")
        {
            avatars_hit = number;
            update_hovertext();
        }
        if (message == "tc avatars killed")
        {
            avatars_killed = number;
            update_hovertext();
        }
        if (message == "tc deaths")
        {
            deaths = number;
            update_hovertext();
        }
        if (message == "tc on")
        {
            combat = TRUE;
            update_hovertext();
        }
        else if ((message == "tc off") || (message == "tc unseated"))
        {
            combat = FALSE;
            update_hovertext();
        }
        
        
        if (message == "tc regen")
        {
            regen_mode = TRUE;
            regen_sec = number;
            update_hovertext();
        }
        
    }

}

