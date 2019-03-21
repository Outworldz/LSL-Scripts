// :CATEGORY:ChatBot
// :NAME:ChatBot
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2014-08-11 17:28:45
// :EDITED:2014-08-11
// :ID:1038
// :NUM:1620
// :REV:1.0
// :WORLD:Second Life, OpenSim
// :DESCRIPTION:
// Chatbot for PersonalityForge. Get a free  account at http://www.personalityforge.com.
// 5,000 chats are free.
// Get an API ID, and add it to the apiKey below
// Add the domain *.secondlife.com or your OpenSim server IP to the list of authorized domains at http://www.personalityforge.com/botland/myapi.php
// add a checkmark to the Enable Simple API
// click on the Simple API tab and pick a chatbot ID from the list of chatbots under the heading "Selecting A Chat Bot ID"
// for example, Countess Elvira is 99232.  Put that in chatBot ID below.
// 754 is for a ssex flirt.

// :CODE:
key requestid;
string apiKey = "jkeU6Hv3tbk318wn1";    // your supplied apiKey from your Chat Bot API subscription
string chatBotID = "754";    // the ID of the chat bot you're talking to
integer debug = FALSE;

DEBUG(string msg)
{
    if (debug) llSay(0,msg);
}

default
{
    state_entry()
    {
        llListen(0,"","","");
    }

    on_rez(integer param)
    {
        llResetScript();
    }

    listen(integer channel, string name, key id, string message)
    {

         // if the speaker is a prim, it will have a creator
        list what = llGetObjectDetails(id,[OBJECT_CREATOR]);
        key spkrKey = llList2Key(what,0);

        if (spkrKey != NULL_KEY)
        {
            return;    // we do not want to listen to objects
        }
        
        list names = llParseString2List(name,[" "],[]);
        string firstname = llList2String(names,0);
        string lastname = llList2String(names,1);
        
        requestid = llHTTPRequest("http://www.personalityforge.com/api/chat"
            + "?apiKey="         + llEscapeURL(apiKey)
            + "&message="        + llEscapeURL(message)
            + "&chatBotID="      + llEscapeURL(chatBotID)
            + "&externalID="     + llEscapeURL(name)
            + "&firstName="      + llEscapeURL(firstname)
            + "&lastName="       + llEscapeURL(lastname)
            ,[HTTP_METHOD,"GET"],"");
    }
    http_response(key request_id, integer status, list metadata, string body)
    {

        DEBUG(body);
        // typical body:
        // Checking origin: '71.252.253.190' (regex: '71\.252\.253\.190')<br>Matched!<br>{"success":1,"errorMessage":"","message":{"chatBotName":"Liddora","chatBotID":"754","message":"Look up. It's Liddora. So how have you been lately, hello?","emotion":"asking"}}
        
        if (request_id == requestid)
        {
            integer  begin = llSubStringIndex(body, "message\":\"");
            DEBUG((string) begin);
            
            string msg =  llGetSubString(body, begin +10, -1);
            DEBUG((string) msg);
            
            integer  end = llSubStringIndex(msg, "emotion");
            DEBUG((string) end);
             
            string reply = llGetSubString(msg, 0, end-4);         
            llSay(0,reply);
        }
    }
}
