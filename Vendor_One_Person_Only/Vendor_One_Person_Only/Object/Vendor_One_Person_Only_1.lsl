// :CATEGORY:Vendor
// :NAME:Vendor_One_Person_Only
// :AUTHOR:Ama Omega
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:09
// :ID:948
// :NUM:1366
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Vendor (One Person Only).lsl
// :CODE:

//Title: Vendor to Sell to Only One Person
//Date: 01-28-2004 04:38 PM
//Version: 1.0.0
//Scripter: Ama Omega
//
string name = "Nameofpersonbuying";
integer price = 10; // adjust accordingly
string item = "nameofitem";

default
{
   state_entry()
   {
      llRequestPermissions( llGetOwner(), PERMISSION_DEBIT );
   }
   run_time_permissions(integer perms)
   {
      if (perms & PERMISSION_DEBIT)
         state run;
   }
}

state run
{
   money(key id, integer amount)
   {
      if (llKey2Name(id) == name)
      {
         if (amount != price)
         {
            llWhisper(0,"Sorry!  The price is $" + (string)price);
            llGiveMoney(id,amount);
         }
         else
         {
            llGiveInventory(id,item);
            llInstantMessage(llGetOwner(),name + " bought their item.");
            state sold;
         }
      }
      else
      {
         llWhisper(0,"Sorry I'm only selling this to " + name);
         llGiveMoney(id,amount);
      }
   }
}

state sold
{
   state_entry() { }
}// END //
