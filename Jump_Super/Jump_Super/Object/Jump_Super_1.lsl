// :CATEGORY:Animation
// :NAME:Jump_Super
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:55
// :ID:414
// :NUM:570
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Jump Super.lsl
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
