// :SHOW:
// :CATEGORY:Fire
// :NAME:MOAP Top 2000 Radio Stations Player
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2015-06-11 14:36:40
// :EDITED:2015-06-11  13:36:40
// :ID:902
// :NUM:1753
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Media-On-A-Prim Radio station with several thousand stations.
// You must deed this to a group if you are on group-owned Land.
// :CODE:
// :License: CC-BY-NC-SA - Not to be sold in any form, Copyright 2015 Fred Beckhusen (Ferd Frederix)
// :Worlds: Opensim, Second Life

// Please do not change the timeouts or URLS - this script is server dependent. 

integer debug = TRUE;
float version = 1.1;


string requestURL;         // HTTP-IN URL
key  http_request_id; // the key we search for
key selfCheckRequestId;// the key we search for

string mediaURI ;        // saved URI for radio
string Description ;     // saved URI for radio


float newTimer = 0;      // how long to play a piece of music

string url = "http://www.outworldz.com";
string HTTPIN;


DEBUG(string str)
{
    if (debug) llSay(0,str);
}

// ###############################################
// Routine to parse a string sent through the 
// http server via post.
//       parsePostData(theMessage)
// Returns a strided list with stride length 2.
// Each set has the key and then its value.
list parsePostData(string message) {
    list postData = [];         // The list with the data that was passed in.
    list parsedMessage = llParseString2List(message,["&"],[]);    // The key/value pairs parsed into one list.
    integer len = ~llGetListLength(parsedMessage);
 
    while(++len) {          
        string currentField = llList2String(parsedMessage, len); // Current key/value pair as a string.
 
        integer split = llSubStringIndex(currentField,"=");     // Find the "=" sign
        if(split == -1) { // There is only one field in this part of the message.
            postData += [llUnescapeURL(currentField),""];  
        } else {
            postData += [llUnescapeURL(llDeleteSubString(currentField,split,-1)), llUnescapeURL(llDeleteSubString(currentField,0,split))];
        }
    }
    // Return the strided list.
    return postData ;
}

// get from list the value of the name
string Get( string name, list data)
{
    integer index =llListFindList(data,[name]);
    if (index == -1)
        return "Nothing";
    return llList2String(data,index+1);
}

DoWebPage(integer onOff)
{
    if (! onOff)
    {
        llClearPrimMedia(1);
        llOwnerSay("Touch power button to activate");
    }
    else
    {
        string lURL = url + "/radio?URI=" + llEscapeURL(HTTPIN);
        
        DEBUG("lSetting Media URL to : " + lURL);
        llOwnerSay("Touch screen to view. Shared media must be enabled in the Setup Menu (Ctrl-P)");
        llSetPrimMediaParams(1,[PRIM_MEDIA_CONTROLS,PRIM_MEDIA_CONTROLS_STANDARD,
            PRIM_MEDIA_HOME_URL,lURL,
            PRIM_MEDIA_CURRENT_URL ,lURL,
            PRIM_MEDIA_AUTO_PLAY , TRUE,
            PRIM_MEDIA_AUTO_ZOOM, TRUE,
            PRIM_MEDIA_WIDTH_PIXELS, 838,
            PRIM_MEDIA_HEIGHT_PIXELS ,1088
//            PRIM_MEDIA_WHITELIST_ENABLE ,TRUE
//            PRIM_MEDIA_WHITELIST, llEscapeURL(url),
//            PRIM_MEDIA_PERMS_INTERACT ,PRIM_MEDIA_PERM_GROUP
//            PRIM_MEDIA_PERMS_CONTROL ,PRIM_MEDIA_PERM_GROUP
            ]); 
    }
}
            
string strReplace(string str, string search, string replace) {
    return llDumpList2String(llParseStringKeepNulls((str = "") + str, [search], []), replace);
}

request_url()
{
    llReleaseURL(HTTPIN);
    HTTPIN = "";
 
    http_request_id = llRequestURL(); // Request that an URL be assigned to me.
    DEBUG("http_request_id:" + http_request_id);
}


SaveToServer()
{
    string newurl = url + "cgi/shoutcast2.plx?description="
        + llEscapeURL(Description)
        + "&mediaURI=" + llEscapeURL(mediaURI)
        + "&version=" + llEscapeURL((string) version);
    DEBUG("NewURL:" + newurl);
    http_request_id = llHTTPRequest(newurl, [], "");        
}

default {
 
    state_entry() {
        request_url();
        llSetTimerEvent(1);
    }

    timer()
    {
        llSetTimerEvent(3600);    // hourly
        
        if (newTimer)
        {
            DEBUG("Timer set to regular channel");
            llSetParcelMusicURL(mediaURI);
            newTimer = FALSE;
            
            return;
        }
        if (llStringLength(requestURL))
        {
            DEBUG("timer:" + (string) requestURL);
            selfCheckRequestId = llHTTPRequest(requestURL,[],"");
        }
                                     
    }

    touch_start(integer n)
    {
        key id = llDetectedKey(0);
 
        integer sameGroup = llSameGroup(id);
        if (sameGroup) {
            DoWebPage(TRUE);
        }
    }

    http_response(key id, integer status, list metaData, string body)
    {
        DEBUG("ID:" + (string) id);
        DEBUG("selfCheckRequestId:" + (string) selfCheckRequestId);
        
        if (id == selfCheckRequestId)
        {
            // If you're not usually doing this,
            // now is a good time to get used to doing it!
            selfCheckRequestId = NULL_KEY;
 
            if (status != 200)
                request_url();
        }
 
        else if (id == NULL_KEY)
            llOwnerSay("Too many HTTP requests too fast!");
    }
    
    http_request(key id, string method, string body) {
        
        DEBUG("http_request:" + body);
         list incomingMessage;
 
        if ((method == URL_REQUEST_GRANTED) && (id == http_request_id) ){
            // A URL has been assigned to me.
            HTTPIN = body;
            DEBUG("Obtained URL: " + body);
            DoWebPage(TRUE);
        }
        else if ((method == URL_REQUEST_DENIED) && (id == http_request_id)) {
            // I could not obtain a URL
            llOwnerSay("The following error occurred while attempting to get a free URL for this device: " + body);

            llSleep(60);
            llOwnerSay("Retrying in one minute");
            llResetScript();
        } 
        else if (method == "POST") {
            // An incoming message was received.
             DEBUG("Received information from the outside: " + body);
            incomingMessage = parsePostData(body);
            DEBUG(llDumpList2String(incomingMessage,"\n"));

            // see if we forced a switch
            string change = Get("change",incomingMessage);
            string goback = Get("goback",incomingMessage);

            // forced a change in URI with "change"
            if (llStringLength(change)) {
                string newURI = Get("id",incomingMessage);
                float newTimer = (float) Get("timer",incomingMessage);
                llSetParcelMusicURL(newURI);
                llSetTimerEvent(newTimer);
                
                DEBUG("Add " + newURI + " running for " + (string) newTimer + " seconds ");
            }
            else  if (llStringLength(goback)) {
                DEBUG("Commanded to go back");
                llSetParcelMusicURL(mediaURI);
            } else {
                mediaURI = Get("id",incomingMessage);
                Description = Get("name",incomingMessage);
                Description = strReplace(Description,"+"," ");
                llOwnerSay("Station changed to " + Description +"\n" + llUnescapeURL(mediaURI));

                SaveToServer(); 
            }
            
            DEBUG("Set Media URL on land to " + mediaURI);
            llSetParcelMusicURL(mediaURI);
                            
            if (llList2String(incomingMessage,0) == "power")
                DoWebPage(FALSE);

            
            llHTTPResponse(id,200,"OK:" + llDumpList2String(incomingMessage,"\n"));
 
        }
        else {
            // An incoming message has come in using a method that has
            // not been anticipated.
            llHTTPResponse(id,405,"Unsupported Method");
        }
    }

    changed(integer change)
    {
        if (change & CHANGED_REGION_START)
            request_url();
            
    }
}