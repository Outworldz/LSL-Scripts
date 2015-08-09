// :CATEGORY:Easy Animator
// :NAME:Easy_Animal_Animator_script_for_mul
// :AUTHOR:Ferd Frederix
// :CREATED:2010-06-01 13:49:28.000
// :EDITED:2013-09-18 15:38:52
// :ID:267
// :NUM:358
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// These scripts are  licensed under the GPL and are not to be sold.  Objects created with them may be under any license. This script is open source and is not for sale.  This first script is the child prim script. Any prims you want to move must have one of these scripts.    Instructions are online ain my Blue Whale Project at http://secondlife.mitsi.com/Secondlife/Code/fish/
// :CODE:
// Open source, GPL license.
// Do not remove the header, do not sell this script.
// ______           _  ______            _           _
// |  ___|         | | |  ___|          | |         (_)
// | |_ ___ _ __ __| | | |_ _ __ ___  __| | ___ _ __ ___  __
// |  _/ _ \ '__/ _` | |  _| '__/ _ \/ _` |/ _ \ '__| \ \/ /
// | ||  __/ | | (_| | | | | | |  __/ (_| |  __/ |  | |>  <
// \_| \___|_|  \__,_| \_| |_|  \___|\__,_|\___|_|  |_/_/\_\
//
// author Ferd Frederix

// Prim positioner child script.
// Put a copy of this script in any prim you wish to move

integer debug = 0;
integer linkchannel = 5001;		 // for recording purposes
vector vLastpos;
rotation rLastrot;

default
{
	on_rez(integer p)
	{
		llResetScript();
	}

	// accept messages from the main script
	link_message(integer sender_num, integer num, string msg, key id)
	{
		if (msg == "Set")  // SEt records the current prim rot and pos.
		{
			llSleep(llFrand(3.0));
			vector vPos = llGetLocalPos();
			rotation rRot = llGetLocalRot();

			if (vPos != vLastpos || rRot != rLastrot)
				llMessageLinked(LINK_ROOT, linkchannel, (string) vPos + "|" + (string) rRot, "");

			vLastpos = vPos;
			rLastrot = rRot;
		}
		else if (msg == "Remove")		// deletes the script from the child to help with lag
		{
			if (debug)
				llSetScriptState(llGetScriptName(),FALSE);
			else
				llRemoveInventory(llGetScriptName());
		}
		else if (msg == "Reset")		// set the coords to some rare value so the prim will have been seen to have moved
		{
			vLastpos = <0,0,0>;
			rLastrot = <0,0,0,1>;
		}
		else if (msg == "All")	// dump the current pos and rot to the server
		{
			vector vPos = llGetLocalPos();
			rotation rRot = llGetLocalRot();
			llSleep(llFrand(3.0));
			llMessageLinked(LINK_ROOT, linkchannel, (string) vPos + "|" + (string) rRot, "");
		}
	}
}
