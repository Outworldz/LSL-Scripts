// :CATEGORY:XY Text
// :NAME:Chat_Listen_Script
// :AUTHOR:fratserke
// :CREATED:2010-11-09 05:56:08.910
// :EDITED:2013-09-18 15:38:50
// :ID:168
// :NUM:239
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// 1 part of XY Text 
// :CODE:
////////////////////////////////////////////
// Hello World! Script
//
// Written by Xylor Baysklef
////////////////////////////////////////////

/////////////// CONSTANTS ///////////////////
// XyText Message Map.
integer DISPLAY_STRING      = 204000;
///////////// END CONSTANTS ////////////////

show_line(string line, integer num)
{
    string part1 = llGetSubString(line, 0, 5);
    string part2 = llGetSubString(line, 6, 11);
    string part3 = llGetSubString(line, 12, 17);
    
    llMessageLinked(2+(num*3), DISPLAY_STRING, part1, "");
    llMessageLinked(3+(num*3), DISPLAY_STRING, part2, "");
    llMessageLinked(4+(num*3), DISPLAY_STRING, part3, "");
}

default {
    state_entry() {
        llListen(0, "", llGetOwner(), "");
    }
    
    listen(integer channel, string name, key id, string message)
    {
        // split chat into lines
        string line1 = llGetSubString(message, 0, 17);
        string line2 = llGetSubString(message, 18, 35);
        string line3 = llGetSubString(message, 36, 53);
        string line4 = llGetSubString(message, 54, 71);
        show_line(line1, 0);
        show_line(line2, 1);
        show_line(line3, 2);
        show_line(line4, 3);
    }
}
