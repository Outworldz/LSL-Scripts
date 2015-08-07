// :CATEGORY:TV
// :NAME:TV_Station_Script
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:08
// :ID:925
// :NUM:1329
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// TV Station Script.lsl
// :CODE:

list    teeVees;
integer listenID;
key     programID = NULL_KEY;

updateTV(integer number)
{
  //Scripts are delayed 20 seconds for each email
  if (programID != NULL_KEY)
  {
    llWhisper(0, "Sending Notcard: " + (string)programID);
    llEmail(llList2String(teeVees, number) + 
            "@lsl.secondlife.com", (string)programID, "");
  }
}
default
{
  state_entry()
  {
    listenID = llListen(1, "", NULL_KEY, "");
    llSetText(llGetObjectName(), <1,1,1>, 1);
  }
  
  on_rez(integer startup_param)
  {
    llResetScript();
  }
  
  listen(integer channel, string name,
         key id, string message)
  {
    if (llGetOwner() == (key)message)
    {
      //Only register if the new TV isn't
      //in the list of TVs
      if (llListFindList(teeVees, [id]) == -1)
      {
        llWhisper(0, "Registering TV: " + (string)id);
        teeVees += id; //Register TV in List
      }
      //Update the TV with the notecard
      updateTV(llGetListLength(teeVees) - 1);
    }
  }
    
  changed(integer change)
  {
    integer x;
        
    if (change == CHANGED_INVENTORY)
    {
      string notecardName = 
      llGetInventoryName(INVENTORY_NOTECARD, 0);
      llWhisper(0, "Processing Notecard: " + notecardName);
      programID = llGetInventoryKey(notecardName);
      llRemoveInventory(notecardName);

      //Loop through all the registered TVs
      for (x = 0; x < llGetListLength(teeVees); x += 1)
      {
        updateTV(x);
      }
    }
  }
}
// END //
