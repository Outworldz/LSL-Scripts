// :CATEGORY:Math
// :NAME:Floats_to_Hex
// :AUTHOR:StrifeOnizuka
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:53
// :ID:326
// :NUM:438
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// How it works:
// :CODE:
string hexc="0123456789ABCDEF";//faster

string Float2Hex(float a)
{// Copyright Strife Onizuka, 2006, LGPL, http://www.gnu.org/copyleft/lesser.html
    //If it's zero, the zero stripper will hang, lets avoid that
    if(a)
    {//we need to find the exponent, but to do that we need to take the log of the number (or run a while loop)
        float b = llFabs(a);//logs don't work on negatives.
        string f = "p";//This is a trade off, slightly slower (only slightly) for a couple bytes savings (10)
        //To get the exponent we need to round the integer portion down or the log2(b)
        //  LSL doesn't have log2, so we use one of the laws of logs to get it from the natural log
        integer c = llFloor(llLog(b) / 0.69314718055994530941723212145818);//floor(log2(b))
        //There is a rounding error in the exponent that causes it to round up, this usualy isn't a problem as the
        //  exponent only is only used to shift the number. It becomes a problem when dealing with float max as
        //  it will round up to 128; which will crash llPow.
        if(c > 127) c = 127;//catch fatal rounding error in exponent.
        //Q: why not do (b * llPow(2,-c))? A: because the range of floats are different at the top and bottom
        //  at the top it's 2^127 at the bottom it's 2^-149; and if you tried to do this otherwise,
        //  llPow would crash with an overflow. Then we multiply it by 2 ^ 24, floats only use 23 bits for the mantisa,
        //  we cannot add it into c because we could overflow llPow; we correct the value of c later.
        // Instead of using llPow(2.0, c) we are using (float)("0x1p"+(string)c), it's 10% faster and 16 bytes lighter.
        integer d = (integer)((b / (float)("0x1p"+(string)c)) * 0x1000000);//shift up into integer range
        while(!(d & 0xf))
        {//strip extra zeros off before converting or they break "p"
            //a catch22 of sorts, you cannot know exactly how far to shift it till after you have shifted it
            d = d >> 4;
            c+=4; //for each zero stripped we must adjust the exponent
        }
        do//convert to hex
            f = llGetSubString(hexc,15&d,15&d) + f;
        while(d = d >> 4);
        if(a < 0)//final formating & c adjustment (from making it an integer)
            return "-0x" + f +(string)(c - 24);
        return "0x" + f +(string)(c - 24);
    }//no point in this getting special formating.
    return "0";//zero would hang the zero stripper.
}
