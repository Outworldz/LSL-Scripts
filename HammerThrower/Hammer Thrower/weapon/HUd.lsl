// :CATEGORY:Weapon
// :NAME:HammerThrower
// :AUTHOR:Anonymous
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:54
// :ID:372
// :NUM:516
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// the HUD
// :CODE:

///Putting it together:
//put the Giant Hammer script in a hammer shaped object, maybe adjust params depending on hammer size, centre of rotation etc.
//put the Hammer in the Bullet object (any prim will do, but I use a tiny invisible one!) and add the Bullet script
//put the Bullet (now containing the Hammer) in the HUD object

// When you wear the HUD it will tell you what to do.


// Project: Hammer thrower
// Script: Hammer launcher
// Get avatar name, or target all.
// Rez objects giving them target avatar name
// add channel command

//Simple OpenSource Licence (I am trusting you to be nice)
//1.  PLEASE SEND ME UPDATES TO THE CODE
//2.  You can do what you want with this code and object including selling it in other objects and so on. 
//You can sell it in closed source objects if you must, but please try to send any updates or
//improvements back to me for possible inclusion in the main trunk of development.
//3.  You must always leave these instructions in any object created; notecard written; posting to
//any electronic medium such as Forum, Email &c. of the source code & generally be nice (as
//already requested!)
//4.  You must not claim that anyone apart from sparti Carroll wrote the original version of this software.
//5.  You can add and edit things below =THE LINE= but please try  to keep it all making sense.
//Thank you for your co-operation
//sparti Carroll


key k_owner;

integer channel_bullet = 540123;
integer channel_hammer = 477591;
integer channel_owner = 324;

integer channel_count = 1;

string lookingfor;

integer HUDcenter2 = 31;
integer HUDtopright = 32;
integer HUDtop = 33;
integer HUDtopleft = 34;
integer HUDcenter = 35;
integer HUDbottomleft = 36;
integer HUDbottom = 37;
integer HUDbottomright = 38;

integer HUD_default = HUDtopleft;


set_hudpos(integer whereami) {
   vector my_size = llGetScale();
   vector v_atpos;
   if (whereami == HUDbottomleft) v_atpos = <0,-my_size.y/2,my_size.z/2>;
   else if (whereami == HUDtopleft) v_atpos = <0,-my_size.y/2,-my_size.z/2>;
   else if (whereami == HUDbottom || whereami == HUDbottomright) v_atpos = <0,0,my_size.z/2>;
   else if (whereami == HUDtop || whereami == HUDtopright) v_atpos = <0,0,-my_size.z/2>;
   else if (whereami == HUDcenter || whereami == HUDcenter2) v_atpos = <0,0,0>;
   llSetPos(v_atpos);
}

reset() {
   k_owner = llGetOwner();
   llOwnerSay("Activated on channel " + (string)channel_owner);
   integer whereami = llGetAttached();
   if (whereami == 0) {
      llOwnerSay("Please wear on the HUD");
   } else {
      set_hudpos(whereami);
   }
   llListen(channel_owner,"",k_owner,"");
}

attack(string avname) {
    llRezObject("Bullet",llGetPos() + <0,0,5>,<0,0,0>,<0,0,0,0>,channel_count);
    llSleep(.5);   // needs time to rez an object and establish a listener
   llSay(channel_bullet + channel_count,"attack^" + avname);
   channel_count++;
   llOwnerSay("Now hammering " + avname);
}


default
{
   on_rez(integer start_param) {
      reset();
   }
   
   state_entry() {
      reset();
   }

   listen(integer channel,string name,key id,string message) {
      if (id == k_owner) {
         lookingfor = llToLower(message);
         llSensor("",NULL_KEY,AGENT,100,PI);
      }
   }
   
   sensor(integer num_detected) {
        integer k;
       //nteger foundpos;
        for (k=0;k < num_detected; k++)
        {
            string name = llKey2Name(llDetectedKey(k)) ;
            if (name == lookingfor)
            {
                attack(name);
            }
        }
    }
    
    no_sensor() {
      llOwnerSay("No matching AV names");
   }
   
   attach(key id) {
      integer whereami = llGetAttached();
      set_hudpos(whereami);
   }
}

