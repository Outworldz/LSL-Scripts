// :CATEGORY:Notecard Reader
// :NAME:Read_Notecard_DataServer_Example
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:00
// :ID:685
// :NUM:928
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Read Notecard DataServer Example.lsl
// :CODE:

//Read Notecard DataServer Example
//by Hank Ramos
string  notecardName = "My Notecard";
integer lineCounter;
key     dataRequestID;

default
{
    state_entry()
    {
        llSay(0, "Ready. Click to start.");
    }
    touch_start(integer num_detected)
    {
        state readNotecard;
    }
}

state readNotecard
{
    state_entry()
    {
        lineCounter = 0;
        dataRequestID = llGetNotecardLine(notecardName, lineCounter);
    }
    dataserver(key queryid, string data)
    {
        //Check to make sure this is the request we are making.
        //Remember that when data comes back from the dataserver, 
        //it goes to *all* scripts in your prim.
        //So you have to make sure this is the data you want, and
        //not data coming from some other script.
        if (dataRequestID)
        {
            //If we haven't reached the end of the file
            //Display the incoming data, then request the next line #
            if (data != EOF)
            { 
                dataRequestID = llGetNotecardLine(notecardName, lineCounter);
                lineCounter += 1;
                llSay(0, "Line #" + (string)lineCounter + ": " + data);
            }
            else
            {
                state default;
            }
        }
    }
}// END //
