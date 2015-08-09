// :CATEGORY:Scanner
// :NAME:Agent_Scanner_with_info
// :AUTHOR:Fred Kinsei
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:47
// :ID:20
// :NUM:30
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Avatar scanner
// :CODE:
string output;
default
{
    state_entry()
    {
        llSensorRepeat("", "", AGENT, 100, PI, 0.1);
    }
    no_sensor()
    {
        output = "No avatars detected.";
        llSetText(output, <1,1,1>, 1);
    }
    sensor(integer num)
    {  
        integer i;
        output="";
        for (i=0; i<num; i++)
        {
            if(llDetectedKey(0) != NULL_KEY)
            {                    
                output+=llDetectedName(i) + " - [ " + (string)llRound(llVecDist(llGetPos(), llDetectedPos(i))) + "m ";
                if(llGetAgentInfo(llDetectedKey(i)) & AGENT_FLYING)
                    output+="- F ";
                if(llGetAgentInfo(llDetectedKey(i)) & AGENT_MOUSELOOK)
                    output+="- ML ";
                if(llGetAgentInfo(llDetectedKey(i)) & AGENT_TYPING)
                    output+="- T ";
                if(llGetAgentInfo(llDetectedKey(i)) & AGENT_SITTING)
                    output+="- S ";
                if(llGetAgentInfo(llDetectedKey(i)) & AGENT_AWAY)
                    output+="- A ";
                output+="]\n";
            }
        }
        llSetText(output, <1,1,1>, 1);
    }
}
