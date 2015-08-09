// :CATEGORY:Elevator
// :NAME:Sky_Lift_Script
// :AUTHOR:Digital Dharma
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:03
// :ID:779
// :NUM:1067
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Sky Lift Script.lsl
// :CODE:

//Created By: Digital Dharma

//Sky Lift
//This script will give the owner of an object 2 commands to lift the object
//to a desired height.
// "up" will cause the lift to rise.
// "down" will cause the lift to lower.

//EDIT THESE VALUES IF NECESSARY
float move_amount = 250; //how many meters to lift/lower on command
integer say_step = 25; //how often to report the % completed


//NOTHING BELOW HERE NEEDS EDITING
//I won't comment it either so if you want to toy you'll have to figure it out!
vector orig_pos;
vector new_pos;

default
{
    state_entry()
    {
        state idle;
    }
}

state idle
{
    state_entry()
    {
        llSay(0, "Lift is ready. Sit on a box and type \"up 250m\" or \"down 250m\" (or any other distance) to command the lift.");
        llListen(0, "", NULL_KEY, "");
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (llGetSubString(llToLower(message), 0, 1) == "up")
        {
            if (id != llGetOwner())
            {
                llSay(0, "Sorry, only the owner of the lift can control it.");
            }
            else
            {
                if ((float) llGetSubString(message, 2, -1) > 0)
                {
                    move_amount = (float) llGetSubString(message, 2, -1);
                }
                
                llSay(0, "Moving up " + (string) ((integer) move_amount) + " m...");
                orig_pos = llGetPos();
                new_pos = <orig_pos.x, orig_pos.y, orig_pos.z + move_amount>;
                state moving;
            }
        }
        else if (llGetSubString(llToLower(message), 0, 3) == "down")
        {
            if (id != llGetOwner())
            {
                llSay(0, "Sorry, only the owner of the lift can control it.");
            }
            else
            {
                if ((float) llGetSubString(message, 4, -1) > 0)
                {
                    move_amount = (float) llGetSubString(message, 4, -1);
                }
                
                llSay(0, "Moving down " + (string) ((integer) move_amount) + " m...");
                orig_pos = llGetPos();
                new_pos = <orig_pos.x, orig_pos.y, orig_pos.z - move_amount>;
                state moving;
            }
        }
    }
}

state moving
{
    state_entry()
    {
        vector last_pos = llGetPos();
        vector current_pos;
        integer last_percent = 0;
        
        while(last_pos != new_pos && last_pos != current_pos)
        {
            current_pos = llGetPos();
            float percent = ((orig_pos.z - current_pos.z) / (orig_pos.z - new_pos.z)) * 100;
            
            
            if ((integer) (percent - say_step) > last_percent)
            {
                last_percent = last_percent + say_step;
                llSay(0, (string) last_percent + "%: " + (string) ((integer) current_pos.z) + "m/" + (string) ((integer) new_pos.z) + "m");
            }
            llSetPos(new_pos);
            last_pos = llGetPos();
        }
        
        if (llGetPos() == new_pos)
        {
            llSay(0, "100%: Arriving at " + (string) ((integer) new_pos.z) + "m");
        }
        else
        {
            llSay(0, "The lift has stopped at " + (string) ((integer) last_pos.z) + "m, cannot continue in that direction.");
        }

        state arriving;
    }
}

state arriving
{
    state_entry()
    {
        state idle;
    }
}// END //
