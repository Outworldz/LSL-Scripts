// :CATEGORY:Chat
// :NAME:Emoter
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2011-01-22 23:31:21.263
// :EDITED:2013-09-18 15:38:52
// :ID:284
// :NUM:382
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// I use the the  tell()  function in this script in a lot of places in SL.  It lets the object take on other people or objects names.
// :CODE:
Tell (string story) {
  integer ind=llSubStringIndex (story, " ");
  if (ind>-1) {
    string oldname=llGetObjectName ();
    llSetObjectName (llGetSubString (story, 0, ind-1));
    llSay (0,"/me "+llGetSubString (story, ind+1, -1));
    llSetObjectName (oldname);
  } else {
    llSay (0,story);
  }
}



default
{
    state_entry()
    {
        
        integer random = llCeil(llFrand(99)) +50;
        llOwnerSay("Type chat on channel " + (string) random + ".   Like this:  /"+ (string)random + " some text");
        llListen(random, "", "", "");

    }
    
    
    listen( integer channel, string name, key id, string message ) 
    {
        Tell(message);
    }
    
    on_rez( integer start)
    {
        llResetScript();
    }
    
} 
