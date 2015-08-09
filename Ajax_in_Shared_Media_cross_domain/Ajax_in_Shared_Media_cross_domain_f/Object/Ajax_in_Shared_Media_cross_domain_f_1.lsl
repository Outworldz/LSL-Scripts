// :CATEGORY:Viewer 2
// :NAME:Ajax_in_Shared_Media_cross_domain
// :AUTHOR:Pavcules Superior
// :CREATED:2010-09-02 12:01:59.597
// :EDITED:2013-09-18 15:38:47
// :ID:24
// :NUM:34
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Although the 'XMLHttpRequest' Javascript function does not work across different domains, the following LSL Script below gets around this problem!// By using Javascript and HTTP-In, the Javascript calls the prim HTTP-In URL.  The LSL script (http_request event) then calls to another website to return data from it.  When the website returns the data, the "http_response" event it sends a page response back with the data via the HTTP-In method.  The response contains the Javascript function to be called with the data to be shown in the webpage.// // The script below obtains the latest Moon information.  If you press the Click Me button every one minute, the information will be updated.
// :CODE:
string g_strURL;
key g_keyResponseRequestID;
key g_keyRequestID; 
 
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
    oScript.src = '" + url + "?sid='+Math.random();
    document.body.appendChild(oScript);  
}

function callback(sText) 
{
    document.getElementById('data').innerHTML = sText;
}

</script>
</head>
<body>
<input type=\"button\" value=\"Click Me\" onclick=\"makeRequest()\" />
<br /><br />
<div id=\"data\">Press the 'Click Me' button to get current moon info!</div>
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
            g_strURL = body + "/";
            
            llOwnerSay(g_strURL);
 
            show(build_url(g_strURL));
        }
        else if (method == "GET")
        {
            // Store the Request ID.
            g_keyResponseRequestID = id;
            
            // Call the website to get data.
            llOwnerSay("Getting data from website..." + (string)g_keyResponseRequestID);       
            g_keyRequestID = llHTTPRequest("http://pkpounceworks.com/pkp/scripts/moon/moontest.php",[],"");
            
        }
    }
    
    http_response(key request_id, integer status, list metadata, string body)
    {
        if(g_keyRequestID == request_id)
        {
            // Respond the website data back.
            llHTTPResponse(g_keyResponseRequestID,200,"callback(\"" + body + "\");" );
        }
    }    
    
    
}
