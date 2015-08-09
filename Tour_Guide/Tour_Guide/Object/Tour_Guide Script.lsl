// :CATEGORY:Tour Guide
// :NAME:Tour_Guide
// :AUTHOR:Wandering Yaffle
// :KEYWORDS:
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2014-03-11
// :ID:908
// :NUM:1286
// :REV:1.1
// :WORLD:Second Life
// :DESCRIPTION:
// The script
// :CODE:


// Revision:
// Ferd Frederix removed useless stuff

key RequestStops;
key GetIndexLines;
key ReadCard;

list Line = [];
list Locations = [];
list Descriptions = [];

integer IndexLines;
integer i = 0;
integer count = 0;
integer locationLength;
integer InitPerCent;
integer timeout = 0;

float OffsetLocx;
float OffsetLocy;
float OffsetLocz;

vector TempLocation;
vector CurrentLocation;
vector TargetLocation;

vector ownerpos;

string TempDescription;
string SpeechCard;
string owner;


default
{
    on_rez(integer param)
    {
        llResetScript();
    }

    state_entry()
    {
    llSetPrimitiveParams([PRIM_PHYSICS, FALSE]);
    llSetBuoyancy(1);
    //llSetStatus(STATUS_ROTATE_X | STATUS_ROTATE_Y | STATUS_ROTATE_Z, FALSE);
    llSetColor(<1,0,0>, ALL_SIDES);
     RequestStops = llGetNumberOfNotecardLines("Initialise");
     GetIndexLines = llGetNotecardLine("Initialise",0);
    CurrentLocation = (llGetPos());
     OffsetLocx = llRound(CurrentLocation.x);
     OffsetLocy = llRound(CurrentLocation.y);
     OffsetLocz = llRound(CurrentLocation.z);
     llSetPos(<OffsetLocx, OffsetLocy, OffsetLocz>);
     llSay (0, "Tour guide initialising. Please wait.");

    }

    dataserver(key queryid, string data)
    {
        if (queryid == RequestStops)
        {
            IndexLines = (integer) data;
        }

        if (queryid == GetIndexLines)
        {

            if (data != EOF)
            {
                queryid = llGetNotecardLine("Initialise", i);
                Line = (llParseString2List(data, ["|"], []));
                string junk  = llList2String(Line, 0);
                TempLocation = (vector) llList2String(Line, 1);
                Locations = Locations + [TempLocation];
                TempDescription = llList2String(Line, 2);
                Descriptions = Descriptions + [TempDescription];
                locationLength = (llGetListLength(Locations));
                InitPerCent = (integer) llRound(((float) locationLength / (float) IndexLines) * 100);
                llSetText("Initialising... \n" + (string) InitPerCent + "%" , <1,1,1>, 1.0);
                if (InitPerCent == 100)
                {
                    state moving;
                }
                i++;
            }
             GetIndexLines = llGetNotecardLine("Initialise",i);


        }

    }

    touch_start(integer total_number)
    {
        integer check = llGetListLength(Locations);

        if (check >= IndexLines)
        {
            owner = llDetectedName(0);
            state moving;
        }

        if (check < IndexLines)
        {
            llSay(0, "Hang on a sec, still initialisng...");
        }
    }

    state_exit()
    {
        llSetText("", <1,1,1>, 1.0);
        TargetLocation = (vector) llList2String(Locations, count);
    }
}

state moving
{

    state_entry()
    {
    llSetPrimitiveParams([PRIM_PHYSICS, TRUE]);
    llSetColor(<0,1,1>, ALL_SIDES);
    CurrentLocation = (llGetPos());
    llSetTimerEvent(0.5);
    llLookAt(TargetLocation, 1, .5);
    }


    timer()
    {
        timeout = timeout + 1;
        CurrentLocation = (llGetPos());
        //llSetText("Timeout... \n" + (string) timeout, <1,1,1>, 1.0);

        if (llVecMag(llGetPos() - TargetLocation) > .49999)
        {
            if (timeout > 50) // Time Out to contingency
            {
                state setposition;
            }
            llMoveToTarget((llVecNorm(TargetLocation - llGetPos()) * 1) + llGetPos(), .5);
            //llSay(0,"Looking at target location: " + (string) TargetLocation);
        }

        if (llVecMag(llGetPos() - TargetLocation) < .49999)
        {
            state speaking;
        }


    }

    state_exit()
    {
        SpeechCard = llList2String(Descriptions, count);
        llSetTimerEvent(0);
        timeout = 0;
        i = 0;
    }

}

state setposition //contingency
{
    state_entry()
    {
            llSetPrimitiveParams([PRIM_PHYSICS, FALSE]);
            CurrentLocation = (llGetPos());
            llSetTimerEvent(0.5);
    }

    timer()
    {
        if (llVecMag(llGetPos() - TargetLocation) > .49999)
        {
            llSetPos((llVecNorm(TargetLocation - llGetPos()) * 0.5) + llGetPos());
            llLookAt(TargetLocation, 10, 10);
        }

        if (llVecMag(llGetPos() - TargetLocation) < .49999)
        {
            state speaking;
        }

    }
    state_exit()
    {

        timeout = 0;
        llSetTimerEvent(0);

    }

}

state speaking
{

    state_entry()
    {
        llSetColor(<0,0,1>, ALL_SIDES);
        llSetTimerEvent(0.5);
        if (SpeechCard == ">")
        {
            count = count +1;
            if (count > (IndexLines - 1))
            {
                state end;
            }
            if (count <= (IndexLines - 1))
            {
                TargetLocation = (vector) llList2String(Locations, count);
                state moving;
            }
        }
        ReadCard = llGetNotecardLine(SpeechCard,i);
    }

    sensor(integer total_number)
    {
         ownerpos = llDetectedPos(0) + <0,0,.7>;
    }

    dataserver(key queryid, string data)
    {

        if (queryid == ReadCard)
        {
         if (data != EOF)
            {
                llSay(0, data);
                queryid = llGetNotecardLine(SpeechCard, i);
                llSleep(2);
                i++;
            }
            ReadCard = llGetNotecardLine(SpeechCard,i);
        }

    }

    timer()
    {
        llSensor(owner, NULL_KEY, AGENT, 10, PI);
        llLookAt(ownerpos, .05, 1);
        timeout = timeout + 1;
        if (timeout == 600)
        {
            llSay(0, "Bored now. Click me to continue!");
        }

        if (timeout > 800)
        {
            llSay(0, "No response. Ending tour.");
            state end;
        }
    }

    touch_start(integer total_number)
    {

        count = count +1;
        if (count > (IndexLines - 1))
        {
            state end;
        }
        if (count <= (IndexLines - 1))
        {
            TargetLocation = (vector) llList2String(Locations, count);
            state moving;
        }
    }

    state_exit()
    {
        llSetTimerEvent(0);
        timeout = 0;
    }

}

state end
{
    state_entry()
    {
        llSay (0, "This concludes the tour. Terminating.");
        llDie();
    }

}
