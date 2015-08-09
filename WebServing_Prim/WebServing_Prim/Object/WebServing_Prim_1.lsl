// :CATEGORY:Viewer 2
// :NAME:WebServing_Prim
// :AUTHOR:Tali Rosca
// :CREATED:2010-09-02 11:41:02.473
// :EDITED:2013-09-18 15:39:09
// :ID:970
// :NUM:1392
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// This is an extention of the Bootstrapping HTML on a prim idea.
// :CODE:
list pages;
list content;
integer indexPage = 0;

key url_request;
string baseUrl;

loadPages()
{
    // Could be loaded from notecard, and/or possibly fetched from storage prims through link messages:
    // For now, the links are a little cumbersome to write, requiring the full javascript: notation.
    // (Remember to escape the single-quotes since the pages will be merged into a JavaScript string.)
    // This could obviously be made prettier with some string pre-processing, and likewise, a system for
    // variable includes, <% %>-style, could be programmed. For now, though, just serve HTML pages.
    pages = [];
    content = [];

    pages += "index";
    content += "<ul><li><a href=\"javascript:l(\\'page1\\')\">Page 1</a></li><li><a href=\"javascript:l(\\'page2\\')\">Page 2</a></li></ul>";

    pages += "page1";
    content += "<h1>Page 1</h1><p>This is page 1.<br/><a href=\"javascript:l(\\'\\')\">Return to the index</a></p>";

    pages += "page2";
    content += "<h1>Page 2</h1><p>And this is page 2.<br/><a href=\"javascript:l(\\'\\')\">Return to the index</a></p>";

    pages += "css";
    content += "body {font-family:Verdana,Arial;font-size:12px;margin:8px;padding:0px;color: #000000;}a {font-weight: bold;text-decoration: none;color: #880000;}a:hover {color: #ee5555;}h1 {float: left;padding-right: 50px;margin-top: 0px;margin-bottom: 10px;font-size: 20px;border-bottom: 1px solid;}p {clear:both}";
}

// Default state is responsible for getting the URL, running a timer until it manages to get one.
default
{
    state_entry()
    {
        loadPages();

        if (llGetFreeURLs()<1)
            llOwnerSay("No URLs available. Something else is using a lot of URLs.");
        else
        {
            // Defensively releasing. Should be a no-op, but prevents a leak if we somehow get here while the server doesn't think it has released.
            llReleaseURL(baseUrl);
            url_request = llRequestURL();
        }
        llSetTimerEvent(60);
    }

    http_request(key id, string method, string body)
    {
        // We need the URL, so only register success, and let the timer retry otherwise:
        if (url_request == id && method == URL_REQUEST_GRANTED)
        {
            url_request = "";

            baseUrl = body;
            state running;
        }
    }

    timer()
    {
        llReleaseURL(baseUrl);
        url_request = llRequestURL();
    }

    state_exit()
    {
        llSetTimerEvent(0);
    }
}

// The main state, handling the HTTP requests.
state running
{
    on_rez(integer i)
    {
        // Re-acquire URL:
        state default;
    }

    changed(integer change)
    {
        if (change & (CHANGED_REGION | CHANGED_REGION_START | CHANGED_TELEPORT))
        {
            state default;
        }
    }

    state_entry()
    {
        // Set up the base HTML page:

        string cssString = "";
        if (llListFindList(pages, ["css"]) > -1) cssString = "<link rel=\"stylesheet\" href=\""+baseUrl+"/css\"/>";

        // This "seeds" the page with a JSON/P-based JavaScript to merge in loaded pages in the body tag.
        string dataUrl = "data:text/html," + llEscapeURL("<html><head>"+cssString+"<script>var s;function w(h){body.innerHTML=h;if(s)head.removeChild(s);s=null}function l(a){if(s)head.removeChild(s);s=document.createElement('script');s.src='"+baseUrl+"/'+a+'?callback=w';head.appendChild(s);}</script></head><body onload=\"head=document.getElementsByTagName('head')[0];body=document.getElementsByTagName('body')[0];l('')\"></body></html>");

        //llOwnerSay(dataUrl);
        //llOwnerSay("Length: "+ (string)llStringLength(dataUrl));

        llSetPrimMediaParams(0, [
        PRIM_MEDIA_CONTROLS, PRIM_MEDIA_CONTROLS_MINI,
        PRIM_MEDIA_PERMS_CONTROL, 0,
        PRIM_MEDIA_PERMS_INTERACT, PRIM_MEDIA_PERM_ANYONE,
        PRIM_MEDIA_AUTO_SCALE, TRUE,
        PRIM_MEDIA_AUTO_PLAY, TRUE,
        PRIM_MEDIA_AUTO_ZOOM, FALSE,
        PRIM_MEDIA_FIRST_CLICK_INTERACT, TRUE,
        PRIM_MEDIA_CURRENT_URL, dataUrl]);
    }

    http_request(key id, string method, string body)
    {
        string page = llGetSubString(llGetHTTPHeader(id, "x-path-info"), 1, -1);
        string query = "&"+llGetHTTPHeader(id, "x-query-string")+"&";
        integer pos = llSubStringIndex(query, "&callback=");
        string callback = "";
        if (pos >-1)
        {
            callback = llGetSubString(query, pos + 10, - 1);
            callback = llGetSubString(callback, 0, llSubStringIndex(callback, "&") - 1);
        }

        //llOwnerSay("Page hit: "+page+ ", callback: " + callback);

        integer p = llListFindList(pages, [page]);
        if (p == -1) p = indexPage;

        string c = llList2String(content, p);

        if (callback != "")
            llHTTPResponse(id, 200, callback+"('"+c+"');");
        else        
            llHTTPResponse(id, 200, c);
    }
}
