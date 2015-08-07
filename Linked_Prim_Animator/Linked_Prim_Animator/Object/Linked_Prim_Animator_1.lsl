// :CATEGORY:Prim
// :NAME:Linked_Prim_Animator
// :AUTHOR:Falados Kapuskas 
// :CREATED:2012-09-18 15:31:14.597
// :EDITED:2013-09-18 15:38:56
// :ID:474
// :NUM:635
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Notes - GNU General Public License
// :CODE:
=Linked Prim Animator Lite=
By: Falados Kapuskas 
Date: 12/27/2007
Version: 1.07

First, thank you for choosing Linked Prim Animator Lite (LPAL) for your linked prim animation needs.  I'll try my very hardest to make this
processes as painless as possible.  There are several features you should know about before you begin so here is the run-down.

==Features / Limitations ===

===Features===
1. LPAL is modular - Each LPAL Frame Capture script captures one clearly labeled element of the linked prims.
2. LPAL is a dialog-based setup.
3. LPAL has protection against lost dialogs
4. Only the one LPAL Frame Controller needs to be copied into the linked prims you would like to track
5. The LPAL link-message protocol is documented.  You may use this to make scripts compatable with LPAL. [LPAL Protocol]
6. Since LPAL is Open Source, you can freely modify it to suite your needs.  Just make sure you release your chages to the public under the GPL.

===Limitations===
1. After you have quit the Wizard, it will default to deleting itself.  This is to reduce lag.  You may use the [Example Script]
    which is a small portion of the wizard (used exclusively for playback).  You simply drag this script into the root and touch the object to begin.
2. Resizing the object or otherwise altering it after the animation has been publish will most likely break the animation.
3. Second Life has some interpolation (tweening), but it only goes so far. The animations will always look slightly choppy.
4. LPA Will only record the quantitys for which you have modules.  You may freely make more modules as long as they are also released GPL (Derived Works)
5. Although LPAL can handle practically any number of prims and snapshots, the less you use, the smoother the animation will be.
6. Prims can only be moved no more than 10 meters from the root prim (This is a SL Limitation)

==Setup==

===Quick Start ===
1. Put the following scripts in your root prim.
    LPAL Editor
    LPAL Player
    LPAL Wizard
    every LPA Frame Capture script you want (At least 1)
2. Put the following in all child prims
    LPAL Frame Controller (<<TYPE>>)
3. Chat the following:
    /55 lpa_wizard
4. Follow the Capture Dialog
5. Move child prims around and press Capture to save the
6. Press [Done] on the capture dialog when you are finished editing
7. Use the player wizard to play back your animation
8. When done, press Quit
9. To play the animation back later, use a script to send link messages using the LPA Protocol

??

See the information about the Capture and Playback stages for more detailed information.

===Verbose Setup===

First, you must start off with some sculpture you wish to animate.  In each child prim, place one LPA Frame Controller script.
In the Root Prim, place all the setup scripts and as many modules as you'd like to track.
These scripts are mandatory:
    LPAL Player
    LPAL Wizard
    LPAL Editor
You may include one or more (or all) of these scripts:
    LPAL Frame Capture (<<TYPE>>)

If you wish to record other quantities, use the [LPAL Template]
and fill in the blanks with your code.

Once you have set up your model with these scripts, you are ready for editing.
Type this to begin: /55 lpa_wizard

You should now be getting some messages alerting you to the status of the setup.  There should be
a percentage that increases over time.  Each prim that you have dropped an LPA Frame Controller script into will be 
loaded with all the LPAL Frame Capture modules you put in the Root Prim. 

==Capture Stage==

After the setup is completed, you should be presented with a dialog. As with almost any dialog, if lose it, just type /55 lpa_lost to get it back. You should notice there are several options.
------------------------------------------------------------------------------------------------------------------------
Buttons                         What they do
------------------------------------------------------------------------------------------------------------------------
<<                                      Go back 1 frame
>>                                      Go forward 1 frame
Capture Frame               Record the state of the prims and go to the next frame
Origin                              Copy the prim attributes at frame 0 to the current frame
Done                                Finish the animation (Clean up, and go to playback)


==Playback Stage==
This wizard has a playback stage where you can see your creation come to life. 

------------------------------------------------------------------------------------------------------------------------
Buttons                         What they do
------------------------------------------------------------------------------------------------------------------------
Play                                     Play the animation between the range (Defaults to all frames)
Pause                                 Stop the animation
Backward                          Play Direction is set in reverse
Forward                             Play direction is set forward
Speed Up                         Decrease the frame time interval by .1 seconds (To a minimum of .2 seconds)
Speed Down                    Increase the frame time interval by .1 seconds
Quit                                    Finish playing back (Kill the wizard)

==Lost Dialogs==

This has been mentioned before, but if, for whatever reason, you lose a dialog either by accidentally ignoreing it or through some other fluke, you can always get it back by typing /55 lpa_lost

==Copyleft==
LPAL is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

LPAL is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details. [Copying]

