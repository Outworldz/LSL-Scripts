// :CATEGORY:Dispenser
// :NAME:Opensim version of Dispenser
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:59
// :ID:595
// :NUM:817
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Opensim version
// :CODE:

// Server Prim

// Change these channels to something that only you know in the client and the server. Pick a large, negative number less than 2 billion or so.

integer talkback = -99291;
integer talktoserver = -99290;


integer debug = 0;

integer listener;

string left(string src, string divider) {
	integer index = llSubStringIndex( src, divider );
	if(~index)
		return llDeleteSubString( src, index , -1);
	return src;
}

string right(string src, string divider) {
	integer index = llSubStringIndex( src, divider );
	if(~index)
		return llDeleteSubString( src, 0, index + llStringLength(divider) - 1);
	return src;
}

// give the item to a customer
dispense(key toWhom,string name)
{
	llGiveInventory(toWhom,name);
}



default
{
	state_entry()
	{
		listener =  llListen(talktoserver,"","","");

		llRegionSay(talktoserver,"Describe|" + llGetObjectDesc()  );
	}

	touch_end(integer total_number)
	{
		// if someone touches object describe what's for sale
		listener =  llListen(talkback,"","","");
		llRegionSay(talktoserver,"Describe|" + llGetObjectDesc());
	}

	listen( integer channel, string name, key id, string message )
	{
		if (debug) llOwnerSay("heard " + message);

		list result = llParseString2List(message,["|"],[""]);
		string command = llList2String(result,0);

		if (command == "Describe")
		{
			integer number = llList2Integer(result,1);
			string name1 = llGetInventoryName( INVENTORY_TEXTURE, number);
			key texturekey = llGetInventoryKey(name1);
			llRegionSay(talkback,"texture|" + (string) texturekey);

			string price = right(name,",");
			name1 = left(name1,",");
			llRegionSay(talkback,"say|" + name1);
			llRegionSay(talkback,"price|" + price);

		}

		if(command == "Sold")
		{
			llOwnerSay("Sold");
			integer number = llList2Integer(result,1);
			string skey = llList2String(result,2);
			string sname = llList2String(result,3);
			string samt = llList2String(result,4);
			string name2 = llGetInventoryName( INVENTORY_OBJECT, number);
			llGiveInventory((key) skey,name2);
			llInstantMessage(llGetOwner(),sname + " bought " + name2 + " for $" + samt);

		}


	}

}


