// :CATEGORY:Spanker
// :NAME:EliteSpankerv4
// :AUTHOR:BigJohn Jade
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:52
// :ID:277
// :NUM:370
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Part (3). Make new script called Elite.Spanker v4.0 and clear out all the code from new script and add new code from here.
// :CODE:
// Elite Spanker v4.0 By BigJohn Jade

string SoundFile ="475a3e83-6801-49c6-e7ad-d6386b2ecc29";

string HelpCard = "Elite.Spanker.Help";

string Anim1express_anger = "express_anger";

string Anim2expressembarrased = "express_embarrased";

vector Vector_Color = <1.00000, 1.00000, 1.00000>;

integer IHavePermission = FALSE;
integer GetAttach = FALSE;
integer SoundOn = TRUE;
integer SexFemale = TRUE;
integer AccessMode = FALSE;
integer lT;
list UserName;
string FirstName;
float TimeIt = 3.0;
integer MaxAccess = 20;
integer lT2; 
integer lA2 =  -69; 
integer lH =  -69; 
integer chan;
key GetUser;
integer CurrentAccessUser = 0;
list Access;
string SetRemoveAccess;
key GetAccessUser;
integer Count;

integer FindNoteCard(string name) 
{
    integer i;
    for(i=0;i<llGetInventoryNumber(INVENTORY_NOTECARD);i++)
        if(llGetInventoryName(INVENTORY_NOTECARD,i) == (string)name)
        return TRUE;
    return FALSE;
}
string getParameter(list strings)
{
    integer len = llGetListLength(strings);
    integer i;
    string ret;
    string space= "";
    for (i=1;i<len;i++)
    {
        ret += space + llList2String(strings,i);
        space=" ";
    }
    return ret;      
}
integer CheckAccessList(key id)
{
   integer i;
    integer List_Count = llGetListLength(Access);
    for (i=0;i<List_Count; i++ )
    {
    if (llGetListLength(Access) == MaxAccess)
    {
    list Buttons = [];
    string title="\n\nAccess List is Full!";
    Buttons+=["Menu","Exit","(A)DataB"];
     llDialog(id,title,Buttons,chan);
    return 1;
 }
}
return 0;
}
integer isAccess(string name)
{
    integer i;
    for (i=0;i<llGetListLength(Access);i++)
    {
        string s = llList2String(Access,i);  
        if (s==llToLower(name)) return 1;
    }
    return 0;
}
 DelFromAccessList(key id,string name)
{
    integer i;
    for (i=0;i<llGetListLength(Access);i++)
    {
        string s = llList2String(Access,i);
        if (s==name)
        {
         Access = llDeleteSubList(Access, i, i);
            list Buttons = [];
            string title="\n\n"+(string)name + " have been removed from the Access list.";
            Buttons+=["Menu","Exit","(A)DataB"];
            llDialog(id,title,Buttons,chan);
        }
    }
    return;
}
ListAccessList(integer user1, key id) {
    integer UserCount = llGetListLength(Access) - 1;
    CurrentAccessUser = user1;
    if (CurrentAccessUser == -1) {
       CurrentAccessUser = UserCount;
    } else if (CurrentAccessUser > UserCount) {
        CurrentAccessUser = 0;
   } 
integer i;
if (Access == [])
{
list Buttons = [];
string title="\n\n*** Access Database Manager ***\n\nAccess List is Empty!";
Buttons+=["Add","Scan Add","Memory Chk","Menu","Exit"];
llDialog(id,title,Buttons,chan);
return;
    }          
list Buttons = [];
Buttons+=["<< Prev","Next >>","Memory Chk","Scan Add","Add","Remove","Menu","Exit"];
  llDialog(id,title,Buttons,chan);
 return;
    }
LetsTimeIt()
{
    lT = (integer)llGetTime() + (integer)TimeIt;
    llSetTimerEvent(1);
}

LetsTimeIt2()
{
    if(lH == -69)
    lH = llListen(chan,"","","");
    lT2 = (integer)llGetTime() + 120;
}


 PlaySoundFile()
{
  if(SoundOn)
  {
  float volume = 0.8;
  llPlaySound(SoundFile, volume);
 }
}

SetupChannels()
{
    chan = (integer)llFrand(1000) + 1000;
    llListenRemove(lH);
    lH = -69;
    llListenRemove(lA2);
    lA2 = llListen(69,"","","");
}

OwnerMenu(key id)
{
    LetsTimeIt2();
    list buttons = [];
    string title = "";
    if(SoundOn)
    {
    title+="\nSound Effects: On";
    }
    if(!SoundOn)
    {
    title+="\nSound Effects: Off";
    }
    if(AccessMode)
    {
    title+="\nAccess Mode: On";
    }
    if(!AccessMode)
    {
    title+="\nAccess Mode: Off";
    }
    if(SexFemale)
    {
    title+="\nSex: Female";
    }
    if(!SexFemale)
    {
    title+="\nSex: Male";
    }
    buttons+=["Spank","Sound","(A)DataB","Reset","Exit","Counter","Sex","Mode","Help"];
    llDialog(id,title,buttons,chan);
        }

default
{
    state_entry()
    {
     UserName = llParseString2List(llKey2Name(llGetOwner()),[" ","| "," |"," | "],[]);  
    FirstName = llList2String(UserName,0);
    llSetText("",Vector_Color, 1); 
    SetupChannels();
}
 listen(integer channel, string name, key id, string message) 
    { 
      list strings = llParseString2List(message,[" "],[]);
      string command = llList2String(strings,0);
      string par = llToLower(getParameter((strings)));
         
      if (message == "Menu" && (id == llGetOwner()))
        {
       GetAccessUser = id;
       OwnerMenu(id);
      return;
    }
      if (message == "Next >>" && (id == llGetOwner()))
        {   
      GetAccessUser = id;
      ListAccessList(CurrentAccessUser + 1,id);
       return;
        }
     if (message == "<< Prev" && (id == llGetOwner()))
        {  
      GetAccessUser = id;
      ListAccessList(CurrentAccessUser - 1,id);
       return;
        }
      if (message == "Help" && (id == llGetOwner()))
      {
      GetUser = id;
      if(FindNoteCard(HelpCard) != TRUE)
      {
      llDialog(id,(string)HelpCard + " Missing from the object content.",["Exit"],999);
        return;
    }
        else
        llGiveInventory(id,HelpCard);
     return;
    }
     if (message == "Counter" && (id == llGetOwner()))
      {
      GetUser = id;
       list Buttons = [];
       string title="\n***(-Reset Counter-)***";
       title+="\n\n"+(string)FirstName+ ", your ass has been spanked "+(string)Count+ " times!";
       Buttons+=["Reset It","Don't","Menu"];
       llDialog(id,title,Buttons,chan);
    }
     if (message == "Reset It" && (id == llGetOwner()))
      {
      GetUser = id;
      Count = 0;
     llOwnerSay("The Counter has been reset back to 0!");
     OwnerMenu(id);
    }
     if (message == "Don't" && (id == llGetOwner()))
      {
      GetUser = id;
      OwnerMenu(id);
    }
    if (message == "Reset" && (id == llGetOwner()))
      {
      GetUser = id;
       list Buttons = [];
       string title="\n***(-Reset Whole System-)***";
       title+="\n\nDatabase and all will be reset and script will go back to default settings.";
       Buttons+=["Yes","No","Menu"];
       llDialog(id,title,Buttons,chan);
    }
     if (message == "Yes" && (id == llGetOwner()))
      {
      GetUser = id;
      llOwnerSay("The system has been reset, you must take off the spanker and add it back on to your av now.");
      llResetScript();
    }
    if (message == "No" && (id == llGetOwner()))
      {
      GetUser = id;
     OwnerMenu(id);
    }
     if (message == "Mode" && (id == llGetOwner()))
      {
      GetUser = id;
      if(AccessMode)
      {
      AccessMode = FALSE;
      llOwnerSay("Access Mode is now off!");
      OwnerMenu(id);
      return;
      }
      if(!AccessMode)
      {
      AccessMode = TRUE;
      llOwnerSay("Access Mode is now on!");
      OwnerMenu(id);
      return;
    }
}
if (message == "Sound" && (id == llGetOwner()))
      {
      GetUser = id;
      if(SoundOn)
      {
      SoundOn = FALSE;
      llOwnerSay("Sound Effects is now off!");
      OwnerMenu(id);
      return;
      }
      if(!SoundOn)
      {
      SoundOn = TRUE;
      llOwnerSay("Sound Effects is now on!");
      OwnerMenu(id);
      return;
    }
}
if (message == "Sex" && (id == llGetOwner()))
      {
      GetUser = id;
      if(SexFemale)
      {
      SexFemale = FALSE;
      llOwnerSay("Sex Set to: Male!");
      OwnerMenu(id);
      return;
      }
      if(!SexFemale)
      {
      SexFemale = TRUE;
      llOwnerSay("Sex Set to: Female!");
      OwnerMenu(id);
      return;
    }
}
    if (message == "Spank" && (id == llGetOwner()))
    {
    GetUser = id;
      if(SexFemale)
  {
  llStartAnimation(Anim2expressembarrased);
  }
  else
  if(!SexFemale)
  {
  llStartAnimation(Anim1express_anger);
  }
    LetsTimeIt();
    PlaySoundFile();
    llSetText("\n\n"+(string)FirstName+" has spanked their own ass!\n\n"+(string)FirstName+"'s ass has been spanked "+(string)Count+" times.",Vector_Color, 1); 
    OwnerMenu(id);
     return;
    }
    if (message == "(A)DataB" && (id == llGetOwner()))
    {
      GetAccessUser = id;
      string Incoming = llToLower(llKey2Name(id));
      LetsTimeIt2();
      ListAccessList(CurrentAccessUser,id);
      return;
    }
   if (message == "Memory Chk" && (id == llGetOwner()))
    {
    GetAccessUser = id;
    list Buttons = [];
    string title ="\n*** Access Database Memory ***\n\nAccess Database bytes available: "+(string)llGetFreeMemory();
 Buttons+=["Menu","Exit","(A)DataB"];
   llDialog(id,title,Buttons,chan);
    return;
    }
    if (message == "Scan Add" && (id == llGetOwner()))
   {
    GetAccessUser = id;
    llMessageLinked(LINK_SET,0,"START SCAN AROUND FOR ACCESS",id);
   return;
   }
   if (message == "Remove" && (id == llGetOwner()))
    {
    GetAccessUser = id;
    SetRemoveAccess = llList2String(Access,CurrentAccessUser);
    DelFromAccessList(id,SetRemoveAccess);
      return;
     }
      if(lA2 != -69 && channel == 69)
            {
                llListenRemove(lA2);
                lA2 = -69;
            }
        if (message == "Add" && (id == llGetOwner()))
            {
           GetAccessUser = id;
           lA2 = llListen(22,"","","");
           list Buttons = [];
          string title="\n***(-Access Adding-)***\nType in the chat command with, /69 add av name like so.\n\n/69 add bigjohn jade";
          Buttons+=["Exit","(A)DataB","Menu"];
          llDialog(id,title,Buttons,chan);
         return;
        }
         if (command == "add" && (id == llGetOwner()))
                {
         GetAccessUser = id;
                 if (par =="")
                 {
                 llListenRemove(lA2);
                 return;
                }
                else
                 if (CheckAccessList(id) == 1)
            {
            llListenRemove(lA2);
            return;
        }
            else
             if ((isAccess(par)>0))
             {
             list Buttons = [];
             string title="\n\nSorry " + (string)par + " was already found in the Access List.";
          Buttons+=["Menu","Exit","(A)DataB"];
          llDialog(id,title,Buttons,chan);
            llListenRemove(lA2);
            return;
            }
        else
            Access = llListInsertList(Access,[par],llGetListLength(Access));
  list Buttons = [];
  string title="\n\nAdd " + (string)par + " to the Access List.";
Buttons+=["Menu","Exit","(A)DataB"];
llDialog(id,title,Buttons,chan);  
llListenRemove(lA2);
 return;
   } 
  }
attach(key id)
    {
    if(id == NULL_KEY)
    {
     GetAttach = FALSE;
    return;
    }
    else
    GetAttach = TRUE;
    SetupChannels();
    llRequestPermissions(id,PERMISSION_TRIGGER_ANIMATION);
    UserName = llParseString2List(llKey2Name(llGetOwner()),[" ","| "," |"," | "],[]);  
    FirstName = llList2String(UserName,0);
    llOwnerSay("Spanker System is now ready, click the spanker for Owner Menu. (Bytes Free"+" "+(string)llGetFreeMemory()+")");
        }    

    touch_start(integer total_number)
    {
     integer TouchTrack;
     key person  = llDetectedKey(TouchTrack);
     string name = llDetectedName(TouchTrack);
     string user;
     if(!GetAttach)
     {
    llInstantMessage(person,"I must be attach before you can use me!");
    return;
    }
    else
     if (person == llGetOwner())
 {
OwnerMenu(llDetectedKey(0));
return; 
}
else
  if(AccessMode)
  {
  if ((isAccess(name)==0))
  {
  llInstantMessage(person,"Sorry but "+(string)FirstName+" has their spanker on access mode, you was not found on the access list!");
  return;
  }
}
  LetsTimeIt();
  PlaySoundFile();
  if(SexFemale)
  {
  llStartAnimation(Anim2expressembarrased);
  }
  else
  if(!SexFemale)
  {
  llStartAnimation(Anim1express_anger);
  }
Count++;
user+="\n"+llKey2Name(person)+" has spanked that ass!\n\n"+(string)FirstName+"'s ass has been spanked "+(string)Count+" times.";
 llSetText("\n"+user,Vector_Color, 1);
 }
  run_time_permissions(integer permissions)
    {
        if (permissions == PERMISSION_TRIGGER_ANIMATION)
        {
          IHavePermission = TRUE;
        }   
    }
 link_message(integer sender_num,integer num,string str,key id)
    {
       if (str == "SET ID")
        {
        GetAccessUser = id;
        }
    if (str == "MAIN MENU")
    {
     GetUser = id;
     string Incoming3 = llToLower(llKey2Name(id));
      OwnerMenu(id);
    }
        if (str == "ACCESS DATABASE MENU")
        {
     SetupChannels();
     GetAccessUser = id;
     string Incoming = llToLower(llKey2Name(id));
      LetsTimeIt2();
      ListAccessList(CurrentAccessUser,id);
      return;
}
      if (str == "SCAN ACCESS ADD")
        {
         string Incoming = llToLower(id);
         if ((isAccess(Incoming)>0))
         {
          llInstantMessage(llGetOwner(),(string)Incoming+ " was already found in the Access list.");
          return;
         }
        else
        Access = llListInsertList(Access,[Incoming],llGetListLength(Access));
         llInstantMessage(llGetOwner(),(string)Incoming+ " has been add to the Access list.");
         return;
        }
    if (str == "SET UP ACCESS USERS")
        {
        if ((isAccess(id)>0))
         {
         return;
        }
        else
        Access = llListInsertList(Access,[id],llGetListLength(Access));
        return;
        }
    }
timer()
    {
        if(llGetTime() > lT)
        {
            llSetText("",Vector_Color, 1); 
            llSetTimerEvent(0.0); 
        }
        if(llGetTime() > lT2)
        {
         llListenRemove(lH);
            lH = -69;
    }
  }
}
