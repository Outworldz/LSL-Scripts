// :CATEGORY:Viewer 2
// :NAME:Javascript_boot_strapping_method
// :AUTHOR:Vegas Silverweb
// :CREATED:2010-09-02 11:04:06.910
// :EDITED:2013-09-18 15:38:55
// :ID:408
// :NUM:564
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Javascript_boot_strapping_method
// :CODE:
string URL;
 
string get(string page)
{
    if (page == "index")
    {
        return "<h1>Index</h1>This is the index page.<br><br><a href='page1.html'>Link to page 1</a>";
    }
    else if (page == "page1")
    {
        return "<h1>Page 1</h1>This is page 1!.<br><br><a href ='index.html'>Link to the index page.</a>";   
    }
    else return "Unknown page.";
}
 
string serve(string page)
{
    return "document.write(atob('"+llStringToBase64(get(page))+"'));";
}
 
integer R;
load(string page)
{
    string content="data:text/html;base64,"
        +llStringToBase64("<html><head><base href='"+URL+"/'></head><body>"+
                        "<script src='"+page+".js' type='text/javascript'>"+
                        "</script><span r='"+(string)(++R%10)+"</body></html>");
 
    llSetPrimMediaParams(0,[
                    PRIM_MEDIA_CURRENT_URL,content,
                    PRIM_MEDIA_HOME_URL,content,
                    PRIM_MEDIA_AUTO_ZOOM,FALSE,
                    PRIM_MEDIA_FIRST_CLICK_INTERACT,TRUE,
                    PRIM_MEDIA_PERMS_INTERACT,PRIM_MEDIA_PERM_ANYONE,
                    PRIM_MEDIA_PERMS_CONTROL,PRIM_MEDIA_PERM_NONE,
                    PRIM_MEDIA_AUTO_PLAY,TRUE
                    ]);
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
            URL = body;
            load("index");
        }
        else if (method == URL_REQUEST_DENIED)
        {
            llOwnerSay("Unable to get url!");
        }
        else if (method == "GET")
        {
            string path_raw = llGetHTTPHeader(id,"x-path-info");
            if (path_raw == "")
            {
                // No path, assume index.html
                path_raw = "/index.html";
            }
 
            list path = llParseString2List(llGetSubString(path_raw,1,-1),["."],[]);
            string page = llList2String(path,0);
            string type = llList2String(path,1);
 
            if (type == "js")
            {
                llHTTPResponse(id,200,serve(page));
            }
            else if (type == "html")
            {
                llHTTPResponse(id,100,"");
                load(page);
            }
        }
    }
}
 
