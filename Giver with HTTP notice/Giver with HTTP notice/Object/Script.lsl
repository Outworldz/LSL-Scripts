//
// Give with notice via HTTP
//

// Fill in your server and port, if necessary, port 80 is a default. It will connect to Apache with the parameter ?name=(Prim Name)
string SERVER = "http://outworldz.com";



//    * This function cases the script to sleep for 3.0 seconds.
//    * If inventory is missing from the prim's inventory then an error is shouted on DEBUG_CHANNEL.
//    * Avatar must be, or have recently been, within the same Region as sending object.
//    * Does not create a folder when avatar is a prim UUID.
//         o The prim must be in the same region.

//Examples

// When a user clicks this object, this script will give a folder containing everything in the objects inventory
// This can serve as a unpacker script for boxed objects

default {

	http_request(key id, string method, string body)
	{
		llOwnerSay("Someone just got " + llGetObjectName());
	}

	touch_start(integer total_number) {

		llHTTPRequest(SERVER + "?Name=" + llGetObjectName(),[], "");

		list        inventory;
		string      name;
		integer     num = llGetInventoryNumber(INVENTORY_ALL);
		integer     i;

		for (i = 0; i < num; ++i) {
			name = llGetInventoryName(INVENTORY_ALL, i);
			if(llGetInventoryPermMask(name, MASK_NEXT) & PERM_COPY)
				inventory += name;
			else
				llSay(0, "Don't have permissions to give you \""+name+"\".");
		}


		//we don't want to give them this script
		i = llListFindList(inventory, [llGetScriptName()]);
		inventory = llDeleteSubList(inventory, i, i);

		if (llGetListLength(inventory) < 1) {
			llSay(0, "No items to offer.");
		} else {
				// give folder to agent, use name of object as name of folder we are giving
			llGiveInventoryList(llDetectedKey(0), llGetObjectName(), inventory);
			llHTTPRequest(SERVER,[],llGetObjectName());
		}

	}
}

