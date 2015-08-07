// :CATEGORY:Vendor
// :NAME:Multiitem_Multiauthor_vendor_MAIN_B
// :AUTHOR:Apotheus Silverman
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:57
// :ID:539
// :NUM:725
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Multi-item, Multi-author vendor -MAIN- By Apotheus Silverman.lsl
// :CODE:

//========== FOREWORD By Apotheus Silverman =========================
//
//the code I have here is for a vendor that rezzes display models. When someone purchases something the payment can be automatically divided between mulitiple people if desired.
//All the information about the items being sold and who gets paid reside in a note card.
//
//
//I have listed a multi-author vendor kit on SLExchange.com that anyone can use to get this vendor system up and running within a few minutes. Most people who have problems getting the scripts working find it to be of incredible value.
//
//The kit is fully open-source, just like the scripts themselves. It includes a working vendor, tutorial notecard and tools to help you along the way.
//
//You will find it HERE: http://www.slexchange.com/modules.php?name=Marketplace&file=item&ItemID=4081
//===================================================================





//    HOW TO USE By Ulrika Zugzwang
//    
//    * Create a vendor prim and put the vendor script in.
//    * Create a previous-button prim and put the previous-button (back-button) script in.
//    * Create a next-button prim and put the next-button script in.
//    * Link all three prims together making the vendor prim the parent prim.
//    * Make a model by rezing an object you want to sell, copy it, shrink it, and remove all contents.
//    * Place the display script inside this model.
//    * Rename the model.
//    * Place the model and the original object for sale into the vendor.
//    * Edit the "Item Data" notecard to include the following data: object name, model name, price, agent keys
////////////////////////////////////////////////////////////////////////////////////
//Sample "Item Data" notecard:
////////////////////////////////////////////////////////////////////////////////////
//Abbotts Float Plane v1.0.1, Float Plane Display Model - red stripe, 500, 
//d9bcb9e0-bfa2-4b8b-a8fc-9d996935ef51|0d994ae7-2d6a-4cd3-bdcf-81c82c35928b
//Abbotts Float Plane v1.0.1 black feathers, Float Plane Display Model - black feathers, 500, 
//d9bcb9e0-bfa2-4b8b-a8fc-9d996935ef51|0d994ae7-2d6a-4cd3-bdcf-81c82c35928b
//Abbotts Float Plane v1.0.1 red-yellow feathers, Float Plane Display Model - red feathers, 500, 
//d9bcb9e0-bfa2-4b8b-a8fc-9d996935ef51|0d994ae7-2d6a-4cd3-bdcf-81c82c35928b
//Abbotts Float Plane v1.0.1 stars stripes, Float Plane Display Model - stars stripes, 500, 
//d9bcb9e0-bfa2-4b8b-a8fc-9d996935ef51|0d994ae7-2d6a-4cd3-bdcf-81c82c35928b
/////////////////////////////////////////////////////////////////////////////////////




// This is the name of the notecard to read items from
string itemDataNotecard = "Item Data";

// Type of thingy this vendor sells (inventory constant)
integer inventoryType = INVENTORY_OBJECT;

// Keeps track of the currently-displayed item (1-indexed)
integer currentItem = 0;

// Floating text color
vector textColor = <1,1,1>;

// Model rez position relative to parent object
vector rezPosition = <-0.1,0,-0.1>;

// Inter-object commands
string commandDerez = "derez";

// How many seconds between automatic item changes
float changeTimer = 300.0;



// This is the channel the main vendor talks to rezzed models on
integer commChannel;

// These lists are synchronized to simulate a structure for each item's data
list items = [];
list models = [];
list prices = [];
list authors = [];

// Required to read the notecard properly
integer notecardLine;
key currentDataRequest;


// Reads the data from the notecard. Each line in the notecard should be
// formatted as follows:
// Item Name, Model Name, Price, Authors
// string (no commas), string (no commas), integer, pipe-delimited list of keys
// Example:
// Abbotts Float Plane v1.0.1, Abbotts Float Plane Model, 500, key|key
InitializationStep1() {
    llSay(0, "Reading item data...");
    notecardLine = 0;
    currentDataRequest = llGetNotecardLine(itemDataNotecard, notecardLine);
}

// Requests debit permission
InitializationStep2() {
    // Request debit permission
    llRequestPermissions(llGetOwner(), PERMISSION_DEBIT);
}

// Change currently-displayed item
SetCurrentItem(integer item) {
    // determine which item to display
    integer itemCount = llGetListLength(items) - 1;
    currentItem = item;
    if (currentItem == -1) {
        currentItem = itemCount;
    } else if (currentItem > itemCount) {
        currentItem = 0;
    }

    // derez current model
    llWhisper(commChannel, commandDerez);

    // Build and set hover text
    string hoverText = "Item " + (string)(currentItem + 1) + " of " + (string)(itemCount + 1) + "\n" + llList2String(items, currentItem) + "\n$" + (string)llList2String(prices, currentItem);
    llSetText(hoverText, textColor, 1.0);
    
    // Say what item is now being displayed
    llSay(0, "Now Showing: " + llList2String(items, currentItem));

    // rez the new model
    llRezObject(llList2String(models, currentItem), llGetPos() + rezPosition, ZERO_VECTOR, ZERO_ROTATION, commChannel);
}

default {
    state_entry() {
        llSay(0, "Starting up...");

        // Initialize commChannel
        commChannel = (integer)llFrand(2000000000.0);

        // Clear text
        llSetText("", textColor, 1.0);

        // Read notecard, populate lists
        InitializationStep1();
    }

    run_time_permissions(integer perm) {
        if (perm & PERMISSION_DEBIT) {
            state vend;
        } else {
            llSay(0, "You must grant debit permission for me to work properly.");
        }
    }

    dataserver(key query, string data) {
        if (query == currentDataRequest) {
            currentDataRequest = ""; // Prevent a bug that occurs with dataserver events.
            if (data != EOF) {
                // Read the current item
                list currentList = llCSV2List(data);
                string myItemName = llList2String(currentList, 0);
                string myModelName = llList2String(currentList, 1);
                integer myPrice = llList2Integer(currentList, 2);
                string myAuthorsAsString = llList2String(currentList, 3);

                items += [myItemName];
                models += [myModelName];
                prices += [myPrice];
                authors += [myAuthorsAsString];

                notecardLine++;
                // Get the next line
                currentDataRequest = llGetNotecardLine(itemDataNotecard, notecardLine);
            } else {
                // Signal that we are done getting items
                InitializationStep2();
           }
        }
    }
}




state vend {
    state_entry() {
        //llSay(0, "items = " + llDumpList2String(items, ","));
        //llSay(0, "models = " + llDumpList2String(models, ","));
        //llSay(0, "prices = " + llDumpList2String(prices, ","));
        //llSay(0, "authors = " + llDumpList2String(authors, ","));
        
        // Rez initial model
        SetCurrentItem(currentItem);

        // Start the timer for item autorotation
        llSetTimerEvent(changeTimer);
                
        llSay(0, "Multiauthor Multivendor online.");
    }
    
    timer() {
        // Choose a random item to display. Make sure it's not the current item.
        integer newItem = currentItem;
        if (llGetListLength(items) > 1) {
            while (newItem == currentItem) {
                newItem = (integer)(llFrand(llGetListLength(items)) + 1.0);
            }
            SetCurrentItem(newItem);
        }
    }

    touch(integer total) {
        llSay(0, "I sell things! Use the left or right arrows to cycle through the items I am selling, then right-click and \"Pay\" me the displayed amount to purchase an item.");
    }

    // Someone has given me money
    money(key agentkey, integer amount) {
        string name = llKey2Name(agentkey);
        integer currentPrice = llList2Integer(prices, currentItem);
        integer sale;
        integer i;
        
        if(amount < currentPrice) {
            // Not enough money was given. Cancel sale.
            llSay(0, name +  " you Paid $" + (string)amount + " - thats not enough money for the current item! Refunding $" + (string)amount + "...");
            llGiveMoney(agentkey, amount);
            sale = FALSE;
        }
        else if(amount > currentPrice) {
            // Too much money was given. Refund the differnce.
            integer change = amount - currentPrice;
            llSay(0, name + " you Paid $" + (string)amount + " - your change is $" + (string)change + ".");
            llGiveMoney(agentkey, change);
            sale = TRUE;
        } else {
            // The proper amount was given.
            sale = TRUE;
        }

        if (sale) {
            // Make sure I have the item in inventory before trying to give it.
            integer found = FALSE;
            //llSay(0, "searching for " + llList2String(items, currentItem));
            for (i = 0; i < llGetInventoryNumber(inventoryType); i++) {
                if (llGetInventoryName(inventoryType, i) == llList2String(items, currentItem)) {
                    found = TRUE;
                }
            }

            if (!found) {
                // Display error and refund money
                llSay(0, "Erm, I am sorry " + name + ", but it seems that I do not have that item to give to you, so I am refunding the purchase price. Please contact my owner about this issue.");
                llGiveMoney(agentkey, currentPrice);
            } else {
                // Complete the sale
                llSay(0, "Thank you for your purchase, " + name + "!");
                llGiveInventory(agentkey, llList2String(items, currentItem));

                llWhisper(0, "Please wait while I perform accounting activities...");

                // Distribute money to the object authors
                list myAuthors = llParseString2List(llList2String(authors, currentItem), ["|"], []);
                
                if (llGetListLength(myAuthors) > 0) {
                    integer shareAmount = (integer)llList2Integer(prices, currentItem) / llGetListLength(myAuthors);
                    // Eliminate my owner from the authors list
                    for (i = 0; i < llGetListLength(myAuthors); i++) {
                        llInstantMessage(llList2Key(myAuthors, i), name + " purchased " + llList2String(items, currentItem) + ". Your share is L$" + (string)shareAmount + ".");
                        if (llList2Key(myAuthors, i) == llGetOwner()) {
                            myAuthors = llDeleteSubList(myAuthors, i, i);
                        }
                    }
                    // Pay any remaining authors accordingly
                    if (shareAmount > 0 && llGetListLength(myAuthors) > 0) {
                        for (i = 0; i < llGetListLength(myAuthors); i++) {
                            llGiveMoney(llList2Key(myAuthors, i), shareAmount);
                        }
                    }
                }
                llWhisper(0, "Accounting completed. Thanks again, " + name + "!");
            }
        }
    }

    link_message(integer sender, integer num, string message, key id) {
        if (message == "next") {
            llSetTimerEvent(changeTimer);
            SetCurrentItem(currentItem + 1);
        } else if (message == "prev") {
            llSetTimerEvent(changeTimer);
            SetCurrentItem(currentItem - 1);
        }
    }

    on_rez(integer startParam) {
        llResetScript();
    }
} // END //
