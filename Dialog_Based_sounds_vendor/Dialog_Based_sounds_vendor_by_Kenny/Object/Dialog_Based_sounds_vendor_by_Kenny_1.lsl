// :CATEGORY:Vendor
// :NAME:Dialog_Based_sounds_vendor
// :AUTHOR:Kenny Jackson
// :KEYWORDS:
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2014-02-24
// :ID:231
// :NUM:317
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Dialog Based sounds vendor by Kenny Jackson.lsl
// :CODE:

// Mods by Fred Beckhusen (Ferd Frederix)
// 02-23-2014
// removeed useless code.
// made functions out of repeated items.
// added price checks
// removed listener when not being used
// play sounds when changed
// dialog always on any click

// Dialog Based sounds vendor by Kenny Jackson


//NOTES:
//1.) All sounds in the vendor will have the same price.
//2.) Set the price by changing the vendor description.
//(example. If you want the price of all the sounds in the vendor to be L$50 set the vendor description to 50.)
//3.) After changing the price hit the RESET button to update the script. Only the owner will see the RESET button.
//4.) Just drop this script and the sounds your selling into a prim
//5.) Click the prim to get the dialog.
//Kenny Jackson

integer price;
string wrong = "Sorry, that is not the correct price";
string over = "You have overpaid, here is your change";
string thank = "Thank you for your purchase";
integer finished = FALSE;
integer n = 0;
integer i;
list sounds;
integer CHANNEL;
string soundName;
string GNAME;
integer listener;
key aviKey;

Dialog ()
{
    llListenRemove(listener);
    CHANNEL = llCeil(llFrand(10000) + 10000);
    listener = llListen(CHANNEL, "",  "", "");
    if(aviKey == llGetOwner())
    {
        llDialog(aviKey,"1.) Choose Next/Back to scroll through sounds.\n2.) Press Play to hear a sound.\n3.) Right Click and Pay to buy!", ["Back", "Next", "Play", "Reset"], CHANNEL);
    }
    else
    {
        llDialog(aviKey,"1.) Choose Next/Back to scroll through sounds.\n2.) Press Play to repeat a sound.\n3.) Right Click and Pay to buy!", ["Back", "Next"], CHANNEL);
    }

}



GetSounds()
{
    finished = FALSE;
    n = 0;
    
    while(!finished)
    {
        soundName = llGetInventoryName(INVENTORY_SOUND, n);
        if(soundName == "")
        {
            finished = TRUE;
            price = (integer)llGetObjectDesc();
            if (price <= 0)
            {
                llOwnerSay("Price set to 10 Lindens as a default. Change it in the description and reset the script.");
                llSetObjectDesc("10");
            }
            llSetPayPrice(price,[price,PAY_HIDE,PAY_HIDE,PAY_HIDE]);
        } 
        else 
        {
            sounds = sounds + soundName;
            n++;  
        }
    }
}

default
{
    state_entry()
    {
        GetSounds();  
        llRequestPermissions(llGetOwner(), PERMISSION_DEBIT);
    }
    
    run_time_permissions(integer permissions)
    {
        //Only wait for payment if the owner agreed to pay out money
        if (permissions & PERMISSION_DEBIT)
        {
            llSetText("Initialized with " + (string) n + " sounds", <0,1,0>,1);
            state ready;
        }
    }
    
    on_rez(integer start_param)
    {
        llResetScript();
    }
}

state ready
{
    on_rez(integer start_param)
    {
        llResetScript();
    }
    
    listen(integer channel, string name, key id, string message)
    {        
        if(message == "Next")
        {
          i++;
          if(i >= n)
          {
                i = 0;
          }
          GNAME = llList2String(sounds, i);                 
          llPlaySound(GNAME, 1);
        }
        else if(message == "Back")
        {
          i--;
          
          if(i < 0)
          {
                i = n - 1;
          }
          GNAME = llList2String(sounds, i); 
          llPlaySound(GNAME, 1);
        }
        else if(message == "Play")
        {
            GNAME = llList2String(sounds, i); 
            llPlaySound(GNAME, 1);
        }
        else if(message == "Reset")
        {
            llResetScript();
        }


        llSetText(GNAME, <1,0,0>, 1);
        Dialog();
         
    }
    
    changed(integer what)
    {
        if (what & CHANGED_INVENTORY)
        {
            GetSounds();
        }
    }
    
    touch_start(integer total_number)
    {
        aviKey = llDetectedKey(0);
        Dialog();
    }
    
    money(key id, integer amount)
    {
        if(amount < price)
        {
            llSay(0, wrong);
            llGiveMoney(id, amount);
        }
        if(amount > price)
        {
            llSay(0, over);
            llGiveMoney(id, amount - price);
            llGiveInventory(id, GNAME);
        }
        if(amount == price)
        {
            llSay(0, thank);
            llGiveInventory(id, GNAME);
        }
    }
} 

// END //