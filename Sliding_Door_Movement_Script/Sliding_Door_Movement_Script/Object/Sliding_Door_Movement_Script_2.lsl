// :CATEGORY:Door
// :NAME:Sliding_Door_Movement_Script
// :AUTHOR:John Linden
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:04
// :ID:796
// :NUM:1106
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Put this in aprim and touch it to open and close the remote door// // Commands:// // admit [name] -- grants access// ban [name] -- revokes access
// list -- shows admit/ban lists
// forget [name] -- removes from admit and ban lists
// default admit -- anyone not specifically banned is admitted
// default ban -- anyone not specifically admitted is banned"
// :CODE:
// Door Lock Script -- JohnG Linden

// To make this script open/close an actual door, the door should listen
// for the following messages on the following chat channel.  One lock 
// can control multiple doors if they all listen on the same channel.
//
// It is advisable for you to pick your own channel number so other locks 
// in the area don't inadvertently open/close your door.
//
integer gLockChannel = 100;
string  gOpenMsg = "MSG_OPEN";
string  gCloseMsg = "MSG_CLOSE";
//
// Final note: if you need to open doors a long way from the lock, look
// for the functions door_open_msg() and door_close_msg() below, and 
// change the llSay() to llShout().

// who owns this door
// this is changed by on_rez to whoever rezzed the door
string gAdministrator = "";

// who's in and who's out
// can be changed by the admin at runtime
list gAdmittedList =
[
];
list gBannedList = 
[
];

// return values from permissions funcs
integer PERM_BANNED = -1;
integer PERM_NO = 0;
integer PERM_ADMIN = 1;
integer PERM_OK = 2;

// permission given to people not on any list
// if you just want to exclude people on the banned list and admit 
// everyone else, set to PERM_OK
integer gDefaultPerm = PERM_NO;

// Note: this all would be much easier with lists that can contain lists,
// as people could have multiple properties hanging on them.  Currently
// it's better than arrays but is still somewhat broken, because you have
// to assume a # of data fields instead of being able to traverse a list
// of lists.
  
// 
// Helper functions here
//

func_debug(string str)
{
    llSay(0, str);
}
debug(string str)
{
    llSay(0, str);
}
say(string str)
{
    llSay(0, str);
}

// is name on admitted list?
integer check_admitted_list (string name)
{
    if ( llListFindList(gAdmittedList, [name]) >= 0 )
    {
        return TRUE;
    } else
    {
        return FALSE;
    }
}

// is name on banned list?
integer check_banned_list (string name)
{
    if ( llListFindList(gBannedList, [name]) >= 0 )
    {
        return TRUE;
    } else
    {
        return FALSE;
    }
}

// does name have perms to open the door?
integer check_permission (string name)
{
    say("check_permission: " + name);
    // admin always wins (and cannot ban themselves)
    if ( name == gAdministrator ) return PERM_ADMIN;
    // now check the plebeians
    if ( check_banned_list(name) == TRUE ) return PERM_BANNED;
    if ( check_admitted_list(name) == TRUE ) return PERM_OK;
    // not on any lists, check default
    return gDefaultPerm;
}

add_to_admitted_list (string name)
{
    func_debug("add_to_admitted_list");
        
    gAdmittedList = gAdmittedList + name;
}

add_to_banned_list (string name)
{
    func_debug("add_to_banned_list");

    gBannedList = gBannedList + name;
}

integer remove_from_admitted_list (string name)
{
    func_debug("remove_from_admitted_list");

    list    lyst;
    
    debug("admit: looking for " + name);
    
    // search and destroy
    integer index = llListFindList(gAdmittedList, [name]);
    if ( index >= 0 )
    {
        debug("admit: found " + name);
        
        // remove entry
        gAdmittedList = llDeleteSubList(gAdmittedList, index, index);
        return TRUE;
    }
    
    // couldn't find
    debug("admit: can't find " + name);
    return FALSE;
}

integer remove_from_banned_list (string name)
{
    func_debug("remove_from_banned_list");

    list    lyst;
    
    debug("ban: looking for " + name);
    
    // search and destroy
    integer index = llListFindList(gBannedList, [name]);
    if ( index >= 0 )
    {
        debug("ban: found " + name);
        
        // remove entry
        gBannedList = llDeleteSubList(gBannedList, index, index);
        return TRUE;
    }
    
    // couldn't find
    debug("ban: can't find " + name);
    return FALSE;
}

show_list (list src)
{
    integer i;
    integer len = llGetListLength(src);
    
    for ( i = 0; i < len; ++i )
    {
        say(llList2String(src, i));
    }
}

show_admitted_list ()
{
    say("Admitted avatars:");
    show_list (gAdmittedList);
}

show_banned_list ()
{
    say("Banned avatars:");
    show_list (gBannedList);
}

// parses incoming messages and does dirty work accordingly
parse_and_handle_message (string message)
{
        func_debug("parse_and_handle_message");
        
        string  name;
        
        // we only listen to admin, so no user check here
        if ( "ban " == llGetSubString(message, 0, 3) )
        {
            name = llGetSubString(message, 4, -1);
            if ( name != gAdministrator )
            {
                // note: no check for validity of usernames
                add_to_banned_list (name);
                remove_from_admitted_list (name);
                say(name + " has been banned.");
            } else
            {
                // error
                say("You cannot ban yourself, Master.");
            }
        } 
        else if ( "admit " == llGetSubString(message, 0, 5) )
        {
            name = llGetSubString(message, 6, -1);
            if ( name != gAdministrator )
            {
                add_to_admitted_list (name);
                remove_from_banned_list (name);
                say(name + " will now be admitted.");
            } else
            {
                // error
                say("You are already admitted, Master.");
            }
        } 
        else if ( "forget " == llGetSubString(message, 0, 6) )
        {
            name = llGetSubString(message, 7, -1);
            // remove user from ban and admit lists
            if ( remove_from_banned_list(name) )
            {
                say(name + "'s ban has been revoked.");
                if ( gDefaultPerm == PERM_NO )
                {
                    say("But the current default permissions still do not allow them");
                    say("to open this door.");
                }
            }
            if ( remove_from_admitted_list(name) )
            {
                say(name + "'s access has been revoked.");
                if ( gDefaultPerm == PERM_OK )
                {
                    say("But the current default permissions still allow them");
                    say("to open this door.");
                }
            }
        }
        else if ( "list" == llGetSubString(message, 0, 3) )
        {
            say("Administrator: " + gAdministrator);
            show_admitted_list();
            show_banned_list();
            if ( gDefaultPerm == PERM_NO )
            {
                say("Anyone not specifically admitted is denied entry.");
            } else
            {
                say("Anyone not specifically banned is allowed entry.");
            }
            say("Type 'help' for full command list.");
        }
        else if ( "default admit" == llGetSubString(message, 0, 12) )
        {
            say("Anyone not specifically banned is now allowed entry.");
            gDefaultPerm = PERM_OK;
        }
        else if ( "default ban" == llGetSubString(message, 0, 10) )
        {
            say("Anyone not specifically admitted is now denied entry.");
            gDefaultPerm = PERM_NO;
        }
        else if ( "help" == llGetSubString(message, 0, 3) )
        {
            // list of commands
            say("Command List:");
            say("admit [name] -- grants access");
            say("ban [name] -- revokes access");
            say("list -- shows admit/ban lists");
            say("forget [name] -- removes from admit and ban lists");
            say("default admit -- anyone not specifically banned is admitted");
            say("default ban -- anyone not specifically admitted is banned");
            say("help -- this text");
        }
}

// send messages to actual door
door_open_msg()
{
    llSay(gLockChannel, gOpenMsg);
}
door_close_msg()
{
    llSay(gLockChannel, gCloseMsg);
}

//
// States
//

default
{
    on_rez(integer param) { llResetScript(); }

    state_entry()
    {
        func_debug("default state_entry");
        // set the owner to administrator
        string owner = llKey2Name(llGetOwner());
        if ( owner == "" )
        {
            say("FATAL ERROR: no owner!");
        }
        gAdministrator = owner;
        say("Door Admin: " + owner);
        // listen for the administrator
        llListen(0, owner, "", "");
        // door starts out closed
        state closed_state;
    }
    
    state_exit()
    {
    }
}

state closed_state
{
    on_rez(integer param) { llResetScript(); }

    state_entry()
    {
        func_debug("closed_state state_entry");
        llPlaySound("lock_close", 0.7);
        // tell door to close
        door_close_msg();
    }
    
    touch_start(integer num_touches)
    {
        func_debug("closed_state touch_start");
        //  currently we only address the first touch, if multiple
        integer i = 0;
        // who touched us?
        string  name = llDetectedName(i);
        // can they open the door?
        integer perm = check_permission(name);
        if ( perm == PERM_ADMIN )
        {
            // Yes, master.  I'd like a call to determine gender so
            // I can say "mistress" when appropriate
            say("Door opened, Master.");
            state open_state;
        } else if ( perm == PERM_OK )
        {
            // yep
            say("Door opened for " + name);
            state open_state;
        } else if ( perm == PERM_BANNED )
        {
            // specifically denied
            say(name + " is specifically prohibited from opening this door.");
        } else
        {
            say(name + " is not permitted to open this door.");
        }
    }

    listen(integer channel, string name, key id, string message)
    {
        func_debug("closed_state listen");
        // note: we don't check name because we only listen to our admin
        parse_and_handle_message (message);
    }
    
    state_exit()
    {
    }
}

state open_state
{
    on_rez(integer param) { llResetScript(); }

    state_entry()
    {
        func_debug("open_state state_entry");
        llPlaySound("lock_open", 0.7);
        // tell door to open
        door_open_msg();
    }

    touch_start(integer num_touches)
    {
        func_debug("open_state touch_start");
        //  currently we only address the first touch, if multiple
        integer i = 0;
        // who touched us?
        string  name = llDetectedName(i);
        // can they open the door?
        integer perm = check_permission(name);
        if ( perm == PERM_ADMIN )
        {
            // Yes, master.  I'd like a call to determine gender so
            // I can say "mistress" when appropriate
            say("Door closed, Master.");
            state closed_state;
        } else if ( perm == PERM_OK )
        {
            // yep
            say("Door closed for " + name);
            state closed_state;
        } else if ( perm == PERM_BANNED )
        {
            // specifically denied
            say(name + " is specifically prohibited from closing this door.");
        } else
        {
            say(name + " is not permitted to close this door.");
        }
    }

    listen(integer channel, string name, key id, string message)
    {
        func_debug("open_state listen");
        // note: we don't check name because we only listen to our admin
        parse_and_handle_message (message);
    }
    
    state_exit()
    {
    }
}
