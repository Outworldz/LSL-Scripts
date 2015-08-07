// :CATEGORY:Animation
// :NAME:Super_Jump
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:05
// :ID:847
// :NUM:1177
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Super Jump.lsl
// :CODE:

default
{
     attach(key avatar)
     {
          vector force = <0,0, llGetMass() * 6.2>;
          llSetForce(force, TRUE);
          if(avatar==NULL_KEY)
          {
               llSetForce(<0,0,0>,TRUE);
          }
     }
}
// END //
