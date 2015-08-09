// :CATEGORY:Avatar Key
// :NAME:Key_DB
// :AUTHOR:Fred Kinsei
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:55
// :ID:418
// :NUM:574
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Key_DB
// :CODE:
//Credit to the creator:
//Made by SL resident Fred Kinsei
default
    {
    state_entry()
    {
        llListen(0, "", llGetOwner(), "");
    }
    listen(integer chan, string name, key id, string message)
    {
        if(llGetSubString(message, 0, 4) == ".key ")
        {
	    llHTTPRequest("http://irc.gameoria.com/keydb/?a=get&pass=alwel&what="+llEscapeURL(llToLower(llGetSubString(message, 5, -1)))+"&clean=0",[HTTP_METHOD,"GET"],"");
        }     
    } 
    http_response(key request_id, integer status, list metadata, string body)
    {
        list parse = llParseString2List(body, [":"], []);
        integer results = ((llGetListLength(parse)+1) / 4);
        if(body != "")
        {
            integer i;
            while(i<=results)
            {
                if(((i*4)-3) >-1)
                {
                    llOwnerSay(llList2String(parse, ((i*4)-3)) + ": " + llList2String(parse, ((i*4)-2)));
                }
                i++;
            }
        }
    }
}
