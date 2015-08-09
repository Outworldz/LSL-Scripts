// :CATEGORY:Color
// :NAME:color_change_script
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:50
// :ID:191
// :NUM:264
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// color change script.lsl
// :CODE:

default
{
    state_entry()
    {
        llListen(0, "",llGetOwner(), "" );
    }
    
    on_rez(integer start_param)
    {
        llResetScript();
    }

    listen(integer channel, string name, key id, string message)
    {
        if (message == "black") llSetColor(<0,0,0>, ALL_SIDES);
        if (message == "white") llSetColor(<1,1,1>, ALL_SIDES);
        if (message == "grey") llSetColor(<0.5,0.5,0.5>, ALL_SIDES);
        if (message == "light grey") llSetColor(<0.75,0.75,0.75>, ALL_SIDES);
        if (message == "dark red") llSetColor(<0.5,0,0>, ALL_SIDES);
        if (message == "red") llSetColor(<1,0,0>, ALL_SIDES);
        if (message == "light yellow") llSetColor(<1,1,0.5>, ALL_SIDES);
        if (message == "yellow") llSetColor(<1,1,0>, ALL_SIDES);
        if (message == "dark yellow") llSetColor(<0.5,0.5,0>, ALL_SIDES);
        if (message == "light green") llSetColor(<0,1,0.5>, ALL_SIDES);
        if (message == "green") llSetColor(<0,1,0>, ALL_SIDES);
        if (message == "dark green") llSetColor(<0,0.5,0>, ALL_SIDES);
        if (message == "light turquoise") llSetColor(<0.5,1,1>, ALL_SIDES);
        if (message == "turquoise") llSetColor(<0,1,1>, ALL_SIDES);
        if (message == "dark turquoise") llSetColor(<0,0.5,0.5>, ALL_SIDES);
        if (message == "light blue") llSetColor(<0,0.5,1>, ALL_SIDES);
        if (message == "blue") llSetColor(<0,0,1>, ALL_SIDES);
        if (message == "dark blue") llSetColor(<0,0,0.5>, ALL_SIDES);
        if (message == "light purple") llSetColor(<0.5,0,1>, ALL_SIDES);
        if (message == "purple") llSetColor(<1,0,1>, ALL_SIDES);
        if (message == "dark purple") llSetColor(<0.5,0,0.5>, ALL_SIDES);
        if (message == "orange") llSetColor(<1,0.5,0>, ALL_SIDES);
        if (message == "brown") llSetColor(<0.5,0.25,0>, ALL_SIDES);
        if (message == "pink") llSetColor(<1,0,0.5>, ALL_SIDES);
        if (message == "dark pink") llSetColor(<0.5,0,0.25>, ALL_SIDES);
    }
}// END //
