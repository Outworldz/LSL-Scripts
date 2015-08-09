// :CATEGORY:Texture
// :NAME:hide_showchan9
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:54
// :ID:381
// :NUM:529
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// hide_show-chan9.lsl
// :CODE:

default
{
    
    state_entry()
    {
        llListen(9, "","", "" );
}
     listen(integer channel, string name, key id, string text)
    {
        if(text=="hide"){
            llSetAlpha(0.0,ALL_SIDES);
             llSetStatus(STATUS_PHANTOM,TRUE);
             llSetText("",<0,0,0>,1);
            }
        if(text=="show"){
            llSetAlpha(1,ALL_SIDES);
            llSetStatus(STATUS_PHANTOM,FALSE);
            llSetText("",<256,256,256>,1);
         }
        
    }
}// END //
