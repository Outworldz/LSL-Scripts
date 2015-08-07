// :CATEGORY:AO
// :NAME:Franimation_Overrider
// :AUTHOR:Amanda Vanness
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:53
// :ID:337
// :NUM:453
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Franimation overrider V 1.5
// :CODE:
==========================
Franimation Overrider v1.5
Copyright (C) 2004 Francis Chung
Documentation by Gwynneth Llewyn and Kex Godel
==========================

Welcome to the wonderful world of animation overriding! 

We hope that you enjoy this open source product.  

Please note that although this object allows you full technical permissions, you must still abide by the licensing terms specified below.

----------
 LICENSE&#1048576;
----------

Scripts:
---------
This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version. 

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.

Model:
---------
The WetIkon (amped) model copyright CCA-NoDerivs License.

----------------
Support Help
----------------
The following people have generously offered their time to help with animation overrider questions:

 Ulrika Zugzwang
 Water Rogers
 Gwyneth Llewelyn
     Email:       gwyneth.llewelyn@secondlife.game-host.org
     MSN:         gwyneth.llewelyn@secondlife.game-host.org
     Yahoo:       gwyneth_llewelyn

-----------------------
 QUICK START GUIDE
-----------------------

So you're itching to try it out and don't want to read the whole manual? Good for you! 

To get the Franimation Overrider working, there are just a few simple steps.  If you need more help, details are provided in the Documentation/FAQ section below.

1. Rez the Franimation Overrider on the ground.

2. Drag your custom animations for walking, standing, sitting, etc. and drop them inside the "Contents" folder of the Franimation Overrider.

3. Open the "*Default Anims" notecard located in the Franimation Overrider and type the EXACT name of each custom animation below every "posture state" line.   DO NOT add any lines or remove any lines to any part of the notecard.  Just fill in the blank lines.  Also note that spaces, punctuation, hyphens, etc. ARE relevant here!

Example: If you have a custom animation for walking called "Sexy-Walk #1" you have to type exactly that  on the line under the "-=Walking=-" posture state keyword.   Your notecard should look like the following:

-=Walking=-
Sexy-Walk #1
=Running=-

-=Crouchwalk=-
[...]

4. Attach the Franimation Overrider to yourself. 

5. That's it!  Enjoy your "new moves" :-)


-------------------------
 COMMAND REFERENCE
-------------------------
 
/ao on 
Enable the Franimation Overrider

/ao off
Disable the Franimation Overrider.  This will make you revert back to using the default animations.

/ao hide
Make the Franimation Overrider attachment invisible (if you don't like it to appear with your current outfit)

/ao show
If invisible, make the Franimation Overrider visible again.

/ao reset
Reset the Franimation Overrider script.  This can be useful if the script is acting strangely, or if you just want it to reset and re-read the default notecard.

/ao nextstand
Immediately switches you to the next standing animation in the list, or the first one if you're at the end of the list.

/ao col [colour]
Changes the colour of the model. [colour] can be a name (such as red, tan, or mauve) or a colour vector. (<0,0,1> for blue)

/animset < NotecardName >
This tells the Franimation Overrider to load a different notecard, in case you want to use multiple animation sets and quickly switch between them.  You must specify the exact notecard name in place of "< NotecardName >" above.  

/anim < animation name >
Play an animation. (eg. /anim hold_r_handgun)

/noanim < animation name >
Stop playing an animation. Play an animation. (eg. /noanim hold_r_handgun)

/noanim all
Stop playing all animations.

For example, if you want to play a different set of animations when you're tired, you can create a second copy of the Default Animations notecard, name it "sleepyanims" and then switch to it by typing: /animset sleepyanims


---------------------------
 DOCUMENTATION / FAQ
---------------------------

Q> What is "animation overriding"?

A> This is a way to replace the default body movements that SL does on your avatar with custom animations.

Your avatar has different "postures", which technically are a "state" you're in, for example, "Standing", "Flying", "Walking", and "Sitting on Ground" are a few of the many posture states your AV can be in.

An animation overrider makes it possible for you to play a custom animation whenever you are in a specific posture.  This means you can choose to replace the way you look when you are standing, flying, sitting, etc.

This means that you can make your avatar move, stand, and sit in a unique way.


Q> Where are the custom animations?

A> The Franimation Overrider does not come with any custom animations, you will have to add your own.


Q> Where do I get custom animations?

A> You can get custom animations in stores, or from friends.  There are also a bunch of free animations floating around the world and reportedly available at the Bazaar in Stillman.

There are nice people collecting dozens of freebie animations, for example, if you look or ask around some people have a "pack" of 200 free custom animations.

If you need more sophisticated animations, then you may contact one of the many wonderful professional animators out there or buying animations from their stores.  You can search for them in world under the "Find" button, with the "Places" tab selected, or search the forums at:

http://forums.secondlife.com

If you feel bold, creative, and technically competent, you can try making your own custom animations.

All custom animations in Second Life were uploaded in "BVH" format from a software program called Poser.  You can upload your own if you own a copy of Poser, or if you have any BVH files which are compatible with the exact format that Second Life needs.  Most random BVH files will not work without first being processed through Poser with the P2 figure.

There are several public domain, open source or shareware alternatives to Poser, but so far, they all seem to need the final tweaking done in Poser to work correctly in Second Life. 

There are several tutorials online (again, search for that in the forums) for creating your own animations.  To help you get started, here is a rough guideline for creating a still standing pose with Poser:

- Use a P2 model
- Create two frames
- Set both frames as keyframes
- Leave the first frame unchanged (ignore it)
- Pose your model in the second frame
- Export BVH
- Switch to SL and select "Upload Animation" from the "File" menu
- In the preview window, check [x] Loop, and set "Ease In" and "Ease Out" both to "0.5" (roughly)
- Click the "Play" arrow button to confirm it looks ok
- Click the Upload button

Important Note:  Using Poser and getting it to work with SL can be very challenging.  We really can't help you overcome it's learning curve in this document alone or through Instant Messages.  If you do need help with Poser, *please* ask on the Second Life forum created specifically for animation discussion.


Q> How does the Franimation Overrider work?

A> The Franimation Overrider detects your posture and plays a custom animation whenever it changes.

The Franimation Overrider is an attachment containing a script and a configurable notecard.  The Franimation Overrider script will read the notecard so that it knows which postures to override animations for, and the names of the animations to use in their place.

While the Franimation Overrider is attached, it will constantly monitor your posture state.  When it sees that your posture has changed, it will send a command to stop playing the current animation and start playing the custom animation you specified in the notecard.


Q> How do I add animations to my Franimation Overrider?

A> Just drag and drop them into the contents of the Franimation Overrider, as so:

- Rez your Franimation Overrider on the ground (must be in an area which allows building)
- Right click on the Franimation Overrider, choose Edit
- In the edit window, if you see a button which says "More >>" in the bottom right corner, click that so that it opens up the edit window to show you more options
- You should see several tabs "General", "Object", "Content" and "Texture".
- Click on the "Content" tab.  You will see some notes and a script, don't mind them just yet.
- Now locate the custom animations that you want to use in your inventory, and drag-drop them into the Contents folder
- Right click on the Franimation Overrider and choose "Take" to take it back into your inventory


Q> How do I configure the Franimation Overrider notecard?

A> Follow these instructions:

- Attach the Franimation Overrider to yourself, or rez it on the ground
- Open the contents tab (as described above)
- Open up the notecard named  "*Default Anims". 

Here is where you assign a custom animation to each of the possible "anim states". "Standing" is a special state - you can have up to 5 different standing animations, and Franimation Overrider will cycle among those 5 animations occasionally.

The notecard configuration is rather simple. Lines starting with things like "-=Sitting=-" identify the posture that will be detected; the line immediately following that one will have the NAME of the custom animation that you have dragged into the Franimation Overrider's inventory.

*CAUTION: It is very important not to add or remove any lines!

When you first open the notecard, it will have the names of all states, and all lines in-between will be empty.   It is important that you only change the empty line between each -=Posture=- line.

The empty lines should be the name of the animation which will be played for the posture specified immediately above it. Make sure you write the name EXACTLY like the animations's name - with spaces, punctuation, and caps. 

Sometimes the name can be something very weird, or, if you don't have an US keyboard, some characters may be very hard to reproduce. In that case, either change the animation's name _before_ you drag it into the Franimation Overrider's Contents, or you may open up Properties on that custom animation, use the mouse to copy the name, and paste it into the notecard. Just make sure you don't get any extra spaces at the beginning or end of the animation name when pasting - Franimation Overrider needs the EXACT name to work properly (otherwise you'll get some errors like "Couldn't find animation XXXX").

Example: 

You want to override your default sitting animation with a custom animation called "weird0-S1tDown #345". Your notecard configuration should have something like that:

[...]
-=Hover=-

-=Sitting=-
weird0-S1tDown #345
-=PreJump=-

[...]

Notice the empty lines after "Hover" and "PreJump", meaning you don't have any custom animations for those, and Franimation Overrider will simply revert to the default animations. Also note it is very important not to add any extra lines anywhere to the notecard.

USEFUL TIP: 

You should make a copy of a blank notecard first to your inventory, just in case you delete too many lines and can't remember the state's names afterwards. And make a copy of your own, modified notecard - you'll save time when a new version of the Franimation Overrider comes along!


Q> What if I leave a line blank?

A> That is fine, if you leave a line blank, the animation for that posture will revert back to the default animation.


Q> Why are there 5 stand animations?

A> The Franimation Overrider will cycle through all five animations every 40 seconds or so.  This behavior is much like the default standing animation where you occasionally shift your avatar's body to different positions.


Q> I'm having animation glitches with my vehicle/dance script when the Franimation Overrider is on.

A> Other scripts which also play custom animations may interfere with the Franimation Overrider.  Turn off the Franimation Overrider before you interact with these objects (see command reference for the off command).  

Also see the Drawbacks section below for more details


-----------------
 TIPS & TRICKS
-----------------

* Proper Application

Most animation states are rather simple to understand, but some of them are tricky. For example, you can run instead of walking.  

In most cases, the animation for one would not look proper for the other, which is why there usually are two different custom animations for those states (i.e. two different Sexy Walks or Power Walks). 

Using the wrong one generally looks quite weird (i.e. avatars "running in place" or "taking too long of strides"). 

Also note that there are two different sitting animations - one for sitting on chairs (actually, any kind of object surface) and the other for sitting on the ground.

* Smooth Transitions

If you have an unusual custom walking animation, you probably will want to also customize the Turn Left and Turn Right animations as well.  Otherwise your avatar will seem to go through a complex "dance" every time you turn left or right. 

Flying is also complex, since you have things like "hovering" (standing in the air), flying slowly and quickly.  You will want to probably choose a set of animations which makes these flow together well.  Note that the "Flying slow" posture state is actually quite rarely experienced, unless you have a flawless connection and very high frame rates, but it does happen :) 

Landing is also another problem, since you have soft and hard landings (depending on the speed) and free falling (not flying at all!). 

So for most realistic appearance, this means that you have to "combine" all these animations properly and see how they work together - that's normally not very easy when you just grab a few freebies (or worse, just poses and no real animations). The same, actually, applies to "swimming" - "flying" at the water's surface or below.

* Idle Standing Cycle:

Standing is a special case in animations. The Franimation Overrider allows you to have up to 5 different standing animations, and will cycle among them every 40 seconds or so. If you just have one standing animation, be prepared to wait a while until it's displayed!

* Multi-Animation:

For maximum flexibility, the Franimation Overrider also allows you to enable *multiple* animation with each posture.  To do so, you put each animation name on the line, separated by commas.

Why would you want to do this?  Well, often you will find that a single animation doesn't fit what you want to do because of animation priorities.  The problem sometimes is that high priority animations will completely override the lower priority animations.  

If you are able to create your own animations in Poser, you can avoid this problem by breaking up your animation into multiple parts, which customize different parts of your body, then use the Franimation Overrider to re-play all of them together by specifying them as a comma-separated list on the line in the notecard.

This not only allows you to work around some of the limitations caused by animation priorities, but allows you to extract much more variety out of your animations since you can play them in different "chords".

* Smooth Transitions (CONTENT CREATORS, PLEASE READ)

If you are creating and uploading animations, please note the importance of the "Ease In" and "Ease Out" settings.  I strongly recommend setting these at 0.5 or higher, otherwise your animations will SNAP into place far too quickly, and it looks very unnatural.

By default, the preview window is usually set far too low.  Every time I upload an animation, I usually set each to 0.5, sometimes higher (such as a slow dance movement where you want a very steady transition), and sometimes lower when applicable (such as the ease-in on a falling-to-the-ground animation).

---------------
 DRAWBACKS
---------------

The Franimation Overrider is a nifty script, but as it is not part of the native code in the SL Client/Server architecture, you may occasionally encounter some very minor discrepancies from the intended behavior.

1. Animation Download Lag

Animations are rendered in the SL client program - and not server-side - so this means that all animations have to be loaded from the server into your program, for all avatars "seeing" you.

While the default animations are immediately available for everybody (as said, they already come with the SL application), your cool custom animations are not. This means that you'll probably see them working for you, but on a particularly slow sim, others won't see them immediately. 

This is exactly the reason why sometimes you go to a club and nobody seems to be moving. After a while, you see everybody connected to the dance machine moving, and finally the one having dancing bracelets or loading custom dances.

The Franimation Overrider works the same way. People who haven't recently "seen" your custom animation will have to download it from the servers before they see it in action. This means that probably just after teleport, or when using a "fresh" animation (say, sitting for the first time), people will NOT immediately see your custom animation, but the default one. There is nothing you can do about it, except fretting and wishing that Linden Lab(TM) gets you faster servers :)

2. Polling Lag

The way the Franimation Overrider works is by polling your current posture in a loop to retrieve your current state.  This means that there will be a slight bit of response time between when you changed postures and when the next polling event occurs.

3. Conflicts With Other Animating Objects

The Franimation Overrider only knows how to override the default animation states.  It will get into conflict with other objects which change your animation and should be turned off before using the other objects (see command reference for how to turn it off).  

Examples of other objects which will probably interfere with the Franimation Overrider include dance bracelets, dance machines, and vehicles which use custom animations.  Some other animation scripts may have some odd behavior as well, such as the hug animation script.


------
 END
------

Documentation written by:
2004 Oct 17 - Gwyneth Llewely (first draft)
2004 Nov 28 - Kex Godel (edited and reformatted)
