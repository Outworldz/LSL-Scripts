// :CATEGORY:Drop Box
// :NAME:Dropbox
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:52
// :ID:264
// :NUM:355
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Dropbox.lsl
// :CODE:

//See the video at: http://cter.ed.uiuc.edu/tutorials/SecondLife/dropbox.mov
//Created by ANONYMOUS.
default 
{ 
state_entry() 
{ 
    llAllowInventoryDrop(TRUE); 
    llSay(0, "Please drop your notecard here by dragging it into the box from your inventory."); 
} 
    changed(integer mask) 
{ 
    if(mask & (CHANGED_ALLOWED_DROP | CHANGED_INVENTORY)) 
    llWhisper(0, "Thank you for submitting your notecard!"); 
} 
} // END //
