// :CATEGORY:Textures
// :NAME:TextureAllByDescription
// :AUTHOR:Ferd Frederix
// :CREATED:2014-01-01 12:18:56
// :EDITED:2014-01-01 12:18:56
// :ID:1008
// :NUM:1560
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Texture all prims from an inventory by menu
// :CODE:
integer debug = TRUE;

DEBUG(string msg)
{
    if (debug) llSay(0,msg);
}

list textures; // a list of texture names, in Head,Middle,Bottom Strided order
key user;        // you
integer listen_id;    // a listener that we can cancel to control lag
integer menuChannel;
list menus;         // a list of Names of textures read from inventory
// from the menu system http://wiki.secondlife.com/wiki/SimpleDialogMenuSystem
integer N_DIALOG_CHOICES;
integer MAX_DIALOG_CHOICES_PER_PG = 8; // if not offering back button, increase this to 9
string PREV_PG_DIALOG_PREFIX = "< Page ";
string NEXT_PG_DIALOG_PREFIX = "> Page ";
string DIALOG_DONE_BTN = "Done";
string DIALOG_BACK_BTN = "<< Back";

integer pageNum;
list DIALOG_CHOICES;

giveDialog( integer pageNum)  {

    list buttons;
    integer firstChoice;
    integer lastChoice;
    integer prevPage;
    integer nextPage;
    string OnePage;

    CancelListen();

    menuChannel = llCeil(llFrand(1000000) + 11000000);
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
    llDialog(user, "Page "+(string)pageNum+"\nChoose one:", buttons, menuChannel);
}


CancelListen() {
    llListenRemove(listen_id);
    llSetTimerEvent(0);
}


// change texture of any prims name Head, Body, Legs
TextureIt(integer texNum) {

    DEBUG("using texture # " + (string) texNum);
    
    DEBUG(llDumpList2String(textures,","));
    
    DEBUG(llList2String(textures,0));
    DEBUG(llList2String(textures,1));
    DEBUG(llList2String(textures,2));
    DEBUG( llList2String(textures,3));
    DEBUG(llList2String(textures,4));
    DEBUG(llList2String(textures,5));

    
    
    // Head, Middle, Bottom pops out of this
   // texNum *= 3;   // cast this to the size of the actual texture list, which is 3



    
    integer found = 0;    
    integer nPrims = llGetNumberOfPrims();
    integer i;
    for (i = 0; i <= nPrims; i++)    {
        list param = llGetLinkPrimitiveParams(i,[PRIM_DESC]);        // DESCRIPTION holds the texture number
        string primName = llList2String(param,0);

        if (primName == "Body") {
             string text =  llList2String(textures,texNum);
            llSetLinkTexture(i,text,ALL_SIDES);        // add this line which sets the texture with no offset or repeat or rotation changes
            found++;
        }
        else if (primName == "Head")     {
            string text = llList2String(textures,texNum+1);
            llSetLinkTexture(i,text,ALL_SIDES);        // add this line which sets the texture with no offset or repeat or rotation changes
            found++;
        }
        else if (primName == "Leg") {
            string text =  llList2String(textures,texNum+2);
            llSetLinkTexture(i,text,ALL_SIDES);        // add this line which sets the texture with no offset or repeat or rotation changes
            found++;
        }
    }

    if (found < 3)
    {
        llOwnerSay("Something is wrong.  There must be at least 3 prims with a description of Head, Body, and Leg");
    }
    
}

GetTextures()
{
    integer nItems = llGetInventoryNumber(INVENTORY_TEXTURE);
    integer i;
    textures = [];
    DIALOG_CHOICES = [];
    menus = [];
    for ( i = 0; i < nItems; i++)    {

        // this section makes a list with all three texture names in alphabetical order
        string name = llGetInventoryName(INVENTORY_TEXTURE,i);    
        textures += name;

        // This break it down into the Name-Head, name-Body and name-Leg parts and saves the name for a menu
        list parts = llParseString2List(name,["-"],[""]);
        string firstpart = llList2String(parts,0);
        menus += firstpart;
    }
    // we want a menu with just the names, bit the -Head, etc.
    DIALOG_CHOICES = ListUnique(menus);

    // and all this depends upon them being in alpha order.
    DIALOG_CHOICES = llListSort(DIALOG_CHOICES,1,1);
    menus = llListSort(menus,3,1);
}

list ListUnique( list lAll ) {
    integer i;
    list lFiltered = llList2List(lAll, 0, 0);
    integer iAll = llGetListLength( lAll );
    for (i = 1; i < iAll; ++i) {
        if ( llListFindList(lFiltered, llList2List(lAll, i, i) ) == -1 ) {
            lFiltered += llList2List(lAll, i, i);
        }
    }
    return lFiltered;
}

default
{
    state_entry() {
        GetTextures();
    }

    touch_start(integer total_number) {
        GetTextures();
        user =  llDetectedKey(0);
        giveDialog(pageNum);
    }

    listen(integer channel, string name, key id, string message){
        CancelListen();
        
        user = id;    // two people may be using it at the same time, so we save the ID here
        
        if ( message == DIALOG_DONE_BTN){
            CancelListen();
            return;
        }
        else if (message == DIALOG_BACK_BTN){
            pageNum = 1;
            giveDialog(pageNum);
        }
        else if (llSubStringIndex(message, PREV_PG_DIALOG_PREFIX) == 0){
            pageNum = (integer)llGetSubString(message, llStringLength(PREV_PG_DIALOG_PREFIX), -1);
            giveDialog( pageNum);
        }
        else if (llSubStringIndex(message, NEXT_PG_DIALOG_PREFIX) == 0){
            pageNum = (integer)llGetSubString(message, llStringLength(NEXT_PG_DIALOG_PREFIX), -1);
            giveDialog(pageNum);

        } else { //this is the section where we do stuff other than menus

            integer where = llListFindList(menus, [message]);        // find the string he clicked in the master list
            if (where >= -1) {   // -1 is not found
                TextureIt(where);  //  0th is Body, 1 = Head, 2 = Legs
            }
        }
    }


    timer() {
        CancelListen();
        llOwnerSay("Sorry. The menu timed out, click me again. ");
    }

}
