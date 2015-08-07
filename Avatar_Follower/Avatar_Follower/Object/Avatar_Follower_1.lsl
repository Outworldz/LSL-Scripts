// :CATEGORY:Follower
// :NAME:Avatar_Follower
// :AUTHOR:Dale Innis
// :CREATED:2010-12-27 12:53:33.280
// :EDITED:2013-09-18 15:38:48
// :ID:72
// :NUM:99
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Introduction// // It can be hard to follow someone in Second Life; if someone says "follow me" and goes flying off over hill and dale in an even slightly crowded region, it's all too easy to lose track of them. This script lets you specify a person to follow, and if you get too far from them it will exert a force that will make your avatar walk (or run or fly or etc) in their direction, until you are close enough.// Usage// // To use this script, stick it into the root prim of an object, and wear that object. (Anywhere on the body; wearing it as a HUD attachment hasn't been tested.) Then to follow someone, say their name on channel 15 (like "/15 Dale Innis", you know). You will then begin following that person (sometimes for some reason you have to move a bit first using the arrow keys or whatever before the following will start). To stop following them, say "off" on channel 15 ("/15 off" or "/15off").
// Limitations and Notes
// 
// The main purpose of this script is to show that llMoveToTarget and family are a good way of moving an avatar about; with appropriate modifications this code could be used to move someone wearing a tour device through a set of waypoints, or to pull an AV wearing a grappling hook attachment to whatever the hook hit, or whatever. All sorts of potential!
// 
// The interface in the version of the script given here requires you to get the person's name exactly right, including capitalization. The version that I actually use myself allows specifying just a part of the person's name, and having it look around for someone nearby that matches. But the code to do that just complicates the script without adding anything fundamental, so I don't include it here. If you'd like a copy of that version, feel free to contact me.
// 
// There's no magic in the script; all it actually does is move your AV toward the person whenever they are too far away. This only lets you get to places that you could have gotten to anyway manually using the arrow keys or whatever (with one possible exception noted below). It doesn't let you follow people through teleports or anything like that.
// 
// The code isn't very smart about its following, and in particular it doesn't do anything about obstacles. If there's a wall or something between you and the person you're following, you may find yourself pressed thoroughly against that wall, pretty much unable to move. Use the "off" command to free yourself, and move to a place where you have a clear line of sight to them before following them again.
// 
// If you start following someone when they are quite a distance away (the limit is about 90 meters), or if the person that you are following moves very suddenly and fast, the script can in some circumstances exert enough force that you pass right through intervening walls and/or objects. This can be quite fun. (In damage-enabled areas, it can also be quite fatal.)
// 
// If the person that you're following flies upward while you are in walking mode, you may find yourself swimming through the air in that awkward "eeeek I'm falling" animation; you can press the "Fly" button to switch to the more graceful flying animation. Similarly, if you're flying while following someone and they land, you may find yourself skimming over the ground behind them; press "Stop Flying" if you'd rather walk also.
// 
// If the person that you're following TPs away, or logs out, or in some cases crosses into a different sim than the one you're in, the script will say that the person "seems to be out of range. Waiting for return...", and you will be free to move about. If the person comes back into range, you will (suddenly and without warning) start following them again. Myself, I generally issue the "off" command if the person that I'm following goes out of range, just to avoid surprises.
// 
// While you are following someone, you will be pretty much unable to move very far away from them. It will be as though an invisible force were pressing on you, keeping you nearby. (Because that's in fact exactly what's happening.) If you want to move away from the person, use the "off" command to stop following them.
// 
// Odd and random things may (or may not) happen if you follow someone while riding a vehicle or sitting. Or vice-versa.
// 
// You can change the channel that the script listens on for commands, the frequency with which it looks to see if the followed person is too far away, the number of meters it considers "too far", and the hardness with which it pushes you (or actually the reciprocal thereof) by altering the first four constants in the code (respectively).
// The Code
// 
// You may do anything you like with this code, without limitation. As far as I'm concerned. Well, except you shouldn't use it for evil. Which is sort of true by the definitions of "should" and "evil". 
// :CODE:
integer CHANNEL = 15;  // That's "f" for "follow", haha
 
float DELAY = 0.5;   // Seconds between blinks; lower for more lag
float RANGE = 3.0;   // Meters away that we stop walking towards
float TAU = 1.0;     // Make smaller for more rushed following
 
// Avatar Follower script, by Dale Innis
// Do with this what you will, no rights reserved
// See https://wiki.secondlife.com/wiki/AvatarFollower for instructions and notes
 
float LIMIT = 60.0;   // Approximate limit (lower bound) of llMoveToTarget
 
integer lh = 0;
integer tid = 0;
string targetName = "";
key targetKey = NULL_KEY;
integer announced = FALSE;
 
init() {
  llListenRemove(lh);
  lh = llListen(CHANNEL,"",llGetOwner(),"");
}
 
stopFollowing() {
  llTargetRemove(tid);  
  llStopMoveToTarget();
  llSetTimerEvent(0.0);
  llOwnerSay("No longer following.");
}
 
startFollowingName(string name) {
  targetName = name;
  llSensor(targetName,NULL_KEY,AGENT,96.0,PI);  // This is just to get the key
}
 
startFollowingKey(key id) {
  targetKey = id;
  llOwnerSay("Now following "+targetName);
  keepFollowing();
  llSetTimerEvent(DELAY);
}
 
keepFollowing() {
  llTargetRemove(tid);  
  llStopMoveToTarget();
  list answer = llGetObjectDetails(targetKey,[OBJECT_POS]);
  if (llGetListLength(answer)==0) {
    if (!announced) llOwnerSay(targetName+" seems to be out of range.  Waiting for return...");
    announced = TRUE;
  } else {
    announced = FALSE;
    vector targetPos = llList2Vector(answer,0);
    float dist = llVecDist(targetPos,llGetPos());
    if (dist>RANGE) {
      tid = llTarget(targetPos,RANGE);
      if (dist>LIMIT) {
          targetPos = llGetPos() + LIMIT * llVecNorm( targetPos - llGetPos() ) ; 
      }
      llMoveToTarget(targetPos,TAU);
    }
  }
}
 
default {
 
  state_entry() {
    llOwnerSay("/"+(string)CHANNEL+" [name of person to magically follow]");
    init();
  }
 
  on_rez(integer x) {
    llResetScript();   // Why not?
  }
 
  listen(integer c,string n,key id,string msg) {
    if (msg == "off") {
      stopFollowing();
    } else {
      startFollowingName(msg);
    }
  }
 
  no_sensor() {
    llOwnerSay("Did not find anyone named "+targetName);
  }
 
  sensor(integer n) {
    startFollowingKey(llDetectedKey(0));  // Can't have two ppl with the same name, so n will be one.  Promise.  :)
  }
 
  timer() {
    keepFollowing();
  }
 
  at_target(integer tnum,vector tpos,vector ourpos) {
    llTargetRemove(tnum);
    llStopMoveToTarget();  
  }
 
}
