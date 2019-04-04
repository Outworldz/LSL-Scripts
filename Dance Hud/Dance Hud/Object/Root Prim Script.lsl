// :CATEGORY:Animation
// :NAME:Dance Hud
// :AUTHOR:unknown
// :REV:1.0
// :WORLD:Second Life, Opensim
// :DESCRIPTION:
// Dance Hud. Add animations to this and wear it as a HUD
// :CODE:

// To build this, make a small prim. Add Button sized prims for Stop, Next and Previous. Put the scripts in the Buttons.
// Put the Root Prim script in the main body.
// Select the three buttons and select the root prim last,. and link them
// Add animations to the root and wear it as a HUD.

list dances;
integer activedance = 0;
integer lastdance = 0;
integer total = 0;
integer perms = 0;
integer interval = 60;
integer timercount = 60;
integer active = FALSE;
integer paused = FALSE;
string title = "Modern";

getDances()
{
    integer i = 0;
    for (i = 0; i < 100; i++) {
        string dance = llGetInventoryName(INVENTORY_ANIMATION, i);
        if (dance != "") {
            dances += [dance];
        } else {
            i = 100;
        }
    }
}

stopAllAnims()
{
    if (llGetPermissions() & PERMISSION_TRIGGER_ANIMATION)
    {
        list anims = llGetAnimationList(llGetPermissionsKey());
        integer len = llGetListLength(anims);
        integer i = 0;
        for (i=0; i<len; ++i) {
            llStopAnimation(llList2Key(anims, i));
        }
        llStartAnimation("stand");
    }
}

startDance()
{
    perms = llGetPermissions();
    if (perms & PERMISSION_TRIGGER_ANIMATION)
    {
        llStartAnimation(llList2String(dances, activedance));
        llStopAnimation(llList2String(dances, activedance - 1));
    }
}

showStatus()
{
    if (active) {
        if (!paused) {
            llSetText(title + "\n" +
                    "Dancing the " + llList2String(dances, activedance) + "\n" + 
                    "Seconds remaining: " + (string)timercount, <1,1,1>, 1);
        } else {
            llSetText(title + "\n" +
                    "Dancing the " + llList2String(dances, activedance) + "\n" + 
                    "Seconds remaing: Paused!", <1,1,1>, 1);
        }
    } else {
        llSetText(title + "\n" + 
                "Currently Off", <1,1,1>, 1);
    }
}
default
{
    state_entry()
    {
        llOwnerSay("Dance HUD loading...");
        getDances();
        total = llGetListLength(dances) - 1;
        llOwnerSay("Dances found: " + (string)(total + 1));
        llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
        llSetTimerEvent(1.0);
        llMessageLinked(LINK_ALL_OTHERS, 0, "dpauseoff", NULL_KEY);
        llListen(0, "", llGetOwner(), "");
        showStatus();
    }

    on_rez(integer sparam)
    {
        llResetScript();
    }
    
    attach(key attached)
    {
        if (attached) {
            llResetScript();
        } else {
            if (active != FALSE) { stopAllAnims(); }
            llResetScript();
            
        }
    }
    
    timer()
    {
        {
            if (active == TRUE)
            {
                --timercount;
                if (timercount == 0) {
                    activedance++;
                    if (activedance > total)
                    {
                        activedance = 0;
                    }
                    startDance();
                    showStatus();
                    timercount = interval;
                } else {
                    showStatus();
                }
                
            }
        }
    }
    
    link_message(integer sender_num, integer num, string message, key id)
    {
        if (id == NULL_KEY)
        {
            if (message == "doff")
            {
                active = FALSE;
                stopAllAnims();
                timercount = interval;
                paused = FALSE;
                llMessageLinked(LINK_ALL_OTHERS, 0, "dpauseoff", NULL_KEY);
                showStatus();
            } else if (active == FALSE && message == "don")
            {
                if (!(perms & PERMISSION_TRIGGER_ANIMATION))
                {
                    llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
                }
                llSetTimerEvent(1.0);
                showStatus();
                startDance();
                active = TRUE;
            } else if ((active == TRUE) && (message == "dnext")) {
                activedance++;
                    if (activedance > total)
                    {
                        activedance = 0;
                    }
                    timercount = interval;
                    startDance();
                    showStatus();
            } else if ((active == TRUE) && (message == "dprev")) {
                activedance--;
                    if (activedance < 0)
                    {
                        activedance = total;
                    }
                timercount = interval;
                startDance();
                showStatus();
            } else if ((active == TRUE) && (message == "dpause")) {
                if (paused) {
                    llMessageLinked(LINK_ALL_OTHERS, 0, "dpauseoff", NULL_KEY);
                    llSetTimerEvent(1.0);
                    paused = FALSE;
                } else {
                    llMessageLinked(LINK_ALL_OTHERS, 0, "dpauseon", NULL_KEY);
                    llSetTimerEvent(0.0);
                    paused = TRUE;
                    showStatus();
                }
            }
        }
    }
}
