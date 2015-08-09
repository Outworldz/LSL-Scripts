// :CATEGORY:HTTP
// :NAME:Permanent_HTTPIN_URL_persister
// :AUTHOR:donjr Spiegelblatt
// :CREATED:2012-06-16 03:41:32.957
// :EDITED:2013-09-18 15:38:59
// :ID:621
// :NUM:846
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// This is a simple example of using an LSL-script to query the other script and get results.
// :CODE:
key rlReq;
key fReq = NULL_KEY;
string newpath = "";

key Request(string cmd)
{
    llSay(0, "sending="+newpath+"?"+cmd);
    return llHTTPRequest( newpath+"?"+cmd, [HTTP_METHOD, "GET"], "");
}

default
{
    state_entry()
    {
    }
    on_rez(integer param)
    {
        llResetScript();
    }

    touch_start(integer xx)
    {
        rlReq = llHTTPRequest( "http://tiny.cc/hotrod", [HTTP_METHOD, "GET"], "");  // find the other object/script
        // llSay(0, "MyKey="+(string)llGetKey());
    }

    http_response(key request_id, integer status, list metadata, string body)
    {
        if (rlReq == request_id)
        {
            rlReq = NULL_KEY;       // the same event sometimes shows up more then once
            if(status != 200)
                llOwnerSay("request failed status="+(string)status+" "+body);
            else
            {
                llSay(0, "body["+body+"]");     // report what was returned
                if(newpath == "")
                {
                    list t = llParseString2List(body,["="],[]);     // break it into two parts
                    if(llList2String(t,0) == "URL")                 // test that the first par matched
                    {
                        newpath=llList2String(t,1);                 // set newpath to the second part
                        rlReq = Request("name");        // request the object name
                    }
                }
                else if (fReq == NULL_KEY)
                    fReq = Request("unknown");          // make an unknown parameter test
            }
        }
        else if (fReq == request_id)
        {
            fReq = llGetKey();       // the same event sometimes shows up more then once
            if(status != 200)
                llOwnerSay("request failed status="+(string)status+" "+body);
            else
            {
                llSay(0, "body["+body+"]");     // report what was returned from unknow request
                rlReq = Request("sim");         // request the 'sim' parameter
            }
        }
    }
}
