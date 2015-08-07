// :CATEGORY:RSS
// :NAME:Cnnrssfeed
// :AUTHOR:Wietse Cassini
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:50
// :ID:185
// :NUM:258
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Cnn-rss-feed.lsl
// :CODE:


string LatestItem;
string RSSurl = "http://rss.cnn.com/rss/cnn_topstories.rss";
key    PageKey;

default
{
    state_entry ()
    {
        llSay(0, "Scripts 'r us CNN RSS feed started. Brought to you by Wietse Cassini");
        llSay(0, "Top stories RSS feed");
        llSetTimerEvent(60);
        
    }
    
    timer ()
    {
        PageKey = llHTTPRequest(RSSurl,[],"");
    }    

    http_response (key request_id, integer status, list metadata, string body)
    {
        integer begin = llSubStringIndex(body, "<item>") + 6;
        integer end   = llSubStringIndex(body, "</item>");
        string item   = llGetSubString(body, begin, end);
            
        if (item != LatestItem)
        {

            LatestItem = item;

            begin         = llSubStringIndex(item, "<title>") + 7;
            end           = llSubStringIndex(item, "</title>");
            llSay(0, llGetSubString(item, begin, end));

            begin         = llSubStringIndex(item, "<description>") + 13;
            end           = llSubStringIndex(item, "</description>");
            llSay(0, llGetSubString(item, begin, end));

            begin         = llSubStringIndex(item, "<link>") + 6;
            end           = llSubStringIndex(item, "</link>");
            llSay(0, llGetSubString(item, begin, end));
        }
    }
}     // end 
