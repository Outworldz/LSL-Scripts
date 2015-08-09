// :CATEGORY:Walk
// :NAME:Walk_Other
// :AUTHOR:Fred Kinsei
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:09
// :ID:960
// :NUM:1382
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// This script requires a flat prim to act as the platform.// // Looking back at this script, I realize it's pretty ugly.// // Feel free to fix some stuff. -- Fred 
// :CODE:
string mess = "BLANK";
float distance;
vector height;
default
{
    state_entry()
    {
        llListen(0, "", llGetOwner(), "");
        distance = 0;
    }
    sensor(integer num)
    {
        integer i;
        for (i=0; i<num; i++)
        {
            if(llSubStringIndex(llToLower(llDetectedName(i)), llToLower(mess)) >= 0)
            {
                if(llVecDist(<0,0,0>, llDetectedPos(i)) != distance)
                {
                    vector agent = llGetAgentSize(llDetectedKey(i));
                    agent.z = agent.z / 2;
                    agent.z = agent.z + 0.11;
                    llRezObject("plat", llDetectedPos(i) - <0,0,agent.z>, ZERO_VECTOR, ZERO_ROTATION, 0);
                    distance = llVecDist(<0,0,0>, llGetPos());
                }
            }
        }
    }
    listen(integer channel, string name, key id, string message)
    {
        if(llGetSubString(message, 0, 3) == "walk")
        {
            llSensorRepeat("", "", AGENT, 96, TWO_PI, 0.01);
            mess = llGetSubString(message, 5, -1);
        }
        else if(message == "/walk off")
        {
            llSensorRemove();
            mess = "BLANK";
        }
            
    }
}
