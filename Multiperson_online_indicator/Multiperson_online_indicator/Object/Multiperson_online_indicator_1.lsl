// :CATEGORY:Online Indicator
// :NAME:Multiperson_online_indicator
// :AUTHOR:Fred Kinsei
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:58
// :ID:543
// :NUM:739
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Multiperson_online_indicator
// :CODE:
//Made By Fred Kinsei
//Put keys into the first list
//And names into the second
//Make sure the keys and names match up order-wise
list keys = ["34d58721-379d-41b3-a108-b34acafc94f5", "78cd2158-4a9f-4712-a0f2-74451bb55e2b"];
list names = ["Fred Kinsei", "Kharne Spyker"];
integer length;
list returns;
list requests;
default
{
    state_entry()
    {
        length = llGetListLength(keys);
        returns = [];
        requests = [];
        integer i;
        for(i=0;i<length;i++)
        {
            requests += llRequestAgentData(llList2Key(keys, i), DATA_ONLINE);
        }
        llSetTimerEvent(10);
    }

    timer()
    {
        llSetText(llDumpList2String(returns, " \n"), <1,1,1>, 1);
        returns = [];
        requests = [];
        integer i;
        for(i=0;i<length;i++)
        {
            requests += llRequestAgentData(llList2Key(keys, i), DATA_ONLINE);
        }
    }
    dataserver(key queryid, string data)
    {
        if((integer)data == TRUE)
            data = "Online";
        else
            data = "Offline";
        returns+=[llList2String(names, llListFindList(requests, [queryid])) + " - " + data];
    }
}
