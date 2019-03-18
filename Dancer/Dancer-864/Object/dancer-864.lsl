// :CATEGORY:Dance
// :NAME:Dancer
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:51
// :ID:214
// :NUM:289
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Dance Server
// :CODE:

// Open source do with as you want license by Fred Beckhusen (Ferd Frederix)

// plays a random bunch of animations that are located in the prim inventory when it is attached or rezzed.

integer INTERVAL = 30; // how many seconds to play each dance, randomly

// just some constants, nothing here. Move on.
list dances;
integer WHICH; // which dance
integer TOTAL;    // how many dances
integer PERMS;    // current permissions
integer STATE;        // off if flase, 1 = next dance, 2 = random
integer listener;    // the current listener, so we can remove it.
integer counter;     // counter for timer to auto stop listeners;

// pop up a dialog boz

dialog()
{
    llListenRemove(listener);
    integer channel = llCeil(llFrand(1000)+100 * -1);
    listener =  llListen(channel,"","","");
    llDialog(llGetOwner(),"Choose",["Next Dance","Stop Dance","Random"], channel);
}

default
{
    state_entry()
    {
        // load up the current animation inventory into a list
        integer i;
        integer j = llGetInventoryNumber(INVENTORY_ANIMATION);
        for (i = 0; i < j; i++)
        {
            dances += llGetInventoryName(INVENTORY_ANIMATION,i);    // add to a list
            TOTAL++;
        }
        STATE = 1;    // dance sequentially

        llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
        dialog();
    }

    // was rezzed or attached, start over
    on_rez(integer param)
    {
        llResetScript();
    }

    // someone added or deleted an animation. Start over and ake a new list and
    changed(integer what)
    {
        if (what & CHANGED_INVENTORY)
            llResetScript();
    }
    
    timer()
    {
        // since they may hit ignore on the dialog, we count two passes at rthe timer, then kill off any listener.
        if (listener)
            counter++;
        if (counter)
            llListenRemove(listener);    // remove the listener after two passes to help with lag

        // now lets see what to do
        PERMS = llGetPermissions();
        if (PERMS & PERMISSION_TRIGGER_ANIMATION)
        {
            
            if (STATE == 1)    // sequential play
            {
                llStopAnimation(llList2String(dances, WHICH));        // quit the current 
                WHICH++;
                if (WHICH >= TOTAL)
                {
                    WHICH = 0;
                }
                llStartAnimation(llList2String(dances, WHICH));       // start next one.
                llOwnerSay("Dance:" + llList2String(dances, WHICH));       
            }
            else if (STATE == 2)    // random play
            {
                llStopAnimation(llList2String(dances, WHICH));
                WHICH = llCeil(llFrand(TOTAL))-1;
                llStartAnimation(llList2String(dances, WHICH));
                llOwnerSay("Dance:" + llList2String(dances, WHICH));
            }
            llSetTimerEvent(INTERVAL);
        }
        else
        {
            // dang, no permissions, oh well, ask for them
            llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
        }
    }
    
    
    listen(integer channel, string name, key id, string message)
    {
        llListenRemove(listener);    // save lag
        PERMS = llGetPermissions();

        if (message == "Stop Dance")
        {
            STATE = FALSE;
            if (PERMS & PERMISSION_TRIGGER_ANIMATION)
            {
                llStopAnimation(llList2String(dances, WHICH));
            }
            llSetTimerEvent(0);        // shit it all down
        }
        else if (message == "Next Dance")
        {
            if (!(PERMS & PERMISSION_TRIGGER_ANIMATION))
            {
                llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
            }
            STATE = 1;    // flag ithis as sequential
        }
        else if ( message == "Random")
        {
            if (!(PERMS & PERMISSION_TRIGGER_ANIMATION))
            {
                llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
            }
            STATE = 2; // flag this as random
        }
    }

    touch_start(integer who)
    {
        if (llDetectedKey(0) == llGetOwner())        // only the owner can do this as we can control only one avatar at a time
        {
            dialog();
        }
    }
    
    run_time_permissions(integer perm)
    {
        PERMS = perm;
        llSetTimerEvent(1.0);    // trigger the logic in one second
    }

}
// END //

