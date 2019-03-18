// :CATEGORY:Teleport
// :NAME:Elven Door Teleport System
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2014-12-04 12:10:54
// :EDITED:2014-12-04
// :ID:1056
// :NUM:1678
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// DESCRIPTION: []::Elven Door teleport System
// :CODE:

default
{
    state_entry()
    {
        llSetTextureAnim(ANIM_ON | LOOP, 4,4,2,0,0,6.0);
    }
    on_rez(integer p)
    {
        llResetScript();
    }
}
