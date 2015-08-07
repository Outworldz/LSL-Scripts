// :CATEGORY:HoverText
// :NAME:MM_SVN_Titler_v1
// :AUTHOR:Fenrir Reitveld
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:57
// :ID:516
// :NUM:700
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// MM SVN Titler v1.lsl
// :CODE:

// -[ Licensing and Copyright ]-----------------------
//
// Script copyright by Fenrir Reitveld, 02/10/06
//
// This program is free software; you can redistribute it and/or modify it under the terms of the
// GNU General Public License version 2 as published by the Free Software Foundation.
//
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
// without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
// the GNU General Public License for more details.

// You should have received a copy of the GNU General Public License along with this program in a
// notecard; if not, write to the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
// Boston, MA  02110-1301, USA.
//
// GPL license version 2 on the web: http://www.gnu.org/copyleft/gpl.html (Note, URL might change
// once v3 is released.)

// -[ Script Purpose ]--------------------------------
//
// Not much to it.  This script just sets the text above our vendor.  If you want to have the
// floating text appear over a prim that is not the root prim (where the inventory and core
// vendor scripts live), then place this in the prim.
//

default
{
    state_entry()
    {
        llSetText ("Master!", ZERO_VECTOR, 0.0) ;
    }
    link_message (integer sender, integer num, string msg, key id)
    {
        if (num == 4500)  // Set our title
        {
            vector color = (vector)((string)id) ;
            llSetText (msg, color, 1.0) ;
        }
    }

}
// END //
