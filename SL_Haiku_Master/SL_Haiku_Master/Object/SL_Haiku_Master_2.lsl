// :CATEGORY:HTTP
// :NAME:SL_Haiku_Master
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:03
// :ID:785
// :NUM:1074
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// LSL Script
// :CODE:
default

{

    state_entry()

    {

        llSay(0,"The haiku master is ready...");

    }

    

    touch_start(integer total_number)

    {

        key requestid = llHTTPRequest("http://www.simteach.com/slhaiku.php",[HTTP_METHOD,"GET"],"");

    }

    

    http_response(key request_id, integer status, list metadata, string body)

    {

        llSay(0,body);

    }

}
