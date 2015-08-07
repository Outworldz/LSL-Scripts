// :CATEGORY:Spanker
// :NAME:EliteSpankerv4
// :AUTHOR:BigJohn Jade
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:52
// :ID:277
// :NUM:369
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// My new Elite Spanker v4.0 came a very hot free item on SLX and many ppl has it and love it. I am going to share whore script system how it was made. You can not sale the scripts for money.// // Part (1). Make note card called Elite.Spanker.Help and copy the text into it.// // **** Elite Spanker v4.0 .Help.Card **** THIS SPANKER IS 100% FREE ***// ============================================
// 
// Elite Spanker is a free version spanker for Male and Female that will add some fun to your second life. It does not spam out in open chat when someone has spanked you. It will display a hover text over the object for a short time and this Elite Version comes with some cool options that you can set to the spanker system.
// 
// 4.0 Release Notes
// --------------------
// 1. I changed the shape of the object to make it fit better.
// 2. The system is now using embedded animations and no longer needs the animation files in the content.
// 3. I freed much more memory in the spanker system main script.
// 4. I updated the help doc with more info about the spanker system.
// -------------------------------------------------------------------------------
// 
// (Note: Only the Owner will have dailog menu not any one else that clicks it.)
// 
// 
// The layout for the main Menu system looks like like this:
// 
// Sex. Mode, Help
// Reset, Exit, Counter,
// Spank, Sound, (A)DataB
// Ignore
// 
// 1. Sex: will switch from male to female every time push this button.
// 
// 2. Mode: will switch the Access list on and off list every time this button is clicked and the access list will hold up to 20 people.
// 
// 3. Help: you are reading it now :)
// 
// 4. Reset: This resets the database and whole system.
// 
// 4. Exit: This button will just Exit main the Menu system.
// 
// 5. Counter: this will let you reset the counter.
// 
// 6. Spank: this will let you spank your own ass, when you spank your own ass the counter does not count at all.
// 
// 7. Sound: this will let you switch sound effects on and off.
// 
// 8. (A)DataB: This button stands for Access Database, when you push this button another dialog menu system will load up and look like:
// 
// Access User (1 of 1)
// Menu, Exit,
// Scan Add, Add, Remove,
// <<Prev, Next >>, Memory Chk,
// Ignore
// 
// Menu: This button loads the main Menu system back up.
// 
// Exit: This button exits the Menu system.
// 
// Scan Add: This button lets you Scan/Add to the base spanker.
// 
// 
// Menu, (A)DataB, Exit
// << Prev, Next >>, Add User
// Ignore
// 
// Menu: This button loads the main Menu system.
// 
// (A)DataB: This button will load the main Access Database Manager Menu system back up.
// 
// Exit: This button exits the Menu system.
// 
// <<Prev: This button will take you back to the name that it was on before the Next >> button was clicked.
// 
// Next >>: This button will go to the next name found in the database list.
// 
// Add User: This button will add a name found in the Scan that you are looking at on the Access Scan Database Manager to the Access list.
// 
// Add: This button will let you Add people to the Access list manually and when clicked another dialog Menu system will load and look like:
// 
// 
// Exit, (A)DataB, Menu,
// Ignore
// 
// Just type in the name of person that you want to add by hand to the Access list , for example:
// 
// /69 add bigjohn jade
// 
// Exit: This button will exit the Menu system.
// 
// (A)DataB: This button will load the main Access Database Manager Menu system again.
// 
// Menu: This button will load the main Menu system again.
// 
// Remove: This button on the Access Database Manager lets you remove people very easily, you dont have to type in any names at all to remove people from the Access list.
// 
// Just find the person in the database list you want to remove by using Next >> button and once you find the person you want to remove from the system you just hit the Remove button while that person's name is selected.
// 
// <<Prev: This button will take you back to name before that it was on before you had hit the Next >> button.
// 
// Next >>: This button will go to next name found in the database list.
// 
// Memory Chk: This will show you how many free bytes the main script has for the Access database list.
// 
// End of help file.
// :CODE:

// By BigJohn Jade

integer CurrentTempUser2 = 0;

integer chan;

list Users2;

key GetUser;

float ScanAroundM = 30.0;

float RepeatScanTime = 0.1;

integer TurnOn = FALSE;

integer lH = -213645771;          
integer lT;
integer lT2;

ET()
{
    llSetTimerEvent(0.0);
    if(lH == -213645771)
    lH = llListen(chan,"","","");
    lT = (integer)llGetTime() + 120;
        llSetTimerEvent(45);
} 
ET2()
{
   llSetTimerEvent(0.0);
   TurnOn = TRUE;
   lT2 = (integer)llGetTime() + 5;
    llSetTimerEvent(1);
}

integer isUser(string name)
{
    integer i;
    for (i=0;i<llGetListLength(Users2);i++)
    {
        string s = llList2String(Users2,i);  
        if (s==llToLower(name)) return 1;
    }
    return 0;
}
SetupScanner()
{
 llSensorRemove();
 llSensorRepeat("","" , AGENT, ScanAroundM, 2*PI, RepeatScanTime);
}

ListUsers2List(integer user1, key id) {
    integer UserCount2 = llGetListLength(Users2) - 1;
    CurrentTempUser2 = user1;
    if (CurrentTempUser2 == -1) {
       CurrentTempUser2 = UserCount2;
    } else if (CurrentTempUser2 > UserCount2) {
        CurrentTempUser2 = 0;
   } 
if (Users2 == [])
{
 return;
    }
ET();
list Buttons = [];
integer RangeSet = (integer)ScanAroundM;
string title="\n*** Access Scan Database Manager ***\n*** Scan Range Setting: "+(string)RangeSet+"m *** \n\nUser (" + (string)(CurrentTempUser2 + 1) + " of " + (string)(UserCount2 + 1)+ ")\nName:"+llList2String(Users2,CurrentTempUser2);  
Buttons+=["<< Prev","Next >>","Add User","Menu","(A)DataB","Exit"];
llDialog(id,title,Buttons,chan);
 return;
    }

default
{
sensor(integer total_number)
    {
        integer i;
        for (i=0;i<total_number;i++)
        {
            key person  = llDetectedKey(i);
            string name = llToLower(llDetectedName(i));
            key K2N = llToLower(llKey2Name(person));
            if ((isUser(K2N)==0))
            {
            Users2 = llListInsertList(Users2,[(string)K2N],llGetListLength(Users2));
        }
    }
}
no_sensor()
{
llSetTimerEvent(0.0); 
llSensorRemove();
TurnOn = FALSE;
list Buttons = [];
string title="\n*** Access Scan Database Manager.\n\nNo one in Range detected!";
ET();
Buttons+=["Menu","Exit"];
llDialog(GetUser,title,Buttons,chan);
}
  listen(integer channel, string name, key id, string message) 
    {
 if (message == "Add User" && (id == llGetOwner()))
 {
  GetUser = id;
  llMessageLinked(LINK_SET,0,"SET ID",id);
  llSleep(1);
  string SetNewAccess = llList2String(Users2,CurrentTempUser2);
  llMessageLinked(LINK_SET,0,"SCAN ACCESS ADD",SetNewAccess);
  ListUsers2List(CurrentTempUser2,GetUser);
  return;
 }
 if (message == "Next >>" && (id == llGetOwner()))
        {   
       GetUser = id;
       ListUsers2List(CurrentTempUser2 + 1,id);
       return;
        }
     if (message == "<< Prev" && (id == llGetOwner()))
        {   
        GetUser = id;
       ListUsers2List(CurrentTempUser2 - 1,id);
       return;
        }
     if (message == "Menu" && (id == llGetOwner()))
        {   
         GetUser = id;
         llMessageLinked(LINK_SET,0,"MAIN MENU",GetUser);
       return;
        }
      if (message == "(A)DataB" && (id == llGetOwner()))
        { 
        GetUser = id;
         llMessageLinked(LINK_SET,0,"ACCESS DATABASE MENU",GetUser);
       return;
        }
    }
  link_message(integer sender_num,integer num,string str,key id)
    { 
      if (str == "START SCAN AROUND FOR ACCESS")
      {
      chan = (integer)llFrand(1000) + 1000;
      llListenRemove(lH);
       lH = -213645771;
       GetUser = id;
       Users2 = [];
       llOwnerSay("Please Wait... Scan Around Database will be done within 5 Secs...");
       ET2();
       SetupScanner();
      }
      if (str == "GET USER")
     { 
      GetUser = id;
     }
     if (str == "SET SCAN AROUND M")
     { 
      ScanAroundM = (float)num;
     }
      if (str == "RESET WIZARD")
     {
      llResetScript();
     }
}
 timer()
    {
          if(llGetTime() > lT2)
        {
          if (TurnOn)
          {
          TurnOn = FALSE;
          llSensorRemove();
          llSetTimerEvent(0.0); 
          ListUsers2List(CurrentTempUser2,GetUser);
        }
        if(llGetTime() > lT)
        {
            Users2 = [];
            llListenRemove(lH);   
            lH = -213645771;
            llSetTimerEvent(0.0);
        }
    }
  }
}
