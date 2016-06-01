// :SHOW:1
// :CATEGORY:Maibox
// :NAME:Give_All_NoteCards_To_Owner
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2016-06-01 10:19:39
// :EDITED:2016-06-01  09:23:07
// :ID:1107
// :NUM:1896
// :REV:1
// :WORLD:Second Life, Opensim
// :DESCRIPTION:
Gives one or more notcards to the owner when they touch it in a folder with todays date. Anyone can drop a notecard or other object into the prim by holding ctrl and dragging an item onto it.
// Added scripts will not run.
// :CODE:

list names; // a list of items we wish to give to owner

default
{

    state_entry()
    {
        llAllowInventoryDrop(TRUE);
    }
        
	touch_start(integer N)
	{
		// give only to owner
		if (llDetectedKey(0)== llGetOwner())
		{
			integer count = llGetInventoryNumber(INVENTORY_ALL); // 1 or more?

			while (count > 0)
			{
				// notecard indexes start at number 0, not 1, so we subtract 1
                string notecardname = llGetInventoryName(INVENTORY_ALL,count-1);
                if (notecardname != llGetScriptName())
                {
                    names += [notecardname];
                }
				count --;
            }                
            
            string folder = llGetDate();
            llGiveInventoryList(llDetectedKey(0),folder, names);

            count = llGetInventoryNumber(INVENTORY_ALL); // 1 or more?

			while (count > 0)
			{
				// notecard indexes start at number 0, not 1, so we subtract 1
                string notecardname = llGetInventoryName(INVENTORY_ALL,count-1);
                if (notecardname != llGetScriptName())
                {
                    llSay(0,"Del " + notecardname);
                   lRemoveInventory(notecardname);
                }
				count--;
            }         
        }
	}
}
