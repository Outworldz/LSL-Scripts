// :SHOW:
// :CATEGORY:Teleporter
// :NAME:HG Teleporter
// :AUTHOR:Jeff Kelley
// :KEYWORDS:
// :CREATED:2020-04-22 00:19:49
// :EDITED:2020-04-22  23:19:49
// :ID:1127
// :NUM:2015
// :REV:1
// :WORLD:OpenSim
// :DESCRIPTION:
// Notecrad teleport
// :CODE:


//LSL-Editor ONLY code - delete this to actually work in-Openim

osMessageObject(key id, string str) {}
osSetDynamicTextureData( string dynamicID, string contentType, string data, string extraParams, integer timer) {}
string osSetPenColor(string drawList, string color) { return "";}
string osMovePen(string drawList, integer x, integer y) { return "";}
string osDrawRectangle(string drawList, integer width, integer height) { return "";}
string osDrawFilledRectangle(string drawList, integer width, integer height) {return "";}
string osDrawText(string drawList, string texts) {return "";}
string osSetPenSize(string drawList, integer penSize) {return "";}
string osSetFontSize(string drawList, integer fontSize) {return "";}
osTeleportAgent(key agent, string regionName, vector position, vector lookat) {}


            
// (c) The owner of Avatar Jeff Kelley, 2010
//
// This script is licensed under Creative Commons BY-NC-SA
// See <http://creativecommons.org/licenses/by-nc-sa/3.0/>
//
// You may not use this work for commercial purposes.
// You must attribute the work to the author, Jeff Kelley.
// You may distribute, alter, transform, or build upon this work
// as long as you do not delete the name of the original author.
//
// *** UPDATED ***
// Fix to allow the boards to work under Opensim 0.8.1 official release and later
// by Aine Caoimhe March 2015
// - removed 4096-region distance check as distance is no longer limitted as of 0.8.0.x
// - fixed: change to TP code handling requires that grid url and port be stripped from local tp
// To use this fix you must add your own local grid's url and port here (example "refugegrid.com:8002")
string localGrid="world.narasnook.com:8900";

integer DEBUG_ON = FALSE;
DEBUG(string message) {if (DEBUG_ON) llOwnerSay(message);}


///////////////////////////////////////////////////////////////////
// Part 1 : Datasource
///////////////////////////////////////////////////////////////////

// The goal of the datasource is to read a file in script's memory
// At the moment, we support three datasources:
//
//  http://                 A web file
//  card://cardname         A notecard in the objects's inventory
//  card://uuid/cardname    A notecard from the LSL server 'uuid'
//                          (requires a server script, not included)
//
// Edit the 'datasource' string to fit your need
//
//string datasource = "card://Destinations";
//string datasource = "card://e511d6c0-7588-4157-a684-8ca5f685a077/Destinations";
//string datasource = "http://my_web_server/path_to_file/Destinations";

string datasource =  "card://Destinations";

string datasorceData;   // The content of the datasource

readFile(string source) {
    list parse = llParseString2List (source, ["/"],[]);
    string s0 = llList2String (parse, 0);
    string s1 = llList2String (parse, 1);
    string s2 = llList2String (parse, 2);

    // Web server: fall through http_response event

    if (s0 == "http:") sendHTTPRequest (source);

    // LSL server : fall through dataserver event
    // If no UUID : fall through dataserver event

    if (s0 == "card:")
        if (isUUID(s1)) osMessageObject ((key)s1, "READ "+s2);
        else            readNotecard (s1);
}

integer isUUID (string s) {
    list parse = llParseString2List (s, ["-"],[]);
    return ((llStringLength (llList2String (parse, 0)) == 8)
        &&  (llStringLength (llList2String (parse, 1)) == 4)
        &&  (llStringLength (llList2String (parse, 2)) == 4)
        &&  (llStringLength (llList2String (parse, 3)) == 4)
        &&  (llStringLength (llList2String (parse, 4)) == 12));
}

///////////////////
// Notecard reader
///////////////////

// Since osGetNotecard has Threat Level = VeryHigh
// we stick to the old, slow, clumsy notecard reader

string ncName;      // Name of the notecard to be read
key ncQueryID;      // id of dataserver queries
integer ncLine;     // Current line being read

readNotecard (string name) {
    ncName = name;
    ncLine = 0;
    ncQueryID = llGetNotecardLine(ncName, ncLine++);  // request first line
}

addtoNotecard (string data) {
    datasorceData += data+"\n";
    ncQueryID = llGetNotecardLine(ncName, ncLine++);  // Request next line
}

///////////////////
// Http stuff
///////////////////

key httpQueryId;

sendHTTPRequest (string url) {
    httpQueryId = llHTTPRequest(url,
        [ HTTP_METHOD,  "GET", HTTP_MIMETYPE,"text/plain;charset=utf-8" ], "");
}

string URI2hostport (string uri) {
    list parse = llParseString2List (uri, [":"], []);
    return llList2String (parse, 0)
    +":" + llList2String (parse, 1);
}


///////////////////////////////////////////////////////////////////
// Part 2 : Parsing & accessors
///////////////////////////////////////////////////////////////////

list destinations;      // Strided list for destinations

integer NAME_IDX = 0;   // Index of region name in list
integer COOR_IDX = 1;   // Index of grid coordinates in list
integer HURL_IDX = 2;   // Index of hypergrid url in list
integer HGOK_IDX = 3;   // Index of validity flag in list
integer LAND_IDX = 4;   // Index of landing point in list
integer N_FIELDS = 5;   // Total number of fields

parseFile (string data) {
    list lines = llParseString2List (data,["\n"],[]);
    integer nl = llGetListLength (lines);
    integer i; for (i=0;i<nl;i++)
        parseLine (llList2String(lines,i));
}

parseLine (string line) {
    if (line == "") return; // Ignore empty lines

    if (llGetSubString (line,0,1) == "//") {  // Is this a comment?
        llOwnerSay ("(Comment) "+line);
        return;
    }

    list parse  = llParseStringKeepNulls (line, ["|"],[]);
    string grid = llList2String (parse, 0); // Grid name
    string name = llList2String (parse, 1); // Region name
    string gloc = llList2String (parse, 2); // Coordinates
    string hurl = llList2String (parse, 3); // HG url
    string coor = llList2String (parse, 4); // Landing

    // Parse and check grid location
// *** CHANGED by Aine Caoimhe: removed distance check because 0.8.0 and later no longer have distance limit
//    parse = llParseString2List (gloc, [","],[]);
//    integer xloc = llList2Integer (parse, 0);  // X grid location
//    integer yloc = llList2Integer (parse, 1);  // Y grid location

//    vector hisLoc = <xloc, yloc, 0>;
//    vector ourLoc = llGetRegionCorner()/256;
//    integer ok =( llAbs(llFloor(hisLoc.x - ourLoc.x)) < 4096 )
//            &&  ( llAbs(llFloor(hisLoc.y - ourLoc.y)) < 4096 )
//            &&  ( hisLoc != ourLoc);
    integer ok=TRUE;
// *** END CHANGE

    // Parse and check landing point

    parse = llParseString2List (coor, [","],[]);
    integer xland = llList2Integer (parse, 0);  // X landing point
    integer yland = llList2Integer (parse, 1);  // Y landing point
    integer zland = llList2Integer (parse, 2);  // Z landing point

    vector land = <xland, yland, zland>;
    if (land == ZERO_VECTOR) land = <128,128,20>;

    // Note: grid and region names merged into one field
    destinations += [grid+" "+name, gloc, hurl, ok, land];
}

///////////////////
// List accessors
///////////////////

string dst_name (integer n) {   // Get name for destination n
    return llList2String (destinations, N_FIELDS*n +NAME_IDX);
}

string dst_coord (integer n) {  // Get coords for destination n
    return llList2String (destinations, N_FIELDS*n +COOR_IDX);
}

vector dst_landp (integer n) {  // Get landing point for destination n
    return llList2Vector (destinations, N_FIELDS*n +LAND_IDX);
}

string dst_hgurl (integer n) {  // Get hypergrid url for destination n
    return llList2String (destinations, N_FIELDS*n +HURL_IDX);
}

integer dst_valid (integer n) { // Get validity flag for destination n
    return llList2Integer (destinations, N_FIELDS*n +HGOK_IDX);
}


////////////////////////////////////////////////////////////
// Part 3 : Drawing
////////////////////////////////////////////////////////////

integer TEXTURE_SIZE = 512;
integer DISPLAY_SIDE = 4;
integer FONT_SIZE = 10; // Depends on TEXTURE_SIZE
integer COLUMNS = 2;
integer ROWS = 16;

string validCellColor   = "CadetBlue";
// string invalCellColor   = "IndianRed";
string invalCellColor   = "CadetBlue";
string emptyCellColor   = "DarkGray";
string cellBorderColor  = "White";
string backgroundColor  = "Gray";

string drawList;

displayBegin() {
    drawList = "";
}

displayEnd() {
    osSetDynamicTextureData    ( "", "vector", drawList,
        "width:"+(string)TEXTURE_SIZE+",height:"+(string)TEXTURE_SIZE, 0);
}

drawCell (integer x, integer y) {
    integer CELL_HEIGHT = TEXTURE_SIZE / ROWS;
    integer CELL_WIDHT  = TEXTURE_SIZE / COLUMNS;
    integer xTopLeft    = x*CELL_WIDHT;
    integer yTopLeft    = y*CELL_HEIGHT;

    // Draw grid

    drawList = osSetPenColor   (drawList, cellBorderColor);
    drawList = osMovePen       (drawList, xTopLeft, yTopLeft);
    drawList = osDrawRectangle (drawList, CELL_WIDHT, CELL_HEIGHT);

    integer index = (y+x*ROWS);
    string  cellName  = dst_name(index);
    integer cellValid = dst_valid(index);

    string cellBbackground;
    if (cellName == "") cellBbackground = emptyCellColor;   else
    if (cellValid)      cellBbackground = validCellColor;   else
                        cellBbackground = invalCellColor;

    // Fill background

    drawList = osSetPenColor         (drawList, cellBbackground);
    drawList = osMovePen             (drawList, xTopLeft+2, yTopLeft+2);
    drawList = osDrawFilledRectangle (drawList, CELL_WIDHT-3, CELL_HEIGHT-3);

    xTopLeft += 2;  // Center text in cell
    yTopLeft += 6;  // Center text in cell
    drawList = osSetPenColor (drawList, "Black");
    drawList = osMovePen     (drawList, xTopLeft, yTopLeft);
    drawList = osDrawText    (drawList, cellName);
}

drawTable() {
    displayBegin();

    drawList = osSetPenSize  (drawList, 1);
    drawList = osSetFontSize (drawList, FONT_SIZE);

    drawList = osMovePen     (drawList, 0, 0);
    drawList = osSetPenColor (drawList, backgroundColor);
    drawList = osDrawFilledRectangle (drawList, TEXTURE_SIZE, TEXTURE_SIZE);

    integer x; integer y;
    for (x=0; x<COLUMNS; x++)
        for (y=0; y<ROWS; y++)
            drawCell (x, y);

    displayEnd();
}

integer getCellClicked(vector point) {
    integer y = (ROWS-1) - llFloor(point.y*ROWS); // Top to bottom
    integer x = llFloor(point.x*COLUMNS);         // Left to right
    integer index = (y+x*ROWS);
    return index;
}


///////////////////////////////////////////////////////////////////
// Part 4 : Action routnes: when clicked, when http test succeed
///////////////////////////////////////////////////////////////////

string CLICK_SOUND = "clickSound";      // Sound to play when board clicked
string TELPT_SOUND = "teleportSound";   // Sound to play when teleported
integer JUMP_DELAY = 2;                 // Time to wait before teleport

string hippo_url;   // URL for http check
string telep_url;   // For osTeleportAgent
key    telep_key;   // For osTeleportAgent
vector telep_land;  // For osTeleportAgent


integer action (integer index, key who) {
    string name = dst_name  (index);
    string gloc = dst_coord (index);
    vector land = dst_landp (index);
    string hurl = dst_hgurl (index);
    integer ok  = dst_valid (index);

    if (name == "") return FALSE; // Empty cell
//    if (!ok) llWhisper (0, "This region is too far ("+gloc+")");
//    if (!ok) return FALSE; // Incompatible region

    llWhisper (0, "You have selected "+name+", location "+gloc);

    // Préparer les globales avant de sauter

    telep_key  = who;   // Pass to postaction
    telep_url  = hurl;  // Pass to postaction
    telep_land = land;  // Pass to postaction

    hippo_url = "http://"+URI2hostport(hurl);   // Pass to http check

    DEBUG ("Region name:   " +name +" "+gloc+" (Check="+(string)ok+")");
    DEBUG ("Landing point: " +(string)land);
    DEBUG ("Hypergrid Url: " +hurl);
    DEBUG ("Hippochek url: " +hippo_url);

    llTriggerSound (CLICK_SOUND, 1.0);
    return TRUE;
}

postaction (integer success) {
    if (success) {
        llWhisper (0, "Fasten your seat belt, we move!!!");
        llPlaySound (TELPT_SOUND, 1.0); llSleep (JUMP_DELAY);
        // CHANGED by Aine Caoimhe: if local grid, strip that from the telep_url before sending
        if (llSubStringIndex(telep_url,localGrid)==0)
        {
            telep_url=llGetSubString(telep_url,llStringLength(localGrid)+1,-1);
            DEBUG ("This is a local TP so stripped grid portion of URL. New telep_url is: "+telep_url);
        }
        osTeleportAgent(telep_key, telep_url, telep_land, ZERO_VECTOR);
    } else {
        llWhisper (0, "Sorry, host is not available");
    }
}


///////////////////////////////////////////////////////////////////
// State 1 : read the data and draw the board
///////////////////////////////////////////////////////////////////

default {

    state_entry() {
        llOwnerSay ("Reading data from "+datasource);
        readFile (datasource);
    }

    // Handler for card:// datasource
    dataserver(key id, string data) {
        // Internal card reader
        if (id == ncQueryID) {
            if (data != EOF) addtoNotecard (data);
            else state ready; // File in datasorceData
        // External card server
        } else {
            datasorceData = data;
            state ready; // File in datasorceData
        }
    }

    // Handler fot http:// datasource
    http_response(key id,integer status, list meta, string body) {
        if (id != httpQueryId) return;
        datasorceData = body;
        state ready; // File in datasorceData
    }

    state_exit() {
        llOwnerSay ("Done. Initializing board");
        parseFile(datasorceData);
        drawTable();
    }

}

///////////////////////////////////////////////////////////////////
// State 2 : running, we pass most of our time here
///////////////////////////////////////////////////////////////////

state ready {

    state_entry() {
        llWhisper (0, "Ready");
    }

    touch_start (integer n) {
        key whoClick = llDetectedKey(0);
        vector point = llDetectedTouchST(0);
        integer face = llDetectedTouchFace(0);
        integer link = llDetectedLinkNumber(0);

        if (link != LINK_ROOT)
            if (whoClick == llGetOwner()) llResetScript();
            else return;

        if (point == TOUCH_INVALID_TEXCOORD) return;
        if (face != DISPLAY_SIDE) return;

        integer ok = action (getCellClicked(point), whoClick);
        if (!ok) return; // Incompatible grid coordinates

        integer USE_MAP = (llGetObjectDesc() == "usemap");

        // llMapDestination works only in touch events
        // We must invoke it here, bypassing http check
        // Return so osTeleportAgent will not be called

        if (USE_MAP) {
            llMapDestination (telep_url, telep_land, ZERO_VECTOR);
            return;
        }

        // Proceed to http check which
        // will chain to osTeleportAgent

        llWhisper (0, "Checking host. This may take up to 30s, please wait...");
        state hippos; // Perform HTTP check
    }

    changed(integer what) {
        if (what & CHANGED_REGION) llResetScript();
        if (what & CHANGED_INVENTORY) llResetScript();
        if (what & CHANGED_REGION_START) llResetScript();
    }

}

///////////////////////////////////////////////////////////////////
// State 3 : HTTP host check
///////////////////////////////////////////////////////////////////
   
state hippos {
        
    state_entry() {
        sendHTTPRequest (hippo_url);
        llSetTimerEvent (60);
    }

    http_response(key id,integer status, list meta, string body) {
        if (id == httpQueryId)
        postaction (status == 200);
        state ready;
    }

    timer() {
        llSetTimerEvent (0);
        postaction (FALSE);
        state ready;
    }

}
