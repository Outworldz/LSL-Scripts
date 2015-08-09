// :CATEGORY:Viewer 2
// :NAME:Form_handling_in_viewer_2
// :AUTHOR:Kelly Linden
// :CREATED:2010-09-02 11:00:29.677
// :EDITED:2013-09-18 15:38:53
// :ID:334
// :NUM:447
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
//   The Limits// //     * 1024 bytes per url//     * llEscapeURLs means non-alphanumeric characters are 3 bytes (ouch)//           o I'm actually not clear on if this is really needed. I seem to sometimes get blank pages if I don't but some pages render fine with out it. Maybe there is a subset of symbols that must be escaped and escaping only those would ease some of the space constraints? //     * Must force another page view after form submission since HTTP-In can't generate HTML
//     * No real way of knowing which avatar is interacting with the HTML 
// 
// The Tricks
// 
//     * <base href="<http-in-url>/">
//           o HTTP-In urls are long, especially if escaped. In a page that includes more than a single link back to the script, or more than a single form, this can save a lot of space. 
//     * Tiny urls
//           o You can use url shortening services to create short links to long data urls. In theory this should let you get past the 1k limit quite nicely, however there is overhead in setting up the tiny url. 
// :CODE:
string html_base = 
"<h1><form action='%url%' method='GET'>
Floating Text:<input type='text' name='text'><br>
<input type='submit' value='Set'>
</form></h1>";
 
string url;
 
integer r;
show(string html)
{
    html = "data:text/html," + llEscapeURL(html) + "<span " + (string)((++r) % 10) + "/>";
 
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
        llRequestURL();
    }
 
    http_request(key id, string method, string body)
    {
        if (method == URL_REQUEST_GRANTED)
        {
            url = body + "/";
 
            show(replace_all(html_base,"%url%",url));
        }
        else if (method == "GET")
        {
            llSetText(get_query(id,"text"),<1,1,0>,1);
            show(replace_all(html_base,"%url%",url));
            llHTTPResponse(id,200,"Loading....");
        }
    }
}
 
