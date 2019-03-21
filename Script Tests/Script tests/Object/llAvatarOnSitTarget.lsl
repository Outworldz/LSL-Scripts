// :SHOW:
// :CATEGORY:Scripting
// :NAME:Script Tests
// :AUTHOR:Justin Clark-Casey (justincc)
// :KEYWORDS:Opensim
// :CREATED:2019-03-18 23:44:22
// :EDITED:2019-03-18  22:44:22
// :ID:1116
// :NUM:1948
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
