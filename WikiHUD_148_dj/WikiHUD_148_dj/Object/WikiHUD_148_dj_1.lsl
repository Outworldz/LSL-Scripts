// :CATEGORY:WIKI Reader
// :NAME:WikiHUD_148_dj
// :AUTHOR:dgrovesjr
// :CREATED:2011-08-22 02:30:57.600
// :EDITED:2013-09-18 15:39:09
// :ID:981
// :NUM:1403
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// WikiHUD_148_dj
// :CODE:
// Author: Lillie Yifu
//WikiHUD is a simple utility that reads pages from a wiki into Second Life. 

// Downloaded from : http://www.outworldz.com/freescripts.plx?ID=1324

// This program is free software; you can redistribute it and/or modify it.
// License information must be included in any script you give out or use.
// This script is licensed under the Creative Commons Attribution-Share Alike 3.0 License
// from http://creativecommons.org/licenses/by-sa/3.0 unless licenses are
// included in the script or comments by the original author,in which case
// the authors license must be followed.

// Please leave any authors credits intact in any script you use or publish.
////////////////////////////////////////////////////////////////////
// wiki reader 1.05 Lillie Yifu
// http://sexsecond.blogspot.com
// chat on channel 4 the name of an article to get the top of the entry text
// permission is granted to distribute this script free and open source with the header attached

// adding second channel to listen for mode changes
// adding category mode

// Heavey modified(rewritten) by Donjr Spiegeblatt

// configuration variables 
float TIMEOUT = 30.;   // Http_request call timeout  (note: the limit is about 59 seconds) 

integer achan = 4;    // query channel
integer mchan = 5;    // command channel

integer ShortWikiLength = 3;	// +1 equals number of characters that must match a wikis name
integer ShortLength     = 2;	// +1 equals number of characters that must match a command

string wiki = "";				// default to the first wiki entry in the urls table

key image = "f07b2853-6aa2-7819-cbde-a1bf4187091d";
vector large = <0.01,0.3,.3>;
vector small = <0.01,0.1,0.1>;
float alpha = 1.;				// greater then .5 use LARGE else Small as the default

integer showrecent = FALSE;		// default to not showing recent
integer recentlimit = 5;		// maxim number of recent entries to keep (display)

// wiki names and there matching urls
list urls =  [
    "wikia", "http://secondlife.wikia.com",
    "lindenlab","http://wiki.secondlife.com",
    "caledon","http://caledonwiki.com"
];
// end of configuration settings

// All working code from here on
string url;        // gets set to matching url for that entry for "wiki"
list shortwikis = [];			// filled in state_entry
string help = "WikiHUD (Help)";
list recent = [];

//action=query&#8195;&&#8195;list=search&#8195;&&#8195;srsearch=wikipedia&#8195;&&#8195;srlimit=10
string ModeSummary = "summary";
string ModeCategories = "categories";
string ModeWord = "word";
string ModeFull = "full";
string ModeSource = "source";
string ModeWikis = "wikis";
string ModeHelp = "help";
string ModeRecent = "recent";
list modenames = [ModeSummary,ModeCategories,ModeWord,ModeFull,ModeSource,ModeWikis,ModeHelp,ModeRecent];
list shortnames = [];		// filled in state_entry

string mode;	// current command mode

list phps = [ 
    ModeSummary,    "/index.php?action=raw&title=",     // Summary
    ModeCategories, "/api.php?format=xml&prop=categories&action=query&titles=",  // Categories
    ModeWord,       "/api.php?format=xml&action=query&list=search&srlimit=20&srsearch=", // Word
    ModeFull,       "/index.php?action=raw&title=",   // Full
    ModeHelp,       "/index.php?action=raw&title="    // Help
];

list meta = [HTTP_MIMETYPE,"text/plain;charset=utf-8"];		// note [] would yeild the same default values
key hid;
// used for commication btween query() with the http_response() and timer() events.
string oldbody = "";
integer section = 0;
integer follow= 0;

string qmode;   //mode of query
string qname;
query(string article, string mode)
{
    qmode = mode;
    qname=url+llList2String(phps,llListFindList(phps,[mode])+1)+llEscapeURL(article);
    string name = qname;
    if ( ModeSummary==mode || ModeFull==mode )
    {
        name += "&section=0"; // section postpend
        recent = [wiki+":"+article]+llList2List(recent,0,recentlimit);
        if(showrecent)
            llSetText(llDumpList2String(recent,"\n"),<1.,1.,1.>,alpha);
    }
    llOwnerSay(qmode+":"+wiki+":"+article);
    // llOwnerSay(qname+" "+ mode);  // debug version
    hid = llHTTPRequest(name, meta, "");
    // reset local state variables
    section = 0;
    follow = 0;
    oldbody = "";
    llSetTimerEvent(TIMEOUT);
}

string str_replace(string src, string from, string to)
{
    //replaces all occurrences of 'from' with 'to' in 'src'.
    integer len = (~-(llStringLength(from)));
    if(~len)
    {
        string  buffer = src;
        integer b_pos = -1;
        integer to_len = (~-(llStringLength(to)));

        @loop; //instead of a while loop, saves 5 bytes (and run faster).
        integer to_pos = ~llSubStringIndex(buffer, from);
        if(to_pos)
        {
            buffer = llGetSubString(src = llInsertString(llDeleteSubString(src, b_pos -= to_pos, b_pos + len), b_pos, to), (-~(b_pos += to_len)), 0x8000);
            jump loop;
        }
    }
    return src;
}

ToggleScale()
{
    vector cur = small;
    if(alpha > 0.5)
        alpha = .3;
    else
    {
        cur = large;
        alpha = 1.;
    }
    llSetScale(cur);
    llSetAlpha(alpha,ALL_SIDES);
}

default
{
    on_rez(integer xxx)
    {
        llResetScript();
    }

    state_entry()
    {
        // reverse alpha setting to toggle scale and alpha to the right settings
        if ( alpha > 0.5 )
            alpha = 0.1;
        else
            alpha = 1.;
        ToggleScale();
        llSetText("",<1.,1.,1.>,alpha);
        llSetTexture(image,ALL_SIDES);

        integer i;
        // build shor wiki name table
        integer len = llGetListLength(urls);
        shortwikis = [];
        for(i=0;  i < len; i+=2)
            shortwikis += llGetSubString(llList2String(urls,i),0,ShortWikiLength);
        i = llListFindList(shortwikis, [llGetSubString(wiki,0,ShortWikiLength)]);
        if(i < 0)
            i = 0;
        i *= 2;
        wiki = llList2String(urls,i);		// set wiki to full matching value
        url = llList2String(urls,i+1);		// set url to matching value

        llOwnerSay("Chat on channel "+(string)achan+" the name of an article to reference the Second Life Wiki.");
        llOwnerSay("Chat on channel "+(string)mchan+" to change query mode.");

		// build short command names table  (and display startup help)
        len = llGetListLength(modenames);
        shortnames = [];
        for(i=0;i<len;i++)
        {
            string m = llList2String(modenames, i);
            shortnames += llGetSubString(m,0,ShortLength);
            llOwnerSay(m);
        }
        mode = ModeSummary;		// set to default mode "summary"

        llListen(achan,"",llGetOwner(),"");
        llListen(mchan,"",llGetOwner(),"");
    }

    listen(integer c,string n,key id,string m)
    {
        if(achan == c)
            query(str_replace(m," ","_"), mode);
        else if (mchan == c)
        {
            // defaults to tmode = mode when no match found
            string tmode = llList2String([mode]+modenames, llListFindList(shortnames,[llGetSubString(m,0,ShortLength)])+1);
            // end of look for mode

            if(ModeSource == tmode)
            {
                // set source
                string newsource = llGetSubString(llList2String(llParseString2List(m,[" "],[]),1),0,ShortWikiLength);
                integer i = llListFindList(shortwikis,[newsource]);
                if ( i > -1 )
                {
                    i *= 2;
                    wiki = llList2String(urls,i);
                    url = llList2String(urls,i+1);
                    llOwnerSay("Setting source to " + url);
                }
            }
            else if(ModeWikis == tmode)
            {
                llOwnerSay("To change source chat  /" + (string)mchan + " source <wiki name>");
                integer i;
                integer len = llGetListLength(urls);
                for(i=0;i<len;i+=2)
                    llOwnerSay(llList2String(urls,i) + "\t\t @ " + llList2String(urls,i+1));
            }
            else if(ModeHelp == tmode)
            {
                llOwnerSay("Requesting help...");
                query(help, ModeHelp);
            }
            else if(ModeRecent == tmode)
            {
                string text = "";
                if(!showrecent)
                    text = llDumpList2String(recent,"\n");
                llSetText(text,<1,1,1>,1.);
                showrecent = (!showrecent);
            }
            else if(tmode != mode)
            {
                mode = tmode;  
                llOwnerSay("Setting mode to "+mode);
            }
        }// end channel 5
    }

    touch_start(integer p)
    {
        if(1==p && llDetectedKey(0) == llGetOwner())
            ToggleScale();
    }
        
    timer()
    {
        follow = 0;
        if ( qmode == ModeHelp )
        {
            llOwnerSay(help+" timed out.");
            qmode = ModeFull;
            hid = llHTTPRequest(help,meta,"");
        }
        else
        {
            hid = NULL_KEY;
            llOwnerSay("Query timed out.");
            llSetTimerEvent(0.);
        }
    }

    http_response(key request_id, integer status, list metadata, string body)
    {
        if (request_id == hid)
        {
            hid = NULL_KEY;
            llSetTimerEvent(0.);
            if(ModeSummary==qmode || ModeFull==qmode || ModeHelp == qmode)
            {
                // article or full

                // junk                  
                // image = (key)llGetSubString(body,5,40); // image key if available
                // llSetTexture(image,ALL_SIDES);

                if(llSubStringIndex(body,"#REDIRECT")!=0)
                {
                    // no redirect
                    if( ModeSummary == qmode)
                    {
                        // if summary mode,
                        llOwnerSay(body);
                    }
                    else if( oldbody != body)
                    {
                        oldbody = body;
                        // if(0 == section && llSubStringIndex(body,"=")!=0)
                            llOwnerSay(llGetSubString(body,0,llSubStringIndex(body,"\n="))); //truncate at first line that starts with =
                        // else // if(section >0)
                        //     llOwnerSay(body);
                        if(body != "")
                        {
                            ++section ; // increment section, will now be greater then 0
                            hid = llHTTPRequest(qname + "&templates=expand&section=" + (string)section, meta, ""); // query name more
                            llSetTimerEvent(TIMEOUT);
                        }
                    }
                }
                else if(follow< 3)
                {
                    // if redirect and less than 3 jumps
                    integer start = llSubStringIndex(body,"[[") + 2;
                    integer end = llSubStringIndex(body,"]]") -1;
                    ++follow;
                    llSetTimerEvent(TIMEOUT);
                    string name = url+str_replace(llGetSubString(body,start, end)," ","_");
                    // llOwnerSay("Redirecting to: "+name);
                    hid = llHTTPRequest(name, meta, "");
                }
                else
                    llOwnerSay("Too many redirects");
            }
            else if(ModeCategories == qmode || ModeWord == qmode)
            {
                string temp = "Category:";
                if ( ModeWord == qmode)
                    temp = "title=\"";
                // xml categories or titles
                list catraw = llParseString2List(body,[temp],[]);
                while(catraw != [])
                {
                    temp = llList2String(catraw,0);
                    catraw = llDeleteSubList(catraw, 0, 0);
                    llOwnerSay(llGetSubString(temp,0,llSubStringIndex(temp,"\"")-1));
                }
            }
        }
    }
}
