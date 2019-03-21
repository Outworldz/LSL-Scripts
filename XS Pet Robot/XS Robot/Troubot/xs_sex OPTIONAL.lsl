// :CATEGORY:XS Pet
// :NAME:XS Pet Robot
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS: Pet,XS,breed,breedable,companion,Ozimal,Meeroo,Amaretto,critter,Fennux,Pets
// :CREATED:2013-09-06
// :EDITED:2014-01-30 12:24:21
// :ID:988
// :NUM:1468
// :REV:0.50
// :WORLD:Second Life, OpenSim
// :DESCRIPTION:
// XS Pet script to make an xs_pet change prims when male or female
// :CODE:

// 

// LICENSE
/////////////////////////////////////////////////////////////////////
// This code is licensed as Creative Commons Attribution/NonCommercial/Share Alike
// See http://creativecommons.org/liceses/by-nc-sa/3.0/
// Noncommercial -- You may not use this work for commercial purposes, i.e., you cannot sell this script in any form, including derivatives.
// If you alter, transform, or build upon this work, you may distribute the resulting work only under the same or similar license to this one.
// This means that you cannot sell this or derivative code by itself, but you may share and use this code in any object or virtual world.
// You must attribute authorship in the scripts to Fred Beckhusen (Ferd Frederix) and Xundra Snowpaw, and leave this notice intact.
// You do not have to give back to the community any changes you make, however, code changes would be greatly appreciated!
//
// Exception: I am allowing this script to be used in an original build and sold with the build.
// You are not selling the script, you are selling the build. If you want to sell these scripts, write your own or use the original at http://code.google.com/p/xspets/
// Note: Xundra Snowpaw's license was 'New BSD' license and adding additional licenses is allowed.  See  http://opensource.org/licenses/BSD-3-Clause
////////////////////////////////////////////////////////////////////

string sexType = "1";            // set to a "2" for female parts


// Code begins //

integer sex =  0 ;               // no sex, 1 = male, 2 = female
integer LINK_SEX = 932;          // sex
//

default
{
    state_entry()
    {
        llSetAlpha(0.0,ALL_SIDES);       // 0 = invisible so we hide this part until we know our sex
    }

    on_rez(integer param)
    {
        llResetScript();
    }

    link_message(integer sender_num, integer num, string message, key id)
    {
        if (num == LINK_SEX )
        {
            if (message == "1")        // Male
            {
                llSetAlpha(1.0,ALL_SIDES);        // 1 = visible for male parts
            }
            else
            {
                llSetAlpha(0.0,ALL_SIDES);       // 0 = invisible
            }
        }
    }

}

