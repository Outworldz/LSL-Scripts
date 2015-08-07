// :CATEGORY:Permissions
// :NAME:Check_Inventory_Permissions
// :AUTHOR:Ordinal Malaprop
// :CREATED:2012-01-28 21:13:47.813
// :EDITED:2013-09-18 15:38:50
// :ID:172
// :NUM:243
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Put this in the root prim.  It supports the following commands// // help - this help message// send - send out copies of self to all prims in object// check - check inventory permissions in object against desired perms// checkall - complete list of all permissionsfor all inventory contents
// mod - set or remove mod perm desired
// copy - set or remove copy perm desired
// trans - set or remove trans perm desired
// killall - remove all other check scripts from object (including this one)
// highlight - go thro
// :
// :CODE:

integer CHANNEL = 678;
integer LINK_N = -12390133;
integer gDesiredPerms = 0;

list LIST_TYPES = [INVENTORY_NONE, INVENTORY_TEXTURE, INVENTORY_SOUND,
	INVENTORY_LANDMARK, INVENTORY_CLOTHING, INVENTORY_OBJECT, INVENTORY_NOTECARD,
	INVENTORY_SCRIPT, INVENTORY_BODYPART, INVENTORY_ANIMATION, INVENTORY_GESTURE];
list LIST_NAMES = ["None", "Texture", "Sound", "Landmark", "Clothing", "Object", "Notecard",
	"Script", "Body Part", "Animation", "Gesture"];

//---------------------------------------------------------------------

string inventory_type(integer n)
{
	integer detected_type = llGetInventoryType(llGetInventoryName(INVENTORY_ALL, n));
	integer type_index = llListFindList(LIST_TYPES, [detected_type]);
	return llList2String(LIST_NAMES, type_index);
}

string perm_string(integer perms)
{
	list msg = [];
	if (perms & PERM_MODIFY) msg += ["mod"];
	if (perms & PERM_COPY) msg += ["copy"];
	if (perms & PERM_TRANSFER) msg += ["trans"];
	if (msg == []) return "(no perms)";
	else return llDumpList2String(msg, "/");
}

list_perms(integer all)
{
	integer f = 0;
	string report = "";
	integer perms = 0;
	do {
		perms = llGetInventoryPermMask(
			llGetInventoryName(INVENTORY_ALL, f),
			MASK_NEXT
				) & 57344;
		if (all || ((perms != gDesiredPerms)) && llGetInventoryName(INVENTORY_ALL, f) != llGetScriptName()) {
			report += (
				"\n" + llGetInventoryName(INVENTORY_ALL, f)
					+ " (" + inventory_type(f) + "): "
				+ perm_string(perms)
				);
		}
	} while (++f < llGetInventoryNumber(INVENTORY_ALL));
	if (report == "") {
		if (all) report += "\nNo inventory objects in this prim";
		else report += "\nAll inventory objects OK in this prim";
	}
	report = "Inventory permission report for " + prim_name(llGetLinkNumber()) + report;
	llOwnerSay(report);
	if (llGetLinkNumber() <= 1) {
		if (all) llMessageLinked(LINK_ALL_CHILDREN, LINK_N, "checkall", NULL_KEY);
		else llMessageLinked(LINK_ALL_CHILDREN, LINK_N, "check", NULL_KEY);
	}
}

propagate()
{
	// Sends out a copy of itself to every prim in the object
	integer f = llGetNumberOfPrims();
	if (f <= 1) {
		llOwnerSay("There's only one prim in this object");
		return;
	}
	llOwnerSay("Propagating this script throughout object...");
	// Link numbers begin with 1
	do {
		if (f != llGetLinkNumber()) {
			llGiveInventory(llGetLinkKey(f), llGetScriptName());
			llOwnerSay("Given to " + prim_name(f));
		}
	} while (--f > 0);
	llOwnerSay("Done. You will now have to recompile all of the check scripts in this object before they "
		+ "can be used - either take the object into inventory, re-rez and select 'Set all scripts to running in "
		+ "selection' from Tools menu, or manually re-save each script.");
}

help()
{
	llOwnerSay("Say commands on channel " + (string)CHANNEL + "\nhelp - this help message\n"
		+ "send - send out copies of self to all prims in object\ncheck - check"
		+ " inventory permissions in object against desired perms\ncheckall - complete list of all permissions"
		+ "for all inventory contents\nmod - set or remove mod perm desired\ncopy - set or remove copy "
		+ "perm desired\ntrans - set or remove trans perm desired\nkillall - remove all other check scripts "
		+ "from object (including this one)\nhighlight - go through all of the prims highlighting each one, to "
		+ "show permission (will spoil manual alpha adjustments!)");
	llOwnerSay("Current desired permissions - " + perm_string(gDesiredPerms));
}

kill_all_scripts()
{
	// Send out die message and remove this script too
	llOwnerSay("Sending message for other scripts to die...");
	llMessageLinked(LINK_SET, LINK_N, "die", NULL_KEY);
	die();
}

string prim_name(integer f)
{
	return "prim #" + (string)f + " (" + llGetLinkName(f) + ")";
}

die()
{
	llOwnerSay(llGetScriptName() + " in " + prim_name(llGetLinkNumber()) + " - removing myself, goodbye!");
	llRemoveInventory(llGetScriptName());
}

process_command(string msg)
{
	msg = llToLower(msg);
	if (msg == "help") help();
	else if (msg == "send") propagate();
	else if (msg == "killall") kill_all_scripts();
	else if (msg == "check") list_perms(0);
	else if (msg == "checkall") list_perms(1);
	else if (msg == "mod") {
		toggle_flag(PERM_MODIFY);
		if (llGetLinkNumber() <= 1) llMessageLinked(LINK_SET, LINK_N, "perms" + (string)gDesiredPerms, NULL_KEY);
	}
	else if (msg == "copy") {
		toggle_flag(PERM_COPY);
		if (llGetLinkNumber() <= 1) llMessageLinked(LINK_SET, LINK_N, "perms" + (string)gDesiredPerms, NULL_KEY);
	}
	else if (msg == "trans") {
		toggle_flag(PERM_TRANSFER);
		if (llGetLinkNumber() <= 1) llMessageLinked(LINK_SET, LINK_N, "perms" + (string)gDesiredPerms, NULL_KEY);
	}
	else if (llGetSubString(msg, 0, 4) == "perms") {
		gDesiredPerms = (integer)llGetSubString(msg, 5, -1);
	}
	else if (msg == "die") die();
	else if (msg == "highlight") highlight_prims();
}

toggle_flag(integer perm)
{
	gDesiredPerms = gDesiredPerms ^ perm;
	if (llGetLinkNumber() <= 1) llOwnerSay("Desired permissions are now " + perm_string(gDesiredPerms));
}

highlight_prims()
{
	integer f = llGetNumberOfPrims();
	if (f <= 1) {
		llOwnerSay("There's only one prim in this object, what's the point?");
		return;
	}
	llOwnerSay("Beginning prim highlighting");
	llSetLinkAlpha(LINK_SET, 0.1, ALL_SIDES);
	// Link numbers begin with 1
	do {
		llSetLinkAlpha(f, 1.0, ALL_SIDES);
		llOwnerSay("Highlight " + prim_name(f));
		llSleep(3.0);
		llSetLinkAlpha(f, 0.1, ALL_SIDES);
	} while (--f > 0);
	llSetLinkAlpha(LINK_SET, 1.0, ALL_SIDES);
	llOwnerSay("Done");
}

//---------------------------------------------------------------------

default
{
	state_entry()
	{
		gDesiredPerms = PERM_COPY;
		if (llGetLinkNumber() <= 1) {
			llListen(CHANNEL, "", llGetOwner(), "");
			help();
		}
		else {
			llOwnerSay(llGetScriptName() + " " + prim_name(llGetLinkNumber()) + " ready");
		}
	}

	on_rez(integer p)
	{
		llResetScript();
	}

	listen(integer c, string name, key id, string msg)
	{
		process_command(msg);
	}

	link_message(integer s, integer n, string msg, key id)
	{
		if (n == LINK_N && llGetLinkNumber() > 1) {
			process_command(msg);
		}
	}

	changed(integer change)
	{
		if (change & CHANGED_OWNER) {
			// delete if sold etc
			llRemoveInventory(llGetScriptName());
		}
		else if (change & CHANGED_LINK) {
			llResetScript();
		}
	}
}
