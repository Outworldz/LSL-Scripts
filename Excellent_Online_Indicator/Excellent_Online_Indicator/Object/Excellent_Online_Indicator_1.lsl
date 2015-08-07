// :CATEGORY:Online Indicator
// :NAME:Excellent_Online_Indicator
// :AUTHOR:Kristy Fanshaw 
// :CREATED:2011-01-22 12:53:33.923
// :EDITED:2013-09-18 15:38:52
// :ID:288
// :NUM:386
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Copyright © 2008 by Kristy Fanshaw// // This program is free software: you can redistribute it and/or modify// it under the terms of the GNU General Public License as published by// the Free Software Foundation, either version 3 of the License, or// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
// 
To get a copy of the GNU General Public License, see <http://www.gnu.org/licenses/>.
// Online Indicator
// 
// Place this script in a box you've created.
// 
// What it does:
// 
//    1. This script will create hover text with resident name and online status.
//    2. Will show resident profile picture on the object if it's avaliable in search
//    3. On touch the toucher can send IM to the resident by typing the message into main chat.
//    4. Offers a link in main chat to open resident profile.
   5. finding a user key visit http://search.secondlife.com/search.php. Type the name in search and press "go". In results you see either only "Resident profile: name" or "Resident profile: name" and other results.
// 
click on the result and you'll find the UUID in the URL of the page. ("secondlife:/app/agent/User_key/about" or "http://world.secondlife.com/resident/User_key") 
// :CODE:
////////////////////////////////////////////////////////////////////////////////////////////////
//    Copyright (c) 2008 by Kristy Fanshaw                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////
//   This program is free software: you can redistribute it and/or modify                     //
//    it under the terms of the GNU General Public License as published by                    //
//    the Free Software Foundation, either version 3 of the License, or                       //
//    (at your option) any later version.                                                     //
//                                                                                            //
//    Online Indicator is distributed in the hope that it will be useful,                     //
//    but WITHOUT ANY WARRANTY; without even the implied warranty of                          //
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                           //
//    GNU General Public License for more details.                                            //
//                                                                                            //
//    To get a copy of the GNU General Public License, see <http://www.gnu.org/licenses/>.    //
////////////////////////////////////////////////////////////////////////////////////////////////
 
key user_key = "00000000-0000-0000-0000-000000000000";       // must be agent UUID whose status it will indicate
integer time = 30;                                           // time within the message should be written.
string url = "http://world.secondlife.com/resident/";
key blank = TEXTURE_BLANK;
string name;
key toucher;
string status;
 
// VD 2009-11-24 workaround for WEB-1383, use <meta> instead of <img>
// VD 2009-11-25 try <img> if meta tag gets removed in the future
string profile_key_prefix = "<meta name=\"imageid\" content=\"";
string profile_img_prefix = "<img alt=\"profile image\" src=\"http://secondlife.com/app/image/";
integer profile_key_prefix_length; // calculated from profile_key_prefix in state_entry()
integer profile_img_prefix_length; // calculated from profile_img_prefix in state_entry()
 
//string profile_key_prefix = "<meta name=\"imageid\" content=\"";
//integer s1l;
 
default
{
    state_entry()
    {
        profile_key_prefix_length = llStringLength(profile_key_prefix);
        profile_img_prefix_length = llStringLength(profile_img_prefix);
        llSetText("", <1,0,0>, 1.0);
        llSetTexture(blank, ALL_SIDES);
        llRequestAgentData( user_key, DATA_NAME);   
    }
    dataserver(key queryid, string data)
    {
        name = data;
        llSetObjectName(name + "'s Online Detector");
        state show;
    }
}
state show
{   
    state_entry()
    {
        llSetTimerEvent(10);
    } 
    timer()
    {
        llHTTPRequest( url + (string)user_key,[HTTP_METHOD,"GET"],"");
        llRequestAgentData( user_key, DATA_ONLINE);   
    } 
    on_rez(integer start_param)
    {
        llSetText("", <1,0,0>, 1.0);
        llSetTexture(blank, ALL_SIDES);
    } 
    http_response(key request_id,integer status, list metadata, string body)
    {
        string profile_pic;
        integer s1 = llSubStringIndex(body, profile_key_prefix);
        integer s1l = profile_key_prefix_length;
        if(s1 == -1)
        { // second try
            s1 = llSubStringIndex(body, profile_img_prefix);
            s1l = profile_img_prefix_length;
        }
 
        if (s1 == -1)
        { // still no match?
            profile_pic = blank;
        }
        else
        {
            profile_pic = llGetSubString(body,s1 + s1l, s1 + s1l + 35);
            if (profile_pic == (string)NULL_KEY)
            {
                profile_pic = blank;
            }
        }
        llSetTexture(profile_pic, ALL_SIDES);
    }
   

    dataserver(key queryid, string data)
    {
        if ( data == "1" ) 
        {
            status = " is online";
           llMessageLinked(2, 16, "Turn On", ""); /// added for child script
            llSetText(name + status, <0,1,0>, 1.0);
        }
        else if (data == "0")
        {
            status = " is offline";
            llMessageLinked(2, 16, "Turn Off", ""); // added for child script
            llSetText(name + status, <1,0,0>, 1.0);
        }
 
    }
    touch_start(integer num_detected)
    {
        toucher = llDetectedKey(0);
        state msg;
    }
}
state msg
{
    state_entry()
    {
        llListen(0,"",toucher,"");
        llInstantMessage(toucher, "write your message to " + name +" - you have " +(string)time + " seconds");
        llInstantMessage(toucher, "to see " + name +"'s profile, click this link here: secondlife:///app/agent/" + (string)user_key + "/about");
        llSetTimerEvent(time);   
    }
    listen(integer ch, string name, key id, string msg)
    {
        llInstantMessage(user_key, llKey2Name(toucher) + " sent you a message from " + llGetRegionName() + ": " + msg);
        llInstantMessage(toucher, "message is sent.");
        llListenRemove(0);
        state show;
    }
    timer()
    {
        llInstantMessage(toucher, "time is up - touch again to write a message");
        llListenRemove(0); 
        state show;
    }
}
