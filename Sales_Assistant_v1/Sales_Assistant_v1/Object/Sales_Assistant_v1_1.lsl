// :CATEGORY:Vendor
// :NAME:Sales_Assistant_v1
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:01
// :ID:718
// :NUM:983
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Sales Assistant v1.lsl
// :CODE:

//Sales Assistant v1.1
//by Nick Fortune - 09/01/2004

//This script makes it possible to sell things out of boxes and split the profit with a partner.  
//The info about the objects price is read from the object's description. 
//You can set the description on the GENERAL TAB just like the Object Name.

//Example Description:  100$ Super Mega Awesome Prim Thinger

//The script reads the price from the description so long as you have it in the format above.  
//You must put "price$ info".  The dollar sign must be in there for the script to work.
//-----Do Not Remove Header


//key gPartner = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"; // ############# PUT YOUR PARTNER'S KEY HERE. #############
//where the x's are your partner's key


key gPartner = "6cb1319d-07f7-4aad-96df-03fcd3d33bf6"; // ############# PUT YOUR PARTNER'S KEY HERE. #############


///----------------Don't need to change anything below this line-------------------

key gOwner;
integer gPrice;
integer gCut;
integer gPerms = FALSE;
string gObject;


default {
    state_entry() {
        llWhisper(0, (string)gPartner);
        gOwner = llGetOwner();
        list Parsed = llParseString2List(llGetObjectDesc(), ["$"], []);
        gPrice = llList2Integer(Parsed, 0);
        if (!gPrice) {
            llInstantMessage(gOwner, "Error:  Please set object description to ''price$ info about object''.  Touch to reset when ready.");
        }
        else {
            if (gPartner != "") {
                gCut = llRound(gPrice / 2);
            }
            gObject = llGetInventoryName(INVENTORY_OBJECT,0);
            llRequestPermissions(gOwner,PERMISSION_DEBIT);
        }
    }
    
    on_rez(integer passed) {
        if(llDetectedKey(0) != llGetOwner()) {
            llResetScript();
        }
    }

    run_time_permissions(integer type)
    {
        if ((type & PERMISSION_DEBIT) != PERMISSION_DEBIT) {
            gPerms = FALSE;
            llInstantMessage(gOwner, "I require debit permissions to function.");
            llRequestPermissions(gOwner,PERMISSION_DEBIT);
        }
        else {
            gPerms = TRUE;
            llInstantMessage(gOwner, "I have aquired debit permissions from "+llKey2Name(gOwner)+".");
            if ((gPrice) && (gObject != "")) {
                if (gPartner != "") {
                    llInstantMessage(gOwner, "Selling "+gObject+" for "+(string)gPrice+"$L. [Partner receives "+(string)gCut+"$L cut.]");
                }
                else {
                    llInstantMessage(gOwner, "Selling "+gObject+" for "+(string)gPrice+"$L. [NO Partner Defined.]");
                }
            }
            else {
                llInstantMessage(gOwner, "I have permissions, but your box is missing contents or missing a price.");
                llInstantMessage(gOwner, "Fix error and touch to reset when ready.");
            }
        }
    }

    touch_start(integer total_number) {
        if (llDetectedKey(0) == llGetOwner()) {
                llResetScript();
        }
        else {
                llWhisper(0, gObject+" - $"+(string)gPrice+"L.  Right click and pay amount to purchase.");
        }
    }
    
    money(key giver, integer amount) {
        if (gPerms == TRUE) {
            if (amount < gPrice) {
                llSay(0, gObject+" costs L$" + (string) gPrice);
                llSay(0, "You paid $L"+(string)amount+", which is not enough!");
                llGiveMoney(giver, amount);
            }
            else {
                llSay(0, "Thank you for your purchase!");
                llGiveInventory(giver, gObject);
                if (amount > gPrice) {
                    llGiveMoney(giver, amount - gPrice);
                }
                
                if (gPartner != "") {
                    llGiveMoney(gPartner, gCut);
                }
            }
        }
    }
}// END //
