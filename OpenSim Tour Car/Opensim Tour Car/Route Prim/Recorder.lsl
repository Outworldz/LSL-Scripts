// :CATEGORY:Tour
// :NAME:OpenSim Tour Car
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2014-09-07 10:50:19
// :EDITED:2014-09-07
// :ID:1040
// :NUM:1628
// :REV:1
// :WORLD:Opensim
// :DESCRIPTION:
// Tour recordwer. Touch this after placing #10 prims
// :CODE:


osMakeNotecard(string notecardName, string contents) {
    llOwnerSay("Make Notecard " + notecardName + "Contents:" +  (string) contents);
}



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
            integer aname = (integer) llList2String(msg,0);
            vector dest  =  (vector) llList2String (msg,1);
            rotation  arot  = (rotation) llList2String(msg,2);
            integer  isthere = llListFindList(prims,[aname]);

            if (isthere > -1)
            {
                llOwnerSay("Error, there are two prims named " + aname + ".  Please make sure each prim is uniquely numbered from - to N in sequence from the start prim to the finish prim. Gaps in the sequence are allowed.");
            }

            if (wanted)
            {
                prims += (integer) aname;
                prims += (vector) dest;
                prims += (rotation) arot;

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
        string out;

        for (i = 0; i < llGetListLength(prims); i+=3)
        {
            integer primnum = llList2Integer(prims,i);
            vector loc = llList2Vector(prims,i+1);
            rotation arot = llList2Rot(prims,i+2);
            out += (string) primnum + "|" + (string) loc  + "|" + (string) arot +"|\n";
        }
        osMakeNotecard("Route",out);
        llOwnerSay("The Route notecard is ready");


    }

    on_rez(integer p)
    {
        llResetScript();
    }
}

