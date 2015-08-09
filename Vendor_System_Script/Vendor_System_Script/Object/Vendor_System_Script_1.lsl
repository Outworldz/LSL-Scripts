// :CATEGORY:Vendor
// :NAME:Vendor_System_Script
// :AUTHOR:Kristy Fanshaw 
// :CREATED:2011-01-22 12:49:11.923
// :EDITED:2013-09-18 15:39:09
// :ID:949
// :NUM:1367
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// What it does:// //    1. it asks the owner of the vendor to rezz the update box.//    2. update box will define the URL from where it can aquire the email address of the vendor. (the webpage body should contain only pure address - index.html file should contain no code)//    3. when the URL is set, it asks the owner of the vendor to grant debits. If the owner won't do so, the script resets.
//    4. when debits are granted the vendor will be active.
//    5. if the owner of the vendor touches vendor in active mode, the vendor will tell how many items have been sold since activation.
// 
// Purchase:
// 
//    1. buyer can pay only the amount of money that is set in "integer gCorrectAmount"
//    2. when buyer pays money, the vendor goes to check the email address of the server from given URL. If there will be invalid response, money will be refunded to buyer and vendor shuts down till next update.
//    3. vendor sends now email to server prim with buyers ID in subject line and its own email address in message content.
//    4. server will give the item to buyer and sends "delivered" notification back to vendor. If the server is not working or there will be some other issues with delivery, then money will be refunded to buyer and vendor shuts down till next update.
//    5. when vendor receives email from server with "delivered" note, then creator of the vendor receives the money. 
// 
// 
// Pay Script for Reseller vendor
// 
// Place this script in a Vendor Root prim you've created.
// 
// What it does:
// 
//    1. it asks the owner of the vendor to rezz the update box.
//    2. update box will define the URL from where it can aquire the email address of the vendor. (the webpage body should contain only pure address - index.html file should contain no code)
//    3. when the URL is set, it asks the owner of the vendor to grant debits. If the owner won't do so, the script resets.
//    4. when debits are granted the vendor will be active.
//    5. if the owner of the vendor touches vendor in active mode, the vendor will tell how many items have been sold since activation.
// 
// Purchase:
// 
//    1. buyer can pay only the amount of money that is set in "integer gCorrectAmount"
//    2. when buyer pays money, the vendor goes to check the email address of the server from given URL. If there will be invalid response, money will be refunded to buyer and vendor shuts down till next update.
//    3. vendor sends now email to server prim with buyers ID in subject line and its own email address in message content.
//    4. server will give the item to buyer and sends "delivered" notification back to vendor. If the server is not working or there will be some other issues with delivery, then money will be refunded to buyer and vendor shuts down till next update.
//    5. when vendor receives email from server with "delivered" note, then creator of the vendor receives the money. 
// 
// Copyright © 2008 by Kristy Fanshaw
// 
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
// 
To get a copy of the GNU General Public License, see <http://www.gnu.org/licenses/>.
// :CODE:
////////////////////////////////////////////////////////////////////////////////////////////////
//    Copyright (c) 2008 by Kristy Fanshaw                                                    //
//    This script is part of Vendor System.                                                   //
////////////////////////////////////////////////////////////////////////////////////////////////
//    Vendor System is free software: you can redistribute it and/or modify                   //
//    it under the terms of the GNU General Public License as published by                    //
//    the Free Software Foundation, either version 3 of the License, or                       //
//    (at your option) any later version.                                                     //
//                                                                                            //
//    Vendor System is distributed in the hope that it will be useful,                        //
//    but WITHOUT ANY WARRANTY; without even the implied warranty of                          //
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                           //
//    GNU General Public License for more details.                                            //
//                                                                                            //
//    To get a copy of the GNU General Public License, see <http://www.gnu.org/licenses/>.    //
////////////////////////////////////////////////////////////////////////////////////////////////
 
integer gCorrectAmount = 10;                            // enter the price for fast pay
integer my_profit = 50;                                 // how many percent you would like to recieve form the sale
string update_box = "update box name";                  // describe the name of the "update box" object that should be rezzed
string name = "my vendor name";                         // Set the vendor name here
 
integer totalsold = 0;
integer Ch;
integer listen_handle;
integer buyer_paid;
key OWNER;
key CREATOR;
key ID;
key http_request_id;
string url;
string mail;
 
default
    {
        changed(integer change)
            {
                if(change & CHANGED_OWNER)
                    {
                        llSetObjectDesc("0");
                        llResetScript();
                    }
            }
        on_rez(integer start_param)
            {
                llResetScript();
            }
        state_entry()
            {
                OWNER = llGetOwner();
                CREATOR = llGetCreator();
                Ch =  ( -1 * (integer)("0x"+llGetSubString((string)CREATOR,-7,-1)) );
                totalsold = (integer)llGetObjectDesc();
                llSetObjectName(name);
                llSetPayPrice(PAY_HIDE, [gCorrectAmount, PAY_HIDE, PAY_HIDE, PAY_HIDE]);
                llSetText("To start vendor, rezz '" + update_box + "'.", <1.0, 1.0, 1.0>, 1.0);
                llSensorRepeat(update_box, NULL_KEY , SCRIPTED, 10 , PI, 10);
            }
        sensor (integer numberDetected)
            {
                state sens;
            }
        no_sensor ()
            {
                llResetScript();
            }
    }
state sens1
    {
        state_entry()
            {
                state sens;
            }
    }
state sens
    {
        on_rez(integer start_param)
            {
                llResetScript();
            }
        state_entry()
            {
                llSetText("Updating", <1.0, 1.0, 1.0>, 1.0);  
                llShout(Ch,"update");
                listen_handle = llListen(Ch,update_box, NULL_KEY, "");
                llSensorRepeat(update_box, NULL_KEY , SCRIPTED, 10 , PI, 5);
            }
        listen( integer channel, string name, key id, string message )
            {
                 url = message;
                 llOwnerSay("updated");
                 llShout(Ch,"updated");
                 llListenRemove(listen_handle);     
            }
        sensor (integer numberDetected)
            {
                llListenRemove(listen_handle);
                state sens1;
            }
        no_sensor ()
            {
                llSetText("Touch to grant debit permission.", <1.0, 1.0, 1.0>, 1.0);
            }
        touch_start(integer total_number)
            {
                llRequestPermissions(OWNER, PERMISSION_DEBIT);
            }
        run_time_permissions(integer Permission)
            {
                if(Permission == PERMISSION_DEBIT)
                    {
                        llOwnerSay("Starting vendor.");
                        llSetText("", <1.0, 1.0, 1.0>, 1.0);
                        state Ready;
                    }
                else
                    {
                        llOwnerSay ( "To share proceeds I must have give money(DEBIT) permissions");
                        llOwnerSay ( "Try again");
                        llResetScript();
                    }
            }  
    } 
state Ready1
    {
        state_entry()
            {
                state Ready;
            }
    }
state Ready
    {
        on_rez(integer start_param)
            {
                llResetScript();
            }
        state_entry()
            {
                llSensorRepeat(update_box, NULL_KEY , SCRIPTED, 10 , PI,30);
            }
        sensor (integer numberDetected)
            {
                llSetText("Updating", <1.0, 1.0, 1.0>, 1.0);
                llShout(Ch,"update");
                listen_handle = llListen(Ch,update_box, NULL_KEY, "");
            }
        listen( integer channel, string name, key id, string message )
            {
                url = message;
                llOwnerSay("updated");
                llShout(Ch,"updated");
                llSetText("", <1.0, 1.0, 1.0>, 1.0);
                llListenRemove(listen_handle);
            }
        touch_start(integer total_number)
            {
                if (llDetectedOwner(0) == OWNER)
                    {
                        llOwnerSay((string)totalsold +" units have been sold since object rez. ");
                    }
                else
                    {
                        llInstantMessage(llDetectedKey(0), "Right-click and pay to purchase."); 
                    }
            }
        money(key id, integer amount)
            {
                ID =id;
                buyer_paid = amount;
                    {
                        if (amount == gCorrectAmount)
                            {
                                llInstantMessage(id, "Thank you " + llKey2Name(id) + " for your purchase.");
                                llInstantMessage(id,"Server initialises your request .....");
                                http_request_id = llHTTPRequest(url, [], "");
                            }
                        else if (amount < gCorrectAmount)
                            {
                                llInstantMessage(llDetectedKey(0),"You didn't pay enough, " + llKey2Name(id) + ". Refunding your payment of L$" + (string)amount + ".");
                                llGiveMoney(id, amount);
                                state Ready1;
                            }
                        else
                            {
                                integer refund = amount - gCorrectAmount;
                                llInstantMessage(llDetectedKey(0),"You paid too much, " + llKey2Name(id) + ". Your change is L$" + (string)refund + ".");
                                llGiveMoney(id, refund);
                                llInstantMessage(id, "Thank you " + llKey2Name(id) + " for your purchase.");
                                llInstantMessage(id,"Server initialises your request .....");
                                http_request_id = llHTTPRequest(url, [], "");
                            }
                    }
            }
        http_response(key request_id, integer status, list metadata, string body)
            {
                mail =body;
                    {
                        if (request_id == http_request_id)
                            {
                                if(llGetSubString(body, -19, -1) == "@lsl.secondlife.com")
                                    {
                                        llInstantMessage(ID,"Request initialised.");
                                        llInstantMessage(ID,"Sending your requested items .....");
                                        llSetText("Purchase in progress...\n\nPlease Wait...", <1.0, 1.0, 1.0>, 1.0);
                                        llSetPayPrice(PAY_HIDE,[ PAY_HIDE, PAY_HIDE, PAY_HIDE, PAY_HIDE]);
                                        llEmail( body, ID, (string)llGetKey()+"@lsl.secondlife.com" );
                                        llSetTimerEvent(5);
                                        llGetNextEmail("", "");     
                                    }
                                else
                                    {
                                        llGiveMoney(ID, buyer_paid);
                                        llInstantMessage(ID, "Vendor is outdated");
                                        llInstantMessage(OWNER, "Your Vendor in " + llGetRegionName() + " sim can't deliver items. Please update your Vendor.");
                                        llResetScript();  
                                    }
                            }
                    }
            }
        email( string time, string address, string subj, string message, integer num_left )
            {    
                if (subj == "delivered")
                    {
                        float profit = (my_profit + 0.0) / 100;
                        float calc = buyer_paid + 0.0;
                        float a = calc * profit;
                        float b = buyer_paid - a;
                        llGiveMoney( CREATOR, llFloor((integer)a) );
                        llInstantMessage(ID,"Accept your purchased items");
                        totalsold = totalsold + 1;
                        llSetObjectDesc((string)totalsold);
                        llInstantMessage(OWNER, (string)llKey2Name(ID) + " has paid " + (string)buyer_paid + "L$ in "+ llGetRegionName() + " and you have recived " + (string)llCeil(b) + "L$ from this sale");
                        llInstantMessage(CREATOR, (string)llKey2Name(ID) + " has paid " + (string)buyer_paid + "L$ in "+ llGetRegionName() + " and you have recived " + (string)llFloor(a) + "L$ from this sale");
                        llSetPayPrice(PAY_HIDE,[gCorrectAmount, PAY_HIDE, PAY_HIDE, PAY_HIDE]);
                        llSetText("", <1.0, 1.0, 1.0>, 1.0);
                        llSetTimerEvent(0);
                        state Ready1;
                    }  
            }
        timer() 
            {       
                llGiveMoney(ID, buyer_paid);
                llInstantMessage(ID, "Vendor couldn't deliver items ... your money is refunded");
                llInstantMessage(OWNER, "Your Vendor in " + llGetRegionName() + " sim can't deliver items. Please update your Vendor.");
                llSetPayPrice(PAY_HIDE,[gCorrectAmount, PAY_HIDE, PAY_HIDE, PAY_HIDE]);
                llSetText("", <1.0, 1.0, 1.0>, 1.0);
                llSetTimerEvent(0);
                state default;         
            }                           
}
