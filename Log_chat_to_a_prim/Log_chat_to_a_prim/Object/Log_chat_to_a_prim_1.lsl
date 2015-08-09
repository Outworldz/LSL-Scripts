// :CATEGORY:Viewer 2
// :NAME:Log_chat_to_a_prim
// :AUTHOR:Qie Niangao
// :CREATED:2010-09-02 11:37:02.380
// :EDITED:2013-09-18 15:38:56
// :ID:490
// :NUM:657
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Log_chat_to_a_prim
// :CODE:
integer SHOW_FACE = 4;
list log;
integer logCount;
integer logSlot;
integer LOG_LENGTH = 10;
key urlRequestID;
string myURL;
integer flipper;
saveLog(string logText)
{
    if (logSlot == logCount)
        log += logText;
    else
        log = llListReplaceList(log, [logText], logSlot, logSlot);
    logCount++;
    logSlot = logCount % LOG_LENGTH;
}
default
{
    state_entry()
    {
        llListen(0, "", "", "");
        urlRequestID = llRequestURL();
        llClearPrimMedia(SHOW_FACE);
    }
    on_rez(integer num)
    {
        llResetScript();
    }
    changed(integer change)
    {
        if ((CHANGED_REGION_START | CHANGED_REGION) & change)
            urlRequestID = llRequestURL();
    }
    http_request(key id, string method, string body)
    {
        if (method == URL_REQUEST_GRANTED)
        {
            if (myURL != "")
                llReleaseURL(myURL);
            myURL = body;
            llSetPrimMediaParams
                ( SHOW_FACE
                ,   [ PRIM_MEDIA_CONTROLS, PRIM_MEDIA_CONTROLS_MINI
                    , PRIM_MEDIA_HOME_URL, myURL
                    , PRIM_MEDIA_AUTO_PLAY, TRUE
                    , PRIM_MEDIA_WIDTH_PIXELS, 500
                    , PRIM_MEDIA_HEIGHT_PIXELS, 500
                    , PRIM_MEDIA_AUTO_SCALE, TRUE
                    , PRIM_MEDIA_PERMS_CONTROL, PRIM_MEDIA_PERM_NONE
                    ]
                );
        }
        else
        if ((method == URL_REQUEST_DENIED) && (urlRequestID == id))
            llSay(DEBUG_CHANNEL, "Report URL denied. (This shouldn't happen.) "+body);
        else
        if (method == "GET")
        {
            if (logSlot == 0)
                llHTTPResponse(id, 200, llDumpList2String(log, "\n"));
            else
                llHTTPResponse(id, 200, 
                    llDumpList2String(llList2List(log, logSlot, LOG_LENGTH-1), "\n")
                    + "\n" +
                    llDumpList2String(llList2List(log, 0, logSlot-1), "\n")
                    );
        }
        else
            llHTTPResponse(id, 405, "Unsupported method: "+method);
    } 
    listen(integer channel, string name, key id, string message)
    {
        string timeStamp=llGetTimestamp(); 
        string blankIfEmote=":";
        if ("/me " == llToLower(llGetSubString(message, 0, 3)))
        {
            blankIfEmote="";
            message = llGetSubString(message, 4, -1);
        }
        string thisRecord
            = "["
            + llGetSubString(timeStamp, 5, 9)   // MM-DD
            + " "
            + (string)((integer)llGetWallclock() / 3600)    // Pacific timezone hour
            + llGetSubString(timeStamp, 13, 15) // :mm
            + "] "
            + name
            + blankIfEmote
            + " "
            + message
            ;
        saveLog(thisRecord);
        llSetPrimMediaParams
            ( SHOW_FACE
            ,   [ PRIM_MEDIA_CURRENT_URL, myURL+"/?rand="+(string)(flipper = !flipper)
                ]
            );
    }
}
