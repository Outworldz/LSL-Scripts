// :CATEGORY:Inventory Giver
// :NAME:A_Friendly_Unpacker
// :AUTHOR:Rolig Loon
// :CREATED:2011-07-05 15:42:02.557
// :EDITED:2013-09-18 15:38:47
// :ID:9
// :NUM:14
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Unpacker scripts scatter no-copy items all over your inventory. This can mean that you get a lot of IMs from frustrated and confused SL newbies who open one of your gift boxes and then can't find where everything went.  There's no new magic to this short script -- you still have to give no-copy items individually, after all -- but it does send the new owner a friendly message that tells where to look for each unpacked item.// // This work uses content from the Second Life® LSL Script library. Copyright © 2007-2009 Linden Research, Inc. Licensed under the Creative Commons Attribution-Share Alike 3.0 License.
// :CODE:
list gItems;
list gNocopy;
list gList_types = [INVENTORY_NONE,INVENTORY_TEXTURE, INVENTORY_SOUND, INVENTORY_LANDMARK,INVENTORY_CLOTHING, INVENTORY_OBJECT, INVENTORY_NOTECARD, INVENTORY_SCRIPT,INVENTORY_BODYPART, INVENTORY_ANIMATION, INVENTORY_GESTURE];
list gList_names = ["None", "Texture", "Sound", "Landmark", "Clothing", "Object", "Notecard", "Script", "Body Part", "Animation", "Gesture"];

default
{
    state_entry()
    {
        integer All = llGetInventoryNumber(INVENTORY_ALL);
        while (All)
        {
            string name = llGetInventoryName(INVENTORY_ALL, All - 1);
            if (name != llGetScriptName())
            {
                if(llGetInventoryPermMask(name, MASK_OWNER) & PERM_COPY)
                {
                    gItems += [name]; //Copy perm items
                }
                else
                {
                    gNocopy += [name];  //No-copy perm items
                }
            }
            --All;
        }
    }
    
    changed (integer change)
    {
        if ((change & CHANGED_INVENTORY) || (change & CHANGED_OWNER))
        {
            llResetScript();
        }
    }

    touch_start(integer num)
    {
        llOwnerSay("Look for unpacked items in a folder named " + llGetObjectName() + " in your inventory.");
        llGiveInventoryList(llGetOwner(), llGetObjectName(), gItems);
        integer len = llGetListLength(gNocopy);
        if (len) 
        {
            llOwnerSay("Also, look for the following one-of-a-kind items:");
            while (len) 
            {
                // Determine what kind of inventory this is, and find that type in the gList_types list
                integer idx = llListFindList(gList_types,[llGetInventoryType(llList2String(gNocopy,len-1))]);
                // Then use idx to find the name of that type in the gList_names list and say it
                if (~idx)
                {
                    llOwnerSay(llList2String(gNocopy,len-1) + " will be in your " + llList2String(gList_names,idx) + " folder.");
                    llGiveInventory(llDetectedKey(0),llList2String(gNocopy,len-1));
                }
                --len;
            }
        }
    }
}
