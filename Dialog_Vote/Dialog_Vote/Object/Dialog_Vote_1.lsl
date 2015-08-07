// :CATEGORY:Vote
// :NAME:Dialog_Vote
// :AUTHOR:Fred Kinsei
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:51
// :ID:234
// :NUM:322
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Dialog_Vote
// :CODE:
//Credit to the creator:
//Made by SL resident Fred Kinsei
integer votes1;
integer votes2;
string vote1;
string vote2;
list buttons;
string question;
default
{
    state_entry()
    {
        llListen(5, "", NULL_KEY, "");
        llListen(-11, "", "", "");
    }
    listen(integer channel, string name, key id, string message)
    {
        if(channel==5)
        {
            list vote = llParseString2List(message, [" -"], []);
            if(llList2String(vote,0) == "/vote")
            {
                question = llList2String(vote,1);
                vote1 = llList2String(vote,2);
                vote2 = llList2String(vote,3);
                integer range = llList2Integer(vote,4);
                if(range == 0)
                    range=96;
                buttons = [vote1, vote2];
                llDialog(llGetOwner(),"\n"+question,buttons,-11);
                llSensor("", NULL_KEY, AGENT, range, TWO_PI);
            }
        }
        if(channel==-11)
        {
            if(message == vote1)
            {
                votes1++;
            }
            if(message == vote2)
            {
                votes2++;
            }
        }
    }
    timer()
    {
        llSensorRemove();
        llOwnerSay(vote1 + ": " + (string)votes1);
        llOwnerSay(vote2 + ": " + (string)votes2);
        llResetScript();
    }
    sensor(integer num)
    {
        llSetTimerEvent(15);
        integer i;
        for(i=0;i<num;i++)
        {
            if(llDetectedKey(i) != llGetOwner())
                llDialog(llDetectedKey(i),"\n"+question,buttons,-11);
        }
    }
}
