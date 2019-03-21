// :CATEGORY:FaceLight
// :NAME:facelight
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2014-04-04 22:00:30
// :EDITED:2014-04-04
// :ID:1031
// :NUM:1606
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// A user settable facelight with HUD
// :CODE:

list MENU_MAIN = ["On", "---", "Off", "Brilliant", "Normal", "Subtle" ]; // the main menu

integer CHANNEL; // dialog channel


setup_listen()
{
    llListenRemove(1);
    CHANNEL = llRound(llFrand(1) * 100000);
    integer x = llListen(CHANNEL, "", "", ""); // listen for dialog answers
}

default
{
    state_entry()
    {
        setup_listen();

    }
    
    touch_start(integer total_number) 
    {
        llDialog(llDetectedKey(0), "What do you want to do?", MENU_MAIN, CHANNEL); // present dialog on click
    }
    
    listen(integer channel, string name, key id, string message) 
    {
    
        llOwnerSay(message);
        if (message == "On")
        {
            llSay ( -9999, "ON");
            
            
        }
    
        else if (message == "Off") 
        {
            llSay ( -9999, "OFF");
        }
    
    
    // add more of these for more commands.
    
        else if (message == "Brilliant") 
        { 
            llSay ( -9999, "Brilliant");
        }
    
        else if (message == "Normal") 
        { 
            llSay ( -9999, "Normal");
        }
    
        else if (message == "Subtle") 
        { 
            llSay ( -9999, "Subtle");
        }
    }
    
    
    
    
    attach(key agent)
    {
        if (agent != NULL_KEY)
        {
            setup_listen();        
        }
    }
    
    
    on_rez( integer start_param)
    {
        llResetScript();
    }
    
    

    
}

