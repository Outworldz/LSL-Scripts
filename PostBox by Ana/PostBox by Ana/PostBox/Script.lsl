// :AUTHOR:Anatova Akina
// :CATEGORY:Email
// :NAME:PostBox
// :REV:1.0
// :WORLD:Second Life,Opensim
// :DESCRIPTION:
// This script transform a prim to a Mail Box.
// :CODE:

// --------------------------------------
// This script transform a prim to a Mail Box.

// Folks can drop notecard to the box.
// Read/unread information is displayed as hovering text.
// You can copy/modify this script, it's totally free.
// --------------------------------------
//
// 2021-04-22 - refactored / rewritten by Anatova Akina
// * Resolved the 1 notecard not deleted bug
// * Added admin access with IM notifications
// * Uses changed() event better
// * Compacted code, removed unecessary stuff
// * Extended menu text & floatertext can be hidden
// * Added delete notecards confirmation
//
//-------------------------------------------

////// USER SETTINGS: ///////////////////
//
// Add keys of admin access in the admin list as strings. 
// Object owner is added automatically.
// Example:
// list admin=["01234567-89ab-cdef-0123-456789abcdef", "01234567-89ab-cdef-0123-456789abcdef"];
list admin=[];

// set this to FALSE to hide floater text
integer floaterText=TRUE;

////// END of USER SETTINGS ////////////////

// column 1 = notecard name, column 2 = read by user
list        lMail = [];
integer     MAIL_UNREAD = 0;
integer     MAIL_READ = 1;

integer     DIALOG_CHANNEL = -4938453;

string txtRefresh()
{
    integer nTotalCard = llGetListLength(lMail)/2;
    integer nNotRead = 0;
    integer nCount = 0;

    for (nCount = 0; nCount < llGetListLength(lMail); nCount += 2)
    {
        if (llList2Integer(lMail, nCount + 1) == MAIL_UNREAD)
            nNotRead += 1;
    }

    // total string
    string cPost = (string)nTotalCard + " card";
    if (nTotalCard > 1)
        cPost += "s";
    cPost += " posted";

    // unread string
    string cUnread = (string)nNotRead + " unread";

    string text="Postbox\n" + cPost + "\n" + cUnread;
    
    if (floaterText) 
        llSetText(text, <.95, .75, 0>, 1);
    else
        llSetText("", <.95, .75, 0>, 1);
        
    return text;
}

notifyAdmin(string m) {
    integer i=llGetListLength(admin);
    while(i) {
        llInstantMessage(llList2Key(admin,i-1),m);
        i--;
    }
}

// scan and clean inventory of this object
scanInventory(integer notify) 
{
    integer n;
    for (n=0;n<llGetInventoryNumber(INVENTORY_ALL);n++)
    {
        string cName = llGetInventoryName(INVENTORY_ALL, n);
        if (cName != llGetScriptName())
        {
            if (llGetInventoryType(cName) != INVENTORY_NOTECARD)
            {
                llSay(0, cName + " is not a notecard. Deleted.");
                llRemoveInventory(cName);
                n=n-1;
            }
            else if (cName)
            {
                if (llListFindList(lMail, [cName]) == -1)
                {
                    // ok its a new card
                    lMail += [cName, MAIL_UNREAD];
                    llSay(0, "Notecard \"" + cName + "\" added to the mailbox. Thank you!");

                    if (notify) 
                        notifyAdmin("Notecard dropped: "+cName);
                }
            }
        }
    }
}
default
{
    state_entry()
    {
       // Allowing dropping of object
       llAllowInventoryDrop(TRUE);

       llListen(DIALOG_CHANNEL, "", NULL_KEY, "");

       // add owner to admin access list
       admin+=(string) llGetOwner();

       scanInventory(FALSE);
       txtRefresh();
    }

    touch_start(integer total_number)
    {

        key id = llDetectedKey(0);
        llRegionSayTo(id,0, "Drag and drop a notecard from inventory to post it to the staff");

        // if admin access
        if (~llListFindList(admin,[(string) id]))
        {
            // Show a dialog
            llDialog(id,
                "\nWelcome admin to this "+ txtRefresh() + "\n\n" +
                "Unread: gives all unread notecards\n" +
                "Read: gives all read notecards\n" +
                "Delete: deletes all read notecards\n\n" +
                "What do you want to do ?", ["Unread", "Read","Delete"], DIALOG_CHANNEL);
        }
    }

    listen(integer channel, string name, key id, string message)
    {
        if (~llListFindList(admin,[(string) id]))
        {
            if (message == "Delete")
            {
                llDialog(id,"Are you sure?",["YES", "NO"],channel);
                return;
            }
            else if (message == "YES" )
            {
                message="Delete";
            }
            else if (message=="NO")
                return;

            integer i;
            for (i = 0; i < llGetListLength(lMail); i += 2)
            {
                string cName = llList2String(lMail, i);
                integer nStatus = llList2Integer(lMail, i + 1);

                if (message == "Unread" && nStatus == MAIL_UNREAD)
                {
                    // open un-read, mark read
                    llGiveInventory(id, cName);
                    lMail = llListReplaceList(lMail, [MAIL_READ], i + 1, i + 1);
                }
                else if (message == "Read" && nStatus == MAIL_READ)
                {
                    // open read
                    llGiveInventory(id, cName);
                }
                else if (message == "Delete" && nStatus == MAIL_READ)
                {
                    // delete read
                    llRegionSayTo(id,0, "Deleting " + cName);
                    llRemoveInventory(cName);
                    lMail = llDeleteSubList(lMail, i, i+1);
                    i=i-2; // list has become smaller (solves the bug in original version)
                }
            }
            
            txtRefresh();
        }
    }

    changed(integer change)
    {
        // did the inventory not change due to owner or someone using drop access?
        if (! (change & (CHANGED_ALLOWED_DROP | CHANGED_INVENTORY)) )
            return; // back off

        if (llGetInventoryNumber(INVENTORY_ALL) < 2)
        {
            // clear the list
            lMail = [];
        }
        else
        {
            scanInventory(TRUE);
        }
        
        // refresh the text
        txtRefresh();
    }
}
