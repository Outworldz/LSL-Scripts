// :CATEGORY:NPC
// :NAME:NPC HUD
// :AUTHOR:Anonymous
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:58
// :ID:568
// :NUM:779
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Master
// :CODE:

key npc = "00000000-0000-0000-0000-000000000000";
string notecard= "clonedAV";
string clonetype;
key av;
key toucher;
vector npcPos ;

integer channel = -19;
integer clonechannel = -18;
// menus
list lstMainMenu = ["Clone","Recall","Destroy","Control","Settings","Load","-","-","Reset"];

string cmdname;

float range = 12.0;

string name;
string first;
string last;

list avatarlist;//2 strided list in form of name,key used to create menu of people to grab, and process responses.

integer listener;
integer timeout = 30;

AvMenu(key id)
{
    //give list of people in victims list
    list buttons;
    integer n;
    integer stop = llGetListLength(avatarlist);
    for (n = 0; n < stop; n = n + 2)
    {
        buttons += llList2String(avatarlist, n);
    }
    string prompt = "Select who to clone.";
    prompt += "  (Menu will time out in " + (string)timeout + " seconds.)";
    llSetTimerEvent(timeout);
    listener = llListen(clonechannel, "", id, "");
    llDialog(id, prompt, buttons,clonechannel );
}

ControlMenu(key id)
{
    list buttons = ["Unsit"];
    string prompt = "Pick an option.";
    prompt += "  (Menu will time out in " + (string)timeout + " seconds.)";
    llSetTimerEvent(timeout);
    listener = llListen(clonechannel, "", id, "");
    llDialog(id, prompt, buttons, clonechannel);
}


CloneAv(key id,string name)
{

    //--------------------------------------------------
    first = llList2String(llParseString2List(name,[" "],[]),0);
    last = llList2String(llParseString2List(name,[" "],[]),1);
    vector npcPos = llGetPos() + <3,0,0>;
    osAgentSaveAppearance(id, notecard);
    npc = osNpcCreate("_" + first, last, npcPos, notecard);
    clonetype= "default";
    llMessageLinked(LINK_ALL_CHILDREN,1,"green",npc);
    //-------------------------------------------------
}

list order_buttons(list buttons)
{
    return llList2List(buttons, -3, -1) + llList2List(buttons, -6, -4) + llList2List(buttons, -9, -7) + llList2List(buttons, -12, -10);
}

default
{
    touch_start(integer num)
    {
        if (llDetectedKey(0) == llGetOwner())
        {
            //
            llDialog(llDetectedKey(0), "What do you want to do?", order_buttons(lstMainMenu), channel);
            listener = llListen(channel, "", NULL_KEY, "");
            npcPos = llGetPos() + <3,0,0>;
            llSetTimerEvent(30.0);
        }
    }



    listen(integer channel, string name, key id, string message)
    {
        llListenRemove(listener);
        llSetTimerEvent(0.0);
        //--------------------------------------
        // main menu results here
        //--------------------------------------
        if (channel == channel)
        {
            if (message == "Clone")
            {
                if (npc == "00000000-0000-0000-0000-000000000000")
                {
                    llSensor("", NULL_KEY, AGENT, range, PI);
                }
                else
                {
                    llOwnerSay("Sorry,but it appears you have already have a clone");
                }

            }
            if (message == "Recall")
            {
                if (npc  == "00000000-0000-0000-0000-000000000000")
                {
                    llMessageLinked(LINK_ROOT,10,"Recall",id);
                }
                else
                {
                    llOwnerSay("Sorry,but it appears you have already have a clone");
                }
            }
            if (message == "Control")
            {
                if (npc  != "00000000-0000-0000-0000-000000000000")
                {
                    llMessageLinked(LINK_ROOT,20,clonetype,npc);
                }
                else
                {
                    llOwnerSay("Sorry,but it appears you do not have a clone to control");
                }
            }
            if (message == "Destroy")
            {
                llMessageLinked(LINK_ALL_CHILDREN,2,"red",npc);
                llOwnerSay("Removing clone");
                osAvatarPlayAnimation(npc, "shock");
                llSleep(5);
                osNpcRemove(npc);
                npc = "00000000-0000-0000-0000-000000000000";
            }
            if (message == "Reset")
            {
                llResetOtherScript("~animator");
                llResetOtherScript("~clonesit");
                llResetOtherScript("~comehere");
                llResetOtherScript("~controler");
                llResetOtherScript("~dance");
                llResetOtherScript("~follow");
                llResetOtherScript("~recall");
                llResetOtherScript("~StopAllAnimations");
                llSleep(0.2);
                llResetScript();
            }
            if (message == "-")
            {
            }
        }
        //--------------------------------------
        // avatar selected to clone
        //--------------------------------------
        if (channel == clonechannel)
        {
            //message will be victim name.  get key from list
            integer index = llListFindList(avatarlist, [message]);
            key victim = llList2Key(avatarlist, index + 1);
            CloneAv(victim, message);
        }

    }

    sensor(integer num)
    {
        llListenRemove(listener);
        llSetTimerEvent(0.0);
        //give menu of potential avatars
        integer n;
        avatarlist = [];

        //cap at 12 victims to avoid needed multi page menu
        if (num > 12)
        {
            num = 12;
        }

        for (n = 0; n < num; ++n)
        {
            avatarlist += [llDetectedName(n), llDetectedKey(n)];
        }
        AvMenu(llGetOwner());

    }

    no_sensor()
    {
        llOwnerSay( "Sorry, there's no one close enough to clone.");
        llListenRemove(listener);
        llSetTimerEvent(0.0);
    }

    timer()
    {
        llSetTimerEvent(0.0);
        llListenRemove(listener);
    }
    link_message(integer sender_number, integer num, string msg, key id)
    {
        if (num == 99)
        {
            npc = id;
            llSay(0,(string)npc);
            clonetype=msg;

        }
    }

}

