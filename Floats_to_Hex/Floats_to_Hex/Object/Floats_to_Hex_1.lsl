// :CATEGORY:Math
// :NAME:Floats_to_Hex
// :AUTHOR:StrifeOnizuka
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:53
// :ID:326
// :NUM:435
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Use to encode floats in hex notation, minimal overhead, does not introduce errors. No special decoder needed. Try it.// // Use this instead of (string) when converting floats to strings.// // LSL (float) typecast supports C99 hex floats. This is good because with hex you can store floats without the need for a special decoder (just use (float)) and since hex is a power of 2 format, floats can be stored without any loss or rounding errors.// 
// A similar function (also by me) Float to Scientific Notation, works much the same way (except it uses base 10). The trouble is it has to emulates higher precision math, in a scripting language this is a bad solution. Because of the base conversion using logs would introduce a huge accumulated error (read as: floats suck). Resulting in the need to do the shifting with a while loop. This wasn't good enough, even with 32 bits small numbers would still be corrupted by the shifting. An integer and a float (or in one rewrite two integers) were used, one to store the integer portion, and the other the float. This worked, but was slow as all get out for large and small numbers (2 seconds). Finaly some optical approches were used to do the conversion which sped up large numbers. While accurate, the function was slow and used alot of memory.
// 
// This function is much faster, it requires about 900 instructions with little deviation from that number. In the sceme of things it's not too costly (on a not too lagged sim that is about 0.12 seconds). There isn't much that can be done to reduce the number of instructions executed, unless LL wants to give us an llInteger2HexString or an llFloat2HexString.
// 
// UPDATE:
// There was a small bug that would cause the script to crash on numbers that were greater then 0x1.FFFFF8p127. Please update to fix the script crash issue. As a result of the fix, it will be just a bit slower.
// :CODE:
string hexc="0123456789ABCDEF";//faster

string Float2Hex(float input)
{// Copyright Strife Onizuka, 2006, LGPL, http://www.gnu.org/copyleft/lesser.html
    if((integer)input != input)//LL screwed up hex integers support in rotation & vector string typecasting
    {//this also keeps zero from hanging the zero stripper.
        float unsigned = llFabs(input);//logs don't work on negatives.
        integer exponent = llFloor(llLog(unsigned) / 0.69314718055994530941723212145818);//floor(log2(b))
        if(exponent > 127) exponent = 127;//catch fatal rounding error in exponent.
        integer mantissa = (integer)((unsigned / (float)("0x1p"+(string)exponent)) * 0x1000000);//shift up into integer range
        while(!(mantissa & 0x1))
        {//strip extra zeros off before converting or they break "p"
            mantissa = mantissa >> 1;
            exponent = -~exponent;//++c;
        }
        string str = "p" + (string)(exponent - 24);
        do
            str = llGetSubString(hexc,15&mantissa,15&mantissa) + str;
        while(mantissa = mantissa >> 4);
        if(input < 0)
            return "-0x" + str;
        return "0x" + str;
    }//integers pack well so anything that qualifies as an integer we dump as such, supports netative zero
    return llDeleteSubString((string)input,-7,-1);//trim off the float portion, return an integer
}
