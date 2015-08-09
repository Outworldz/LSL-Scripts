// :CATEGORY:Math
// :NAME:Floats_to_Hex
// :AUTHOR:StrifeOnizuka
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:53
// :ID:326
// :NUM:439
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// This version is perfect, it is slightly slower. It properly handles the exponent bug. It's included for curiosities sake (and a bunch of work went into it and i didn't want to throw it away).
// :CODE:
string Float2Hex(float a)
{// Copyright Strife Onizuka, 2006, LGPL, http://www.gnu.org/copyleft/lesser.html
    if(a)
    {
        float b = llFabs(a);
        integer c = llFloor(llLog(b) / 0.69314718055994530941723212145818);//floor(log2(b))
        string f = "";
        if(c > 127) c = 127;
        else if(c < -126) c = -126;
        else c -= ((float)("0x1p"+(string)c) > b);
        integer d = ((integer)(b / (float)("0x.000002p"+(string)c)) & 0x7FFFFF) << 1;
        integer m = 6;
        while(!(d & 0xf))
        {//strip extra zeros off before converting or they break "p"
            d = d >> 4;
            --m;
        }
        do
        {
            f = llGetSubString(hexc, 0xf & d, 0xf & d) + f;
            d = d >> 4;
        }while(--m);
        if(a < 0)
            return "-0x"+(string)(b > 1.1754943508222875079687365372222e-38)+"."+f +"p"+(string)(c);
        return "0x"+(string)(b > 1.1754943508222875079687365372222e-38)+"."+f +"p"+(string)(c);
    }
    return "0";//zero would hang the zero stripper.
}
