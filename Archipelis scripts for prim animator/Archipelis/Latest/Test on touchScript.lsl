// :CATEGORY:Prim Animator
// :NAME:Archipelis scripts for prim animator
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:48
// :ID:52
// :NUM:74
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// When touched will trigger an animation named "jump"
// :CODE:


default
{
    state_entry()
    {
        
    }
    
    
    touch_start(integer count)
    {
        llMessageLinked(LINK_SET, 1,"jump","");
    } 
}
