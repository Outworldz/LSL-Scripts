// :SHOW:
// :CATEGORY:NPC
// :NAME:Paramour Multi-Purpose NPC Rez & Pose
// :AUTHOR:Aine Caoimhe
// :KEYWORDS:
// :CREATED:2015-11-24 20:38:24
// :EDITED:2015-11-24  19:38:24
// :ID:1093
// :NUM:1868
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// NPC Controller
// :CODE:
Paramour Multi-Purpose NPC Rez & Pose
by Aine Caoimhe (Mata Hari)(c. LACM) April 2015

Provided under Creative Commons Attribution-Non-Commercial-ShareAlike 4.0 International license.
Please be sure you read and adhere to the terms of this license: https://creativecommons.org/licenses/by-nc-sa/4.0/

INSTRUCTIONS

This item is designed as a multi-purpose NPC utility for a wide variety of general uses. You can place the script in any object you want, then adjust its settings to whatever general application you have in mind. For more complex situations you may need to make additions or alterations to the script which you are free to do provided you adhere to the license.

1. Either rez this object to ground or place the script into another object you'd like to use as your controller. If you wear it, it will be deactivated although if you have a bit of scripting knowledge you could alter the script to allow this but then you're responsible for making sure you don't rez a NPC that then attempts to sit on a worn object and then ends up stranded.

2. If you want this script to handle basic animation for you, you'll need to add at least 1 animation to the object's inventory. If you prefer, you can have another script handle animations instead provided it's designed to work for a sitting NPC. Most basic furniture sit scripts can do this but more complicated systems may not (unless modified).

3. If you want to use a NPC that you've already stored as an appearance notecard, you can simply place a copy of that notecard into the object's inventory and rename it to meet the name requirements of this script (see below).

4. Now open the script and adjust the user settings, then save. Depending on your settings and whether you've supplied a NPC notecard, resetting the script will either rez a NPC or wait for you to touch it.

5. If the object is controlling a NPC, touching the object will remove the NPC. If it isn't currently controlling a NPC, touching it will rez one.

6. If you change the inventory (add/remove animations or notecards) you should reset the script as well to have the changes picked up. I don't do it automatically in case you wish to add/remove many items at once which can result in extremely long processing and is a PITA.

NPC APPEARANCE NOTECARD NAMING

This item is quite flexible but it's best to use the same naming format as the PMAC system where the name must be in the form:
        .NPCxxp Firstname Lastname
- it must begin with .NPC (dot and then capital letters NPC)
- it is then immediately followed by two more letters or numbers that only affect its sort order in inventory. For use with this script they are optional
- then one final letter which is also optional for this script but in PMAC is used for permission check
- then a space
- then the first name to use for the NPC
- then a space
- then the last name to use for the NPC
- for this script if no names are supplied a generic name will be used

So for this script you just need a card that starts with ".NPC" but it might be a good idea to get into the habit of using PMAC formatting for added convenience should use use that system at some point in the future.

When this script creates an appearance notecard it is automatically named using the source avatar's name and is correctly formatted for PMAC with sort order 00 and permission set to A (all).


USER SETTINGS

ownerOnly
can be set to either TRUE or FALSE
- if TRUE, only the owner can touch the object to rez/remove the NPC
- if FALSE, anyone can do so

hideInUse
can be set to either TRUE or FALSE
- if TRUE, when the NPC is rezzed the prim containing the script will be set to alpha = 0 to hide it, and any floaty text will also be hidden. The object and floaty text will re-appear when touched. This is very handy when using this as an invisible poseball for NPCs to sit on...you just need to remember where you put it so you can locate it again to touch it while it's invisible. when made visible the alpha is set to 1.0 which might not be suitable for your object so you may need to change this value inside the script itself for custom applications == just search for "llSetLinkAlpha" and adjust as appropriate)
- if FALSE, the alpha of the object won't be changed and no text will be applied

target
can be left at "" or you can supply the key (UUID) of any object in the region that you want the NPC to sit on when it is rezzed
- if no key is supplied, the object containing this script will be the object the NPC sits on
- if you supply a key but the object isn't in the region or isn't valid, it will revert to use the object containing this script instead
- if the object is more than 10m from the object containing this script, the NPC will first be teleported to the location of the object. There is no distance limit (provided the target remains in the region)

animateNpc
can be set to either TRUE or FALSE
- if FALSE, the NPC will be rezzed and sit on the target and then it's assumed that another script will handle animations (if any) and this script's function will simply be to control rezzing and removing the NPC
- if TRUE, this script will handle basic animation of the NPC provided you place one or more animations in the script object's inventory (even if the NPC is sitting on a different target!). If more than 1 animation is supplied it will cycle through all available animations

animationTimer
can be any value greater than 0.0
This determines how often to change animation if there is more than 1 animation in inventory and if animateNpc is TRUE. If there is only a single animation (or you set animateNpc to FALSE) it is ignored

randomAnim
can be set to either TRUE or FALSE
- if TRUE, the list of animations will play in random order. After each animation has played once, the list is re-shuffled so it's possible that the same animation could play twice in a row

autoRez
can be set to TRUE or FALSE
- if TRUE and there's a NPC appearance notecard in inventory, the NPC will automatically rez and sit on the target when the script is reset or if the region restarts -- highly useful for populating your region with NPCs even if you aren't there when the region restarts
- if FALSE, or if there is no appearance notecard in inventory, the object will wait for you to touch it before rezzing the NPC

storeToucher
can be set to TRUE or FALSE
- if TRUE and if the object does not already contain a NPC appearance notecard, the toucher will be asked whether they are willing to be cloned and have that appearance stored as a notecard in the prim's inventory. If they agree, the script will do so using the correct naming format. If they decline, the script will abort.
- if FALSE, and if there is no appearance notecard in inventory, the toucher will be cloned and rezzed directly to the NPC without a permission check but the appearance is NOT stored
- in either case, if there is one or more appearance notecard in inventory the first one found will be used instead

floatyText and floatyTextColour
You can set text to display above the object or leave it blank ( "" ). The colour uses standard LSL vector values.
