// :CATEGORY:Updater
// :NAME:Open_Product_Updater
// :AUTHOR:Ferd Frederix
// :CREATED:2013-05-24 13:20:21.143
// :EDITED:2013-09-17 21:48:39
// :ID:589
// :NUM:807
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Server Script.  Please remember to configure the UUID in both the server and the client,it is simple, and free.  This prim needs to be in-world at all times.   Add any new gadgets to this prim and give them a name such as "Name-V2", where the number  is higher that what is already out there.
// :CODE:
// Script by Ferd Frederix
// fred@mitsi.com
// License: CC-BY-NC
// This means you must leave the headers in this script intact, and it is not to be sold by itself, not even for a Linden
// You are allowed to use and sell Products that use this script.

//
// Open Update server 
// Rev 0.1
// 5/24/2013
// Put Products in a box inside the prim that has this script.  Put the Product Updater scipt in products that get rezzed, and not the box that holds them.
// You must make the name of the box that you put in this server  "Name-VN", where N is a version number such as 1, 1.0, 2 and so on.
// The Name must not have a | in it.
// The box  MUST have a name followed by -V and a version number
//
// Examples: Horsie-V1.0    ( Same as V1 )
//           Horsie-V1      ( Same as V1.0, V1.000 etc. )
//           Horsie-V1.1    ( his will be sent if the product is named Horsie-V0.99999 or lower )
//           Horsie-V4.1.1  ( This is an illegal number as it has 2 decimals, and will not update as you expect)
//           Horsie|From Me-V4.1  ( This is an illegal name as it has a "|" in it)



//////////////////////////////////////////////////////////
//                 IMPORTANT   CONFIGURATION            //
//////////////////////////////////////////////////////////

// You MUST put in a UUID from this web site here and put the same UUID in the updater script in your products
// Get one from Latif Khalifa at 
// http://gridurl.appspot.com/random
//
string UUID = "8c1a45eb-6c4e-4916-8fb7-3252964163d3";    // You MUST change this here and in the products upadter script that you put in your products.

// Debugging and setup things that can be changed
integer debug = FALSE;          // Show what is happening in chat
integer ENABLED = TRUE;        // If TRUE, issue updates to clients, if FALSE, do everything but actually give inventory 
float HoverText = 1.0;   // Set to 0.0 to turn hovertext status updates off


//////////////////////////////////////////////////////////
//   CODE BEGINS, Move on, nothing here to change       //
//////////////////////////////////////////////////////////


// global vars
integer nServed; // how many updates sent, starts at zero

// HTTP-IN and other web traffic stuff
key URLReq = NULL_KEY;
string url;            // sop we can release HTTP-In keys
key urlRequestId;      // the key of the request for a HTTP-In URL
key http_RequestID;    // the key of th4e Post to outselves
integer CHECKTIMER = 600; // run a self-test every 5 minutes. if this fails, request a new URL


RequestHTTPInURL()
{
    llSetTimerEvent(0);     // Do not run diags unless we have a valid URL
    llReleaseURL(url);      // there is a limit to the number of URLS, so we always release them.
    url = "";
    urlRequestId = llRequestURL();    // get a HTTP-In URL
}


DEBUG(string msg)
{
    if (debug)
        llOwnerSay(llGetScriptName() + " : " + msg);
}

key Request(string URL)
{
    llSetText("Registering",<0,0,1>,HoverText);   // blue
    string url = "http://gridurl.appspot.com/reg?service=" + UUID + "&url=" + llEscapeURL(URL) + "/";
    return  llHTTPRequest( url, [HTTP_METHOD, "GET"], "");
}


default
{
    // When rezzed, lets start everything from scratch
    on_rez(integer param)
    {
        llResetScript();
    }

    // when reset, we get a HTTP-IN URL. Without this, we can do nothing
    state_entry()
    {
        llSetText("Initializing",<0,0,1>,HoverText); // blue
        RequestHTTPInURL();
    }

    // This event will occur whenever a URL is granted or the web server it created gets a POST or GET
    http_request(key id, string method, string body)
    {
        if (method == URL_REQUEST_GRANTED)
        {
            DEBUG(body);
            url = body;    // save body response, which is our actual URL,  so we can release it.
            llSetText("Update Server is Starting",<0,0,1>,HoverText);
            URLReq = Request(body);    // send it to the server so the gadgets in the field know where to go to get updates.

            llSetTimerEvent(2);        // check server just to be certain
        }
        else if (method == URL_REQUEST_DENIED)
        {
            llSetText("ERROR: URL request was denied, retrying in 1 minute",<1,0,0>,HoverText);
            llSleep(60);
            RequestHTTPInURL();
        }
        else if (id == URLReq)
        {
            if (body == "OK")
            {
                llSetText("Test passed ",<0,0,1>,HoverText);
                llSleep(1);
            }
            else
            {
                llSetText("Unable to register, please check your UUID",<1,0,0>,HoverText);
            }
        }
        else if(method == "GET")
        {
            DEBUG("GET ACK");
            llHTTPResponse(id, 200, "ACK");
        }
        else if(method == "POST")
        {
            DEBUG("POST received");
            string resp = llGetHTTPHeader(id, "x-query-string");
            // should look like this for a version 1 Object
            // q=Object Name-V1.0|10000000-0000-0000-0000-000000000000|SecondLife OwnerName
                
            DEBUG("Query String = " + resp);
            
            list info = llParseString2List(resp,["|"],[]);
            DEBUG(llDumpList2String(info,"|"));

            // get rid of the q= at the beginning of the name
            string name= llList2String(info,0);
            list names = llParseString2List(name,["="],[]);
            
            string shortName = llList2String(names,1);
            DEBUG("shortName:" + shortName);

            // should look like this for a version 1 Object
            // Object Name -V1.0|10000000-0000-0000-0000-000000000000|SecondLife OwnerName

            names = llParseString2List(shortName,["-V"],["-V"]);
            float VerWanted = (float) llList2String(names,1);
            DEBUG("Version of product:" + (string) VerWanted);
            
            string  productName = llList2String(names,0);
            DEBUG("productName:" +  productName);
            
            key  Theirkey = (key) llList2String(info,1);
            DEBUG("Owner key:" + (string) Theirkey);
            
            string Avatar = llList2String(info,2);
            
                        integer count = llGetInventoryNumber(INVENTORY_OBJECT);
            while (count--)
            {
                string fullname = llGetInventoryName(INVENTORY_OBJECT,count);  // obj 1 = 0
                list parts = llParseString2List(fullname,["-V"],["-V"]);
                
                string invName = llList2String(parts,0);
                float invVersion = (float) llList2String(parts,1);
                DEBUG("Inv Name   :" +  (string) invName);
                DEBUG("Inv Version:" +  (string) invVersion);
                
                if (productName == invName && invVersion > VerWanted )
                {
                    DEBUG("Giving:" + invName);
                    nServed++;        // counter for products dispensed         
                    if (ENABLED)    llGiveInventory(Theirkey,fullname);
                    llSetText(Avatar + " got " + fullname + "\nTotal Items Updated:" + (string) nServed, <1,1,1>,1.0 );
                }
            }
            llHTTPResponse(id, 200, "ACK");
        }
        else
        {
            llSetText("Unknown command received",<1,0,0>,HoverText);
            llHTTPResponse(id, 501, "Not Implemented "+method);
        }
    }

    // This even will run when a web page is fetched
     http_response(key request_id, integer status, list metadata, string body)
    {

        // This would be the response from Grispot that out URL was accepted.        
        if(URLReq == request_id)
        {
            URLReq = NULL_KEY;       
            if(status == 200)
            {
                llSetText("Server is OK",<0,1,0>,HoverText);
            }
            else
            {
                llSetText("The internet is broken - retrying",<1,0,0>,HoverText);
                llSleep(60);        // be nice
                RequestHTTPInURL();        // try again
            }
        }

        // this  occurs when we test ourselves. We should have gotten an ACK to keep us happy.
        // if no ACK, we need a new URL
        else if (request_id == http_RequestID)
        {
            if (body != "ACK")
            {
                llSetText("The internet is broken - retrying",<1,0,0>,HoverText);
                llSleep(60);    // be nice to ourserver, the server has probably run out of URLS.
                RequestHTTPInURL();
            }
            else
            {
                llSetText("Server is ready",<0,1,0>,HoverText);
            }
        }
    }


    // run a self test every so often by GETing from ourselves
    // This also resets the timer to CHECKTIMER, as the very first one of these happens at startup in a few seconds.
    timer()
    {
        llSetText("Update Server is checking itself",<0,0,1>,HoverText);
        http_RequestID = llHTTPRequest(url,[HTTP_METHOD,"GET"],"");
        llSetTimerEvent(CHECKTIMER);        // check server just to be certain
    }

     
      
}
