// :CATEGORY:Viewer 2
// :NAME:Bootstrapping_HTML_on_a_prim
// :AUTHOR:Tali Rosca
// :CREATED:2010-09-02 11:30:17.583
// :EDITED:2013-09-18 15:38:49
// :ID:112
// :NUM:153
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// DESCRIPTION: []::Bootstrapping_HTML_on_a_prim
// :CODE:
key url_request;

default
{
    state_entry()
    {
        url_request = llRequestURL();
    }

    http_request(key id, string method, string body)
    {
        if (url_request == id)
        {
            url_request = "";
            if (method == URL_REQUEST_GRANTED)
            {
                llSetPrimMediaParams(0, [
                PRIM_MEDIA_CONTROLS, PRIM_MEDIA_CONTROLS_MINI,
                PRIM_MEDIA_PERMS_CONTROL, 0,
                PRIM_MEDIA_PERMS_INTERACT, PRIM_MEDIA_PERM_ANYONE,
                PRIM_MEDIA_AUTO_SCALE, TRUE,
                PRIM_MEDIA_AUTO_PLAY, TRUE,
                PRIM_MEDIA_AUTO_ZOOM, FALSE,
                PRIM_MEDIA_FIRST_CLICK_INTERACT, TRUE,
                // If your HTML page is shorter than 1k total, you can build it completely here.
                // This, however, contacts the prim through HTTP-in to get more data later.
                PRIM_MEDIA_CURRENT_URL, "data:text/html," + llEscapeURL("<html><head><script src='" + body + "' type='text/javascript'></script></head><body onload='init()'></body></html>")]);
            }
            else if (method == URL_REQUEST_DENIED)
            {
                llOwnerSay("Could not get URL: " + body);
            }
        }
        else
        {
            // This is where the full body HTML goes:
            string content = "<div>Testing</div>";

            string htmlString = "function init() {document.getElementsByTagName('body')[0].innerHTML='" + content + "';}";
            llOwnerSay(htmlString);

            llHTTPResponse(id, 200, htmlString);
        }
    }
}
