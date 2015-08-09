// :CATEGORY:Vendor
// :NAME:Vendor_System_Script
// :AUTHOR:Kristy Fanshaw 
// :CREATED:2011-01-22 12:49:11.923
// :EDITED:2013-09-18 15:39:09
// :ID:949
// :NUM:1369
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Server Script and Mailer Script for "Server Object"// // Place these scripts into a box you've created as a server prim.// Place the object you'd like to sell into this prim - only one object// 
// Server Script:
// 
//    1. when rezzed, it will tell you it's email address.
//    2. when this scrpt gets an email from the vendor, it gives the inventory item to buyer and asks mailer script to send a note back to vendor that the delivery is done.
//    3. when touched by the owner, it says totalsold. 
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
 
string my_address = "my.email@email.com";       // Write here the email, where you want to recieve the message with new server email address.
integer total_mailers = 5;                      // How many mailer scripts you have in server prim. 5 mailer scripts are Recomended min. because of llEmail function.
integer mailer = 1;                             
 
default
    {
        changed(integer change)
            {
                if(change && CHANGED_OWNER)
                    {
                        llSetObjectDesc("0");
                        llResetScript();
                    }       
            }
        on_rez(integer start_parameter)
            {
                llOwnerSay("new email is: " + (string)llGetKey() + "@lsl.secondlife.com");
                llEmail(my_address,llGetObjectName() , "my new email is: " + (string)llGetKey() + "@lsl.secondlife.com");
                llOwnerSay("message with new address is sent to your email");
            }
        state_entry()
            {               
                llSetObjectName(llGetInventoryName(INVENTORY_OBJECT,0));
                llSetText(llGetObjectName(),<1,1,1>,1);
                totalsold = (integer)llGetObjectDesc();
                llOwnerSay("new email is: " + (string)llGetKey() + "@lsl.secondlife.com");
                llEmail(my_address,llGetObjectName() , "my new email is: " + (string)llGetKey() + "@lsl.secondlife.com");
                llOwnerSay("message with new address is sent to your email");
                llSetTimerEvent(5.0);               
            } 
        timer()
            {
                llGetNextEmail("", "");
            }
        email( string time, string address, string subj, string message, integer num_left )
            {
                llGiveInventory(subj,llGetInventoryName(INVENTORY_OBJECT,0) );
                message = llDeleteSubString(message, 0, llSubStringIndex(message, "\n\n") +1);
                llMessageLinked(LINK_THIS, mailer, message, "");
                if (mailer <= total_mailers)
                    {
                        mailer = mailer + 1;
                    }
                if (mailer >= total_mailers + 1)
                    {
                        mailer = 1;  
                    }
                totalsold = totalsold + 1;
                llSetObjectDesc((string)totalsold);
                llGetNextEmail("", "");
            }
        touch_start(integer total_number)
            {
                if (llDetectedOwner(0) == llGetOwner())
                    {
                        llOwnerSay((string)totalsold +" units have been sold since server update. ");
                    }
                else
                    {
                        llInstantMessage(llDetectedKey(0), "please don't touch"); 
                    }
            }
}
