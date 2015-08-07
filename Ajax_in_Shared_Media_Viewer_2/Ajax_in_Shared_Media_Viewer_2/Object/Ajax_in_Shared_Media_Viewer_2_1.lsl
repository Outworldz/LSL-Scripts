// :CATEGORY:Viewer 2
// :NAME:Ajax_in_Shared_Media_Viewer_2
// :AUTHOR:Pavcules Superior
// :CREATED:2010-09-02 11:59:54.190
// :EDITED:2013-09-18 15:38:47
// :ID:25
// :NUM:35
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// What it does is to show a web page with a button and field.  If you click on the button it shows the latest Unix Timestamp in the field.// // The web page is produced via the LSL script.  The Javascript function calls the prim HTTP-In URL to return a function with the Timestamp.// This is not the usual way of doing Ajax, as I had some problems using the 'XMLHttpRequest' object approach. I believe it could be a cross-domain issue.  This alternative way creates a HTML Script element tag, and references the prim URL for the Source code.  The code calls a function back in the main Javascript code to return the data.// // I'm sure there could be other uses of Ajax in LSL.  But have to be careful of the 1024 character URL limit.
// 
// Thanks to Tali Rosca for getting the ball rolling on using Javascript to get around limitations!  
// :CODE:
string url; // Our base http-in url
 
show(string html)
{
 
    llOwnerSay(html);
 
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
    return "data:text/html, 
<html>
<head>
<script type=\"text/javascript\">
    
function makeRequest()
{
    var oScript = document.createElement('script');
    oScript.src = '" + url + "&sid='+Math.random();
    document.body.appendChild(oScript);  
}

function callback(sText) 
{
    document.timeform.data.value = 'Loaded: ' + sText;   
}

</script>
</head>
<body>
<input type=\"button\" value=\"Click Me\" onclick=\"makeRequest()\" />
<form name=\"timeform\" >
Data:<input type=\"text\" name=\"data\"/>
</form>
</body>
</html>";
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
            
            llOwnerSay(url);
 
            show(build_url(url));
        }
        else if (method == "GET")
        {
            llOwnerSay("Getting Time");
            llHTTPResponse(id,200,"callback(\"" + (string)llGetUnixTime() + "\");" );
        }
    }
}
