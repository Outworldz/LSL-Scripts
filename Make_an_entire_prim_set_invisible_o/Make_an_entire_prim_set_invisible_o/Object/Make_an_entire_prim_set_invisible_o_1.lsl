// :CATEGORY:Invisibility
// :NAME:Make_an_entire_prim_set_invisible_o
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2011-07-28 09:43:31.640
// :EDITED:2013-09-18 15:38:57
// :ID:500
// :NUM:669
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// The Owner can chat 'switch 0' without the quotes to make a prim set invisible.  'switch 1' will make it visible.  'switch 0.5' will make it half-visible.
// :CODE:
onoff(float alpha)
{
  integer j = llGetNumberOfPrims();
  integer i ;
  for (i = 0; i<j;i++)
  {
    llSetLinkAlpha( i, alpha, ALL_SIDES);
  }
}
default
{
    state_entry()
    {
        onoff(1);    // let thenm see it rez
        llListen(0, "", llGetOwner(), "");
    }
  // you need an event to listen for chatted commands
    listen( integer channel, string name, key id, string message )
    {
       list args = llParseString2List(message,[" "],[]); // convert string to a list of words at spaces
       if (llList2String(args,0) == "switch")
       {
            onoff(llList2Float(args,1)); // send the float to the onoff subroutine
       }
    }

}
