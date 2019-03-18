// :SHOW:1
// :CATEGORY:Mailbox
// :NAME:Give_All_NoteCards_To_Owner
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2016-06-01 10:19:38
// :EDITED:2016-06-01  09:23:07
// :ID:1107
// :NUM:1895
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Gives one or more notcards to whoever touches it, by name. Notecards have to be in Legacy name format such as 'Fred Beckhusen (Ferd Frederix)', or 'Fred Beckhusen (Ferd Frederix)1', 'Fred Beckhusen (Ferd Frederix)2'.  Not the 'Ferd.Frederix' style.
// :CODE:

// give notecard by Legacy name
// i.e. "John Doe" or if lastname Resident "John Resident"

integer debug = FALSE;

default
{
	touch_start(integer N)
	{
		integer count = llGetInventoryNumber(INVENTORY_NOTECARD); // 1 or more?

		while (count > 0)		
        {
            // notecard indexes start at number 0, not 1, so we subtract 1
            string notecardname = llGetInventoryName(INVENTORY_NOTECARD,count-1);

            //      name is the legacy name, i.e. "John Doe" or if lastname Resident "John Resident"
            string avatarName= llDetectedName(0);

            if (debug)avatarName = "Ferd Resident";
            if (debug) llSay(0,avatarName);
            
            //  Returns an integer that is the index of the first instance of pattern in source.
            // Function: integer llSubStringIndex( string source, string pattern );
            // src (or notecard) = Ferd.Fredrix03, pattern = Ferd.Frederix, if it matches == 0
            if (llSubStringIndex(notecardname, avatarName) == 0)
            {
                if (debug) llSay(0,"Giving " + notecardname);
                llGiveInventory(llDetectedKey(0), notecardname);
                if (!debug)
                    llRemoveInventory(notecardname);
            }
            
            
            count--; // count dowb to zero
		}
	}
}
