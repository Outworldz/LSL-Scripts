// :CATEGORY:Hebrew
// :NAME:reverse_for_hebrew_
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:01
// :ID:701
// :NUM:957
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// reverse for hebrew -.lsl
// :CODE:

default
{
    state_entry()
    {
        llListen(0,"","","");
    }

    listen(integer channel,string name,key id,string msg)
    {
      integer i;
      string text="";
      if(id==llGetOwner())
      {
      for(i=llStringLength(msg);i>=0;i--)
      {
       text+=llGetSubString(msg,i,i); 
      } 
      
      llSetObjectName(name); 
      
      llSay(0,text);
      }
    }
}
// END //
