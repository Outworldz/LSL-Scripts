// :CATEGORY:Dispenser
// :NAME:Opensim version of Dispenser
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:59
// :ID:595
// :NUM:816
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// A dispenser fo items on a sim
// :CODE:

// remote dispenser/sign 

integer debug = 0;

// Change these channels to something that only you know in the client and the server. Pick a large, negative number less than 2 billion or so.

integer talkback = -99291;
integer talktoserver = -99290;


integer listener;

key avatar = NULL_KEY;
string desc;
integer gPrice;

// give the item to a customer
dispense(key toWhom, string item, string avatar, integer amt)
{
	llRegionSay(talktoserver,"Sold|" + llGetObjectDesc() + "|" + (string) toWhom + "|" + avatar + "|" + (string) amt); // bought
}

default
{
	state_entry()
	{
		listener =  llListen(talkback,"","","");
		llRequestPermissions(llGetOwner(), PERMISSION_DEBIT);

		llRegionSay(talktoserver,"Describe|" + llGetObjectDesc()  );
	}

	touch_end(integer total_number)
	{
		// if someone touches object describe what's for sale
		listener =  llListen(talkback,"","","");
		llRegionSay(talktoserver,"Describe|" + llGetObjectDesc());
		avatar = llDetectedKey(0);
	}

	listen( integer channel, string name, key id, string message )
	{
		if (debug) llOwnerSay("heard " + message);

		list result = llParseString2List(message,["|"],[""]);
		string command = llList2String(result,0);

		if (command == "texture")
			llSetTexture(llList2String(result,1),0);  // side 0
		else if (command == "say")
			desc = llList2String(result,1);
		else if (command == "price")
		{
			gPrice = llList2Integer(result,1);
			llSetPayPrice(gPrice, [gPrice, PAY_HIDE, PAY_HIDE, PAY_HIDE]);

			if (avatar != NULL_KEY)
				llInstantMessage(avatar,desc + ", only " + (string) gPrice + " dollars");

			llListenRemove(listener);
		}




	}

	money(key id, integer amt)
	{
		if (amt >= gPrice)
		{
			// customer has given us at least enough money
			amt -= gPrice;
			string name = llKey2Name(id);
			string item = llGetObjectDesc();
			dispense(id, item, name, gPrice);
		}
		if (amt > 0) // give back change
		{
			llInstantMessage(id,"Oops,you overpaid!.  Refunding " + (string) amt);
			llGiveMoney(id, amt);
		}
	}
}


