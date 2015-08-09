// :CATEGORY:Calculator
// :NAME:Oddeven_calculator
// :AUTHOR:Blind Paine
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:58
// :ID:580
// :NUM:796
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// A script which calculates whether or not an integer (non-deciaml nuber) is odd or even. Integers must be above -2147483648 and below 2147483648. 
// :CODE:
//Author: TSL Resident, Blind Paine

integer number;
string pre="mod "; //Set prefix here
default
{
    state_entry()
    {
        llListen(0,"",llGetOwner(),"");
    }

    listen(integer chan,string name, key id,string msg)
    {
        if(llSubStringIndex(msg,pre)==0)
        {
            number=(integer)llGetSubString(msg,llStringLength(pre),-1); 
            if(number%2==1)
            { 
                llOwnerSay((string)number+" is an odd number.");
            }
            
            if(number%2==0)
            {
                llOwnerSay((string)number+" is an even number.");
            }
    
        }
    }
    
    changed(integer change)
    {
        if(change&CHANGED_OWNER)
        {
            llResetScript();
        }
    }
}
