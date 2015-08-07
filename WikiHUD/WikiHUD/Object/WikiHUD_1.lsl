// :CATEGORY:WIKI Reader
// :NAME:WikiHUD
// :AUTHOR:Lillie Yifu
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:09
// :ID:980
// :NUM:1402
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// WikiHUD is a simple utility that reads pages from a wiki into Second Life. One WikiHUD reads pages from this Wiki. The code reads the raw contents of an article from this wiki. Originally written by Lillie Yifu. The code is open source and the freebie wikiHUD is full permissions.// // The secondlife wikiHUD works by listening on channel 4 for the name of an article, and then returning the search. The simple version only returns a summary.// // Version 1.02 of the wikiHUD has several command modes.
// 
// Because wikiMedia is case sensitive in article names, so are the requests.
// 
// edit Command Modes
// 
// In summary mode it returns the first 2048 characters of the article.
// 
// In full mode it returns the first 2048 characters of each section of the article, which means that if each section is less than 2048, it returns the whole article.
// 
// In category mode it returns the categories an article belongs to.
// 
// In word mode it returns the list of articles with the word in the title of the article.
// 
// In help mode it returns the help page. (See WikiHUD (Help) )
// edit In World Texture Display
// 
// The wikiHUD will display a full permissions texture if it is placed in the first line of an article entry in the {{ik|}} template, with the UUID or key of a full permissions texture after the | character. 
// :CODE:
// wiki reader 1.05 Lillie Yifu
// http://sexsecond.blogspot.com
// chat on channel 4 the name of an article to get the top of the entry text
// permission is granted to distribute this script free and open source with the header attached


// adding second channel to listen for mode changes
// adding category mode

list wikis = ["wikia","lindenlab","caledon"];
list urls =  ["http://secondlife.wikia.com","http://wiki.secondlife.com","http://caledonwiki.com"];
string help = "WikiHUD (Help)";
integer sources;
integer oldmode;
integer wiki = 0;

string oldbody = "";
float alpha = 1.;
string redirect = "#REDIRECT";
integer section ;
integer follow= 0;
integer redirlen;
string qname;
list meta = [HTTP_MIMETYPE,"text/plain;charset=utf-8"];
key hid;
string name;

key image = "f07b2853-6aa2-7819-cbde-a1bf4187091d";
vector large = <0.01,0.3,.3>;
vector small = <0.01,0.1,0.1>;
integer islarge =TRUE;
integer qmode = 0;//mode of query
integer oldqmode = 0;
integer mode = 0;//mode of command

list recent = [];
integer showrecent = FALSE;
integer recentlimit = 5;


string url;
integer modes;
//action=query&#8195;&&#8195;list=search&#8195;&&#8195;srsearch=wikipedia&#8195;&&#8195;srlimit=10
list modenames = ["summary","categories","word","full","source","wikis","help","recent"];
list phps = [ 
"/index.php?action=raw&title=",
"/api.php?format=xml&prop=categories&action=query&titles=",
"/api.php?format=xml&action=query&list=search&srlimit=20&srsearch=",
"/index.php?action=raw&title="
];
//string url = "http://en.wikipedia.org/index.php?action=raw&title=";
integer achan = 4;
integer mchan = 5;

integer query(string article)
{
                    qmode = mode;
                    qname=url+llList2String(phps,qmode)+article;
                name = qname +"&section=0"; // section postpend
                llOwnerSay(name+" "+ llList2String(modenames,mode));
                hid = llHTTPRequest(name, meta, "");
                recent = llList2String(wikis,wiki)+":"+llUnescapeURL(article)+llList2List(recent,0,recentlimit);
                if(showrecent) {
                    llSetText(llDumpList2String(recent,"\n"),<1.,1.,1.>,alpha);
                }
                section =-1;
                return 0;
}


string str_replace(string src, string from, string to)
{//replaces all occurrences of 'from' with 'to' in 'src'.
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

default
{
    state_entry()
    {
        llSetText("",<1.,1.,1.>,alpha);
        integer i = 0;
        url = llList2String(urls,wiki);
        sources = llGetListLength(wikis);
        modes = llGetListLength(modenames);
        llSetTexture(image,ALL_SIDES);
        llOwnerSay("Chat on channel "+(string) achan+" the name of an article to reference the Second Life Wiki.");
        llOwnerSay("Chat on channel "+(string) mchan+" to change query mode.");
        for(;i<modes;++i) {
            llOwnerSay(llList2String(modenames, i));
        }
        
        llListen(achan,"",llGetOwner(),"");
        llListen(mchan,"",llGetOwner(),"");
    }

    listen(integer c,string n,key id,string m)
    {
        string article = str_replace(m," ","_");
        article = llEscapeURL(article);
        
       
        if(achan==c) {
            if(0==mode|| 3==mode) {
                query(article);
                
            } else if(1==mode) {
                name = url+llList2String(phps,mode)+article;
                llOwnerSay(name+" "+ llList2String(modenames,mode));
                hid = llHTTPRequest(name, meta, "");
                qmode = mode;
            } else if(2==mode) {// will need a loop here
                name = url+llList2String(phps,mode)+article;
                llOwnerSay(name+" "+ llList2String(modenames,mode));
                hid = llHTTPRequest(name, meta, "");
                qmode = mode;
            }
                
        } else if (mchan ==c) { 
        
            integer i =0;
             oldmode = mode;
            for(;i<modes;++i) {
                if(llGetSubString(m,0,2) == llGetSubString(llList2String(modenames,i),0,2) ){
                    mode = i;
                    i=modes;
                    }
                }// end look for mode
                if(4 == mode) { // set source
                    list parse = llParseString2List(m,[" "],[]);
                    string newsource = llGetSubString(llList2String(parse,1),0,3);
                    for(i=0;i<sources;++i) { // I should sort and search... 
                        if(llGetSubString(llList2String(wikis,i),0,3)==newsource) {
                            wiki = i;
                            url = llList2String(urls,wiki);
                            llOwnerSay("Setting source to " + url);
                            i=sources;
                            }
                        }
                    mode = oldmode; // set mode to default, we should never stay here.
                } else if(5 ==mode) {
                        llOwnerSay("To change source chat  /" + (string)mchan + " source <wiki name>");
                        for(i=0;i<sources;++i) {
                            llOwnerSay(llList2String(wikis,i) + "\t\t @ " + llList2String(urls,i));
                        }
                        mode = oldmode; // set mode  back, we should never stay here
                } else if(6==mode) {
                        llOwnerSay("Getting help...");
                        article = help;
                        article = llEscapeURL(article);
                        mode = 3;
                        query(article);
                        oldqmode = qmode;
                        qmode = 3;
                        hid = llHTTPRequest(help,meta,"");
                        mode = oldmode;
                } else if(7==mode) {
                    if(showrecent){
                        llSetText("",<1,1,1>,1.);
                        showrecent = FALSE;
                    } else {
                        showrecent = TRUE;
                        llSetText(llDumpList2String(recent,"\n"),<1.,1.,1.>,alpha);
                    }
                    
                    mode = oldmode;
                } // end of mode processing
            if(mode!= oldmode) {
                    llOwnerSay("Setting mode to "+llList2String(modenames,mode));
                }
            }// end channel 5
        }
            
            
            
    
    on_rez(integer p)
    {
        llResetScript();
    }
    touch_start(integer p)
    {
        if(1==p) {
        if(islarge) {
                llSetScale(small);
                islarge = FALSE;
                alpha = .3;
                
            } else {
                llSetScale(large);
                islarge = TRUE;
                alpha=1.;
            }
            llSetAlpha(alpha,ALL_SIDES);
        } 
    }
        
        timer()
        {
            if(hid){
                hid = NULL_KEY;
                follow = 0;
                llOwnerSay("Query timed out.");
            }
            llSetTimerEvent(0.);
        }

    http_response(key request_id, integer status, list metadata, string body)
    {
        if(0==qmode || 3==qmode) { // article or full
            key image;
            if (request_id == hid) {
                    
                    image = (key)llGetSubString(body,5,40); // image key if available
                    llSetTexture(image,ALL_SIDES);
                    follow = TRUE;
                if(llSubStringIndex(body,redirect)!=0) { // no redirect
                
                    if( qmode == 0) { // if summary mode,
                        llOwnerSay(body); 
                        return;
                    } else {
                        if(0 == section && llSubStringIndex(body,"=")!=0) {
                            llOwnerSay(llGetSubString(body,0,llSubStringIndex(body,"\n="))); //truncate at first line that starts with = 
                            oldbody = body;
                        } else if( oldbody == body) {
                            body = "";
                            oldbody = "";
                        } else if(section >0) {
                            llOwnerSay(body);
                            oldbody = body;
                        }
                        }
                        if(body !="") {    
                            ++section ; // increment section, will now be 0
                            name = qname + "&templates=expand&section=" + (string) section; // query name
                            hid = llHTTPRequest(name, meta, "");
                        }
                    }
                        
                        

                } else if(follow< 3) {// if redirect and less than 3 jumps
                    
                    integer start = llSubStringIndex(body,"[[") + 2;
                    integer end = llSubStringIndex(body,"]]") -1;
                    string m = llGetSubString(body,start, end);
                    ++follow ;
                    llSetTimerEvent(180.); 
                    name=url+str_replace(m," ","_");
                    list meta = [HTTP_MIMETYPE,"text/plain;charset=utf-8"];
                    hid = llHTTPRequest(name, meta, "");
                } else {
                    hid = NULL_KEY;
                    follow=0;
                    llOwnerSay("Too many redirects");
                }
            } else if(1 == qmode) {// xml categories
                list catraw = llParseString2List(body,["Category:"],[]);
                integer i = 1;
                string temp;
                for(;i<llGetListLength(catraw);++i){
                    temp = llList2String(catraw,i);
                    llOwnerSay(llGetSubString(temp,0,llSubStringIndex(temp,"\"")-1));
                }
            } else if(2 == qmode) {
                 list catraw = llParseString2List(body,["title=\""],[]);
                integer i = 1;
                string temp;
                for(;i<llGetListLength(catraw);++i){
                    temp = llList2String(catraw,i);
                    llOwnerSay(llGetSubString(temp,0,llSubStringIndex(temp,"\"")-1));
                }
            }
    }
        
}
