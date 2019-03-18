// :CATEGORY:Tour
// :NAME:Tour Bird
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:07
// :ID:907
// :NUM:1284
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Tour
// :CODE:


integer wanted = 0;
integer debugger =1;
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
            integer aname = llList2Integer(msg,0);
            vector dest  =  llList2Vector(msg,1);
            string text = llList2String(msg,2);
            integer  isthere = llListFindList(prims,[aname]);


            if (isthere > -1)
            {
                llOwnerSay("Error, there are two prims named " + aname + ".  Please make sure each prim is uniquely numbered from - to N in sequence from the start prim to the finish prim. Gaps in the sequence are allowed.");
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
            llOwnerSay("|" + (string) primnum + "|" + (string) loc.x + "|" + (string) loc.y + "|" + (string) loc.z + "|" + text);

        }
        llOwnerSay("Copy the above lines to the notecard in the tour guide and reset it");


    }

    on_rez(integer p)
    {
        llResetScript();
    }
}

