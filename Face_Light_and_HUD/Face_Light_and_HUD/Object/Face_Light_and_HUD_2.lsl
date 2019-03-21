// :CATEGORY:Face Light
// :NAME:Face_Light_and_HUD
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2010-03-29 22:56:31.820
// :EDITED:2013-09-18 15:38:52
// :ID:294
// :NUM:393
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Face Light HUD script.  This goes into  a prim you can touch to get a menu. Attach it to any HUD position and click it to control the face light
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
            
        if (message == "ON")
        {
            llSay ( -9999, "ON");
        }
    
        else if (message == "OFF") 
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

