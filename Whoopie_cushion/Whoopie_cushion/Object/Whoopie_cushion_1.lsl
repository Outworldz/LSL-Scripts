// :CATEGORY:whoopie cushion
// :NAME:Whoopie_cushion
// :AUTHOR:jab737
// :CREATED:2013-01-07 20:05:59.953
// :EDITED:2013-09-18 15:39:09
// :ID:978
// :NUM:1400
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// I couldn't find a basic, straightforward whoopie cushion script for a Second Life class I was taking, so I made one.
// :CODE:
//JackieBee's Whoope Cushion Script
//drop it and any soundfile into any object that can be sat on
//Created for Rah Rehula's Second Life class @ Yavapai College AZ
//Rah's Renegades Spring 2012

default
{
    state_entry()
    {
        
    
    llSetText("",<1.0,1.0,1.0>,1.0);//hovering text in ""
    llSetSitText(""); //change action text in pie/menu   
    llSitTarget(<0.3,0.0,0.3>,ZERO_ROTATION);//adjust Sit Target
    }
    changed(integer change)
    {
    if (change == CHANGED_LINK)
    {
        key avatar=llAvatarOnSitTarget();
        if(avatar != NULL_KEY)
        { 
            llLoopSound("Fart",1.0);//add soundfile name(& file)
        }
        else if(avatar == NULL_KEY)
        {
            llStopSound();
        }
    }
}
} 
