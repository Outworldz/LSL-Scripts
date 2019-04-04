// :CATEGORY:Building
// :NAME:Builders Buddy for Opensim
// :AUTHOR:Newfie Pendragon
// :KEYWORDS:Opensim
// :REV:2
// :WORLD:Opensim
// :DESCRIPTION:
// Builders Buddy for Opensim readme
// :CODE:


Revision History

  TABLE OF CONTENTS


01. PRODUCT SUMMARY
02. LICENCE AND COPYRIGHT
03. OFFICIAL RELEASES
04. ABOUT THE SCRIPTS
05. USAGE SUMMARY
06. DEFINITIONS
07. PREPARING A SET OF PRIMS TO WORK WITH BUILDER'S BUDDY
08. FINE-TUNING THE BEHAVIOUR
09. OTHER NOTES
10. FOOTNOTES
11. USING BUILDER'S BUDDY -- CUSTOMER HELP


01. PRODUCT SUMMARY

Builder's Buddy lets ordinary SL users rez a set of unlinked items in their proper places in relation to each other, without needing any building skills. The "Set" is usually a building, but there is no reason it can't also be a statue, a furniture set, etc.

You prepare the unlinked items according to the easy steps below, then for distribution put them in a Packing Box.

02. LICENCE AND COPYRIGHT

    * Use the Builder's Buddy scripts as you wish, to modify, sell, etc.
    * If you use this script in a for-sale product, please give credit to Newfie Pendragon as the creator of the script.
    * If you wish to modify this script and release the changes for public use, please submit changes to Newfie Pendragon. This is to ensure a consistent version numbering on releases, and to ensure changes are not wiped out in future releases.

03. OFFICIAL RELEASES

Official Releases of Builder's Buddy are tracked here: http://wiki.secondlife.com/wiki/Builders_Buddy

The most current official release as of April 2008 is version 1.10. Any release numbers higher than this, as of April 2008, are not on the officially supported path for updates in the future.

Subsequent versions of help for Builder's Buddy v 1.10 will be named -2, -3, -4, etc. This indicates the version of Builder's Buddy it is for, and the version of the help document.

For instance, when Builder's Buddy v 1.20 comes out, then the help for it would be named v 1.20 -1, etc.

04. ABOUT THE SCRIPTS

There are two scripts, base and component.

Make sure the Builder's Buddy scripts have the right permissions on them. They need at least transfer permissions, and since they are open source, there's no reason not to make them modify and copy as well.

Both scripts must be set to running. Do NOT hold down the CTRL key -- or Apple key on a Mac -- while dragging and dropping any of the scripts into prims, or that will set them to not running.

05. USAGE SUMMARY

The base script you only use once in an item. It goes in a "base" prim, which is the piece that is moved/rotated/etc. The component script goes into each part or each linked part that makes up the rest of the large build. In short, only one base script, many component scripts. You do not put a component script in the same item where you put a base script.

   1. Drop the base script in the Base.
   2. Drop the "Component" Script in each building part.
   3. Touch your Base, and choose RECORD
   4. Take all building parts into inventory except for the base prim
   5. Drag building parts from inventory into Base Prim
   6. Touch your base and choose BUILD

OTHER COMMANDS from the Touch menu

    * To reposition, move or rotate the Base Prim choose POSITION
    * To adjust where the house has rezzed after choosing BUILD, you can just edit - arrow move the base prim around, and the Rest of the build will follow;
    * To lock into position (removes all scripts, helping to reduce work on the sim server) choose DONE
    * To delete building pieces: choose CLEAN

06. DEFINITIONS

For the sake of this help, we refer to the base unit as the "Packing Box", and the set of unlinked items as the "Set."

07. PREPARING A SET OF PRIMS TO WORK WITH BUILDER'S BUDDY

[Note: please ensure first that you are on land where you are allowed to run scripts, or this will not work.]

A) Make a prim. Any size, any shape, and you can decorate later how you wish.

This is now what we are going to refer to as the "Packing Box." Occasionally, elsewhere, you will see it referred to as the "base unit."

All rotations for "Packing Box" should be set to 0, or all bets are off for how the objects rezzed out of it later will come out :} [1]

Drop the base script into it.

B) Rez in-world the set of prims you wish to be working with, if they are not already. As we are preparing them for distribution, now is the time to check that all of the permissions on them are what you like.

[TIP! in the steps below, you are going to do something to these items, then take them back into inventory. Remember that items rezzed in-world in SL, once taken *back* into inventory, tend to want to go back into the folder you rezzed them from. See the potential problem? You could end up with identically named items in that folder, the unprepared objects and the prepared objects, with no way to tell the difference. Consequently, you may wish to make sure in advance that once you have rezzed the items in-world from a folder, that in your inventory you then drag the originals off to another folder, so the coast will be clear for the incoming prepared ones. This can be particularly important if like most builders you leave each piece with the remarkably unique name of "Object" :} ]

C) Place the Component script into the content folder [2] of each piece or set of linked pieces of your build or set. To clarify, if you have several prims linked together (a "linked" set), just one of those prims (the "root" prim, which is the one you see by default when you edit a linked set, anyway) needs a Component script in it. If a prim is a standalone prim, it needs its own Component script.

D) Check your work. Did every piece or set of linked pieces get a Component script? Okay, then proceed.

E) Unless you have logistical reasons not to, we recommend now moving the Packing Box into roughly the centre of the Set. See footnote [3] at the end.

F) Click on the Packing Box (the prim you dropped the base script into earlier.) A blue menu will appear on your screen.

For now, the only button we care about is the RECORD button, but here's an explanation of all of them:

[Note: the menu also very cleverly contains brief explanations right on it!]

CHANNEL: The Packing Box and the Set pieces need a "channel" that they use to talk to each other. If you have several Packing Boxes, or several Sets, rezzed out and on the go all at once, you'll definitely want to make sure that each Packing Box / Set combination has its own unique channel to talk on, or the wrong Set might end up listening to the wrong Packing Box, and disaster could result! You could end up, for instance, issuing a CLEAN (delete) command that the only copy you have on a build might here!

RECORD: This memorizes the locations of the linksets you have dropped Component scripts into;

RESET: This "un-memorizes" the locations of the linksets you have dropped Component scripts into -- that is to say, it undoes any recording;

BUILD: This will rez your set of prepared, unlinked items, putting them all in the right place in relation both to each other, and in relation to the Packing Box.

POSITION: There may be times when the Set of objects doesn't respond to being moved by simply moving the Packing Box with the arrows (covered further below in point 4 of 11. USING BUILDER'S BUDDY) -- owing to lag, or no-script zones, etc. The POSITION command can be used to force the Set to try again.

CLEAN: This will derez the items you just rezzed using BUILD. This is done using the llDie() command. This means these items are gone, bye-bye, gonzo -- you won't even see them in your Lost and Found, or Trash.

DONE: Removes the Component scripts from the linksets, leaving them where they are "permanently." (Removing all the scripts helps to reduce work on the sim server.)

MOVE: Moves and rotates your set of unlinked items in relation to the Packing Box's height and rotation (e.g. your Packing Box will stay where it is; the build pieces will move.)

G) Press the RECORD button; the base Packing Box then records the locations of the prims or primsets that have a component script in them.

[TIP! With many pieces in a build, it can be very easy to forget to add component scripts into a piece or two. To help check that you haven't, after you have recorded the positions, go into edit mode on the Packing Box and move it up a bit. If everything follows as expected, then you are set. If not, from the SL client menu overhead, go EDIT - UNDO to have the Packing Box go back to where it was a second ago. Add a component script to the bits that didn't move. Record the positions again, then proceed.]

H) Leave the base Packing Box out, but take back into inventory all of the pieces that have Component scripts in them. It doesn't matter whether you take them in one by one, or whether you grab them all at once using TAKE from the SL client overhead menu to take them as a compound object.

I) The items are now in your inventory, and if you noted the advice in Step 2 above, you know exactly where they are in your inventory. Now, edit the Packing Box, switch to its contents folder, and drag all these prepared items into it.

J) Rename the Packing Box prim to a more helpful name than Object, if you haven't already.

K) Try rezzing the set from the Packing Box, as described below in 11. USING BUILDER'S BUDDY. Editing the packing box, and using the position arrows in edit mode, will cause the entire Set to move around with the Packing Box. Occasionally, if you are in a very laggy sim, or SL is having some kind of problem, when rezzing a build out of the Packing Box you may have to click on the Packing Box to get the menu, and click the POSITION button to get everything to pop into place. If that still doesn't do the trick, click on the CLEAN button, and then the BUILD button to try again.

[TIP! Occasionally, you may put all the prepared component pieces into the Packing Box, and run a test rez only to find that you're missing a piece of a house or furniture set that you meant to include. Don't despair; after all, that's what test runs are for!

Do the following:

a) rez the set as it is out of the Packing Box;
b) position the missing piece into place, where it should have gone;
c) add a component script to that missing piece;
d) record;
e) take just that missing piece into your inventory (make sure perms are right!);
f) place just that missing piece into the Packing Box

Note: that's right, just the missing piece -- no need to replace everything else.

08. FINE-TUNING THE BEHAVIOUR

Inside the Base script, at the top of it, are some parameters that you can set.

Full help comments are provided in the script above each parameter.

Please see these if you wish to change various aspects of how Buddy's Builder operates for you.

Here, though, is expanded help on a few items:

(a) "dieOnClean"

If you choose to use a piece of your build as the base component (which is fine), you will want to ensure that the "dieOnClean" to parameter is set to FALSE, or you risk deleting the piece during when any CLEAN command is issued.

(b) "creatorUUID" variable

You only need to fill this in if you are not the creator of the main root prim of your object.

Builder's Buddy checks the creator of the main root prim of your object to ensure that it can correctly determine which menu to show to whom. The creator gets the expanded menu; end users get the simpler menu that they need.

Normally, the creator of the packaged object has also made its root prim.

Occasionally, though, you may use prims other than those made by your own hand -- for instance, if you use megaprims. In this case, you can make sure you still get the expanded menu by specifying your UUID.

(c) "chatty" variable

If you want the Builder's Buddy to be less "chatty" while working away, you can change this via this script variable.

By default, it is set to:

integer chatty = TRUE.

To make Builder's Buddy quieter, you would change this to:

integer chatty = FALSE;

Bear in mind, though, that only the owner of the Packing Box can hear the messages, because the LSL script uses "llOwnerSay" versus "Say".

So, even though group members by default can use the menu on the Packing Box (because by default integer ingroup = TRUE ), those group members won't hear any confirmation messages unless they are the owner.

[TIP! If you want do want your team members to hear these messages, do a Search and Replace in the base script - search of llOwnerSay and replace it with llSay.]


09. OTHER NOTES

A) Position of set from Packing Box

If you had the Packing Box 5 metres in the air when you hit the RECORD button, then all the pieces of your Set will remember their position in relation to the box. Bearing that in mind, it therefore would not be a good idea to place the Packing Box on the ground and hit the BUILD button, because some pieces -- say, a floor -- might then end up 5 metres *under* the ground and be a headache for all concerned. So, tell purchasers of your Packing Box how high up or how low to place the Packing Box before hitting the BUILD button.

If you have indeed placed the Packing Box in the centre of your build before hitting the RECORD button, then advise purchasers that the build will rez using the Packing Box as the approximate centre.

B) Not getting a Menu on the Packing Box

    * Check that scripts are enabled for you where you are;
    * Check that the default click behaviour on the Packing Box hasn't been changed to Pay, etc.
    * Edit the Packing Box, go to the contents folder, open up the Base Script, and check that it is set to running.
    * If you copied the scripts yourself directly from the wiki on the web, ensure that no funny spaces or bad breaks come in with the text, as it often does from web pages; 

C) There is no issue per se using megaprims, though normal constraints re sim boundaries, unsocial neighbours who deny building rights, etc :} still apply. However, if a megaprim is used as your base object, you may need to set the "creatorUUID" variable (08. FINE-TUNING THE BEHAVIOUR above) to your creator's UUID.

D) There is no issue with Buddy's Builder rezzing part of a build -- e.g. a foundation, a basement, etc, below ground level, if that is what you want.

E) Underground

When the linksets are moved/positioned, SL uses the coordinates of the root prim to move everything else with it.

When you move a root prim by hand, you can to some extent ram it under the ground (as you no doubt remember from your early days in SL.)

However, when a root prim is moved by script, script cannot move that room underground. Attempts to do so will fail silently.

Child prims linked to it, though, *can* go underground, so long as the root prim's centrepoint remains aboveground.

Bear this in mind if, for instance, you are planning to rez a house with a foundation, or basement.

F) Two different Menus

There are two different menus: one full menu for the creator of the Packing Box, and one with fewer options for the customer.

G) What memorizes the positions of all the bits to be rezzed -- the Packing Box, or the bits themselves?

Each "bit" remembers its own position, independent of the Packing Box and independent of its fellow bits.

For instance, with pieces from an already recorded set, you can:

a) make a fresh, new Packing Box;
b) drop a fresh, new base script into it;
c) load the previously prepared component pieces into it....

and it will all still work!

H) Naming component pieces

Builder's Buddy does not require all the prims in a build to have unique names. That being said, many feel it is good practice to have some kind of a naming system for the objects in your build so that they are not all named "object" or "block" or whatever. Otherwise, when you add them to the Packing Box, the SL system will just arbitrarily name them all Object, Object 1, Object 2, etc, and they will then not have the same name as those pieces in your inventory.

Depending on what your build is, you may have more than one naming convention. At the very least, when you manually add the component script to the component objects, consider naming the objects numerically yourself such as Object 01, Object 02, etc. That way, you have some idea of how many objects are in the build, and by going 01, 02, you know the numbers weren't just system-assigned ones. You can also count them easier from inside your inventory. When a build command doesn't work right, you can look back at your history and see which object by number didn't respond to the base prim when you did the record command.

10. FOOTNOTES

[1] Rotation

It is only the rotation of the Packing Box that you have to be concerned with. The rotation of the prims, or linked sets of prims, that you will be rezzing *doesn't* matter. Their rotations are part of the data that Builder's Buddy records, and deals with.

[2] Finding the Content Folder of an Item

Right-click the item in question (it must be rezzed in-world.) From the round pie menu, choose edit. The modal properties window will appear. Look on the right hand side for a button that says either "More>>" or "Less>>". If the blue button says "More>>", please click it. It will now say "Less>>". If it already says less, you are already ready for the next step.

For the next step, look for the folder tab called "Content". Click on this tab, please. You are now in the Content area of the item. To put items in here, locate them in your inventory, and drag them from your inventory and *drop* then into the Content folder. In a second or two, they will appear there. If SL is not behaving at the time, it may take a few more seconds.

To leave edit mode, locate the x in the upper-right hand corner of this editing properties window. Click it.

[3] Distance of Set pieces from Packing Box

In one way, there is no distance limit, with the simple proviso that all the prims must be in the same sim as the base. The base uses "region say" to communicate with them, meaning that its directions will be heard any anything listening for them within that region (aka sim.)

However, the linden script command to rez something can only rez something at a maximum distance of 96 metres from the item doing the rezzing. Note, however, that this is "in all directions", so the rezzer can rez something a maximum distance of 96 metres to the left, and 96 metres to the right -- ergo, a total distance, if the rezzer is in the middle, of 192 metres, which is not bad going. If you also place the box, say, 96 metres in the air, then you can rez pieces 96 metres up, 96 metres down, and 96 metres to either side, right and left (bear in mind that you probably want to be higher than 96 metres in the air; ground level is rarely actually bang on "0" in most sims.)

Consequently, when first setting out the Packing Box, and before pressing the RECORD button, it's good practice to place the Packing Box in the *middle* of the build, unless there are other prevailing reasons to place it elsewhere.

11. USING BUILDER'S BUDDY -- CUSTOMER HELP

Note: the following directions for usage are written in such a way that you can supply them just as they are written below to users / purchasers of your products, or, of course, modify them to make them more relevant to your product.
- - - - - - - - - - - - - - - - - - -

Packing Box refers to the prim object you received for your purchase. "Set" refers to the items that will be rezzed out of it.

[Note: please ensure first that you are on land where you are allowed to run scripts, or this will not work.]

1. Rez the Packing Box. The creator may have supplied you with directions about how to place the Packing Box for optimal rezzing results. If the creator noted that the Set rezzes using the Packing Box as its centre, bear that in mind. The creator may have recommended placing the Packing Box at a certain height before using it. If so, this is most easily done by editing the Packing Box [1], going to the Object tab of its properties, and just typing the coordinates provided into the appropriate X, Y and / or Z fields. When you close the editing properties, the Packing Box may appear to vanish, but it hasn't -- it has just instantly moved to that new position! Fly there yourself to join it.

TIP! Before changing the position using the X-Y-Z fields, consider just plain sitting on the Packing Box. That way, when it whizzes off, you will too right along with it!

2. Click on the Packing Box. A blue menu will appear on your screen. The buttons are:

Build / Position / Clean / Done

3. Click the BUILD button. In a matter of microseconds, the Set rezzes into place.

4. To move the entire Set of objects all at once, just edit the Packing Box and move it -- the pieces magically move in relation to it!

5. There may be times when the Set of objects doesn't respond to being moved, as just described -- owing to lag, or no-script zones, etc. The POSITION command can be used to force the Set to try again.

6. If a real mess has somehow happened, or if you were just experimenting, click the CLEAN button. This will derez everything you just rezzed, except the Packing Box itself. Then, click the BUILD button again.

7. To fix the build in place, click the DONE button.

CUSTOMER HELP FOOTNOTES

[1] Editing the Packing Box

Right-click the item in question (it must be rezzed in-world.) From the round pie menu, choose Edit. The modal properties window will appear. Look on the right hand side of it for a button that says either "More>>" or "Less>>". If it already says less, you are already ready for the next step. If the blue button instead says "More>>", please click it. It will now say "Less>>". You are now ready to proceed.

To leave edit mode, locate the x in the upper-right hand corner of this editing properties window. Click it. 
