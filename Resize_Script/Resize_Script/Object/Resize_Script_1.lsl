// :CATEGORY:Resizer
// :NAME:Resize_Script
// :AUTHOR:Daemonika Nightfire
// :CREATED:2013-06-24 14:24:19.460
// :EDITED:2013-09-18 15:39:01
// :ID:699
// :NUM:954
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
//  *DS* Resize Script (m/c/t) by Daemonika Nightfire (daemonika.nightfire)//  //     Resize Script for rezzed Objects and Attachments.//     Single-script for a complete linkset with save and restore option.//  //         Featueres:
//         • By the first run or reset of this script, it will ask you to save all parameters.
//           The parameters will be stored in the descriptionfield of each prim, that needs no script-memory :)
//         • You can save, resize and restore individual prims or the complette linkset.
//         • Deleting this script from the object is not required because its only one.
//  
//             Standby-Time ~ 0.004 ms
//             Working-Time with 200 moving Prims ~ 4.000 up to 16.000 ms
//             after finalizing Standby-Time ~ 0.004 ms again
//  
//         Note:
//         • You have to stand on a posestand, if you want to edit attached attachments.
//           This is necessary because otherwise the linkset is misadjusted, if you move your avatar during the process.
//  
//         Important:
//         • Undersize is possible, but take care.
//           if you are small your object and several prims already have minimum dimensions, they are not further reduced, but they are moved proportionally.
//         • Sculpted Prims are no problem, but take care.
//           Sculpties with moved Bounding Box perhaps moving optical not correct
//           That is not true, they are moving correctly, but when the visible Sculptie is not the center of the Bounding Box, it will be looking wrong.
//  
//     Terms of use:
//     You can use, edit and sell this script inside your creations with the following permissions in Second Life:
//     • MOD Yes • COPY Yes • TRANSFER Yes
//  
//     Yes that means fullperm. Other settings, are against the following licenses.
//     The permission of your Object (prim), remain unaffected by these terms
//  
    https://wiki.secondlife.com/wiki/User:Daemonika_Nightfire/Scripts/*DS*_Resize_Script
    http://wiki.secondlife.com/wiki/Project:Terms_of_Service
    http://creativecommons.org/licenses/by-sa/3.0/
//  
//     violation of this Terms are against the Second Life TOS at §7 Content Licenses and Intellectual Property Rights.
    http://secondlife.com/corporate/tos.php
// :CODE:

 
key owner;
integer new = TRUE;
 
integer LinkSet = TRUE;
integer Prim;
 
integer Channel;
integer Listener;
Chan()
{
    llListenRemove(Listener);
    Channel = (integer)(llFrand(999999.0) * -1);
    Listener = llListen(Channel, "", owner, "");
    llSetTimerEvent(60);
}
 
menu1()
{
    Chan();
    if(new)
    {
        llDialog(owner, "\nYour first run or reset of this script.\nDo you whish to save current parameters?",
        ["Save","Later"], Channel);
    }
    else
    {
        llDialog(owner, "\nselect an option\nThis = touched Prim\nAll = complete Object",
        ["This","All","Done"], Channel);
    }
}
 
menu2()
{
    Chan();
    llDialog(owner, "\n+ - = resize\nSave = record all parameters\nRestore = restore saved parameters",
    ["Save","Restore","Done","-1%","-5%","-10%","+1%","+5%","+10%"], Channel);
}
 
default
{
    state_entry()
    {
        owner = llGetOwner();
        llWhisper(0,"/me " + llGetScriptName() + " Free Memory: " + (string)llGetFreeMemory() + " bytes.");
    }
 
    touch_start(integer total_number)
    {
        owner = llGetOwner();
        if(llDetectedKey(0) == owner)
        {
            if(llGetAttached() != 0)
            {
                if(llGetAgentInfo(owner) & AGENT_SITTING)
                {
                    Prim = llDetectedLinkNumber(0);
                    menu1();
                }
                else
                {
                    llOwnerSay("Please use a posing stand for resizing!");
                }
            }
            else
            {
                Prim = llDetectedLinkNumber(0);
                menu1();
            }
        }
    }
 
    listen(integer channel, string name, key id, string msg)
    {
        float shift = 0;
        vector position;
        vector size;
        list link;
        integer i;
 
        if(msg == "This")
        {
            LinkSet = FALSE;
            menu2();
        }
        else if(msg == "All")
        {
            LinkSet = TRUE;
            menu2();
        }
        else if(msg == "Done" || msg == "Later")
        {
            llListenRemove(Listener);
            llSetTimerEvent(0);
        }
        else if(msg == "-1%")
        {
            shift = 0.99;
        }
        else if(msg == "-5%")
        {
            shift = 0.95;
        }
        else if(msg == "-10%")
        {
            shift = 0.9;
        }
        else if(msg == "+1%")
        {
            shift = 1.01;
        }
        else if(msg == "+5%")
        {
            shift = 1.05;
        }
        else if(msg == "+10%")
        {
            shift = 1.1;
        }
 
        // Record
        else if(msg == "Save")
        {
            llOwnerSay("Please wait...");
            if(!LinkSet)
            {
                link = llGetLinkPrimitiveParams(Prim, [PRIM_SIZE , PRIM_POSITION]);
                position = llList2Vector(link, 1);
                position = (position - llGetRootPosition()) / llGetRootRotation();
                size = llList2Vector(link, 0);
 
                llSetLinkPrimitiveParamsFast(Prim,[PRIM_DESC,(string)size + "#" + (string)position]);
            }
            else
            {
                for(i = 0; i <= llGetNumberOfPrims(); i++)
                {
                    link = llGetLinkPrimitiveParams(i, [PRIM_SIZE , PRIM_POSITION]);
                    size = llList2Vector(link, 0);
                    position = llList2Vector(link, 1);
                    position = (position - llGetRootPosition()) / llGetRootRotation();
 
                    if(i > 1)
                    {
                        llSetLinkPrimitiveParamsFast(i,[PRIM_DESC,(string)size + "#" + (string)position]);
                    }
                    else
                    {
                        llSetLinkPrimitiveParamsFast(i,[PRIM_DESC,(string)size]);
                    }
                }
                new = FALSE;
            }
            llOwnerSay("All parameters are stored");
            menu2();
        }
 
        // Restore
        else if(msg == "Restore")
        {
            if(!new)
            {
                llOwnerSay("Please wait...");
                if(!LinkSet)
                {
                    link = llGetLinkPrimitiveParams(Prim, [PRIM_DESC]);
                    list parsed = llParseString2List(llList2CSV(link), ["#"], []);
                    string vect = llList2String(parsed, 0);
                    size = (vector)vect;
 
                    llSetLinkPrimitiveParamsFast(Prim, [PRIM_SIZE, size]);
                }
                else
                {
                    for(i = 0; i <= llGetNumberOfPrims(); i++)
                    {
                        link = llGetLinkPrimitiveParams(i, [PRIM_DESC]);
                        list parsed = llParseString2List(llList2CSV(link), ["#"], []);
                        string vect = llList2String(parsed, 0);
                        size = (vector)vect;
                        string posi = llList2String(parsed, 1);
                        position = (vector)posi;
 
                        if(i > 1)
                        {
                            llSetLinkPrimitiveParamsFast(i, [PRIM_SIZE, size, PRIM_POSITION, position]);
                        }
                        else
                        {
                            llSetLinkPrimitiveParamsFast(i, [PRIM_SIZE, size]);
                        }
                    }
                }
                llOwnerSay("All stored parameters restored.");
                menu2();
            }
            else if(new)
            {
                llOwnerSay("Please first save all paremeters to use this.");
            }
        }
 
        // Resize
        if(shift != 0)
        {
            llOwnerSay("Please wait...");
            if(!LinkSet)
            {
                link = llGetLinkPrimitiveParams(Prim, [PRIM_SIZE]);
                size = llList2Vector(link, 0) * shift;
 
                llSetLinkPrimitiveParamsFast(Prim, [PRIM_SIZE, size]);
            }
            else
            {
                for(i = 0; i <= llGetNumberOfPrims(); i++)
                {
                    link = llGetLinkPrimitiveParams(i, [PRIM_SIZE, PRIM_POSITION]);
                    size = llList2Vector(link, 0) * shift;
                    position = llList2Vector(link, 1);
                    position = (position - llGetRootPosition()) / llGetRootRotation() * shift;
 
                    if(i > 1)
                    {
                        llSetLinkPrimitiveParamsFast(i, [PRIM_SIZE, size, PRIM_POSITION, position]);
                    }
                    else
                    {
                        llSetLinkPrimitiveParamsFast(i, [PRIM_SIZE, size]);
                    }
                }
            }
            llOwnerSay("Finish.");
            menu2();
        }
    }
 
    timer()
    {
        llSetTimerEvent(0);
        llListenRemove(Listener);
        llOwnerSay("Listener timeout, please touch again to use the menu.");
    }
 
    on_rez(integer Dae)
    {
        if(new)
        {
            llResetScript();
        }
    }
}
