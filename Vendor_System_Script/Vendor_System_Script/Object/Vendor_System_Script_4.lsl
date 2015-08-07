// :CATEGORY:Vendor
// :NAME:Vendor_System_Script
// :AUTHOR:Kristy Fanshaw 
// :CREATED:2011-01-22 12:49:11.923
// :EDITED:2013-09-18 15:39:09
// :ID:949
// :NUM:1370
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Mailer script.// //    1. Make as many numbers of mailer sciprts you need and place them into server object.//    2. Name them with numbers starting from number "1".//    3. Don't skip any numbers: if you have 5 mailer scripts in you server object then you their names should be 1, 2, 3, 4 and 5. 
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
 
string mailer_num;
 
default
    { 
        link_message(integer sender_num, integer num, string msg, key id) 
            {
                mailer_num = llGetScriptName();
                if (num == (integer)mailer_num)
                    {
                        llEmail(msg,"delivered", (string)num);
                    }
            }
}
