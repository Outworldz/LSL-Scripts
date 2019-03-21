// :CATEGORY:Tour Guide
// :NAME:Valentines_Day_tour_bird
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2011-02-04 22:42:15.247
// :EDITED:2014-03-11
// :ID:946
// :NUM:1360
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Recorder prim script.   After you set out the waypoint prims, click this to get the notecard contents for the tour guide
// :CODE:
// Version 1.1 09-06-2012
// Changed lines 54 and 55 to this: 
//    integer aname = (integer) llList2String(msg,0); 
//    vector dest  = (vector) llList2String(msg,1);


integer wanted = 0;
integer debugger = FALSE ;
list prims;


debug(string message)
{
    if (debugger)
        llOwnerSay(message);
}



string left(string src, string divider) {
    integer index = llSubStringIndex( src, divider );
    if(~index)
        return llDeleteSubString( src, index , -1);
    return src;
}

string right(string src, string divider) {
    integer index = llSubStringIndex( src, divider );
    if(~index)
        return llDeleteSubString( src, 0, index + llStringLength(divider) - 1);
    return src;
}



default
{
    state_entry()
    {
        llSetText("Click after setting up all tour prims.", <1.0, 1.0, 1.0>, 2.0);
        llListen(300,"","","");
    }

    touch_start(integer n)
    {
        llOwnerSay("Please wait");
        prims = [];
        wanted ++;
        llRegionSay(300,"where");
    }

    listen(integer channel,string name, key id, string message)
    {
        debug(llGetObjectName() + " heard  " + message);
        if (wanted)
        {
            list msg = llParseString2List(message,["|"],[""]);
            integer aname = (integer) llList2String(msg,0);        // changed V 1.1
            vector dest  = (vector) llList2String(msg,1);            // changed V 1.1
            string text = llList2String(msg,2);
            integer  isthere = llListFindList(prims,[aname]);


            if (isthere > -1)
            {
                llOwnerSay("Error, there are two prims named " + (string) aname + ".  Please make sure each prim is uniquely numbered from - to N in sequence from the start prim to the finish prim. Gaps in the sequence are allowed.");
            }

            if (wanted)
            {
                prims += (integer) aname;
                prims += dest;
                prims += text;

            }
            llSetTimerEvent(10.0);
        }
    }

    timer()
    {
        wanted = 0;
        llSetTimerEvent(0);
        integer i = 0;

        prims = llListSort(prims,3,1);


        for (i = 0; i < llGetListLength(prims); i+=3)
        {
            integer primnum = llList2Integer(prims,i);
            vector loc = llList2Vector(prims,i+1);    
            string text = llList2String(prims,i+2);
            // It is correct to have a | at the beginning so the object name does not have to be removed
            llOwnerSay("|" + (string) primnum + "|" + (string) loc.x + "|" + (string) loc.y + "|" + (string) loc.z + "|" + text);

        }
        llOwnerSay("Copy the above lines to the notecard in the tour guide and reset it");


    }

    on_rez(integer p)
    {
        llResetScript();
    }
}
