// :CATEGORY:Combat
// :NAME:The_Terra_Combat_System_TCS
// :AUTHOR:Cubey Terra
// :CREATED:2010-07-01 15:11:14.270
// :EDITED:2013-09-18 15:39:07
// :ID:887
// :NUM:1256
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Instructions
// :CODE:
================================
INSTALLING THE TERRA COMBAT SYSTEM VERSION 2.5.4
================================
Cubey Terra
WWW.CUBEYTERRA.COM

In this notecard:
I. BEFORE YOU BEGIN
II. PUT THE TCS SCRIPTS INTO THE CORRECT PRIMS
III. ADD MOUSE BUTTON TO YOUR VEHICLE SCRIPT
IV. FINISH AND TEST
VI. ADVANCED CUSTOMIZATION

The Terra Combat System (TCS) is for vehicle-to-vehicle combat. Any two vehicles equipped with TCS can engage each other in combat. 

Rather than rezzing bullets, the combat system relies on sensors, so you can engage in fun dogfights without annoying bystanders -- it's completely harmless to anyone who isn't using the system, and it even works in no-build areas. Also, if you don't wish to engage in combat, you can easily turn it off and become invulnerable.

In a typical dogfight, the aircraft that scores the most hits wins. But watch out... some vehicles have more "hit points" than others.

When your vehicle is shot down, it billows icky black smoke and (under normal circumstances) falls to the ground. 30 seconds later, the vehicle regenerates and you start again. For each session, which is as long as the vehicle is rezzed, TCS  tracks:

* The number of avatars you hit.
* The number of targets you destroy.
* The number of times you get destroyed.
* The number hit points currently remaining.

It will also tell you who hits you and who shoots you down when that happens.



======================================
I. BEFORE YOU BEGIN
======================================

You can add the TERRA COMBAT SYSTEM to almost any vehicle to which you have modify permissions. Before you start, please read these important notes:

* Your vehicle object and the script inside it must have the Modify permission, or you will not be able to put the combat scripts into it. If the object is non-modifyable, you can't install the combat scripts. 

* Some knowledge of LSL is necessary.

* You also need to be familiar with some basic building concepts, such as parent and child prims, and prim orientations. If you're not familiar with these concepts, I do not recommend that you install this yourself.



======================================
II. PUT THE TCS SCRIPTS INTO THE CORRECT PRIMS
======================================

This is an easy step, but you need to be careful where you put each script, or you may run into difficulty later.

--------------------------------------------------------
A. Put the "TC2.5 sit target" script in the pilot's seat
--------------------------------------------------------

Every vehicle uses a sit target to specify where the pilot sits on the vehicle. In LSL, this is the llSitTarget function. Sometimes the sit target is in the parent prim, and sometimes it's in a seat or other prim that's actually a child prim. 

1. Right-click the vehicle, choose Edit, and select the "Edit linked parts" option.
2. Select the prim that contains the pilot's sit target.
3. Drag the "TC2.5 sit target" script into the Content tab.

If this script is not in the same prim as the pilot's sit target, Terra Combat System will not work.


-----------------------------------------------------------
B. Put the "TC2.5 sensor" in any correctly-oriented prim
-----------------------------------------------------------

The sensor script is the workhorse of the Terra Combat System. It "shoots" a sensor along the prim's x-axis and detects whether there are any avatars in front of it. For this reason, you need to make sure that the sensor shoots in the right direction.

Choose a prim that has its X-axis facing the front of the vehicle. That is, when your vehicle faces east, this prim has an X,Y,Z rotation of 0,0,0. This allows the TERRA COMBAT SYSTEM's sensors to scan forwards.

This prim can be either a parent or a child prim -- it doesn't matter. As long as it has zero rotation relative to your vehicle, it will do.

1. Right-click the vehicle, choose Edit, and select the "Edit linked parts" option.
2. Select the prim where you want to put the sensor.
3. Drag the "TC2 sensor" script into the Content tab.
                    

-------------------------------------------------------------
C. Put the "TC2.5 gun particles and sound" script into a gun barrel
-------------------------------------------------------------

The "guns and sound" script is for the barrel of your gun. It makes the gunfire sound and emits tracer bullet particles.

Gun particles always shoot along a prim's Z axis. That is, out the top of the prim. You need to find a prim that will work as a gun barrel -- one that has its top facing the front of the vehicle, so that the particles shoot forward.

For example, if you place a cylinder and rotate it so that its top points forward on the vehicle, this prim would be ideal as a gun barrel.

You can make more than one copy of the TC particle gun script, in case your vehicle has more than one gun barrel. Gun barrels are a purely aethetic feature -- adding particle emitters won't increase the combat effectiveness of the vehicle.

1. Right-click the vehicle, choose Edit, and select the "Edit linked parts" option.
2. Select the prim where you want to put the particle emitter (usually your gun barrel).
3. Drag the "TC2.5 gun particles and sound" script into the Content tab.


------------------------------------------------------
D. Put the HUD script in a child prim
------------------------------------------------------

The HUD is a hovertext display that shows you when the TERRA COMBAT SYSTEM is on, and displays your remaining hit points, the number of avatars that you have hit, and more. Because the HUD uses "hovertext" (llSetText), it's only visible when your camera is relatively close to the prim that contains the HUD script. 

When deciding where to put the HUD, I suggest choosing a prim that is either:

* in front of the pilot, so that it's visible in mouselook
* at the back of the vehicle, so that it's visible to the vehicle camera

** Do not put the HUD script in a prim that already has hovertext on it. It won't work. **

1. Right-click the vehicle, choose Edit, and select the "Edit linked parts" option.
2. Select the prim where you want to put the heads-up display.
3. Drag the "TC2.5 HUD" script into the Content tab.


--------------------------------
E. Put the optional beacon in any prim
--------------------------------

This step is optional.

The beacon can be important if you're shot down and lose track of where your destroyed vehicle went. Without the beacon, you could end up littering Second Life with lost vehicles, and you'll become a little unpopular. :)

By default, the beacon IMs you with the vehicle's location once per day.

1. Right-click the vehicle, choose Edit.
2. Drag the "TC2.5 beacon" script into the Content tab.



======================================
III. ADD MOUSE BUTTON TO YOUR VEHICLE SCRIPT
======================================

This step requires you to edit the vehicle's script. You need to add CONTROL_ML_L_BUTTON and CONTROL_L_BUTTON to your llTakeControls statement, and add a line to the control( ) event. Here's how...


1. Open your vehicle script in the editor.

2. Locate the line that takes your avatar's control's and add the mouse button controls. In your script, the line will look something like this:

            llTakeControls(CONTROL_UP | CONTROL_DOWN | CONTROL_FWD | CONTROL_BACK | CONTROL_RIGHT | CONTROL_LEFT | CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT, TRUE, FALSE);

Add to it the values "CONTROL_ML_LBUTTON" and "CONTROL_LBUTTON". The previous example would now look like this:
   
            llTakeControls(CONTROL_ML_LBUTTON | CONTROL_LBUTTON | CONTROL_UP | CONTROL_DOWN | CONTROL_FWD | CONTROL_BACK | CONTROL_RIGHT | CONTROL_LEFT | CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT, TRUE, FALSE);

3. Locate the line that says "control(key id, integer level, integer edge) {" and insert this line right after the opening curly bracket: 

       if (edge) llMessageLinked(LINK_SET, level, "tc ctrl", "");
        
NOTE: the variables "level" and "edge" are sometimes named something else, like "held" and "change" for example. Substitute the names that are in your script.

4. Click "Save" and wait for the script to compile and save. 



======================================
IV. FINISH AND TEST
======================================

You're almost done!

*** TAKE YOUR VEHICLE INTO INVENTORY AND REZ IT AGAIN. This initializes the scripts. ***

Hop in and say "combat on". Things to troubleshoot while testing:

* Check to see if TCS turn on when the pilot says "combat on". If nothing happens, then maybe the "sit target" script isn't in the same prim as the vehicle's actual sit target. If that's the case then TCS won't know who to listen to for commands.

* Check to see that the TCS hovertext HUD appears. If it's not visible, make sure that you placed it in a prim that's close enough to the camera or has enough empty space above it for the text.

* Check to see that the bullet particles emit in the right direction. If they appear to shoot in a direction other than forward, then the prim you placed the "TC particle emitter" script in is oriented incorrectly. The top of a prim (like a cylinder) would be the "business end" of your gun. 

* Point your vehicle at an avatar and shoot. It should register on the HUD and show you who you hit in chat. (You might want to ask permission before shooting someone -- some people object to being shot, even with harmless particles.)

* Get someone to shoot you until your hit points are gone. If you are a scripter, you can customize your vehicle script to "die" appropriately, as described in the next section.



======================================
VI. ADVANCED CUSTOMIZATION
======================================
THIS SECTION IS OPTIONAL AND FOR SCRIPTERS.

If you have mod permissions to the vehicle script, you can mod your vehicle to respond to the combat system's link messages. Here are the ones you may wish to use:

* "tc crash" - the TERRA COMBAT script sends this message to all prims when the vehicle is destroyed (i.e., reaches zero hit points). You could add something in your own script that responds to this in a unique way. 

     Suggestions: 
          - particle effects
          - de-linking
          - simulated plane damage
          - set the vehicle motors to zero to prevent the vehicle from running away
          - set vehicle buoyancy parameter to zero to make it fall from the sky

* "tc uncrash" - TCS sends this message to all prims after the regen timer has expired. It's intended to "regenerate" the plane to flyable status.

* "tc avatars hit" - Each time the TERRA COMBAT script detects a hit, it sends this message along with an integer representing the current total avatars hit. The HUD uses this to update itself. This is for display purposes only.

* "tc deaths" - Each time the vehicle is destroyed, it increments a counter. When the vehicle finishes regenerationg, it sends this message along with an integer representing the current number of losses. 

* "tc init hit points" - When the vehicle rezzes, the TERRA COMBAT script sends this message along with an integer representing the total hit points available to the vehicle. The HUD uses this to update itself. This is for display purposes only.

* "tc on" and "tc off" - When the user turns on or off the TERRA COMBAT SYSTEM, it sends this link message to all prims. The HUD uses this to turn on/off. Your vehicle could potentially respond to this by moving guns into firing position etc or something else interesting.

* "tc seated" - When an avatar sits on the sit target prim, the sit target script send sends the link message "tc seated" along with the avatar's key in the id parameter.

* "tc unseated" - When the user stands (or is ejected), the "TC2 sit target" script sends this link message.


