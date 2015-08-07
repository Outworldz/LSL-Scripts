// YOU MUST REZ the Key Finder prim.   Copy and paste your avatar key into the DONATE script.  This is how you get donations.
// I would leave the donate script Modifiable.  This shows that you are not cheating by possibly stealing money. It helps to mention this in the manual or notecard, that you accepot donations and the script is viewable to prove you are honest.

// SEARCH for FOX to see my  changes

// 1) Forces IndieSpectrum Radio = http://81.169.149.182:8016 to be the #1 pick in the list, always

// 2) Sets the land music url back to IndieSpectrumstream every time they touch the object.

// 3) Automatically go back to  stream #1 an hour after it was set to a stream

// change this for 3 hours, currently set for 1.0 hours
float TIMER = 9999900.0 ; // one hour to go back to Fox

// This Script Requires the "Radio Stations" notecard to operate.
// See the "Radio Stations" notecard for the proper configuration when you wish to modify the stations list.

string  _notecard = "Radio Stations";

integer chatChannel = 77;
string HELP_MSG = "touch for station dialog, or use ch 77 to change stations (example \"/77 3\" to set station 3)";

list    _radioURLs;
list    _radioStations;
list    theStations;

integer _linenum = 0;
integer curStationOffset = 0;
integer stationChunk = 6;
integer curStationEnd = 5;
integer totalStations = 0;
integer dialogActive = 0;
integer curIdx  = -1;
string dispStationStr = "";

string NEXT_MSG = "Next >>";
string PREV_MSG = "<< Prev";
string LIST_MSG = "List";

string CUR_SET  = "c";
string ALL_SET  = "a";

list cmdNextChunk = [">>", "next", "Next", NEXT_MSG];
list cmdPrevChunk = ["<<", "prev", "Prev", PREV_MSG];
list cmdLsCur     = ["ls", "list", LIST_MSG];
list cmdLsAll     = ["la", "listall"];
list cmdSearch    = ["s", "search"];

string newURL;
string newDesc;



// FOX sets the parcel medial URL to default item

SetFox()
{

    return;
    // FOX: Set Radio to Fox when touched
    string newURL = llList2String(_radioURLs, 0);
    string newDesc = llList2String(_radioStations, 0);
    //llSay(0, newDesc + " = " + newURL);
    llSetParcelMusicURL(newURL);

}


//-----------------------

reset_radio() {
    llSetText("starting radio ....", // message to display
        <1,0,0>, // color: <red,green,blue>
        1.0 ); // 1.0 = 100% opaque, 0.0 = transparent
    llListen(77, "", "", "");
    curStationOffset = 0;
    curStationEnd = 5;
    _linenum = 0;
    dialogActive = 0;
    _radioURLs = [];
    _radioStations = [];
    totalStations = 0;
    curIdx = -1;
    dispStationStr = "";


    // FOX:Added Fox Radio
    add_station("IndieSpectrum Radio = http://81.169.149.182:8016");

    llGetNotecardLine(_notecard, _linenum);
}

add_station(string line) {
    list words = llParseString2List(line, [" ", " ", "="], []);
    if (llGetListLength(words) < 2) {
        return;
    }
    string url = llList2String(words, llGetListLength(words) - 1);
    string station = "";
    integer i;

    for (i=0; i<llGetListLength(words) - 1; i++) {
        if (llStringLength(station) > 0) {
            station += " ";
        }
        station += llList2String(words, i);
    }

    _radioURLs += [url];
    _radioStations += [station];
}


curStations() {
    theStations = [PREV_MSG, LIST_MSG, NEXT_MSG];

    integer i;
    dispStationStr = "";

    // llWhisper(0, "offset: " + (string)curStationOffset);
    // llWhisper(0, "end: " + (string)curStationEnd);

    for (i = curStationOffset; i <= curStationEnd; i++) {
        if (curIdx == i) {
            dispStationStr += "*";
        } else {
                dispStationStr += "  ";
        }
        dispStationStr += (string) (i + 1) + ") ";
        dispStationStr += llList2String(_radioStations, i);
        dispStationStr += "\n";

        theStations += (string)(i + 1);
    }

    // FOX Dnate button
    theStations += ["Donate"];
    dispStationStr += "Donations are greatly appreciated!";
}


doNextSet() {
    curStationOffset += stationChunk;
    curStationEnd = curStationOffset + (stationChunk - 1);

    if (curStationOffset >= totalStations) {
        curStationOffset = 0;
        curStationEnd = curStationOffset + (stationChunk - 1);
    }

    if (curStationEnd >= totalStations) {
        curStationEnd = totalStations - 1;
    }
}


doPrevSet() {
    if (curStationOffset > 1  && ((curStationOffset - stationChunk) < 1)) {
        curStationOffset = 0;
    } else {
            curStationOffset -= stationChunk;
    }

    curStationEnd = curStationOffset + (stationChunk - 1);

    if (curStationEnd >= totalStations) {
        curStationEnd = totalStations - 1;
    }

    if (curStationOffset < 0) {
        curStationEnd = totalStations - 1;
        curStationOffset = totalStations - (stationChunk - 1);
    }
}

doListStations(string mode) {
    integer i;
    integer startPos;
    integer endPos;

    if (mode == "a") {
        startPos = 0;
        endPos = totalStations - 1;
    } else {
            startPos = curStationOffset;
        endPos = curStationEnd;
    }

    for (i = startPos; i <= endPos; i++) {
        string newURL = llList2String(_radioURLs, i);
        string newDesc = llList2String(_radioStations, i);
        llSay(0, (string)(i + 1) + ": " + newDesc + " = " + newURL);
    }
}


doSearch(string theTerm) {
    integer i;

    llSay(0, "the term is " + theTerm);

    for (i = 0; i < totalStations; i++) {
        string curString = llList2String(_radioStations, i);
        if (llSubStringIndex(curString, theTerm) != -1) {
            string newURL = llList2String(_radioURLs, i);
            llSay(0, (string)(i + 1) + ": " + curString + " = " + newURL);
        }
    }
}

//-----------------------

default {
    on_rez(integer start_param) {
        reset_radio();
    }

    state_entry() {
        reset_radio();
    }

    changed(integer change) {
        if (change & CHANGED_INVENTORY) {
            reset_radio();
        }
    }

    dataserver(key query_id, string data) {
        if (data != EOF) {
            add_station(data);
            _linenum++;

            if (_linenum % 5 == 0) {
                llSetText("starting: \n" + (string)_linenum + " stations ...", // message to display
                    <1,0,0>, // color: <red,green,blue>
                    1.0 ); // 1.0 = 100% opaque, 0.0 = transparent
            }
            llGetNotecardLine(_notecard, _linenum);
            return;
        }
        llListen(93, "", NULL_KEY, "");

        totalStations = llGetListLength(_radioURLs);
        llSay(0, HELP_MSG);
        dialogActive = 1;
        llSetText("", <1,0,0>, 1.0 );
    }

    touch_start(integer touchNumber) {

        // FOX Dnate button
        SetFox();   // Force Fox station

        curStations();

        llDialog(llDetectedKey(0),
            dispStationStr,
            theStations, 93);
    }

    listen(integer channel, string name, key id, string message) {

        if (dialogActive == 0) {
            llWhisper(0, " ... still loading stations ...");
            return;
        }

        if (message == "") {
            message = "cur";
        }

        // FOX Dnate button
        if (message == "Donate") {
            llMessageLinked(LINK_THIS, 324235353254, "Donate", "");
        }



        list words = llParseString2List(message, [" ", " ", "="], []);
        list testFind = llList2List(words, 0, 0);

        if (llListFindList(cmdNextChunk, testFind) != -1) {
            doNextSet();
            curStations();
            if (channel == chatChannel) {
                doListStations(CUR_SET);
            } else {
                    llDialog(id, dispStationStr,theStations, 93);
            }
            return;
        }

        else if (llListFindList(cmdPrevChunk, testFind) != -1) {
            doPrevSet();
            curStations();
            if (channel == chatChannel) {
                doListStations(CUR_SET);
            } else {
                    llDialog(id, dispStationStr, theStations, 93);
            }
            return;
        }

        else if (llListFindList(cmdSearch, testFind) != -1) {
            doSearch(message);
            return;
        }

        else if (llListFindList(cmdLsAll, testFind) != -1) {
            doListStations(ALL_SET);
            return;
        }


        else if (llListFindList(cmdLsCur, testFind) != -1) {
            doListStations(CUR_SET);
            return;
        }


        else if ((integer)message > 0 && (integer)message < 256) {
            curIdx = (integer)message - 1;

            string newURL = llList2String(_radioURLs, curIdx);
            string newDesc = llList2String(_radioStations, curIdx);

            llSay(0, "setting station " + message + ":");
            llSay(0, newDesc + " = " + newURL);
            llSetParcelMusicURL(newURL);

            // FOX 1 hour timer
            // llSetTimerEvent(TIMER);

        }
    }

    //FOX timer fires in XX seconds, and resets the system
    timer()
    {
        SetFox();
    }
}