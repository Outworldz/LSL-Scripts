// :CATEGORY:Viewer 2
// :NAME:llSetPrimMediaParams_using_HTTPIn
// :AUTHOR:Kelly Linden
// :CREATED:2010-09-02 10:58:09.613
// :EDITED:2013-09-18 15:38:56
// :ID:488
// :NUM:655
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// llSetPrimMediaParams_using_HTTPIn
// :CODE:
show(string html)
{
    html = "data:text/html," + llEscapeURL(html);
    llSetPrimMediaParams(0,                  // Side to display the media on.
            [PRIM_MEDIA_AUTO_PLAY,TRUE,      // Show this page immediately
             PRIM_MEDIA_CURRENT_URL,html,    // The url currently showing
             PRIM_MEDIA_HOME_URL,html,       // The url if they hit 'home'
             PRIM_MEDIA_HEIGHT_PIXELS,512,   // Height/width of media texture will be
             PRIM_MEDIA_WIDTH_PIXELS,512]);  //   rounded up to nearest power of 2.
}
 
string replace_all(string src, string target, string replace)
{
    return llDumpList2String(llParseString2List(src,[target],[]),replace);
}
 
string get_query(key id, string name)
{
    string query = llGetHTTPHeader(id,"x-query-string");
    query = replace_all(query,"+"," ");
    query = llUnescapeURL(query);
    list q = llParseString2List(query,["=","&",";"],[]);
    integer i = llListFindList(q,[name]);
    if (i != -1)
    {
        return llList2String(q,i+1);
    }
 
    return "";
}
 
default
{
    state_entry()
    {
        show("<h1>This is a test</h1><h2>This is a test</h2><h3>This is a test</h3>");
        llRequestURL();
    }
 
    http_request(key id, string method, string body)
    {
        if (method == URL_REQUEST_GRANTED)
        {
            show("<h1><a href='" + body + "/?get=owner'>Owner ID</a><br><br><a href='" + body + "/?get=object'>Object ID</a></h1>");
        }
        else if (method == "GET")
        {
            string get = get_query(id,"get");
            if (get == "owner")
            {
                llHTTPResponse(id,200,"Owner is: " + (string)llGetOwner());
            }
            else if (get == "object")
            {
                llHTTPResponse(id,200,"Object is: " + (string)llGetKey());
            }
            else
            {            
                llHTTPResponse(id,400,"huh?");
            }
        }
    }
}
 
