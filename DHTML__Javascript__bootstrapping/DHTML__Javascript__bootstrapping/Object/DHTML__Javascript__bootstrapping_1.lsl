// :CATEGORY:Viewer 2
// :NAME:DHTML__Javascript__bootstrapping
// :AUTHOR:Tali Rosca
// :CREATED:2010-09-02 11:02:40.067
// :EDITED:2013-09-18 15:38:51
// :ID:230
// :NUM:316
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Tali Rosca made this code to render the output of HTTP-In directly. Kelly Linden wrapped her magic into the build_url and build_response functions in the example below. This example renders a page that is around 3.5k bytes - well past the 1k limit of urls.// Pros:// //     * Navigation is much smoother and feels more natural//     * Only limited by script memory // 
// Cons:
// 
//     * Links are extremely large: 296 bytes for a link to just the base http-in url. 
// :CODE:
string url; // Our base http-in url
integer r;  // Used for uniqueness in PrimMedia urls
integer page;  // The page number.
 
show(string html)
{
    html += "<span " + (string)((++r) % 10) + "/>";
 
    llSetPrimMediaParams(0,                  // Side to display the media on.
            [PRIM_MEDIA_AUTO_PLAY,TRUE,      // Show this page immediately
             PRIM_MEDIA_CURRENT_URL,html,    // The url if they hit 'home'
             PRIM_MEDIA_HOME_URL,html,       // The url currently showing
             PRIM_MEDIA_HEIGHT_PIXELS,512,   // Height/width of media texture will be
             PRIM_MEDIA_WIDTH_PIXELS,512]);  //   rounded up to nearest power of 2.
}
 
// This creates a data: url that will render the output of the http-in url 
// given.
string build_url(string url)
{
    return "data:text/html," 
        + llEscapeURL("<html><head><script src='" + url 
        + "' type='text/javascript'></script></head><body onload='init()'></body></html>");
}
 
// This wraps the html you want to display so that it will be shown from links 
// made with build_url
string build_response(string body)
{
    return "function init() {document.getElementsByTagName('body')[0].innerHTML='" + body + "';}";
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
 
            show(build_url(url + "page" + (string)(page)));
        }
        else if (method == "GET")
        {
            string path = llGetHTTPHeader(id,"x-path-info");
            string content = "<h1>path: " + path + "</h1>";
            page = (integer)llGetSubString(path,5,5);
            if (page > 0) content += "<a href=\"" + build_url(url + "page" + (string)(page - 1)) + "\">Previous</a> ";
            if (page < 9) content += "<a href=\"" + build_url(url + "page" + (string)(page + 1)) + "\">Next</a><br>";
            integer k;
            for(;k<10;++k)
            {
                if (k == page)
                    content += "<br>Page " + (string)k;
                else
                    content += "<br><a href=\"" + build_url(url + "page" + (string)(k)) + "\">Page " + (string)k + "</a>";
            }
            content += "<br><br>This page is " + (string)(llStringLength(build_response(content)) + 37) + " bytes long.";
            llHTTPResponse(id,200,build_response(content));
        }
    }
}
 
