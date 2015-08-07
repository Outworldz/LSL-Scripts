// :CATEGORY:Eject
// :NAME:SendHome_Newbies
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:02
// :ID:738
// :NUM:1021
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// SendHome Newbies.lsl
// :CODE:

key Query;
list Users;

default
{
    
    on_rez(integer X) {llResetScript();}
    
    state_entry()
    {
        llSetTimerEvent(10);
    }
    
    timer()
    {
        llSensor("",NULL_KEY,AGENT,32,PI);
    }
    
    sensor(integer TNum)
    {
        integer i;
        for (i = 0; i < TNum; i++)
        {
            if (llListFindList(Users,[llDetectedKey(i)]) == -1)
            {
                Query = llRequestAgentData(llDetectedKey(i),DATA_BORN);
                Users = (Users = []) + Users + [Query, llDetectedKey(i)];
            }
        }
    }
    
    no_sensor()
    {
        llOwnerSay("Nuthin found");
    }
    
    dataserver(key QID,string Data)
    {
        integer LPos = llListFindList(Users,[QID]);
        if (-1 != LPos)
        {
            float YrDays = 365.25;
            float MnDays = YrDays / 12;
            float DyInc = 1 / MnDays;
            integer uYr = (integer)llGetSubString(Data,0,3);
            integer uMn = (integer)llGetSubString(Data,5,6);
            integer uDy = (integer)llGetSubString(Data,8,9);
            float uXVal = uYr * YrDays + (uMn - 1) * MnDays + uDy * DyInc;
            Data = llGetDate();
            integer Yr = (integer)llGetSubString(Data,0,3);
            integer Mn = (integer)llGetSubString(Data,5,6);
            integer Dy = (integer)llGetSubString(Data,8,9);
            float XVal = Yr * YrDays + (Mn - 1) * MnDays + Dy * DyInc;
            integer DDiff = (integer)(XVal - uXVal);
            if (DDiff < 3) {
                llSay(0,"Sending " + llKey2Name((key)llList2String(Users,LPos+1)) + " back home.");
                llTeleportAgentHome((key)llList2String(Users,LPos+1));
            } else {
                //llSay(0,"Passed verification: " + llKey2Name((key)llList2String(Users,LPos+1)));
            }
            Users = llDeleteSubList(Users,LPos,LPos+1);
        }
    }
}
// END //
