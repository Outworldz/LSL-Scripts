// :SHOW:
// :CATEGORY:ChatBot
// :NAME:NPC Chatbot for Opensim
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2016-07-27 16:13:55
// :EDITED:2016-07-27  15:13:55
// :ID:1108
// :NUM:1906
// :REV:1.0
// :WORLD:OpenSim
// :DESCRIPTION:
// This chatbot is for OpenSim Only. It only works on NPC's with  a modified All-In-One NPC script, which is also included
// 5,000 chats are free.
// :CODE:
// Chatbot uses PersonalityForge. Get a free  account at http://www.personalityforge.com.
// first, get a free  account at http://www.personalityforge.com.
// Get an API ID, and add it to the apiKey : 
  
string apiKey = "BlahBlah";    // your supplied apiKey from your Chat Bot API subscription 


// Add the domain or IP of your OpenSim server to the list of authorized domains at http://www.personalityforge.com/botland/myapi.php
// Add a checkmark to the "Enable Simple API" in your account.
// Click on the Simple API tab and pick a chatbot ID from the list of chatbots under the heading "Selecting A Chat Bot ID"
// for example, Countess Elvira is 99232.  Put that in chatBot ID below.
// Sex Bot Ciran is 100387. 
// 754 is Liddora a sexy tart
  
string chatBotID = "23958";    // the ID of the chat bot you're talking to

// The first time, you may want to test it with this set to TRUE
integer debug = FALSE;  // Set this TRUE to see the gory details

// more constants below
integer greeting = TRUE;     // if TRUE, say hello when anyone comes up. 
integer lookat = FALSE;
     
////////// REMOVE THESE IN WORLD ////////////////
///////// LSLEDIT DEBUG ONLY////////////////////
//osNpcSetRot(key npc, rotation rot) {llSay(0,"Roatating to " + (vector) llRot2Euler(rot));}
//osNpcStopAnimation(key npc, string animation) {llSay(0,"Stopped " + animation);}
//osNpcPlayAnimation(key npc, string animation) {llSay(0,"Playing " + animation);}
//osNpcSay(string speach) {llSay(0,speach);}
/////////////////////////////////////////////////////////////////////

// various  tuneable code bits
float range = 35; // haw far away an avatar is before we greet them/. No point in making this more than 20, that cannot hear us after that
float  wpm = 85; // 33 wpm = 2.75 cps @ 5 chars per word for a typical avatar to type with.
//  Larger numbers make your NPC answer quicker.
float cps;
integer emotionchannel = 199; // a secret channel that the chatbot sends emotion strings on.
                              // You can listen for these with other scripts worn by your chatbot,  and animate something to show how your chat bot is feeling.
                              // this is also sent on Link Message Number 1 to all scripts in your chatbox prim
  
// global variables
key  npcKey ;         // the NPC wearing this
string npcName;       // ditto
integer starttime;    // the time we started typing
key requestid;        // check for out HTTP answer
integer AvatarPresent;// true is someone is here

// first of stride is the response from the bot, the second is the built-in animation
list gAnimations = ["normal", "hello",
                    "happy","express_smile",
                    "angry","express_anger",
                    "averse","express_embarrased",
                    "sad","express_sad",
                    "evil","express_repulsed",
                    "fuming","express_worry",
                    "hurt","express_cry",
                    "surprised","express_surprise",
                    "insulted","express_afraid",
                    "confused","express_shrug",
                    "amused","express_laugh",
                    "asking","express_shrug"];
                    

list lAvatars; // a list of visitors 

DEBUG(string msg)
{
    if (debug) llSay(0,msg);
}

string strReplace(string str, string search, string replace) {
    return llDumpList2String(llParseStringKeepNulls(str, [search], []), replace);
}

string KeyValueGet(string var) {
    list dVars = llParseString2List(llGetObjectDesc(), ["&"], []);
    do {
        list data = llParseString2List(llList2String(dVars, 0), ["="], []);
        string k = llList2String(data, 0);
        if(k != var) jump continue;
        //DEBUG("got " + var + " = " +  llList2String(data, 1));
        return llList2String(data, 1);
        @continue;
        dVars = llDeleteSubList(dVars, 0, 0);
    } while(llGetListLength(dVars));
    return "";
}


default  
{
    on_rez(integer param)
    {
        llResetScript();
    }

    state_entry()
    {
        llOwnerSay("Running");
        npcKey = KeyValueGet("key");
        npcName = llGetObjectName();
        DEBUG("npc is named " + npcName);

        llListen(0,"","","");
        cps = wpm * 5 / 60;    // change from words per minute to cps.
        DEBUG("CPS = " + (string) cps);
        
    }
    
    link_message (integer sender, integer num, string str, key id) {
        if (num == 2) {
            npcKey = id;
            DEBUG("Chatbot npcKey = " + (string) npcKey);
            if (greeting)
                llSensorRepeat("","",AGENT,range,PI,10);
        }
    }

    sensor(integer N) {
        integer i;
        for (i = 0 ; i < N; i ++) {
            key avatarName = llDetectedName(i);

            if (llListFindList(lAvatars,[avatarName]) == -1) {
                osNpcSay(npcKey,"Hi there, " + llDetectedName(i)+ ", the Rapunzel sim is new. Try it" );
                
                lAvatars += avatarName;
                
                if (llGetListLength(lAvatars) > 20) {
                    lAvatars = llDeleteSubList(lAvatars, 0,0);
                }
            } 
        }
    }

    no_sensor()
    {
        AvatarPresent = FALSE;    }

    listen(integer channel, string name, key id, string message)
    {
        DEBUG("I Heard from :" + name);   
       // DEBUG("ID: " + (string) id);
       // DEBUG("npcKey: " + (string) npcKey);
        
        if ( id == npcKey) {
         //   DEBUG("ignoring");
            return;
        }
        
    //   DEBUG("Continuing");
        // if the speaker is a prim, it will have a creator. Avatars do not have a creator
        list what = llGetObjectDetails(id,[OBJECT_CREATOR,  OBJECT_POS]);
        key spkrKey = llList2Key(what,0);
 
        if (spkrKey != NULL_KEY && !debug)
        {
            if (! debug)
               DEBUG("ignoring object ");
               return;    // we do not want to listen to objects
        } 
         
        list names = llParseString2List(name,[" "],[]);
        string firstname = llList2String(names,0);
        string lastname = llList2String(names,1);

        requestid = llHTTPRequest("http://www.personalityforge.com/api/chat"
            + "?apiKey="         + llEscapeURL(apiKey)
            + "&message="        + llEscapeURL(message)
            + "&chatBotID="      + llEscapeURL(chatBotID)
            + "&externalID="     + llEscapeURL(firstname)
            + "&firstName="      + llEscapeURL(firstname)
            + "&lastName="       + llEscapeURL(lastname)
            ,[HTTP_METHOD,"GET"],"");

        llSleep(llFrand(3)+ 1);  // think for two to five seconds before we type  - for realism
 
        osNpcPlayAnimation(npcKey,"avatar_type");
        starttime = llGetUnixTime();
        if (lookat) {
            
            vector vspeaker = llList2Vector(what,1);
            rotation rdelta = llRotBetween( llGetPos(), vspeaker );
            
            rotation   newRot  = rdelta * llGetRot();
             //-- rotate the offset to be relative to npc  rotation - vector now points to speaker
            
            osNpcSetRot(npcKey,newRot); // * = add for quats   
        }
        
        llSetTimerEvent(20);    // for safety in case web site is down.
    }

    timer()
    {
        osNpcStopAnimation(npcKey,"avatar_type");
        llSetTimerEvent(0);
    }

    http_response(key request_id, integer status, list metadata, string body)
    {
        DEBUG(body);
        // typical body:
        // Checking origin: '71.252.253.290' (regex: '71\.252\.253\.290')<br>Matched!<br>{"success":1,"errorMessage":"","message":{"chatBotName":"Liddora","chatBotID":"754","message":"Look up. It's Liddora. So how have you been lately, hello?","emotion":"asking"}}
        
        if (request_id == requestid)
        {
            llSetTimerEvent(0);    // shut off the error handler

               // get the name of the bot from the reponse
            integer botname = llSubStringIndex(body,"chatBotName");
            string namestr = llGetSubString(body,botname,-1);
            integer botnameend = llSubStringIndex(namestr,"\",\"");
            
            string botName =  llGetSubString(namestr,14, botnameend-1);
            DEBUG("Bot Name:" + (string) botName);
    
            integer  begin = llSubStringIndex(body, "message\":\"");
            string msg =  llGetSubString(body, begin +10, -1);
            integer  msgend = llSubStringIndex(msg, "emotion");
            string reply = llGetSubString(msg, 0, msgend-4);
            DEBUG("reponse:" + reply);

            // change the name in the reply to the bots real name.
            DEBUG("reply:" + reply);
            DEBUG("botName:" + botName);
            DEBUG("npcName:" + npcName);
            
            reply = strReplace(reply,"<br>"," ");
            reply = strReplace(reply,"<BR>"," ");
            reply = strReplace(reply,"Laurel",npcName);
            reply = strReplace(reply,"Problem",npcName);
        
            DEBUG("after nameswap:" + reply);
            DEBUG("Len:" + llStringLength(reply));
            // calculate how long it would take for a person to type the answer in cps or wpm
            float delay = (float) llStringLength(reply) / cps;    
            
            DEBUG("delay = " + (string) delay);
            
             integer t = llGetUnixTime() - starttime ;                // subtract how long it has taken to look up the bots answer since we started typing.

            DEBUG("t = " + (string) t);
            delay -= t;
            
            DEBUG("delay = " + (string) delay);
            if (delay > 0) {
                DEBUG("delay:" + (string) delay);
                llSleep(delay)    ;  // fake out the delay that happens when an avatar is typing an answer
            }
             
               
            // Emotion Logic - speak on a chat channel what emotional stste the bot is in, for other scripts to use.
            string emotion =  llGetSubString(msg, msgend,-1);
            DEBUG((string) emotion);
            
            msgend = llSubStringIndex(emotion, "\"}");            
            emotion =  llGetSubString(emotion, 10,msgend-1);          
            DEBUG("Emotion:" + (string) emotion);

            // sends a link animate to prim animator, attempts to play an animation
            // normal, happy, angry, averse, sad, evil, fuming,
            // hurt, surprised, insulted, confused, amused, asking.
            
            llMessageLinked(LINK_SET,1,emotion,"");

            //  and also chats it on channel "emotionchannel" for external gadgetry to respond with.
            llSay(emotionchannel,emotion);  // for controlling external gadgets based on emotes

            osNpcStopAnimation(npcKey,"avatar_type");

            // emotional state output

            // you can override the built-in emotion by adding an animation
            // with any of the following names to the inventory
            // normal, happy, angry, averse, sad, evil, fuming,
            // hurt, surprised, insulted, confused, amused, asking.
            
            if (llGetInventoryType(emotion) == INVENTORY_ANIMATION) {
                DEBUG("Playing animation from inventory named " + emotion);
                osNpcPlayAnimation(npcKey,emotion);
            } else {
                integer index = llListFindList(gAnimations,[emotion]);
                if (index != -1) {
                    string toPlay = llList2String(gAnimations,index + 1);
                    DEBUG("Playing built-in animation named " + toPlay);
                    osNpcPlayAnimation(npcKey,toPlay);
                }
            }            
            osNpcSay(npcKey,reply);    // now speak it.

        }
    }
}
