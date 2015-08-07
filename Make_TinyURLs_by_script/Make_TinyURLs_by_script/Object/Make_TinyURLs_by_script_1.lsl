// :CATEGORY:Viewer 2
// :NAME:Make_TinyURLs_by_script
// :AUTHOR:Becky Pippen
// :CREATED:2010-09-02 11:28:01.473
// :EDITED:2013-09-18 15:38:57
// :ID:503
// :NUM:673
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
//     *  Any URL or data URI can be mapped to a TinyURL. The example above reduces an assigned HTTP-in URL, which is a long one such as: // http://sim4605.agni.lindenlab.com:12046/cap/2b9f06f7-431e-5b0f-9271-2d03bd15370b// // into a TinyURL this size:// 
http://tinyurl.com/y9etul3
// :CODE:
string myTinyURL;

default
{
    state_entry()
    {
        llRequestURL();
    }

    http_request(key id, string method, string body)
    {
        if (method == URL_REQUEST_GRANTED) {
            // Send our full URL to tinyurl.com for conversion
            // The answer will come back in http_response()
            llHTTPRequest("http://tinyurl.com/api-create.php?url=" + body, [], "");
        } else if (method == "GET") {
            llHTTPResponse(id, 200, "Hello Real World from the Virtual World");
        }
    }

    http_response(key req, integer stat, list met, string body)
    {
        myTinyURL = body;
        llOwnerSay("My HTTP-in TinyURL is: " + myTinyURL + " , Click Me!");
    }
} 
