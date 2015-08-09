// :CATEGORY:ChatBot
// :NAME:Pandora_Chatbot
// :AUTHOR:Destiny Niles
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:59
// :ID:603
// :NUM:827
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// pandorabot script 
// :CODE:
key requestid;
string botid;
string cust;
string reply;
string newreply;
integer that_begin;
integer that_end;
integer cust_begin;


string SearchAndReplace(string input, string old, string new) 
{
   return llDumpList2String(llParseString2List(input, [old], []), new);
} 

default
{
    state_entry()
    {
        cust="";
        botid="b1e9139eee362838";
    }

    on_rez(integer param)
    {
        llResetScript();
    }

    link_message(integer sender_num, integer num, string msg, key id)
    {
        requestid = llHTTPRequest("http://www.pandorabots.com/pandora/talk-xml?botid="+botid+"&input="+llEscapeURL(msg)+"&custid="+cust,[HTTP_METHOD,"POST"],"");
    }
    http_response(key request_id, integer status, list metadata, string body)
    {
        if (request_id == requestid)
        {
            cust_begin=llSubStringIndex(body, "custid=");
            cust=llGetSubString(body, cust_begin+8, cust_begin+23);
            that_begin = llSubStringIndex(body, "<@that>"); // this should be < that > (delete @)
            that_end = llSubStringIndex(body, "<@/that>"); //this should be < / that > (delete @)
            reply = llGetSubString(body, that_begin + 6, that_end - 1);
            newreply = SearchAndReplace(reply, "%20", " ");
            reply = newreply;
            newreply = SearchAndReplace(reply,"&@quot;","\""); //this should be & quot; (delete @) the wiki changes it to "
            reply = newreply;
            newreply = SearchAndReplace(reply,"&@lt;br&@gt;","\n"); //the first search should be & lt;br & gt; (delete @)
            reply = newreply;
            newreply = SearchAndReplace(reply, "&@gt;", ">"); //the first search should be & gt; (delete @)
            reply = newreply;
            newreply = SearchAndReplace(reply, "&@lt;", "<"); //this first search should be & lt;
            
            llSay(0,newreply);
        }
    }
}
