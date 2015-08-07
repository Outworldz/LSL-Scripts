// :CATEGORY:Keyboards
// :NAME:NN_Free_Keyboard_Script
// :AUTHOR:nonnux White
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:58
// :ID:555
// :NUM:759
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// NN Free Keyboard Script by nonnux White.lsl
// :CODE:

// the first free keyboard script
// by nonnux White
// free to mod, sell, erase, explode, burn :)
list anims = [];
default
{
    state_entry()
    {
        llSetTimerEvent(.2);
    }
    timer()
    {
        anims = llGetAnimationList(llGetOwner());
        if(llListFindList(anims,[(key)("c541c47f-e0c0-058b-ad1a-d6ae3a4584d9")]) != -1)
        {
            llSetText("",<1,0,0>,1);
        llSetLinkAlpha(LINK_SET,1.0,ALL_SIDES);            
        }
        if(llListFindList(anims,[(key)("c541c47f-e0c0-058b-ad1a-d6ae3a4584d9")]) == -1)
        {
            llSetText("",<1,1,0>,1);
            llSetLinkAlpha(LINK_SET,0.0,ALL_SIDES);
        }
    }
}// END //
