// :CATEGORY:Viewer 2
// :NAME:Force_a_page_reload
// :AUTHOR:Becky Pippen
// :CREATED:2010-09-02 11:06:58.287
// :EDITED:2013-09-18 15:38:53
// :ID:333
// :NUM:446
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Force_a_page_reload
// :CODE:
integer face = 4;
string myURL;
integer seq = 0; // sequence number for unique URLs

default
{
    state_entry()
    {
        llRequestURL();
    }

    http_request(key id, string method, string body)
    {
        if (method == URL_REQUEST_GRANTED) {
            myURL = body;
            llSetPrimMediaParams(face,
                [PRIM_MEDIA_AUTO_PLAY, TRUE,
                 PRIM_MEDIA_CURRENT_URL, myURL]);
            llSetTimerEvent(5.0);
        } else if (method == "GET") {
            llHTTPResponse(id, 200, "Sim FPS: " + (string)llGetRegionFPS());
        }
    }

    timer()
    {
        llSetPrimMediaParams(face,
            [PRIM_MEDIA_CURRENT_URL, myURL + "/?r=" + (string)(++seq)]);
    }
} 
