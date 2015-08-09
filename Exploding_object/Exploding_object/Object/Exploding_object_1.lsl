// :CATEGORY:Exploding Objects
// :NAME:Exploding_object
// :AUTHOR:anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:52
// :ID:291
// :NUM:389
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Introduction:// // Making things blow up is good fun. One often-undesirable side-effect of things blowing up is that they leave debris behind. This script example can be used to make an object blow up, and have the resulting debris automatically vanish. In particular, it sets the object to physical (so the physics engine will cause it to blow up in an aesthetically pleasing way), sets it to temp-on-rez (so that all the prims will vanish when the sim gets tired of having them around), and then breaks all the links in the object (causing it to blow up).// Usage// // To use this script, stick it into the root prim of the object in question (after reading the Limitations and Notes below to make sure the object qualifies), say "Yes" to the prompt about whether or not it should be able to change links, and then say "collapse" on channel 7 (like "/7collapse", you know). The object will then blow up. The debris it leaves behind will vanish automatically a bit later, just after you've decided that it's not going to and you're going to have to clean it all up by hand.
// Limitations and Notes
// 
// This script works only on objects into the root prim of which you can stick a script. Which is good, really, as you wouldn't want other people causing your personal objects to blow up.
// 
// More significantly, the script works only on objects that consist of 32 or fewer prims. This is because (at least as of this writing) objects with more than 32 prims cannot be made physical. If you have a larger object, you can manually divide it up into multiple 32-prim-or-less objects and stick this script into the root prim of each one. Then they will all blow up together on command. Probably. Although I haven't ever actually tried that.
// 
// Before activating the script, you should make sure that the object is not interpenetrating with some other object (the ground is probably okay). This is because things that are interpenetrating with other things also cannot be made physical.
// 
// The degree of explodingness of the object will depend largely on how much overlap there is between the various prims making up the object. Objects made of largely-nonoverlapping prims will collapse in a more or less leisurely fashion, whereas objects whose prims overlap heavily may scatter debris all over the place.
// 
// Objects consisting of just a couple of prims, or (clearly) just one, won't do anything all that interesting when this script is activated. Unless sort of falling over and then disappearing is interesting. The more prims (up to and not exceeding 32) the merrier, in general.
// 
// To change the channel on which the object listens or the command that it listens for, or to allow it to accept the command from anyone rather than just the owner, made the blindingly obvious change(s) to the first few lines. 
// :CODE:
integer CHANNEL = 7;
string COMMAND = "collapse";
integer OWNER_ONLY = TRUE;
 
// Exploding Objects script, by Dale Innis
// Do with this what you will, no rights reserved
// See https://wiki.secondlife.com/wiki/ExplodingObjects for instructions and notes
 
integer lh = 0;
 
init() {
    llListenRemove(lh);
    key who = NULL_KEY;
    if (OWNER_ONLY) who = llGetOwner();
    lh = llListen(CHANNEL,"",who,COMMAND);
    llOwnerSay("To cause collapse, say '"+COMMAND+"' on channel "+(string)CHANNEL);
    llRequestPermissions(llGetOwner(),PERMISSION_CHANGE_LINKS);
}
 
default {
    // usual faffing about
    state_entry() { 
        init();
    }
    on_rez(integer x) {
        llResetScript();
    }
    changed(integer change) {
        if (change & CHANGED_OWNER) llResetScript();
    }
    // the part that actually does something interesting
    listen(integer c,string name,key id,string msg) {
        llSetStatus(STATUS_PHYSICS,TRUE);
        llSetPrimitiveParams([PRIM_TEMP_ON_REZ,TRUE]);
        llBreakAllLinks();        
    }
    // faffing about with permissions
    run_time_permissions(integer perms) {
        if (!(perms & PERMISSION_CHANGE_LINKS)) {
            llOwnerSay("Well, the collapsing stuff isn't going to work, then!");
        }
    }
}
 
