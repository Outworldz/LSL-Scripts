// :CATEGORY:Viewer 2
// :NAME:Displaying_a_notecard_beyond_124_ch
// :AUTHOR:Pavcules Superior
// :CREATED:2010-09-02 11:34:33.207
// :EDITED:2013-09-18 15:38:51
// :ID:244
// :NUM:334
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// The following LSL Script reads a notecard that is over 3300 characters in size, and renders the HTML.// // How might this be possible?  This is basically using a combination of Javascript and HTTP-In.// //     * The script reads the notecard into memory.//     * The script also gets a HTTP-In URL.
//     * It then displays a webpage that contains 2 DIV tags, and automatically runs a Javascript function on Body load.
//     * A Javacsript function creates a SCRIPT tag inside the first DIV tag which points to the HTTP-In URL to request the first 1900 characters from the script.
//     * The script responds with the data, and a different Javascript function dumps the data into the first DIV tag.
//     * The Javacsript function then creates a SCRIPT tag inside the second DIV tag, and gets the next 1900 characters.
//     * The process is pretty quick and you will see the HTML data straight away.
// 
// If you are creating a webpage that is over 1000 charaters in size, and want to use this way of rendering it, then you will have to check the characters around the 1900 character mark.   If its in the middle of a HTML tag block, the end part will not used, because it will be placed inside a DIV tag.
// 
// With further tweaking, you could use a For Loop to create several DIV tags and show even more data.
// :CODE:
string g_strURL;  
string g_strNotecardName;   
string g_strNotecardText;
integer g_intNotecardLine = 0;        
key g_keyNotecardQueryID; 
key g_keyURLRequestID;


// Start reading the notecard text.
ReadNotecardText()
{
    llOwnerSay("Reading Notecard...please wait.");
    
    g_intNotecardLine = 0;    
    g_strNotecardText = "";    
    g_strNotecardName = llGetInventoryName(INVENTORY_NOTECARD, 0);
    g_keyNotecardQueryID = llGetNotecardLine(g_strNotecardName, g_intNotecardLine);   
     
} 
 
 
show(string html)
{
 
    llOwnerSay(html + "\nSize: " + (string)llStringLength(html) );
 
    llSetPrimMediaParams(0,                  // Side to display the media on.
            [PRIM_MEDIA_AUTO_PLAY,TRUE,      // Show this page immediately
             PRIM_MEDIA_CURRENT_URL,html,    // The url if they hit 'home'
             PRIM_MEDIA_HOME_URL,html,       // The url currently showing
             PRIM_MEDIA_HEIGHT_PIXELS,1024,   // Height/width of media texture will be
             PRIM_MEDIA_WIDTH_PIXELS,1024]);  //   rounded up to nearest power of 2.
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
    // " + (string)llGetUnixTime() + "    
    var oScript = document.createElement('script');
    oScript.src = '" + url + "?part=0&sid='+Math.random();
    document.body.appendChild(oScript);  
    
    var oScript= document.createElement('script');
    oScript.src = '" + url + "?part=1&sid='+Math.random();
    document.body.appendChild(oScript);     
}

function callback(num, sText) 
{
    document.getElementById('d' + num).innerHTML = sText;  
}

</script>
</head>
<body onload=\"makeRequest();\">
<div><div id=\"d0\" style=\"display:inline;\"></div><div id=\"d1\" style=\"display:inline;\"></div></div>
</body>
</html>";
}


string strReplace(string str, string search, string replace) {
    return llDumpList2String(llParseStringKeepNulls((str = "") + str, [search], []), replace);
}
 
default
{
    state_entry()
    {
        ReadNotecardText();
        
        llRequestURL();
    }
 
    changed(integer change)
    {
        // If the inventory is updated, read the notecard data again.        
        if(change & CHANGED_INVENTORY)
        {
              ReadNotecardText();
        }       
    }
     
 
    dataserver(key query_id, string data) 
    {
        if (query_id == g_keyNotecardQueryID) 
        {
            if (data != EOF)
            {    
                // Store the text.
                g_strNotecardText += data;
                
                // Read next notecard line.
                ++g_intNotecardLine;
                g_keyNotecardQueryID = llGetNotecardLine(g_strNotecardName, g_intNotecardLine);
            }
            else
            {
        
                // We have reached the end of the notecard.
                llOwnerSay("Size: " + (string)llStringLength(g_strNotecardText));
                show(build_url(g_strURL));
            }
        }
    } 
 
    http_request(key id, string method, string body)
    {
        if (method == URL_REQUEST_GRANTED)
        {
            g_strURL = body + "/";
            
            llOwnerSay(g_strURL);
 
          //  show(build_url(url));
        }
        else if (method == "GET")
        {
            
            string strParams = llGetHTTPHeader(id, "x-query-string");
             llOwnerSay("url: " + strParams);          
            list lstParams = llParseStringKeepNulls(strParams, ["&"], []);
            
            list lstParamID = llParseStringKeepNulls(llList2String(lstParams,0), ["="], []);
            
            integer intPartNumber = llList2Integer(lstParamID,1);
            integer intSize = 1900;
            integer intStart = 0;
            integer intFinish = intSize -1;
            

            if(llList2String(lstParamID,0) == "part")
            {
                intStart = intSize * intPartNumber;
                intFinish = intStart + intSize - 1;
            }
            
            
            llOwnerSay("Getting Notecard Contents:");
            g_strNotecardText = strReplace(g_strNotecardText,"\"","'");
            
            string strCallback = "callback(" + (string)intPartNumber + ",\"" +
                llGetSubString(g_strNotecardText,intStart,intFinish) + 
                "\");";
            
            
            llHTTPResponse(id,200,strCallback );
        }
    }
}
