// :CATEGORY:Animation Vendor
// :NAME:A_animation_Vendor
// :AUTHOR:Ariane Brodie
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:46
// :ID:6
// :NUM:10
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// ANimation Vendor
// :CODE:
// TWO-BUTTON ANIMATION VENDOR
// Origional script by Thili Playfair
// Heavily Modified by Karandas Banjo
// Radically modified by Ariane Brodie who converted the texture vendor into an animation vendor script
// Please include these names if you modify or
// re-distribute this code ^_^

// To set up your vendor, you will need at least 3 prims,
// the main prim, and two buttons.

// The two buttons must both be linked to the main prim,
// one must be called "next", the other called "prev".
// The Buttons do NOT need any script if you name them as shown above.

// Next, enter the price of the animations in this vendor,
// and if you want, time to wait for auto-scrolling.

// After that, just drop your animations into the main prim,
// and press one of the scroll buttons, and you're ready
// to go!

integer price = 10; // The price of any animation in this
                    // vendor.
// Added touch-giving for when price is set to L$0


float time = 0; // Enter a value if you want time based
                // scrolling otherwise set to zero.

// NO TOUCHY BELOW HERE

string vendorname;
integer total;
integer counter;
integer change;
integer anim_on = FALSE;
string curranim;
string lastanim;
vector offset=<0,0,1.0>;
key avatar;

next()
{
    total=llGetInventoryNumber(INVENTORY_ANIMATION);
    vendorname = llGetObjectName();
    counter++;
    if(counter>=total)
    {
        counter=0;
    }
    lastanim = curranim;
    curranim = llGetInventoryName(INVENTORY_ANIMATION,    counter);
    if (price > 0)
    {
        llSetText(vendorname + "\n" + llGetInventoryName(INVENTORY_ANIMATION,  counter) + "\nPay base L$" + (string)price + " to buy", <1,1,1>, 1);
    }
    else
    {
        llSetText(vendorname + "\n" + llGetInventoryName(INVENTORY_ANIMATION,  counter) + "\n Touch to recieve", <1,1,1>, 1);
    }
    
    if (anim_on) {
        llStopAnimation(lastanim);
        llStartAnimation(curranim);
    }
}
prev()
{
    total=llGetInventoryNumber(INVENTORY_ANIMATION);
    vendorname = llGetObjectName();
    if (counter > 0)
    {
        counter--;
    }
    else
    {
        counter=total - 1;
    }
    lastanim = curranim;
    curranim = llGetInventoryName(INVENTORY_ANIMATION,    counter);
    if (price > 0)
    {
        llSetText(vendorname + "\n" + llGetInventoryName(INVENTORY_ANIMATION,  counter) + "\nPay base L$" + (string)price + " to buy", <1,1,1>, 1);
    }
    else
    {
        llSetText(vendorname + "\n" + llGetInventoryName(INVENTORY_ANIMATION,  counter) + "\n Touch to recieve \n", <1,1,1>, 1);
    }
    
    if (anim_on) {
        llStopAnimation(lastanim);
        llStartAnimation(curranim);
    }
}

default
{
    state_entry()
    {
        rotation rot = llEuler2Rot(<0,0,PI>);
        llSetSitText("Animate");
        llSitTarget(offset,rot);
        llSetCameraAtOffset(<0.0,0.0,1.0>);
        llSetCameraEyeOffset(<-4.0,0.0,1.0>);
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
                llWhisper(0, "Right click and Animate to try, Pay L$" + (string)price + " to buy");
            }
            else
            {
                llGiveInventory(llDetectedKey(0), llGetInventoryName(INVENTORY_ANIMATION,  counter));
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
            llGiveInventory(giver, llGetInventoryName(INVENTORY_ANIMATION,  counter));
            llInstantMessage(llGetOwner(), llKey2Name(giver) + " bought " + llGetInventoryName(INVENTORY_ANIMATION,  counter) + " for L$" + (string)price);
        }
        else if (amount == price)
        {
            llGiveInventory(giver, llGetInventoryName(INVENTORY_ANIMATION,  counter));
        llInstantMessage(llGetOwner(), llKey2Name(giver) + " bought " + llGetInventoryName(INVENTORY_ANIMATION,  counter) + " for L$" + (string)price);
        }
    }
    
    on_rez(integer start_param)
    {
        llResetScript();
    }
    
    changed(integer change)
    {
        if(change == CHANGED_LINK)
        {
            avatar = llAvatarOnSitTarget();
            if(avatar != NULL_KEY)
            {
                llRequestPermissions(avatar,PERMISSION_TRIGGER_ANIMATION);
            }
            else
            {
                if (llGetPermissionsKey() != NULL_KEY) {
                    llStopAnimation(curranim);
                    anim_on = FALSE;
                }
            }
        }
    }
    
    run_time_permissions(integer perm)
    {
        if(perm == PERMISSION_TRIGGER_ANIMATION)
        {
            llStopAnimation("sit");
            llStartAnimation(curranim);
            anim_on = TRUE;
        }
    }
}
