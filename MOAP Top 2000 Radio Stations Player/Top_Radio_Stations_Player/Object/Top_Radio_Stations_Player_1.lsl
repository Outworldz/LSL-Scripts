// :SHOW:1
// :CATEGORY:Radio
// :NAME:MOAP Top 2000 Radio Stations Player
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2012-09-04 15:30:52.010
// :EDITED:2022-07-10  08:22:08
// :ID:902
// :NUM:1278
// :REV:1.1
// :WORLD:Second Life, OpenSim
// :DESCRIPTION:
// This is an automatically updating radio player with several thousand stations.// If your land is owned by a group, you will need to deed the prim to the group. Just edit the prim that the script is in, set 'Group:' to the same group as the land, and click 'Share with Group'.  Then click the prim and select the Cartegory and radio station and enjoy free music!
// :CODE:

// More information on this radio player is at <a href="http://www.outworldz.com/Secondlife/posts/streaming">this link</a>
// Copyright 2010 Fred Beckhusen (Ferd Frederix)
// License:
// Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License
// http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US
// That means this must always be free.

// V1.1 allow longer names

integer mode ;            // true if we are in refresh mode
list lCategories;        // list of categories
list  lStations;        // list of stations
key http_request_id;    // key of the current HTTP request
integer busy = 0;        // go away, I'm budy

integer type;    // 3 possible http transactions
string genre;    // the category
string url;        // the last URL
string station;    // current station
integer menuChannel;    // int of the channel number
key user;            // the poerson who touched me
integer listen_id;    // int of the current listener
string pubpriv = "Public";

// from the menu system http://wiki.secondlife.com/wiki/SimpleDialogMenuSystem
integer N_DIALOG_CHOICES;
integer MAX_DIALOG_CHOICES_PER_PG = 8; // if not offering back button, increase this to 9
string PREV_PG_DIALOG_PREFIX = "< Page ";
string NEXT_PG_DIALOG_PREFIX = "> Page ";
string DIALOG_DONE_BTN = "Done";
string DIALOG_BACK_BTN = "<< Back";

integer pageNum;
list DIALOG_CHOICES;

giveDialog(key ID, integer pageNum) {

    list buttons;
    integer firstChoice;
    integer lastChoice;
    integer prevPage;
    integer nextPage;
    string OnePage;

    CancelListen();

    menuChannel = llCeil(llFrand(1000000) + 11000000);
    listen_id = llListen(menuChannel,"","","");
    mode = FALSE;
    llSetTimerEvent(60);


    N_DIALOG_CHOICES = llGetListLength(DIALOG_CHOICES);


    if (N_DIALOG_CHOICES <= 10) {
        buttons = DIALOG_CHOICES;
        OnePage = "Yes";
    }
    else {
        integer nPages = (N_DIALOG_CHOICES+MAX_DIALOG_CHOICES_PER_PG-1)/MAX_DIALOG_CHOICES_PER_PG;


        if (pageNum < 1 || pageNum > nPages) {
            pageNum = 1;
        }
        firstChoice = (pageNum-1)*MAX_DIALOG_CHOICES_PER_PG;

        lastChoice = firstChoice+MAX_DIALOG_CHOICES_PER_PG-1;


        if (lastChoice >= N_DIALOG_CHOICES) {
            lastChoice = N_DIALOG_CHOICES;
        }
        if (pageNum <= 1) {
            prevPage = nPages;
            nextPage = 2;
        }
        else if (pageNum >= nPages) {
            prevPage = nPages-1;
            nextPage = 1;
        }
        else {
            prevPage = pageNum-1;
            nextPage = pageNum+1;
        }
        buttons = llList2List(DIALOG_CHOICES, firstChoice, lastChoice);
    }


    // FYI, this puts the navigation button row first, so it is always at the bottom of the dialog
    list buttons01 = llList2List(buttons, 0, 2);
    list buttons02 = llList2List(buttons, 3, 5);
    list buttons03 = llList2List(buttons, 6, 8);
    list buttons04;
    if (OnePage == "Yes") {
        buttons04 = llList2List(buttons, 9, 11);
    }
    buttons = buttons04 + buttons03 + buttons02 + buttons01;

    if (OnePage == "Yes") {
        buttons = [ DIALOG_DONE_BTN, DIALOG_BACK_BTN ]+ buttons;
        //omit DIALOG_BACK_BTN in line above  if not offering

    }
    else {
        buttons = [
            PREV_PG_DIALOG_PREFIX + (string)prevPage,
            DIALOG_BACK_BTN, NEXT_PG_DIALOG_PREFIX+(string)nextPage, DIALOG_DONE_BTN
                ]+buttons;
        //omit DIALOG_BACK_BTN in line above if not offering
    }
    llDialog(ID, "Page "+(string)pageNum+"\nChoose one:", buttons, menuChannel);
}


CancelListen() {
    llListenRemove(listen_id);
    llSetTimerEvent(3600);
    mode = TRUE;
}


list shrink(list in)
{
    list out;
    integer i;
    integer j = llGetListLength(in);
    for (; i < j; i++)
    {
        out += llGetSubString( llList2String(in,i), 0, 23);// V1.1 longer names
    }
    return out;
}

setStation()
{
    llOwnerSay("Station set to " + genre + ":" + station + ":" + url);
    llSetParcelMusicURL(url);
}

getCategories()
{
    type = 1;
    busy = TRUE;
    string url = "http://www.outworldz.com/cgi/shoutcast.plx?search=1";
    http_request_id = llHTTPRequest(url, [], "");
}

getCategory()
{
    type = 2;
    busy = TRUE;
    string url = "http://www.outworldz.com/cgi/shoutcast.plx?genre=" + llEscapeURL(genre);

    //    llOwnerSay(url);

    http_request_id = llHTTPRequest(url, [], "");
}

getURL()
{
    type = 3;
    busy = TRUE;
    string url = "http://www.outworldz.com/cgi/shoutcast.plx?genre=" + llEscapeURL(genre) + "&station=" + llEscapeURL(station);

    //llOwnerSay(url);

    http_request_id = llHTTPRequest(url, [], "");
}



default {

    on_rez(integer start_param)
    {
        llResetScript();
    }

    state_entry()
    {
        getCategories();
        pageNum = 1;
    }



    touch_start(integer touchNumber)
    {
        user =  llDetectedKey(0);
        if (!busy)
        {
            DIALOG_CHOICES = [pubpriv,"Categories","Show URL"];
            giveDialog(user, pageNum);
        }
        else
        {
            llOwnerSay("Still loading stations, please wait a moment");
        }
    }

    listen(integer channel, string name, key id, string message)
    {
        integer where ;
        if (message == "-")
        {
            giveDialog(user, pageNum);
        }
        else if ( message == DIALOG_DONE_BTN)
        {
            CancelListen();
            return;
        }
        else if (message == DIALOG_BACK_BTN)
        {
            pageNum = 1;

            DIALOG_CHOICES = lCategories;
            giveDialog(user, pageNum);
        }
        else if (llSubStringIndex(message, PREV_PG_DIALOG_PREFIX) == 0)
        {
            pageNum = (integer)llGetSubString(message, llStringLength(PREV_PG_DIALOG_PREFIX), -1);
            giveDialog(user, pageNum);
        }
        else if (llSubStringIndex(message, NEXT_PG_DIALOG_PREFIX) == 0)
        {
            pageNum = (integer)llGetSubString(message, llStringLength(NEXT_PG_DIALOG_PREFIX), -1);
            giveDialog(user, pageNum);

        } else { //this is the section where you do stuff
                if (message == "Categories")
                {
                    DIALOG_CHOICES = lCategories;
                    giveDialog(user, pageNum);
                }
            else if (message == "Public")
            {
                pubpriv = "Private";
                pageNum = 1;
                DIALOG_CHOICES = lCategories;
                giveDialog(user, pageNum);

            }
            else if (message == "Private")
            {
                pubpriv = "Public";
                DIALOG_CHOICES = lCategories;
                pageNum = 1;
                giveDialog(user, pageNum);
            }
            else if (message == "Show URL")
            {
                string url = llGetParcelMusicURL();
                if (pubpriv == "Public")
                {
                    llSay(0,"Parcel URL is " + url);
                }
                else
                {
                    llOwnerSay("Parcel URL is " + url);
                }

                pageNum = 1;

                giveDialog(user, pageNum);

            }
            else
            {
                CancelListen();

                where = llListFindList(lCategories,[message]);
                if (where >= 0)
                {
                    genre = message;
                    getCategory();
                    return;
                }

                where = llListFindList(lStations,[message]);
                if (where >= 0)
                {
                    station = message;
                    getURL();
                }
            }
        }
    }

    http_response(key request_id, integer status, list metadata, string body)
    {
        llSay(0,body);
        if (request_id == http_request_id)
        {
            busy = FALSE;
            if (type == 1)
            {
                lCategories = llParseString2List(body,["|"],[]);
                lCategories= shrink(lCategories);
                DIALOG_CHOICES = lCategories;

            }
            else if (type == 2)
            {
                lStations = llParseString2List(body,["|"],[]);
                lStations= shrink(lStations);
                DIALOG_CHOICES = lStations;
                pageNum = 1;
                giveDialog(user, pageNum);
            }
            else if (type == 3)
            {
                url = body;
                setStation();
            }

        }
    }


    timer()
    {
        if (mode)
        {
            getCategories() ;
        }
        else
        {
            llListenRemove(listen_id);
            llWhisper(0, "Sorry. The menu timed out, click me again to change stations.");
            mode = TRUE;
            llSetTimerEvent(3600.0); //Stop the timer from being called repeatedly
        }

    }

}
