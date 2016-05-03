// :SHOW:
// :CATEGORY:Chart
// :NAME:ThingSpeak Chart
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2016-05-02 13:04:51
// :EDITED:2016-05-02  12:04:51
// :ID:1106
// :NUM:1894
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// An attempt at making Thingspeak charts in SL
// :CODE:

integer osIsNpc(key UUID) { return 0; }


string wAPIKey = "419JVLGPPTCM5TZ1";

string ChannelID = "47964";
string fieldID = "field1";

list exclude = [];
// You can add a list of name of people to exclude, such as your name.
// list exclude = ["Nara Malone","Ferd Frederix"];

integer debug = FALSE;
integer hovertext = TRUE;    // shows visitor count, or not
integer ToDo;
integer timeGoneBy = 0;

DEBUG(string msg)
{
    if (debug ) llOwnerSay(msg);
}

key http_request_id;
list ToDoURL;

default
{

    state_entry()
    {
        llSetText("", <1,1,1>, 1);

        string url = "https://api.thingspeak.com/update?api_key="
                                + wAPIKey
                                + "&"
                                + "title"
                                + "="
                                + "Visitors";
                            
        http_request_id = llHTTPRequest(llList2String(ToDoURL,0), [], "");
        llSetTimerEvent(1);
    }
    
    timer()
    {
        if (ToDo == 0 &&  timeGoneBy )
        {
            DEBUG((string) timeGoneBy);
            timeGoneBy--;
            return;
        }

        if (ToDo == 0 &&  !timeGoneBy )
        {
            timeGoneBy = 60;
            
            ToDoURL = [];
            
            list keys = llGetAgentList(AGENT_LIST_REGION,[]);
            
            integer i;
            for (i=0; i < llGetListLength(keys); ++i)
            {
                key UUID = llList2Key(keys,i);
                if (!osIsNpc(UUID)) {
                    string name = llKey2Name(UUID);    // name
                    DEBUG("Checking " + name);

                    if (hovertext)    llSetText(name, <1,1,1>, 1);
                    if (llListFindList(exclude,[name]) == -1)
                    {
                        list details = llGetObjectDetails(UUID, [OBJECT_POS]) ; // pos
                        vector pos = llList2Vector(details,0);
                        string x = (string) pos.x;
                        string y = (string) pos.y;
                        string z = (string) pos.z;

                        // parcel
                        details = llGetParcelDetails(pos,[PARCEL_DETAILS_NAME]);
                        string parcel = llList2String(details,0); 
 
                        string url = "https://api.thingspeak.com/update?api_key=" + wAPIKey
                                + "&field1=" + x;
                                + "&field2=" + y;

                        DEBUG(url);
                        ToDoURL += url;
                    }
                }
            }
            ToDo = 1;   // send them
        }
        else if (ToDo == 1)
        {
            if (llGetListLength(ToDoURL) == 0)
            {
                ToDo = 0;
                return;
            }

            DEBUG(llList2String(ToDoURL,0));
            http_request_id = llHTTPRequest(llList2String(ToDoURL,0), [], "");

            ToDoURL  = llDeleteSubList(ToDoURL,0,0);
        }
    }

    http_response(key request_id, integer status, list metadata, string body)
    {
        if (request_id == http_request_id)
        {
            if (hovertext)
                llSetText("Click for Stats", <0,0,1>, 1);
            
            DEBUG(body);
        }
    }

    touch_start(integer p)
    {
        if (llDetectedKey(0) == llGetOwner())
        {
            llLoadURL(llGetOwner(), "Click to view vistors", "https://thingspeak.com/channels/"
                + ChannelID
                + "/"
                + fieldID);
        }
    }

}
