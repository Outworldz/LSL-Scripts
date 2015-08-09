// :CATEGORY:Tandy
// :NAME:Tandy the Nymph
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:06
// :ID:867
// :NUM:1206
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Tandy
// :CODE:

// tiny fae  avatar script
// 12-21-2012

// This script is the main control for the tiny fairy avatars
// It colors the avatyar with combined skins and textures from inventory.
// The clothing must be named in this format:

// NAME_face_skin for the face
// NAME_upper_skin for above the waist
// NAME_lower_skin for below the waist

// They MUST be in sets of 3

// Clothing must be named as follows:
// "Name_Top" and "Name_Skirt Base", where name is variable between different clothing sets

// License:
// Copyright (c) 2009, Ferd Frederix

// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:

// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.



// This work uses some content from the Second Life� Wiki article http://wiki.secondlife.com/wiki/SimpleDialogMenuSystem
// Copyright � 2007-2009 Linden Research, Inc. Licensed under the Creative Commons Attribution-Share Alike 3.0 License


// tiny fae  avatar script

// from the menu system http://wiki.secondlife.com/wiki/SimpleDialogMenuSystem
integer N_DIALOG_CHOICES;
integer MAX_DIALOG_CHOICES_PER_PG = 8; // if not offering back button, increase this to 9
string PREV_PG_DIALOG_PREFIX = "< Page ";
string NEXT_PG_DIALOG_PREFIX = "> Page ";
string DIALOG_DONE_BTN = "Done";
string DIALOG_BACK_BTN = "<< Back";

integer pageNum;
list DIALOG_CHOICES;

integer listen_id;    // int of the current listener
integer menuChannel;
string menuType;    // set to cloth or skin depending upon menu choice so we know where to apply yhe chosen texture

list skinNames; // a list made on reset of all the skins
list clothNames;// same for clothes
list headNames; // ditto
list upperNames;
list lowerNames;


list makeMenu()
{
    list menu = ["Skin","Clothes"];//, "Head", "Body", "Legs"

    // If there are any objects in the avatar, make it so she can throw them when she has a tantrum.
    if (llGetInventoryNumber(INVENTORY_OBJECT) > 0)
        menu += ["Tantrum"];

    return menu;
}

// Alpha all heads or other body part  but the chosen part
setSelectedBodyPart(string name, string type)
{
    llOwnerSay("Setting " + type + " to " + name);

    integer i;
    integer j = llGetNumberOfPrims();
    for (; i <= j; i++)
    {
        string aname = llGetLinkName(i); // get the name of the prim
        list a = llParseString2List(aname,["_"],[]);
        string typeA = llList2String(a,0);  // avatar
        string typeB = llList2String(a,1); // head || lower || upper
        string typeC = llList2String(a,2); // name from menu
        if ( (typeA == "avatar"|| typeA == "clothing") && typeB == type) {
            if (typeC == name)
            {
                llSetLinkAlpha(i,1.0,ALL_SIDES); // 100% visible
            }
            else
            {
                llSetLinkAlpha(i,0.0,ALL_SIDES); // 0% visibile

            }
        }
    }

}

// make lists of the available body parts
getBodyParts()
{
    integer i;
    integer j = llGetNumberOfPrims();
    for (; i <= j; i++)
    {
        string aname = llGetLinkName(i); // get the name of the prim
        list a = llParseString2List(aname,["_"],[]);
        string typeA = llList2String(a,0);  // avatar
        string typeB = llList2String(a,1);  // head || lower || upper
        string typeC = llList2String(a,2);  // Name
        if ( typeA == "avatar" && typeB == "head") {
            headNames += typeC;     // add just the head for the menu
        } else if (typeA == "avatar" && typeB == "upper") {
            upperNames += typeC;     // add just the head for the menu
        } else if (typeA == "avatar" && typeB == "lower") {
           lowerNames += typeC;     // add just the head for the menu
        }
    }
    //llOwnerSay(llDumpList2String(headNames,","));
}


// apply the chosen cloth to all prims
getSelectedCloth(string name)
{
    llOwnerSay("Setting clothing to " + name);

    integer i;
    integer j = llGetNumberOfPrims();
    for (; i <= j; i++)
    {
        string aname = llToLower(llGetLinkName(i)); // get the name of the prim
        list a = llParseString2List(aname,["_"],[]);
        string typeA = llList2String(a,0);  // avatar
        string typeB = llList2String(a,1);  // head || lower || upper
        if ( typeA == "clothing" && typeB == "upper") {
            llSetLinkPrimitiveParamsFast(i,[PRIM_TEXTURE,ALL_SIDES, name + "_" + "Top", <1.0,1.0,0.0>, <0.0,0.0,0.0>, 0.0]);
        } else if (typeA == "clothing" && typeB == "lower") {
                llSetLinkPrimitiveParamsFast(i,[PRIM_TEXTURE,ALL_SIDES, name + "_" + "Skirt Base", <1.0,1.0,0.0>, <0.0,0.0,0.0>, 0.0]);
        }
    }
}

getSelectedSkin(string name)
{
    llOwnerSay("Setting skin to " + name);

    integer i;
    integer j = llGetNumberOfPrims();
    for (; i <= j; i++)
    {
        string aname = llToLower(llGetLinkName(i)); // get the name of the prim

        list a = llParseString2List(aname,["_"],[]);
        string typeA = llList2String(a,0);  // avatar
        string typeB = llList2String(a,1); // head || lower || upper
        if ( typeA == "avatar" && typeB == "head" || aname=="eyebrow") {
            llSetLinkPrimitiveParamsFast(i,[PRIM_TEXTURE,ALL_SIDES, name + "_" + "face_skin", <1.0,1.0,0.0>, <0.0,0.0,0.0>, 0.0]);
        } else if (typeA == "avatar" &&  typeB == "upper") {
                llSetLinkPrimitiveParamsFast(i,[PRIM_TEXTURE,ALL_SIDES, name + "_" + "upper_skin", <1.0,1.0,0.0>, <0.0,0.0,0.0>, 0.0]);
        } else if (typeA == "avatar" &&  typeB == "lower") {
                llSetLinkPrimitiveParamsFast(i,[PRIM_TEXTURE,ALL_SIDES, name + "_" + "lower_skin", <1.0,1.0,0.0>, <0.0,0.0,0.0>, 0.0]);
        }
    }

}


// make a menu of the first part of each texture name, and a set of lists of upper and lower 'real' names
getclothNames()
{
    integer i;
    integer j = llGetInventoryNumber(INVENTORY_TEXTURE);
    for (; i < j; i++)
    {
        string realName = llGetInventoryName(INVENTORY_TEXTURE,i); // get full name
        list data = llParseString2List(realName,["_"],[]);    // make it a two piece list split on _
        string name = llList2String(data,0);    // left of the _ is the name
        string type = llList2String(data,1);    // right of the _ is the type

        if (llToLower(type) == "top")
        {
            clothNames += name;     // add just the tops for the menu
        }
    }
}


// make a menu of the first part of each texture name, and a set of lists of upper and lower 'real' names
getskinNames()
{
    integer i;
    integer j = llGetInventoryNumber(INVENTORY_TEXTURE);
    for (; i < j; i++)
    {
        string realName = llGetInventoryName(INVENTORY_TEXTURE,i); // get full name
        list data = llParseString2List(realName,["_"],[]);    // make it a two piece list split on _
        string name = llList2String(data,0);    // left of the _
        string type = llList2String(data,1);    // right of the _
        string skin = llList2String(data,2);    // far right of the _

        if (llToLower(type) == "upper" && llToLower(skin) == "skin")
        {
            skinNames += name;
        }
    }
}



CancelListen() {
    llListenRemove(listen_id);
    llSetTimerEvent(0);
}

giveDialog(key ID, integer pageNum) {

    list buttons;
    integer firstChoice;
    integer lastChoice;
    integer prevPage;
    integer nextPage;
    string OnePage;

    CancelListen();

    menuChannel =-101;
    listen_id = llListen(menuChannel,"","","");

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


default
{

    on_rez(integer p)
    {
        llResetScript();
    }

    state_entry()
    {
        pageNum = 1;
        getskinNames();     // make a list of all skin names
        getclothNames();     // make a list of all skin names
        getBodyParts();     // make 3 lists of all body types
        DIALOG_CHOICES = makeMenu();

        llListen(100,"","","");
        pageNum = 1;
        giveDialog(llGetOwner(), pageNum);
        llOwnerSay( "You can also type '/100 menu' to change colors on this avatar.");
    }


    listen(integer channel, string name, key id, string message)
    {
        integer where ;       
        CancelListen();
        if (message == "menu")
        {
            pageNum = 1;
            DIALOG_CHOICES = makeMenu();
        }
        else if ( message == DIALOG_DONE_BTN)
        {            
            return;
        }
        else if (message == DIALOG_BACK_BTN)
        {
            pageNum = 1;
            DIALOG_CHOICES = makeMenu();
        }
        else if (llSubStringIndex(message, PREV_PG_DIALOG_PREFIX) == 0)
        {
            pageNum = (integer)llGetSubString(message, llStringLength(PREV_PG_DIALOG_PREFIX), -1);
        }
        else if (llSubStringIndex(message, NEXT_PG_DIALOG_PREFIX) == 0)
        {
            pageNum = (integer)llGetSubString(message, llStringLength(NEXT_PG_DIALOG_PREFIX), -1);
        } else { //this is the section where we do stuff prior to this is all menu

           // llOwnerSay(message);
 
            if (message == "Tantrum")
            {
                llMessageLinked(LINK_SET,0,"tantrum","");
                return;
            }
            else if (message == "Skin")
            {
                DIALOG_CHOICES = skinNames;
                menuType = "skin";
            }
            else if (message == "Clothes")
            {
                DIALOG_CHOICES = clothNames;
                menuType = "cloth";

            } else {

                if (message == "Head")
                {
                    DIALOG_CHOICES = headNames;
                    giveDialog(llGetOwner(), pageNum);
                    return;
                } else if (message == "Body")
                {
                    DIALOG_CHOICES = upperNames;
                    giveDialog(llGetOwner(), pageNum);
                    return;                    
                } else if (message == "Legs")
                {
                    DIALOG_CHOICES = lowerNames;
                    giveDialog(llGetOwner(), pageNum);
                    return;                    
                }


                where = llListFindList(skinNames,[message]);    // see if they picked a skin or a cloth
                if (where >= 0)
                {
                    getSelectedSkin(message);
                    llSay(99900,message);
                }
                where = llListFindList(clothNames,[message]);    // see if they picked a skin or a cloth
                if (where >= 0)
                {
                    getSelectedCloth(message);
                    llSay(99900,message);
                }
                where = llListFindList(headNames,[message]);    // see if they picked a skin or a cloth
               // llOwnerSay("Where:"+ (string) where);
                if (where >= 0)
                {
                    setSelectedBodyPart(message,"head");
                }
                where = llListFindList(upperNames,[message]);    // see if they picked a skin or a cloth
                if (where >= 0)
                {
                    setSelectedBodyPart(message,"upper");
                }
                where = llListFindList(lowerNames,[message]);    // see if they picked a skin or a cloth
                if (where >= 0)
                {
                    setSelectedBodyPart(message,"lower");
                } 
            }
        }
        giveDialog(llGetOwner(), pageNum);
    }


    timer()
    {
        llListenRemove(listen_id);
        llOwnerSay( "Sorry. The menu timed out, type '/100 menu' to change colors.");
        llSetTimerEvent(0);
    }

}
