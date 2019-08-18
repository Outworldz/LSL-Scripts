// :SHOW:
// :CATEGORY:Scripting
// :NAME:Script Tests
// :AUTHOR:Justin Clark-Casey (justincc)
// :KEYWORDS:Opensim
// :CREATED:2019-04-04 20:49:51
// :EDITED:2019-04-04  19:49:51
// :ID:1124
// :NUM:2001
// :REV:1
// :WORLD:Opensim
// :DESCRIPTION:
// One of many tests for Opensim
// :CODE:

default
{
    state_entry()
    {
        // set sit target, otherwise this will not work 
        llSitTarget(<0.0, 0.0, 0.1>, ZERO_ROTATION);
    }
    changed(integer change)
    {
        if (change & CHANGED_LINK)
        { 
            key av = llAvatarOnSitTarget();
            //evaluated as true if not NULL_KEY or invalid
            if (av)
            {
                llSay(0, "Hello " + llKey2Name(av) + ", thank you for sitting down");
            }
        }
    }
}
