// :CATEGORY:Updater
// :NAME:Open Updater
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2013-09-06
// :EDITED:2014-02-24
// :ID:586
// :NUM:802
// :REV:1.1
// :WORLD:Second Life, OpenSim
// :DESCRIPTION:
// Grid-wide Updater for products. This is the Client
// :CODE:

// Script by Fred Beckhusen (Ferd Frederix)
// fred@mitsi.com
// License: CC-BY-NC
// This means you must leave the headers in this script intact, and it is not to be sold by itself, not even for a Linden
// You are allowed to use and sell Products that use this script.
//
// Open Update Client
// Updater that goes into any product.
// Rev 1.0 5/24/2013 Initial release
// Rev 1.1 2/21/2014 changed UUID to a valid one as people do not know how to read instructions.

// Put this script into any prim and give the prim to someone.
//  When that product is rezzed, it will check for updates from a Server prim
// You must make the name of the Prim "Name-VN", where N is a version number such as 1, 1.0, 2 and so on.
// The Name must not have a | in it.
// The product MUST have a name followed by -V and a version number
//
// Examples: Horsie-V1.0    ( Same as V1)
//           Horsie-V1      ( Same as V1.0)
//           Horsie-V1.1    ( if inside the updater, this will be sent if the version of Horsie is less than 1.1 )
//           Horsie-V4.1.1  ( This is an illegal number as it has 2 decimals, and will not update as you expect)
//           Horsie|From Me-V4.1  ( This is an illegal name as it has a "|" in it)

//////////////////////////////////////////////////////////
//                 IMPORTANT   CONFIGURATION            //
//////////////////////////////////////////////////////////

// You MUST put in a UUID from this web site here and put the same UUID in the updater script
// Get a UUID from Latif Khalifa at:
//
// http://gridurl.appspot.com/random
//
// You only need to do this once for the server that has the same key. That server has to have a copy of the object in it.
// You can run more than one server, just make sure that the product goes into the correct server and that the key inside this script in that product matches the key inside the server

string UUID = "92e723e8-3653-451c-816d-23f920cd02c8";    // You MUST change this

integer CHATTY = TRUE;       // When TRUE, tells the prim owner it is checking for updates. If FALSE, this script is silent.

//////////////////////////////////////////////////////////
//   CODE BEGINS, Move on, nothing here to change       //
//////////////////////////////////////////////////////////


// Just for Debugging
integer debug = FALSE;          // Show what is happenning in chat if TRUE

DEBUG(string msg)
{
    if (debug)
        llOwnerSay(llGetScriptName() + " : " + msg);
}


// globals
key http_request_id;        // this key of for the update request
key URL_request_id;        // this key is for the HTTP-In
string serverURL;          // This will become out HTTP-I URL


key Request(string cmd)
{
    DEBUG("Sending:"+serverURL+"?"+cmd);
    return llHTTPRequest( serverURL+"?"+cmd, [HTTP_METHOD, "GET"], "");
}



CheckForUpdate()
{
    // Check for an update from the server prim
    string AvatarName = llKey2Name(llGetOwner());
    string AvatarNameESC = llEscapeURL(AvatarName);
    string ProductName = llEscapeURL(llGetObjectName());
    
    //Product Name|UUID|Avatar Name   is the message

     string query = "?q=" + ProductName + "|"+ (string) llGetOwner() +"|" + AvatarName;
    
    DEBUG("URL:" + serverURL);
    http_request_id = llHTTPRequest(serverURL + query,[HTTP_METHOD,"POST"],"");
}


default
{

    on_rez(integer param)
    {
        llResetScript();
    }

    state_entry()
    {
        if (CHATTY)
            llOwnerSay( "Checking for updates");
        string keyURL =  "http://gridurl.appspot.com/get/"+ llEscapeURL(UUID);
        DEBUG(keyURL);
        URL_request_id = llHTTPRequest(keyURL, [HTTP_METHOD, "GET"], "");  // find the server
    }


    http_response(key request_id, integer status, list metadata, string body)
    {
        if (URL_request_id == request_id)
        {
            URL_request_id = NULL_KEY;       // the same event sometimes shows up more then once
            if(status == 200)
            {
                DEBUG("Server URL is :" + body);
                serverURL = body;
                CheckForUpdate();    // let's see if there is an update by connecting to the URL we just got
            }
        }
        else if (http_request_id ==  request_id)
        {
            if(status == 200)
            {
                DEBUG("Success response:" + body);     // report what was returned from update request
            }
            else
            {
                DEBUG("Fail response:" + body);     // report what was returned from update request
            }
        }
    }
}



