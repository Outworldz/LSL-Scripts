// :CATEGORY:Tandy
// :NAME:Tandy the Nymph
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:06
// :ID:867
// :NUM:1224
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Tandy
// :CODE:

// Tantrum script for the wand
// 12-10-2012

// License:
// Copyright (c) 2009, Fred Beckhusen (Ferd Frederix)

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

vector StartColor;
vector EndColor;


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


LaunchSpell(integer color, string name)
{
    rotation rot = llGetRot();
    vector fwd = llRot2Fwd(rot);
    vector pos = llGetPos();
    pos = pos + fwd;

    StartColor = < red/256, green/256, blue/256>;    // Starting color of particles <R,G,B>
    EndColor = StartColor;
    

    llSleep(1);

    llRezObject(name,  pos, fwd * 2 , rot, color);

    llSleep(1);
    
}

// colors for tantrum effect
float red;
float green;
float blue;
integer color;


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

list makeMenu()
{
    list menu ;

    // If there are any objects in the avatar, make it so she can throw them when she has a tantrum.
    integer i;
    integer j = llGetInventoryNumber(INVENTORY_OBJECT);
    for (i = 0; i < j ; i++)
    {
        string tantrum = llGetInventoryName(INVENTORY_OBJECT,i);
        menu += [tantrum];
    }
    return menu;
}


default
{

    on_rez(integer p)
    {
       llResetScript();

    }



    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_TRIGGER_ANIMATION)
        {
            pageNum = 1;
            DIALOG_CHOICES = makeMenu();
            giveDialog(llGetOwner(), pageNum);

        }
    }
    

    touch_start(integer n)
    {
        if (llDetectedKey(0) == llGetOwner())
        {
             red = llFrand(256.0);
             blue =  llFrand(256.0);
             green =  llFrand(256.0);
             color  = (integer) (red * 256 * 256 + blue * 256  + green);
              
            llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);   
        }
   }



   
    listen(integer channel, string name, key id, string message)
    {

        if (message == "-")
        {
            giveDialog(llGetOwner(), pageNum);
        }
        else if ( message == DIALOG_DONE_BTN)
        {
            CancelListen();
            return;
        }
        else if (message == DIALOG_BACK_BTN)
        {
            pageNum = 1;
            DIALOG_CHOICES = makeMenu();
            giveDialog(llGetOwner(), pageNum);
        }
        else if (llSubStringIndex(message, PREV_PG_DIALOG_PREFIX) == 0)
        {
            pageNum = (integer)llGetSubString(message, llStringLength(PREV_PG_DIALOG_PREFIX), -1);
            giveDialog(llGetOwner(), pageNum);
        }
        else if (llSubStringIndex(message, NEXT_PG_DIALOG_PREFIX) == 0)
        {
            pageNum = (integer)llGetSubString(message, llStringLength(NEXT_PG_DIALOG_PREFIX), -1);
            giveDialog(llGetOwner(), pageNum);

        } else { //this is the section where we do stuff prior to this is all menu

            CancelListen();
            red = llFrand(256.0);
            blue =  llFrand(256.0);
            green =  llFrand(256.0);
            color  = (integer) (red * 256 * 256 + blue * 256  + green);

            

            llStartAnimation("punch_onetwo");
            
            LaunchSpell(color, message);
            llStopAnimation("punch_onetwo");
            giveDialog(llGetOwner(), pageNum);
        }
    }

    
    changed(integer what)
    {
        if (what & CHANGED_INVENTORY)
        {
            llResetScript();
        }
    }

}

