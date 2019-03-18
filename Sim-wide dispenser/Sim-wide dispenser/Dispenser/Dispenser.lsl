// :CATEGORY:Dispenser
// :NAME:Sim-wide dispenser
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:02
// :ID:753
// :NUM:1036
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Sim wide dispenser from a central prim
// :CODE:

// remote dispenser/sign
// 7/23/2013  Modified for OpenSim-type string handling

integer debug = FALSE;

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
    llOwnerSay("Sold|" + GetObjectDesc() + "|" + (string) toWhom + "|" + avatar + "|" + (string) amt);
    llRegionSay(talktoserver,"Sold|" + GetObjectDesc() + "|" + (string) toWhom + "|" + avatar + "|" + (string) amt); // bought
}

string GetObjectDesc()
{
    if (debug) {
        llOwnerSay("Debug is on, always using the first item");
        return "0";
    }
    else
        return llGetObjectDesc();
}

default
{
    state_entry()
    {
        listener =  llListen(talkback,"","","");
        llRequestPermissions(llGetOwner(), PERMISSION_DEBIT);
        if(debug) llOwnerSay("Describe|" + GetObjectDesc() );
        llRegionSay(talktoserver,"Describe|" + GetObjectDesc()  );
    }

    touch_end(integer total_number)
    {
        // if someone touches object describe what's for sale
        listener =  llListen(talkback,"","","");
        if(debug) llOwnerSay("Describe|" + GetObjectDesc() );
        llRegionSay(talktoserver,"Describe|" + GetObjectDesc());
        avatar = llDetectedKey(0);
    }

    listen( integer channel, string name, key id, string message )
    {
        if (debug) llOwnerSay("Dispenser heard " + message);

        list result = llParseString2List(message,["|"],[""]);

        key akey = (key) llList2String(result,0);

        if (debug) llOwnerSay("Dispenser found key " + akey);
        if (akey == llGetKey())
        {
            string command = llList2String(result,1);

            if (command == "texture")
                llSetTexture(llList2String(result,2),0);  // side 0
            else if (command == "say")
                desc = llList2String(result,2);
            else if (command == "price")
            {
                gPrice = (integer) llList2String(result,2);
                llSetPayPrice(gPrice, [gPrice, PAY_HIDE, PAY_HIDE, PAY_HIDE]);
                if (debug) llOwnerSay("Setting Pay Price of " + (string) gPrice);

                if (avatar != NULL_KEY)
                    llInstantMessage(avatar,desc + ", only " + (string) gPrice + " dollars");

                llListenRemove(listener);
            }
        }



    }

    money(key id, integer amt)
    {
        if (amt >= gPrice)
        {
            // customer has given us at least enough money
            amt -= gPrice;
            string name = llKey2Name(id);
            string item = GetObjectDesc();
            dispense(id, item, name, gPrice);
        }
        if (amt > 0) // give back change
        {
            llInstantMessage(id,"Oops,you overpaid!.  Refunding " + (string) amt);
            llGiveMoney(id, amt);
        }
    }
}


