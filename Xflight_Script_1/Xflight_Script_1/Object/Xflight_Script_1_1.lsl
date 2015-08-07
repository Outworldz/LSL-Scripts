// :CATEGORY:Flight Assist
// :NAME:Xflight_Script_1
// :AUTHOR:Goodwill Epoch
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:09
// :ID:985
// :NUM:1410
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// X-flight Script 1.lsl
// :CODE:

//X-flight script for increased flying speed and control
//Developed by Goodwill Epoch on 6/12/2003
//Revision 1.9a
//For explicit use only by members of the Kazenojin Airship guild
//
//May be sold with explicit permission from Goodwill Epoch to non-members
//Settings must be set to no-modify no view to prevent theft of script
//script may not be modified without permission from Goodwill Epoch

//List of customizable commands
list commands = ["X", "go", "stop", "status", "speed", "accel", "pos", "accelmode", "turnmode", "hovermode", "posmode"];

//Help for commands
list com_help = ["Trigger for any commands to be entered", "Enable flight enhancements", "Disable flight enhancements", "List current modes and their state", "Current impulse, place a number after to set. limit 1-500", "Current acceleration, place a number after to set. limit 10-100",  "Current coordinates", "Acceleration of movement. Use 'on' or 'off' to set.", "Slow down while turning. Use 'on' or 'off' to set.", "Allows hovering at all heights. Use 'on' or 'off' to set.", "Displays position over object. Use 'on' or 'off' to set."];

//Default movement variables
float speed = 200;
float accel = 25;
float move = 0;
float attached = 0;

//Counters and temp variables
float accel_count = 0;
string temp_newcommand;
integer temp_newcom_pos;
integer wait_for_conf = FALSE;
integer test_move = FALSE;

//Simplified say strings
string off = "off";
string on = "on";

//Default settings
integer accelmode = TRUE;
integer turnmode = TRUE;
integer hovermode = TRUE;
integer posmode = FALSE;

//Other variables
integer listen_num;
string notecard = "X-Flight enhanced flight info";
string notehelp = "X-Flight enhanced flight help";

//Returns a on/off string from a true/false pass
string on_off(integer test)
{
    if(test)
    {
        return on;
    }
    else
    {
        return off;
    }
}

//Returns a true/fals from an on/off string
integer true_false(string test)
{
        if(test == on)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}

//Help menu handler
help()
{
    llSay(0, "Current help");
    integer a;
    for(a = 0; a < llGetListLength(com_help); a++)
    {
        llSay(0, llList2String(commands, a) + " - " + llList2String(com_help, a));
    }
    llSay(0, "customize - Allows you to customize certain commands. '" + llList2String(commands, 0) + " customize [old command] [new command]' Be sure to use full words without spaces for commands. You will then need to type 'yes' to confirm.");
    llSay(0, "reset - Resets entire script. '" + llList2String(commands, 0) + " reset' WARNING: Will erase all customize data and settings.");
}

//Allows customization of function names
customize(string old_com, string new_com)
{
    //Checks for commands and proper commands
    if((old_com == "") || (new_com == ""))  
    {
        llSay(0, "Not enough information, please try again or view help for more info.");
    }
    else
    {
        integer listpos = llListFindList(commands, [old_com]);
        if(listpos == -1)
        {
            llSay(0, "Command not found, please view help for more info on current command settings");
        }
        else    //Sets up wait to confirm changing commands
        {
            temp_newcommand = new_com;
            temp_newcom_pos = listpos;
            llSay(0, "Do you want command '" + old_com + "' to be changed to '" + new_com + "'? Please say 'yes'");
            wait_for_conf = TRUE;
        }
    }
}

//Take controls
get_controls()
{
    llListenRemove(listen_num);
    listen_num = llListen(0, "", llGetOwner(), "");
    llSetTimerEvent(.5);
    llSetText("", <0,0,0>, 0);
    llRequestPermissions(llGetOwner(), PERMISSION_TAKE_CONTROLS);
}

//Handle Commands
com_handle(integer com_num, string message)
{
    if(com_num == 1) //Go
    {
        get_controls();
    }
    else if(com_num == 2) //Stop
    {
        llReleaseControls();
        llSay(0, "All stop");
    }
    else if(com_num == 3) //Status
    {
        llSay(0, "Current settings:");
        llSay(0, llList2String(commands, 4) + " - " + (string)((integer)speed));
        llSay(0, llList2String(commands, 5) + " - " + (string)((integer)accel));
        llSay(0, llList2String(commands, 7) + " - " + on_off(accelmode));
        llSay(0, llList2String(commands, 8) + " - " + on_off(turnmode));
        llSay(0, llList2String(commands, 9) + " - " + on_off(hovermode));
        llSay(0, llList2String(commands, 10) + " - " + on_off(posmode));
    }
    else if(com_num == 4) //Speed
    {
        float tempvar = (integer)message;
        if((tempvar > 0) && (tempvar <= 500))
        {
            speed = tempvar;
            llSay(0, llList2String(commands, com_num) + " is now " + (string)((integer)speed));
        }
        else
        {
            llSay(0, llList2String(commands, com_num) + " is currently " + (string)((integer)speed));
        }
    }
    else if(com_num == 5) //Acceleration
    {
        float tempvar = (integer)message;
        if((tempvar >= 10) && (tempvar <= 100))
        {
            accel = tempvar;
            llSay(0, llList2String(commands, com_num) + " is now " + (string)((integer)accel));
        }
        else
        {
            llSay(0, llList2String(commands, com_num) + " is currently " + (string)((integer)accel));
        }
    }
    else if(com_num == 6) //current pos
    {
        vector pos = llGetPos();
        llSay(0, "<" + (string)((integer)pos.x) + ", " + (string)((integer)pos.y) + ", " + (string)((integer)pos.z) + ">");
    }
    else if(com_num == 7) //Acceleration mode
    {
        if((message == "off") || (message == "on"))
        {
            accelmode = true_false(message);
            llSay(0, llList2String(commands, com_num) + " is now " + message);
        }
        else
        {
            llSay(0, llList2String(commands, com_num) + " is currently " + on_off(accelmode));
        }
    }
    else if(com_num == 8) //Turning mode
    {
        if((message == "off") || (message == "on"))
        {
            turnmode = true_false(message);
            llSay(0, llList2String(commands, com_num) + " is now " + message);
        }
        else
        {
            llSay(0, llList2String(commands, com_num) + " is currently " + on_off(turnmode));
        }
    }
    else if(com_num == 9) //Hover Mode
    {
        if((message == "off") || (message == "on"))
        {
            hovermode = true_false(message);
            llSay(0, llList2String(commands, com_num) + " is now " + message);
        }
        else
        {
            llSay(0, llList2String(commands, com_num) + " is currently " + on_off(hovermode));
        }
        
    }
    else if(com_num == 10) //Position display mode
    {
        if((message == "off") || (message == "on"))
        {
            posmode = true_false(message);
            llSay(0, llList2String(commands, com_num) + " is now " + message);
        }
        else
        {
            llSay(0, llList2String(commands, com_num) + " is currently " + on_off(posmode));
        }
    }
}

//Check for flight and altitude for hover
set_flight()
{
    vector pos = llGetPos();
    float ground = llGround(<0,0,0>);
    if(llGetAgentInfo(llGetOwner()) & AGENT_FLYING)
    {
        move = 1;
        if(hovermode && ((pos.z > 55) && (pos.z > (ground + 35))))
        {
            llSetForce(<0,0,9.8> * llGetMass(), FALSE);
        }
        else
        {
            llSetForce(<0,0,0>, FALSE);
        }
    }
    else
    {
        move = 0;
        llSetForce(<0,0,0>, FALSE);
    }
    // Display position over object if position mode is on
    if(posmode)
    {
        llSetText("<" + (string)((integer)pos.x) + ", " + (string)((integer)pos.y) + ", " + (string)((integer)pos.z) + "> \n \n \n", <1,1,1>, 1);
    }
    else
    {
        llSetText("", <0,0,0>, 0);
    }
}

//Handle Listen Messages
listen_handler(string message)
{
    list lst_msg = llParseString2List(message, [" "],[]);
    if(llList2String(lst_msg, 0) == llList2String(commands, 0))
    {
        wait_for_conf = FALSE;
        if(llList2String(lst_msg, 1) == "help")   //If help pass to help
        {
            help();
        }
        //If customize pass to customize
        else if(llList2String(lst_msg, 1) == "customize")  
        {
            customize(llList2String(lst_msg, 2), llList2String(lst_msg, 3));
        }
        //If reset reset script
        else if(llList2String(lst_msg, 1) == "reset")  
        {
            llSay(0, "Reseting Script");
            llResetScript();
        }
        //Pass to command handler if a command
        else
        {
            integer listpos = llListFindList(commands, llList2List(lst_msg, 1, 1));
            if(listpos != -1)
            {
                com_handle(listpos, llList2String(lst_msg, 2));
            }
        }
    }
    //If Response to customize, confirm
    else if((llList2String(lst_msg, 0) == "yes") && wait_for_conf)  
    {
        llSay(0, "Changing command to " + temp_newcommand);
        commands = llDeleteSubList(commands, temp_newcom_pos, temp_newcom_pos);
        commands = llListInsertList(commands, [temp_newcommand], temp_newcom_pos);
    }
    else
    {
        wait_for_conf = FALSE;
    }
}

control_handler(integer levels, integer edges)
{
    test_move =TRUE;
    accel_count ++;
    if(accel_count > accel)
    {
        accel_count = accel;
    }
    float acc_percent = 1;
    if(accelmode)
    {
        accel_count ++;
        if(accel_count > accel)
        {
            accel_count = accel;
        }
        acc_percent = accel_count / accel;
    }
    float turning = 1;
    vector impulse = <0,0,0>;
    if (levels & CONTROL_UP)
    {
        impulse += <0,0,speed>;
    }
    if (levels & CONTROL_DOWN)
    {
        impulse += <0,0,-speed>;
    }
    if (levels & CONTROL_FWD)
    {
        impulse += <speed,0,0>;
    }
    if (levels & CONTROL_BACK)
    {
        impulse += <-speed,0,0>;
    }
    if (levels & CONTROL_LEFT)
    {
        impulse += <0,speed,0>;
    }
    if (levels & CONTROL_RIGHT)
    {
        impulse += <0,-speed,0>;
    }
    if (levels & CONTROL_ROT_RIGHT)
    {
        if(turnmode)
        {
            turning = 0;
        }
    }
    if (levels & CONTROL_ROT_LEFT)
    {
        if(turnmode)
        {
            turning = 0;
        }
    }
    llApplyImpulse((vector)(impulse * move * turning * acc_percent), TRUE);
}

//Default State, sets up basic listens, and events
default
{
    state_entry()
    {
        get_controls();
    }
    
    on_rez(integer param)
    {
        get_controls();
    }

    listen(integer channel, string name, key id, string message)
    {
        listen_handler(message);
    }
    
    control(key id, integer levels, integer edges)
    {
        control_handler(levels, edges);
    }

    timer()
    {
        set_flight();
        if(!test_move)
        {
            accel_count = -1;
        }
        test_move = FALSE;
    }

    //Detect touch, if not owner then give info. If owner display help.
    touch(integer total_touched)
    {
        integer a = 0;
        key toucher;
        for(a = 0; a < total_touched; a++)
        {
            toucher = llDetectedKey(a);
            if(toucher == llGetOwner())
            {
                llGiveInventory(toucher, notehelp);
                llSay(0, "Please type '" + llList2String(commands, 0) + " help' for more help with commands"); 
            }
            else
            {
                llGiveInventory(toucher, notecard);
            }
        }
    }
    
    //Detect if permission to take controls is enabled
    run_time_permissions(integer permissions)
    {
        if (llGetPermissions() & PERMISSION_TAKE_CONTROLS)
        {
            llSay(0, "All Go");
            llTakeControls(CONTROL_DOWN|CONTROL_UP|CONTROL_FWD|CONTROL_BACK|CONTROL_LEFT|CONTROL_RIGHT|CONTROL_ROT_LEFT|CONTROL_ROT_RIGHT, TRUE, TRUE);
        }
    }
}

// END //
