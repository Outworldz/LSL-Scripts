// :CATEGORY:Viewer 2
// :NAME:Reverse_Ajax__Longpolling_the_HTTPi
// :AUTHOR:Becky Pippen
// :CREATED:2010-09-02 11:18:14.347
// :EDITED:2013-09-18 15:39:01
// :ID:700
// :NUM:955
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// # This "server-push" technique using long-polling gives an LSL script the ability to modify the web page displayed on a prim. The Javascript side always keeps an HTTP GET open to the prim's HTTP-in URL, and the LSL side responds whenever it wants to with a response consisting of strings of Javascript to be executed by the web browser. For example, this LSL code causes an alert box to pop up on the web page:// //     sendMessage( "alert()" );// // # In the LSL listing above, the yellow highlighting shows the most important parts of the HTTP long-polling mechanism. The green highlighting shows the message buffering on top of that. The blue highlighting is the application code that uses long-polling. To use long-polling for a different application, replace the blue parts. The rest is glue.// # To avoid some subtle WebKit problems when dynamically appending or replacing the first-level child nodes in <head> or <body>, we've made two special <div> elements on the bootstrap HTML page. The first surrounds the script#sc element that we replace for each GET. The second is at the end of <body> as a convenient place for the application to insert new content that would otherwise go in <body>.
// # To make sure that there is nearly always a valid GET request open, the Javascript side starts a new GET after receiving a response, or just before the last unanswered GET times out.
// # There are two timeouts hard-coded in the bootstrap data URI:
// 
//    1. The "20000" is the timeout (20 seconds) for when an open GET expires, and should be set to a little less than the minimum of the WebKit outgoing GET request timeout, and the SL-LSL incoming GET timeout. This ensures that GETs are nearly continuous, and the LSL side can always respond to the most recent GET request. This page says the timeout on the LSL side is 25 seconds.
//    2. The "500" is a throttle that sets an upper limit to how fast the Javascript re-polls HTTP-in to prevent hammering the simulator. It's a half-second delay after receiving a GET response before starting a new GET.
// 
// # If there's a little gap between two GETs, or if two overlap a little, the sendMessage() message buffering will compensate by queuing up messages to be sent when the next GET arrives. If there are multiple messages in the queue when a GET arrives, the LSL side will concatenate as many messages as possible and send them together.
// # On the Javascript side, the GET is not triggered until the <script> element is attached to its parent node with .appendChild() or .replaceChild().
// # The bootstrap Javascript above in setDataURI() had to be compressed somewhat to fit into the 1024-byte data URI limit
// :CODE:
// Reverse Ajax: Long-polling HTTP-in.
// Becky Pippen, 2010, contributed to the public domain.

integer face = 4;          // Prim face for Shared Media

string  myURL;             // HTTP-in URL
key inId = NULL_KEY;       // GET request id
list msgQueue = [];        // strings of Javascript

// url is our own HTTP-in url.
// This sets up a bootloader web page like this:
//      <html><body>
//         <div><script id='sc'></script></div>
//         <script> callbacks and poll.beg() defined here </script>
//         <button onclick=poll.beg()>Start</button>
//         <div id='dv'></div>
//      </body></html>
// When the button is pressed, the JS code sets src= on script#sc
// and reattaches the script element to the parent <div> element which
// initiates a GET to the prim's HTTP-in port
//
setDataURI(string url)
{
    string dataURI = "data:text/html,
<!DOCTYPE HTML><html><body><div><script id='sc'></script></div><script>
var poll=function(){var sc=document.getElementById('sc'),t2,seq=0,s0;return{
beg:function(){s0=document.createElement('script');s0.onload=poll.end;t2=setTimeout('poll.end()',20000);
s0.src='" + url + "/?r='+(seq++);sc.parentNode.replaceChild(s0,sc);sc=s0;},
end:function(){clearTimeout(t2);t2=null;sc.onload=null;setTimeout('poll.beg()',500);},};}();</script>
<button id='btn'onclick=poll.beg()>Start</button><div id='dv'></div></body></html>";

    llSetPrimMediaParams(face, [PRIM_MEDIA_CURRENT_URL, dataURI]);
}

// Returns zero or more queued messages. Assumes no single message is
// longer than MAX_SIZE_CHARS (will hang if there is)
//
string popQueuedMessages()
{
    string  totalMsg = "";
    integer totalMsgSize = 0;
    string  nextMsg = "";
    integer nextMsgSize = 0;

    // HTTP response bodies are limited to 2048 bytes after encoding
    // in UTF-8. LSL string sizes are measured in characters, which,
    // in UTF-8, use one byte (for ASCII chars), two bytes (most Latin-1),
    // or three bytes (a few international characters). So, unless
    // you re-write this section so that it measures UTF-8 size, keep
    // MAX_SIZE_CHARS small enough so the text will fit in a response body.
    //
    integer MAX_SIZE_CHARS = 1000; // Max HTTP body size 
 
    integer numMessagesQueued = llGetListLength(msgQueue);
    integer count = 0;
    integer done = FALSE;
    while (!done && count < numMessagesQueued) {
        nextMsg = llList2String(msgQueue, count);
        nextMsgSize = llStringLength(nextMsg);

        if (totalMsgSize + nextMsgSize < MAX_SIZE_CHARS) {
            totalMsg += nextMsg;
            totalMsgSize += nextMsgSize;
            ++count;
        } else {
            done = TRUE;
        }
    }

    // Delete the messages from the queue that we're going to send:
    if (count > 0) {
        msgQueue = llDeleteSubList(msgQueue, 0, count - 1);
    }

    return totalMsg;
}

// Called when there are previous messages still queued, or if there
// is no GET request currently open to respond to.
//
pushMessageToSend(string msg)
{
    msgQueue = msgQueue + [msg]; // last element is the last one stacked

    // See if we can send some messages now:
    if (inId != NULL_KEY) {
        llHTTPResponse(inId, 200, popQueuedMessages());
        inId = NULL_KEY;
    } // else wait for the next incoming GET request
}

// Replaces all occurrences of 'from' with 'to' in 'src'
// From http://snipplr.com/view/13279/lslstrreplace/
//
string str_replace(string subject, string search, string replace)
{
    return llDumpList2String(llParseStringKeepNulls(subject, [search], []), replace);
}

// Optionally filter out characters in text that would mess up the
// web page display. This demo just escapes ' and " and adds a space after '<'.
//
string addSlashes(string s)
{
    return str_replace(str_replace(str_replace(s, "<", "< "), "\"", "\\\""), "'", "\\\'");
}

// This is the main interface for LSL to control the Shared Media web page.
// The messages we send consist of Javascript function statements that the
// browser will evaluate and execute in the context of the web page.
// See sendMessageF() for a similar function with macro replacement.
//
sendMessage(string msg)
{
    // Test for the easy case: if there are no other messages waiting
    // in the queue, and if there is an open GET connection, then just
    // respond immediately:
 
    if (llGetListLength(msgQueue) == 0 && inId != NULL_KEY) {
        // Nothing in the queue and an open GET, so respond immediately:
        llHTTPResponse(inId, 200, msg);
        inId = NULL_KEY;
    } else {
        pushMessageToSend(msg);
    }
}

// Same as sendMessage() but with macro replacements. For each nth string
// element in replacements, replace all occurrences of {@n}. For example,
//     sendMessageF( "alert('{@0} {@1}!')", ["Hello", "World"] );
// will send "alert('Hello World!')" to the web browser.
//
sendMessageF(string msg, list replacements)
{
    integer numrepl = llGetListLength(replacements);
    integer i;
    for (i = 0; i < numrepl; ++i) {
        msg = str_replace(msg, "{@" + (string)i + "}", llList2String(replacements, i));
    }

    sendMessage(msg);
}

// Chat logger demo: writes a new <tr> table row to the web page
// for every line of open chat it hears.
//
webAppInit()
{
    string msg;
    string m0;

    // First, send over a few handy function definitions:

    msg = "function $$(t) { return document.getElementsByTagName(t)[0]; };";
    msg += "function h() { return $$('head'); };";
    msg += "function b() { return $$('body'); };";
    msg += "function e(id) { return document.getElementById(id); };";
    sendMessage(msg);

    // Send some CSS. WebKit is sensitive about appending <style> elements
    // to <head>, so we'll append it to an existing <div> tag in <body> instead.

    msg = "e('dv').innerHTML += \"{@0}\";";
    m0 = "<style>td:nth-child(2) { text-align:right } tr:nth-child(odd) { background-color:#f8e8f8 }</style>";
    sendMessageF(msg, [m0]);

    // Write a <table> element into element div#dv. The lines of chat will
    // become rows in this table appended to tbody#tbd

    msg = "e('dv').innerHTML += \"{@0}\";";
    m0 = "<table><tbody id='tbd'></tbody></table>";
    sendMessageF(msg, [m0]);

    llListen(0, "", NULL_KEY, "");
}

default
{
    state_entry()
    {
        llClearPrimMedia(face);
        llRequestURL();
         
        webAppInit();
    }

    http_request(key id, string method, string body)
    {
        if (method == URL_REQUEST_GRANTED) {
            myURL = body;
            llOwnerSay("myURL=" + myURL);
            setDataURI(myURL);
        } else if (method == "GET") {
            // Either send some queued messages now with llHTTPResponse(),
            // or if there's nothing to do now, save the GET id and
            // wait for somebody to call sendMessage().
            if (llGetListLength(msgQueue) > 0) {
                llHTTPResponse(id, 200, popQueuedMessages());
                inId = NULL_KEY;
            } else {
                inId = id;
            }
        }
    }

    // When we hear chat from name, send a Javascript statement that
    // appends HTML to element #tbd. I.e., we'll make a string of HTML
    // formatted like this:
    //      <tr style="color:hsl(200,100%,30%)">
    //         <td>[01:23]</td>
    //         <td>Avatar Name</td>
    //         <td>the chat text</td>
    //      </tr>
    // and send it wrapped it in a Javascript statement like this:
    //      e('tbd').innerHTML += htmlstring;
    //
    listen(integer chan, string name, key id, string chat)
    {
        integer s = (integer)("0x" + llGetSubString((string)id, 0, 6));
        string hue = (string)(s % 360);
        string color = "hsl(" + hue + ",100%, 30%)";

        string msg = "e('tbd').innerHTML += '{@0}';";
        string m0 = "<tr style=\"color: {@4}\">";
        m0 +=   "<td>{@1}</td>";
        m0 +=   "<td>{@2}:</td>";
        m0 +=   "<td>{@3}</td>";
        m0 += "</tr>";

        string t = llGetSubString(llGetTimestamp(), 11, 15);
        sendMessageF(msg, [m0, "[" + t + "]", name, addSlashes(chat), color]);
    }
}
