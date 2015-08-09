// :CATEGORY:Texture
// :NAME:TWOBUTTON_TEXTURE_VENDOR
// :AUTHOR:Thili Playfair
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:08
// :ID:929
// :NUM:1334
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// TWO-BUTTON TEXTURE VENDOR by Thili Playfair and Karandras Banjo.lsl
// :CODE:

// TWO-BUTTON TEXTURE VENDOR
// Origional script by Thili Playfair
// Heavily Modified by Karandas Banjo
// Please include these names if you modify or
// re-distribute this code ^_^

// To set up your vendor, you will need at least 3 prims,
// the main prim, and two buttons.

// The two buttons must both be linked to the main prim,
// one must be called "next", the other called "prev".
// The Buttons do NOT need any script if you name them as shown above.

// Next, enter the price of the textures in this vendor,
// and if you want, time to wait for auto-scrolling.

// After that, just drop your textures into the main prim,
// and press one of the scroll buttons, and you're ready
// to go!

integer price = 50; // The price of any texture in this
                    // vendor.
// Added touch-giving for when price is set to L$0


float time = 0; // Enter a value if you want time based
                // scrolling otherwise set to zero.

// NO TOUCHY BELOW HERE

string vendorname;
integer total;
integer counter;
integer change;

next()
{
    total=llGetInventoryNumber(INVENTORY_TEXTURE);
    vendorname = llGetObjectName();
    counter++;
    if(counter>=total)
    {
        counter=0;
    }
    llSetTexture(llGetInventoryName(INVENTORY_TEXTURE,    counter),ALL_SIDES);
    if (price > 0)
    {
        llSetText(vendorname + "\n" + llGetInventoryName(INVENTORY_TEXTURE,  counter) + "\n L$" + (string)price + "\n", <1,1,1>, 1);
    }
    else
    {
        llSetText(vendorname + "\n" + llGetInventoryName(INVENTORY_TEXTURE,  counter) + "\n Touch to recieve \n", <1,1,1>, 1);
    }
    llTriggerSound("Pressed", 1);
}
prev()
{
    total=llGetInventoryNumber(INVENTORY_TEXTURE);
    vendorname = llGetObjectName();
    if (counter > 0)
    {
        counter--;
    }
    else
    {
        counter=total - 1;
    }
    llSetTexture(llGetInventoryName(INVENTORY_TEXTURE,    counter),ALL_SIDES);
    if (price > 0)
    {
        llSetText(vendorname + "\n" + llGetInventoryName(INVENTORY_TEXTURE,  counter) + "\n L$" + (string)price + "\n", <1,1,1>, 1);
    }
    else
    {
        llSetText(vendorname + "\n" + llGetInventoryName(INVENTORY_TEXTURE,  counter) + "\n Touch to recieve \n", <1,1,1>, 1);
    }
    llTriggerSound("Pressed", 1);
}

default
{
    state_entry()
    {
        llRequestPermissions(llGetOwner(),PERMISSION_DEBIT  );
        next();
        llSetTimerEvent(time);
    }
    touch_start(integer total_number)
    {
        if ( llGetLinkName(llDetectedLinkNumber(0)) == "next" )
        {
            next();
        }
        else if ( llGetLinkName(llDetectedLinkNumber(0)) == "prev" )
        {
            prev();
        }
        else
        {
            if (price > 0)
            {
                llWhisper(0, "Pay L$" + (string)price + " to buy");
            }
            else
            {
                llGiveInventory(llDetectedKey(0), llGetInventoryName(INVENTORY_TEXTURE,  counter));
            }
        }
    }
    timer()
    {
        next();
    }
    money(key giver, integer amount)
    {
        if (amount < price)
        {
            llSay(0, "Too little payed, refunding");
            llGiveMoney(giver, amount);
        }
        else if (amount > price)
        {
            change = amount - price;
            llSay(0, "Overpaid. vending item and giving L$" + (string)change + " change");
            llGiveMoney(giver, change);
            llGiveInventory(giver, llGetInventoryName(INVENTORY_TEXTURE,  counter));
            llInstantMessage(llGetOwner(), llKey2Name(giver) + " bought " + llGetInventoryName(INVENTORY_TEXTURE,  counter) + " for L$" + (string)price);
        }
        else if (amount == price)
        {
            llGiveInventory(giver, llGetInventoryName(INVENTORY_TEXTURE,  counter));
        llInstantMessage(llGetOwner(), llKey2Name(giver) + " bought " + llGetInventoryName(INVENTORY_TEXTURE,  counter) + " for L$" + (string)price);
        }
    }
    on_rez(integer start_param)
    {
        llResetScript();
    }
}// END //
