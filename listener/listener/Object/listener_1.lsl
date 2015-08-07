// :CATEGORY:Light
// :NAME:listener
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:56
// :ID:481
// :NUM:648
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// listener.lsl
// :CODE:

float MAX_RADIUS = 2.5 ;// default

integer channel = 99;

default
{
    state_entry()
    {
        llOwnerSay("Change radius with /" + (string) channel + " number, like '/" + (string) channel + " 5.0' for 5 meter radius");
        llListen(channel, "", llGetOwner(), "");

    }
    listen( integer channel, string name, key id, string message )
    {
        float diameter = 2 *  (float) message;
        MAX_RADIUS =  (float) message;
        llOwnerSay("Radius is set to " + (string) MAX_RADIUS  + ", Diameter is set to " + (string) diameter);
    }

}
  // END //
