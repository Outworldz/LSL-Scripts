// :CATEGORY:Door
// :NAME:Door_quiet
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:52
// :ID:255
// :NUM:346
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Door quiet.lsl
// :CODE:

// If door is locked, the name of the avatar who locked it.
// If door is not locked, the empty string ("").
string gLockedBy = "";

// This number must match the channel number of the lock
// and unlock objects you want to use.  If multiple doors
// have the same channel, then a single lock can lock all of
// them at once.
integer gLockChannel = 243;

default
{
    state_entry()
    {
        llSay(0, "Door 1.0");
        llListen(gLockChannel, "", NULL_KEY, "");
        state closed;
    }
}

state closed
{
    listen(integer channel, string name, key id, string message)
    {
        if (channel == gLockChannel)
        {
            if (message == "")
            {
                gLockedBy = "";
                //llTriggerSound("door unlock", 10.0);
                llSay(0, "unlocked");
            }
            else
            {
                gLockedBy = message;
                //llTriggerSound("door lock", 10.0);
                llSay(0, "locked");
            }
        }
    }
    
    touch_start(integer total_number)
    {
        string name = llDetectedName(0);
        if (name == gLockedBy || gLockedBy == "")
        {
            llTriggerSound("Door open", 0.5);
       
            rotation rot = llGetRot();
            rotation delta = llEuler2Rot(<0,0,PI/4>);
            rot = delta * rot;
            llSetRot(rot);
            llSleep(0.25);
            rot = delta * rot;
            llSetRot(rot);
            state open;
        }
        else
        {
            llTriggerSound("Door knock", 0.5);
        }
    }
}

state open
{
    touch_start(integer num)
    {
        llTriggerSound("Door close", 0.5);
              
        rotation rot = llGetRot();
        rotation delta = llEuler2Rot(<0,0,-PI/4>);
        rot = delta * rot;
        llSetRot(rot);
        
        llSleep(0.25); 
        rot = delta * rot;
        llSetRot(rot);
        
        state closed;
    }
}
// END //
