// :SHOW:
// :CATEGORY:Scripting
// :NAME:Script Tests
// :AUTHOR:Justin Clark-Casey (justincc)
// :KEYWORDS:Opensim
// :CREATED:2019-04-04 20:49:51
// :EDITED:2019-04-04  19:49:51
// :ID:1124
// :NUM:1980
// :REV:1
// :WORLD:Opensim
// :DESCRIPTION:
// One of many tests for Opensim
// :CODE:

default
{
   state_entry()
   {
       llTargetOmega( < 0, 1, 1 >, .2 * PI, 1.0 );
   }
}

