// :CATEGORY:Menu
// :NAME:Generalized_Menu_Engine
// :AUTHOR:Zonax Delorean
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:54
// :ID:344
// :NUM:463
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// The "menudefs" notecard:
// :CODE:
MENU DEFAULT
TEXT ~ Main Menu ~\nSelect a function
TOMENU SETTITLE Set title
OPTION Start vote
TOMENU CLITEM Clear Item
OPTIONASK Reset

MENU SETTITLE
TEXT Set title for which item?
OPTION 1
OPTION 2
OPTION 3

MENU CLITEM
TEXT Clear title and picture for which item?
OPTION 1
OPTION 2
OPTION 3

MENU INVOTE
TEXT Voting in progress...
OPTIONASK Clear votes
OPTIONASK Close voting

MENU VOTEDONE
TEXT Vote closed
OPTIONASK Restart voting
OPTION Tell results
