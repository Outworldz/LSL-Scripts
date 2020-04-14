// :SHOW:1
// :CATEGORY:Dreamgrid
// :NAME:Opensim Partners
// :AUTHOR:Digiworldz.com
// :KEYWORDS:
// :CREATED:2019-04-04 20:49:47
// :EDITED:2020-04-10  08:29:33
// :ID:1123
// :NUM:1973
// :REV:1
// :WORLD:OpenSim
// :DESCRIPTION:
Opensim Partnership program// :REVISION: 2
// :CODE:
// Put this in a box. When two people touch it, they can make a partership.
// Mods by Fred Beckhusen (Ferd Frederix) for Dreamgrid

// A SETTING YOU HAVE TO SET FOR SECURITY
// It works when blank, but it is possible for someone with this script to make or drop partners!

// Set this to your Unique grid identifier from the Settings panel.
string PW = "";

// CODE follows, the rest of this should probably not be modified.
// If you want to  see a lot of messages, set this to TRUE
integer debug = FALSE;

// variables
string URL = "";
// Default = 8001 for Dreamgrid. :80 or blank for other grids
string PORT = ":8001";
// How long you have to convince him/her  to click the box
float TIMEOUT = 20.0; // seconds


list PAR = [];
key id1; // 1st user
string name1; // 1st user
key id2; // 2nd user
string name2; // 2nd user
key id3; // partner of 2nd user
string name3; // partner of 2nd user

key http_request_id1; // get_partner; 1st user
key http_request_id2; // begin: get_partner; 2nd user
key http_request_id3; // begin: set_partner; 1st user
key http_request_id4; // begin: set_partner; 2nd user
key http_request_id5; // dissolve: set_partner; 1st user
key http_request_id6; // dissolve: set_partner; 2nd user


DEBUG(string msg) {
    if (debug) {
        llSay(0,msg);
    };
}

string left(string src, string divider) {
    integer index = llSubStringIndex( src, divider );
    if(~index)
        return llDeleteSubString( src, index, -1);
    return src;
}
string right(string src, string divider) {
    integer index = llSubStringIndex( src, divider );
    if(~index)
        return llDeleteSubString( src, 0, index + llStringLength(divider) - 1);
    return src;
}
// default state
default {
    state_entry()    {
        //Grid Gatekeeper Uri
        URL = "http:" + left(right(osGetGridGatekeeperURI(),":"),":");
        DEBUG(URL);

        llSetText("Click here to begin or\ndissolve partnership", <1,1,1>, 1);
    }
    touch_start(integer num_detected)     {
        id1 = llDetectedKey(0);
        name1 = llDetectedName(0);
        string req = URL + PORT + "/get_partner?PW=" + PW + "&User=" + (string)id1;
        DEBUG(req);
        http_request_id1 = llHTTPRequest(req, PAR, "");
    }

    // called for all HTTP responses of all states
    http_response(key request_id, integer status, list metadata, string body)    {

        if (request_id == http_request_id1) {
            // get_partner; 1st user
            DEBUG("Partner = " + body);
            id2 = (key)body;
            name2 = llGetDisplayName(id2);
            if (!name2) name2 = (string)id2;

            if (id2 == NULL_KEY)
            {
                llSay(0, name1 + ", you have no partnership at the moment");
                state begin_partnership;
            } else {
                    llSay(0, name1 + ", your partner is " + name2);
                state dissolve_partnership;
            }
        } else if (request_id == http_request_id2) {
                // begin: get_partner; 2nd user
                id3 = (key)body;
            DEBUG("Partner = " + body);

            name3 = llGetDisplayName(id3);
            if (!name3) name3 = (string)id3;

            if (id3 == NULL_KEY)
            {
                string req = URL + PORT  + "/set_partner?PW=" + PW + "&User=" + (string)id1 + "&Partner=" + (string)id2;
                DEBUG(req);
                http_request_id3 = llHTTPRequest(req, PAR, "");
            } else {
                    llSay(0, name2 + ", you have " + name3 + " as partner already");
                state default;
            }
        } else if (request_id == http_request_id3) {
                // begin: set_partner; 1st user
                string req = URL +PORT + "/set_partner?PW=" + PW + "&User=" + (string)id2 + "&Partner=" + (string)id1;
            DEBUG(req);
            http_request_id4 = llHTTPRequest(req, PAR, "");
        } else if (request_id == http_request_id4) {
                // begin: set_partner; 2nd user
                llSay(0, name1 + " and " + name2 + " are now partners. Relog to see your new relationship status in your profiles.");
            state default;
        } else if (request_id == http_request_id5) {
                // dissolve: set_partner; 2nd user
                id2 = (key)body;
            string req = URL+PORT  + "/set_partner?PW=" + PW + "&User=" + (string)id2 + "&Partner=" + (string)NULL_KEY;
            DEBUG(req);
            http_request_id6 = llHTTPRequest(req, PAR, "");
        } else if (request_id == http_request_id6) {
                // dissolve: set_partner; 2nd user
                llSay(0, name1 + " and " + name2 + " are not partners anymore");
            state default;
        } else {
                // unknown response
                llOwnerSay("Error: unknown response");
        }
    }
}

state begin_partnership{
    state_entry()    {
        llSetText("Future partner of\n" + name1 + "\nplease click here", <1,1,1>, 1.0);
        llSay(0,"Future partner of " + name1 + ", please click the box");
        llSetTimerEvent(TIMEOUT);
    }

    timer()    {
        llSay(0, "Timeout, please try again");
        llSetTimerEvent(0.0);
        state default;
    }

    touch_start(integer num_detected)    {
        llSetTimerEvent(0.0);
        id2 = llDetectedKey(0);
        name2 = llDetectedName(0);

        if ((string)id1 == (string)id2)
        {
            llSay(0, "canceled");
            state default;
        }

        // check if new partner has no partnership
        string req = URL +PORT + "/get_partner?PW=" + PW + "&User=" + (string)id2;
        DEBUG(req);
        http_request_id2 = llHTTPRequest(req, PAR, "");
        state default;
    }
}

// dissolve partnership

state dissolve_partnership{
    state_entry()    {
        llSetText(name1 + ", click \nif you want to dissolve\nyour current partnership", <1,1,1>, 1.0);
        llSay(0,name1 + ", click if you want to dissolve your current partnership");
        llSetTimerEvent(TIMEOUT);
    }

    timer()    {
        llSay(0, "Timeout, please try again");
        llSetTimerEvent(0.0);
        state default;
    }

    touch_start(integer num_detected)    {
        llSetTimerEvent(0.0);
        id2 = llDetectedKey(0);
        name2 = llDetectedName(0);

        if ((string)id1 != (string)id2)
        {
            llSay(0, "canceled");
            state default;
        }

        string req = URL +PORT + "/set_partner?PW=" + PW + "&User=" + (string)id1 + "&Partner=" + (string)NULL_KEY;
        DEBUG(req);
        http_request_id5 = llHTTPRequest(req, PAR, "");
        state default;
    }
}
