//
// HYPEvents in-world teleporter board script
//
// Author: Tom Frost <tomfrost@linkwater.org>
//
// GPLv3
//


// configuration:

float refreshTime = 1800;

// internal, do not touch:
integer lineHeight = 30;
integer startY = 90;
    
integer texWidth = 512;
integer texHeight = 512;
key httpRequest;

list events;

integer channel;

integer listenHandle;
integer listening = 0;

list avatarDestinations = [];

//
// manipulate global avatarDestinations list
//
// insert or overwrite destination for agent with dest
//
tfSetAvatarDest(key agent, string dest)
{
    list newList = [];
    integer idx;
    integer len = llGetListLength(avatarDestinations)/2;
    integer set = FALSE;
    
    for(idx=0;idx<len;idx++) {
        key avatar = llList2Key(avatarDestinations, (idx*2));
        if(avatar==agent) {
            newList += [ agent, dest ];
            set = TRUE;
        } else {
            newList += [ avatar, llList2String(avatarDestinations, (idx*2)+1) ];
        }
    }
    if(!set) {
        newList += [ agent, dest ];
    }
    
    avatarDestinations = newList;
}

//
// retrieve avatar dest from global avatarDestination list
//
// returns hgurl if destination set, NULL_KEY otherwise
//
string tfGetAvatarDest(key agent)
{
    integer idx;
    integer len = llGetListLength(avatarDestinations)/2;
    
    for(idx=0;idx<len;idx++) {
        if(llList2Key(avatarDestinations, (idx*2))==agent) {
            return llList2String(avatarDestinations, (idx*2)+1);
        }
    }
    return NULL_KEY;
}

doRequest()
{
    httpRequest = llHTTPRequest("http://hypevents.net/events.lsl", [], "");
}

string tfTrimText(string in, string fontname, integer fontsize,integer width)
{
    integer i;
    integer trimmed = FALSE;
        
    for(;llStringLength(in)>0;in=llGetSubString(in,0,-2)) {
    
        vector extents = osGetDrawStringSize("vector",in,fontname,fontsize);
        
        if(extents.x<=width) {
            if(trimmed) {
                return in + "..";
            } else {
                return in;
            }
        }
        
        trimmed = TRUE;
    }

    return "";
}

refreshTexture()
{
    string commandList = "";
    
    integer fontSize=50;
    
    commandList = osMovePen(commandList, 20, 5);
    commandList = osDrawImage(commandList, 400, 70, "http://linkwater.org/dyntex/hypevents_logo.png");
    
    commandList = osSetPenSize(commandList, 1);
    commandList = osDrawLine(commandList, 0, 80, 512, 80);
    
    integer numEvents = llGetListLength(events)/3;
    
    integer i;

    integer y = startY;
    
    commandList = osSetFontName(commandList, "Arial");
    commandList = osSetFontSize(commandList, 20);
            
    for(i=0;i<numEvents;i++) {
        integer base = i*3;
        
        commandList = osMovePen(commandList, 10, y);
        
        string text = llList2String(events, base+1) + " " + llList2String(events, base);
        text = tfTrimText(text, "Arial", 20, texWidth-40);
        commandList = osDrawText(commandList, text);
        
        y += lineHeight;
    }
    
    osSetDynamicTextureData("", "vector", commandList, "width:"+(string)texWidth+",height:"+(string)texHeight, 0);
}

tfLoadURL(key avatar)
{
    llLoadURL(avatar, "Visit the HYPEvents web-site for more detailed event information and technical information.", "http://hypevents.net/");
}

tfGoToEvent(key avatar, integer eventIndex)
{
    integer numEvents = llGetListLength(events)/3;
    
    integer base = eventIndex * 3;
    
    if(eventIndex<numEvents) {
        string text=llList2String(events, base+0);
        
        text += "\n\n";
        
        text += "The hypergrid url for this event is:\n\n"+llList2String(events, base+2)+"\n\n";
        
        text += "Is this hgurl a hypergrid url for you or a local url?\n\n";
        
        tfSetAvatarDest(avatar, llList2String(events, base+2));
        
        llDialog(avatar, text, ["Hypergrid","Local grid", "Cancel"], channel);
        if(listening==0) {
            listenHandle = llListen(channel, "", NULL_KEY, "");
            listening = (integer)llGetTime();
        }
    } else {
    }
}
 
default
{
    state_entry()
    {
        channel = -25673 - (integer)llFrand(1000000);
        listening = 0;
        avatarDestinations = [];
        llSetTimerEvent(refreshTime);
        doRequest();
    }
    
    http_response(key requestID, integer status, list metadata, string body)
    {   
        if(status==200) {
            events = llParseString2List(body, ["\n"], []);
            refreshTexture();
        } else {
            llOwnerSay("Unable to fetch event.lsl, status: "+(string)status);
        }
    }
    
    listen(integer chan, string name, key agent, string msg)
    {
        if(chan==channel) {
            if(msg!="Cancel") {
                string dest = tfGetAvatarDest(agent);
                if(dest!=NULL_KEY) {
                    string dsturl = dest;
                    if(msg=="Local grid") {
                        list hgurl = llParseString2List(dest, [":"], []);
                        dsturl = llList2String(hgurl, 2);
                    }
                    osTeleportAgent(agent, dsturl, <128.0,128.0,23.0>, <1.0,1.0,0.0> );
                }
            }
        }
    }
    
    touch_end(integer num)
    {
        integer i;
        for(i=0;i<num;i++) {
            vector touchPos = llDetectedTouchUV(i);
            integer touchX = (integer)(touchPos.x * texWidth);
            integer touchY = texHeight - (integer)(touchPos.y * texHeight);
            key avatar = llDetectedKey(i);
            
            if(touchY < 80) {
                tfLoadURL(avatar);
            } else if(touchY>=startY) {
                integer touchIndex;
                
                touchIndex = (integer)((touchY - startY) / lineHeight);
                
                tfGoToEvent(avatar, touchIndex);
            }
        }
    }
    
    timer()
    {
            // timeout listener
        if(listening!=0) {
            if( (listening + 300) < (integer)llGetTime() ) {
                llListenRemove(listenHandle);
                avatarDestinations=[];
                listening = 0;
            }
        }
            // refresh texture
        doRequest();
    }
}