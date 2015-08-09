// :CATEGORY:Utility
// :NAME:Utility__Delete_Script
// :AUTHOR:Alondria LeFay
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:08
// :ID:941
// :NUM:1351
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Utility - Delete Script by Alondria LeFay.lsl
// :CODE:

// UTIL.deletescripts.lsl
// By Alondria LeFay
// Version 1.0


// Utility - Copy/Paste/Delete Scripts by Alondria LeFay
//I create quite a few things with pre-existant modules of scripts. It grew to become a pain to manually drag certain scripts into new objects over and over so I created a set of utility scripts to automate this. Inorder to copy the scripts, drop UTIL.copyscripts into the object you want to copy the scripts from, and UTIL.pastescripts into the object you want them copied into. The utility scripts will transfer all the scripts and then remove themselves. I also include UTIL.deletescripts, which is a quick way to remove all scripts from an object.
//Anyways, they are nothing too special, I just found myself using them a lot so I figured I'd pass them on.

integer lhook;
list scripts;

alInit(integer argi)
{
    if (lhook)
    {
        llListenRemove(lhook);
    }
    llSay(0,"Deleting scripts....");
    integer num = llGetInventoryNumber(INVENTORY_SCRIPT);
    integer i;
    for (i = 0; i < num; i = i + 1)
    {
        string tmps = llGetInventoryName(INVENTORY_SCRIPT,i);
        if (tmps != llGetScriptName())
        {
            scripts = scripts + [ tmps ];
        }
    }
    for (i = 0; i < llGetListLength(scripts); i = i + 1)
    {
        llRemoveInventory(llList2String(scripts,i));
    }
    llSay(0,"Done!");
    llRemoveInventory(llGetScriptName());
}

default
{
    on_rez(integer argi)
    {
        alInit(argi);
    }
    state_entry()
    {
        alInit(0);
    }
} // END //
