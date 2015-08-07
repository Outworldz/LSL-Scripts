// :CATEGORY:Suggestion Box
// :NAME:Suggestion_Box
// :AUTHOR:dakar Muliaina
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:05
// :ID:843
// :NUM:1171
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// To use this script, simply copy/paste the contents below into a New Script in the game. Then place the script into a ‘prim’ (in the shape of a mailbox or suggestion box?). That’s all there is to it.
// :CODE:
// --------------------------------------//

// This script transform a prim to a Mail Box.

// Folks can drop notecard to the box.

// Read/unread information is displayed as hovering text.

// You can copy/modify this script, it's totally free.

// --------------------------------------//

// Modified by dakar Muliaina, converted to The king's English

// and a few other enhancements.

//-------------------------------------------//



list lMail = [];

// column 1 = notecard name, column 2 = read by user

integer     MAIL_UNREADED = 0;

integer     MAIL_READED = 1;

integer     DIALOG_CHANNEL = 49383;

list        DIALOG_CHOICE =

                ["Unread",

                 "Read",

                 "Delete"];

integer nLastCardCount = 0;

integer nLastItemCount = 0;



TxtRefresh()

{

    // show the unreadable notecard

    integer nTotalCard = 0;

    integer nNotReaded = 0;

    integer nCount = 0;

    for (nCount = 0; nCount < llGetListLength(lMail); nCount += 2)

    {

        if (llList2Integer(lMail, nCount + 1) == MAIL_UNREADED)

            nNotReaded += 1;

        nTotalCard += 1;

    }



    // total string

    string cPost = (string)nTotalCard + " card";

    if (nTotalCard > 1) cPost += "s";

    cPost += " posted";



       // unreaded string

    string cUnreaded = (string)nNotReaded + " unread";

    llSetText("Suggestion Box!\n" + cPost + "\n" + cUnreaded, <.95, .75, 0>, 1);

}



default

{

    state_entry()

    {

       // Allowing dropping of object

       llAllowInventoryDrop(TRUE);

       llListen(DIALOG_CHANNEL, "", NULL_KEY, "");

       nLastCardCount = llGetInventoryNumber(INVENTORY_ALL);

       nLastItemCount = llGetInventoryNumber(INVENTORY_NOTECARD);



       // Auto complete list

       integer nCardCount = llGetInventoryNumber(INVENTORY_NOTECARD);

       integer n_CurObj = 0;

       string c_Name = "NotEmpty";

       while (c_Name != "")

       {

            c_Name = llGetInventoryName(INVENTORY_NOTECARD, n_CurObj);

            n_CurObj += 1;

            if (c_Name != "")

            {

                lMail += [c_Name];

                lMail += MAIL_UNREADED;

            }

        }

        TxtRefresh();

    }



    touch_start(integer total_number)

    {

        llSay(0, "Drop a notecard to be sent to MY OWNER.");

//---- Change MY OWNER above to suit your likes and needs.   //

        // if owner

        key id = llDetectedKey(0);

        if (id == llGetOwner())

        {

            // Show a dialog

            llDialog(id, "What do you want to do ?", DIALOG_CHOICE,

              DIALOG_CHANNEL);

        }

    }



    listen(integer channel, string name, key id, string message)

    {

        if (llGetOwner() == id && llListFindList(DIALOG_CHOICE,

           [message]) != -1)

        {

            integer i;

            string cName;

            list lRemove;

            integer nStatus;

            for (i = 0; i < llGetListLength(lMail); i += 2)

            {

                cName = llList2String(lMail, i);

                nStatus = llList2Integer(lMail, i + 1);

                if (message == llList2String(DIALOG_CHOICE, 0)

                   && nStatus == MAIL_UNREADED)

                {

                    // open un-readed

                    llGiveInventory(id, cName);

                    // mark for readed

                    lMail = llListReplaceList(lMail, [MAIL_READED],

                        i + 1, i + 1);

                }

                if (message == llList2String(DIALOG_CHOICE, 1)

                   && nStatus == MAIL_READED)

                {

                    // open readed

                    llGiveInventory(id, cName);

                }

                if (message == llList2String(DIALOG_CHOICE, 2)

                   && nStatus == MAIL_READED)

                {

                    // delete readed

                    llSay(0, cName);

                    llRemoveInventory(cName);

                    lRemove += i;

                }

            }

            // remove from the list

            if (llGetListLength(lRemove) > 0)

            {

                integer k;

                for (k = 0; k < llGetListLength(lRemove); k++)

                {

                    i = llList2Integer(lRemove, k);

                    lMail = llDeleteSubList(lMail, i, i+1);

                }

            }

            TxtRefresh();

        }

    }



    changed(integer change)

    {

        // dont accept other than a notecard

        integer nItemCount = llGetInventoryNumber(INVENTORY_ALL);

        if (nItemCount < 2)

        {

            // clear the list

            lMail = [];

        }



        if (nItemCount != nLastItemCount)

        {

            // delete other item type than notecard

            string cName = "NotEmpty";

            integer nCurObj = 0;

            integer nObjType = INVENTORY_NONE;

            list lRemove = [];

            while (cName != "")

            {

                cName = llGetInventoryName(INVENTORY_ALL, nCurObj);

                nCurObj += 1;

                nObjType = llGetInventoryType(cName);

                if (nObjType != INVENTORY_NOTECARD)

                {

                    // add for deletion, its not a notecard

                    lRemove += cName;

                }

            }



            // delete other object than notecard

            integer nD = 0;

            for (nD = 0; nD < llGetListLength(lRemove); nD += 1)

            {

                // dont remove this script !

                cName = llList2String(lRemove, nD);

                if (cName != llGetScriptName() && cName != "")

                {

                    llSay(0, "Sorry but " + cName + " is not a notecard.");

                    llRemoveInventory(cName);

                }

            }



            // search for a new notecard

            integer n_CurObj = 0;

            string c_Name = "NotEmpty";

            while (c_Name != "")

            {

                c_Name = llGetInventoryName(INVENTORY_NOTECARD, n_CurObj);

                llSay(0, c_Name);

                n_CurObj += 1;

                // search for this card

                if (llListFindList(lMail, [c_Name]) == -1 && c_Name != "")

                {

                    // ok its a new card

                    lMail += [c_Name];

                    lMail += MAIL_UNREADED;

                    llSay(0, c_Name + " added to the mailbox.");

                }

            }

        }

        nLastItemCount = llGetInventoryNumber(INVENTORY_ALL);

        nLastCardCount = llGetInventoryNumber(INVENTORY_NOTECARD);

        // refresh the text

        TxtRefresh();

    }

}
