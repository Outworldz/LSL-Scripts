// :CATEGORY:Vendor
// :NAME:Vendor_System_Script
// :AUTHOR:Kristy Fanshaw 
// :CREATED:2011-01-22 12:49:11.923
// :EDITED:2013-09-18 15:39:09
// :ID:949
// :NUM:1368
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Updater Script for Reseller vendor// // Place this script in a box you've created.// // What it does:
// 
//    1. when rezzed next to the vendor, it will try to update the vendors URL string.
//    2. when vendor gets the URL, the updater dies. It doesn't die until the vendor is updated. 
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
 
string URL = "http://www.my-web.com/my-secret-webpages/my-sl-stuff/my-vendor-name/";      // Write here the URL of the page where is defined the server email address
string update_box = "update box name";                                                    // Write here the name you like, but be sure the name here matches with a name in vendor script
integer Ch;
integer listen_handle;
 
default
    {
        state_entry ()
            {
                Ch =  ( -1 * (integer)("0x"+llGetSubString((string)llGetCreator(),-7,-1)) );
                listen_handle = llListen(Ch,"", NULL_KEY, "");
                llSetObjectName(update_box);
                llSetText("Updating your vendor\n\nPlease Wait ...", <1.0, 1.0, 1.0>, 1.0);
            }
        listen( integer channel, string name, key id, string message )
            {
                if(message == "update")
                    {
                        llShout(Ch, URL);
                    }        
                else if (message == "updated")
                    {
                        llDie();
                    }
            }
}
