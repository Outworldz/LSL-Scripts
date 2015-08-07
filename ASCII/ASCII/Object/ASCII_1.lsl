// :CATEGORY:Strings
// :NAME:ASCII
// :AUTHOR:ChadStatosky
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-25 14:03:03
// :ID:54
// :NUM:81
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// A set of utilities for converting bytes to ASCII
// :CODE:
string ASCII = "             \n                   !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";
integer ord(string chr)
{
    if(llStringLength(chr) != 1) return -1;
    if(chr == " ") return 32;
    return llSubStringIndex(ASCII, chr);
}
string chr(integer i)
{
    i %= 127;
    return llGetSubString(ASCII, i, i);
}
