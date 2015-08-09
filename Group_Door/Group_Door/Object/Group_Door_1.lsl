// :CATEGORY:Door
// :NAME:Group_Door
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:54
// :ID:365
// :NUM:498
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Group Door.lsl
// :CODE:

string name=""; // Open to unlock or leave as "" to lock, group can always open
default
{
    state_entry()
    {
        llSay(0, "Door 1.0");
        state open;
    }
}

state open
{
    
    touch_start(integer total_number)
    {
        if(llSameGroup(llDetectedKey(total_number - 1))==1 || name=="open")
        {
            llTriggerSound("Door", 0.5);
       
            rotation rot = llGetRot();
            rotation delta = llEuler2Rot(<0,0,(-PI/4)+0.1>);
            rot = delta * rot;
            llSetRot(rot);
            llSleep(0.25);
            rot = delta * rot;
            llSetRot(rot);
            state closed;
        }
        else
        {
            llTriggerSound("bell", 0.7);
            llWhisper(0,"only group members may enter this area");
        }   
    }
}

state closed
{
    state_entry()
    {
        llSleep(10.0);
        llTriggerSound("Door", 0.5);
              
        rotation rot = llGetRot();
        rotation delta = llEuler2Rot(<0,0,(PI/4)+-0.1>);
        rot = delta * rot;
        llSetRot(rot);
        
        llSleep(0.25); 
        rot = delta * rot;
        llSetRot(rot);
        state open;
    }
}
// END //
