// :SHOW:1
// :CATEGORY:Gaming
// :NAME:Game Prim Script for5 Game sequence Web site.
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:Game, conteoller
// :REV:5.5
// :WORLD:OpenSim, Second life
// :DESCRIPTION:
// A chat system and controller based on a web site notecards replacement system
// :CODE:

// fred@mitsi.com
// Game Prim script

// v 5.5 NPC uses the server to send text to a NPC
// LOGIN URL = http://www.outworldz.com/game

string Version = "5.5"; //  helps spot old scripts at the web site 

// fiddly bits
integer debug = FALSE;    // if TRUE, should be in Spanish

// SET ONE OR MORE OF THESE
integer COLLIDE = FALSE;          // set to TRUE if you want them to collide with  the prim
integer TOUCH = TRUE;            // set to TRUE if they can touch it to trigger this
integer SIT = FALSE;              // set to TRUE if this goes into a SEAT
integer CollideObjects = FALSE;  // set to TRUE to allow things to bump this prim (unlikely)

integer SPEACHOPTION = 3;        // Set to 0 for chat, 1 for IM
vector OFFSET = <0,0,0>;         // offset to rez items with channel = 2.  <0,0,2> will rez the object 2 meters above the prim. Max = 10 meters.

// not fiddly bits
list stack;                    // place to store HTTP traffic
integer HTTPSTRIDE = 2;        // 3 items in a stack = 2 here as it starts option 0



Ping(string AvatarName,key AvatarKey)
{
    string Language = llEscapeURL(llGetAgentLanguage(AvatarKey));
    
   if (debug)   llSay(0,"Language: " + Language);
        
    string Me = llEscapeURL(llGetObjectName());
    string Them = llEscapeURL(AvatarKey);
    string Theirname = llEscapeURL(AvatarName);
   
    string url = "http://www.outworldz.com/cgi/llgame.plx"
        + "?PrimName=" + (string) Me
        + "&Ver=" + Version
        + "&AvatarKey=" + (string)Them
        + "&Language=" + Language;

    if (AvatarKey != NULL_KEY)
        url +=  "&Avatar=" + (string)Theirname  ;
    if (debug ) llOwnerSay(url);

    stack += AvatarKey;
    stack += Theirname;
    stack += llHTTPRequest(url, [], "");
}


// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// * The real start of the universe.
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

default
{
    state_entry()
    {
        llSetTimerEvent(1);
          
        if (COLLIDE == TRUE)
        {
            llSetAlpha(0,ALL_SIDES);         
            llVolumeDetect(FALSE);
            llVolumeDetect(TRUE);
        }
        else {
            llVolumeDetect(FALSE);
            llSetAlpha(1,ALL_SIDES);  
        }
    }

    timer()
    {
        llSetTimerEvent(3600);  // hourly
        Ping("Ping", NULL_KEY);
    }

    // save the Web server data for this prim
    http_response(key request_id, integer status, list metadata, string body)
    {
        if (debug) llSay(0,"Response Body:" + body);
        integer where = llListFindList(stack,   [request_id]) ;
        if (where > -1)      
        {
            stack = llDeleteSubList(stack,where-HTTPSTRIDE,where);    // key, name, request ID

            if (llGetListLength(stack) > 10 * HTTPSTRIDE )    // 10 at a time, the rest can go phooey
                stack = llDeleteSubList( stack, 0, HTTPSTRIDE ); // kill off 1st element, is old
    
            // $status|$display|$sound|$Channel|$ChannelText|$AvatarKey
            

            list my_detail = llParseString2List( body,["|"],[]);
            if (debug) llSay(0,"Dump:" + llDumpList2String(my_detail,","));

            string statusType = llList2String(my_detail,0);
            string storyText = llList2String(my_detail,1);
            string SoundUUID = llList2String(my_detail,2);
            integer ActionChannel = (integer) llList2String(my_detail,3);
            string ActionText = llList2String(my_detail,4);
            string AvatarKey = llList2String(my_detail,5);


            if (statusType == "ACK"  && llStringLength(AvatarKey) > 1 )
            {
                // play sound, if any
                if (llStringLength(SoundUUID) > 1 ) {
                    if (debug) llSay(0,"Playing sound " + SoundUUID);
                    llTriggerSound(SoundUUID,1.0);
                }

                // They had the requirements, or there was no dependency,  and there was text in the Channel
                if (ActionChannel && llStringLength(storyText) > 1)
                {
                    if (debug) llSay(0,"Sending Region command " +  storyText  + " on channel " + (string) ActionChannel);
                    llRegionSay(ActionChannel,storyText); // pass it to other scripts.
                }
            }
        }
    }

    collision_start(integer total_number)
    {

        if (COLLIDE) {

            if (debug)
                llSay(0," prim collided ");

            integer i;
            for (; i < total_number; i++)
            {
                if (debug) llSay(0,"Collided by " + (string) llDetectedKey(i));
               // if (! osIsNpc(llDetectedKey(i)))
              //  {
                    if (CollideObjects)
                    {
                        list reject = llGetObjectDetails(llDetectedKey(i), [OBJECT_CREATOR]);
                        key x = llList2Key(reject,0);
                        if (x == NULL_KEY)
                            Ping(llDetectedName(i), llDetectedKey(i));
                    } else {
                        Ping(llDetectedName(i), llDetectedKey(i));
                    }
              //  }
            } 
        }
    }
    touch_start(integer total_number)
    {

        if (TOUCH) {

            if (debug)
                llSay(0," prim touched ");

            integer i;
            for (; i < total_number; i++)
            {
                if (debug) llSay(0,"Touched by " + (string) llDetectedKey(i));
                Ping(llDetectedName(i), llDetectedKey(i));
            }
        }
    } 
   
    changed(integer mask)
    {
        if (mask & CHANGED_INVENTORY)
        {
            llResetScript(); 
        }
        if ((mask & CHANGED_LINK) && SIT)
        {
            key avatarKey = llAvatarOnSitTarget();    // see if they sat down
            if (avatarKey != NULL_KEY)
            {
                Ping(llKey2Name(avatarKey), avatarKey);
            }
        }
         if (mask & CHANGED_REGION_START)
         {
             llResetScript();
         }
    }
 

}