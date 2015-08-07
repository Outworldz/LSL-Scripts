// :CATEGORY:Animation
// :NAME:Dance_Pole__Av_Mover
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:51
// :ID:211
// :NUM:285
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Dance Pole + Av Mover.lsl
// :CODE:

integer HIDE = FALSE; //If set to true, it will make the prim invisible when someone is on it (for use with poseballs)

integer CHANNEL; //channel for script to communicate on (generated radomly below)

vector Angle = <0,0,0>; 
string LoadText = "Ready"; 
string Context = "Dance";

integer LISTENER; //listener placeholder to kill active listens

key AVATAR; //this will be set to the person sitting on the prim

vector POS = <0.2,-0,-0.6>;//This is the initial sit target point.

list ANIM_MENU;
list REF_MENU;
integer COUNT = 1;
//---- Global variables are in all caps, local variables are all lowercase, do not try to use local variables out of context. ----//

Stop_All_Animations(key avatar) //this will be called below to stop the animations playing on an avatar, before animating them with your animations.
{
    list animations = llGetAnimationList(avatar);//Make a list of all the animations they are currently playing
    integer i;
    for(i = 0; i < llGetListLength(animations); ++i)//Set up a loop
    {
        llStopAnimation(llList2Key(animations, i));//Stop all the animations
    }
}

PresentMenu()
{
    integer num = llGetInventoryNumber(INVENTORY_ANIMATION);
    if(num <= 11)
    {
        ANIM_MENU = ["Move Av"];
        REF_MENU = ["Move Av"];
        integer i;
        for(i = 0; i < num; ++i)
        {
            string name = llGetInventoryName(INVENTORY_ANIMATION, i);
            if(name != "")
            {
                ANIM_MENU += name;
                integer x = llStringLength(name);
                if(x > 12)
                {
                    name = llGetSubString(name, x - 10, x - 1);
                }
                REF_MENU += name;
            }
        }
    }
    else
    {
        ANIM_MENU = ["Previous", "Move Av", "Next"];  
        REF_MENU = ["Previous", "Move Av", "Next"];      
        integer start = (COUNT * 9) - 9;
        integer stop = (COUNT * 9) - 1;
        integer i;
        for(i = start; i <= stop; ++i)
        {
            string name = llGetInventoryName(INVENTORY_ANIMATION, i);
            if(name != "")
            {
                ANIM_MENU += name;
                integer x = llStringLength(name);
                if(x > 12)
                {
                    name = llGetSubString(name, x - 10, x - 1);
                }
                REF_MENU += name;
            }
        }
    }
    llSetTimerEvent(600); //Set up a timer to kill the listen if no response is received
    CHANNEL = (integer)llFrand((2147283648) + 100000) * -1; //pick a random negative channel to communicate on
    LISTENER = llListen(CHANNEL, "", llDetectedKey(0), "");//open  a listen
    llDialog(llAvatarOnSitTarget(), "Please choose an option", REF_MENU, CHANNEL);
}
    

default
{
    
    state_entry()//State entry occurs whenever a script is reset, or when you make changes and save it.
    {
        llSitTarget(POS, ZERO_ROTATION);//set the point where the person will sit. 
    }
    changed(integer change)//if something changed
    {
        if(change & CHANGED_LINK)//if the something was a link change (when an avatar sits on an object, they link to it)
        {
            if(llAvatarOnSitTarget() != NULL_KEY)//if someone is on me
            {
                AVATAR = llAvatarOnSitTarget();//Set the global variable to their key for use elsewhere.
                if(HIDE)//if the hide feature is set to true
                {
                    llSetAlpha(0.0, ALL_SIDES);//Make this prim invisible
                }
                llRequestPermissions(AVATAR, PERMISSION_TRIGGER_ANIMATION);//ask for permission to animate them (it's granted automatically if they are sitting on this, but still needs to be called for it to work.)
            }
            else//if something changed and noone is sitting on me
            {
                Stop_All_Animations(AVATAR);//call the stop all aniamtions function.
                llSetAlpha(1.0, ALL_SIDES);//make this prim visible
            }            
        }        
    }
    
    run_time_permissions(integer perm)//if we have permission to do something
    {
        if (perm & PERMISSION_TRIGGER_ANIMATION)//and that permisson is to animate them
        {
            Stop_All_Animations(AVATAR);//call the stop all aniamtions function.
            string animation = llGetInventoryName(INVENTORY_ANIMATION, 0);//find the first animation in my inventory
            llStartAnimation(animation);//animate them with it.
        }
    }
    
    touch_start(integer x)//when someone touches the object containing this script.
    {
        if(llDetectedKey(0) == llAvatarOnSitTarget()) //if the persosn touching this is sitting on the object
        {
            PresentMenu();
        }
    }
    
    timer()// If they ran out of time before making a selection.
    {
        llListenRemove(LISTENER); //remove the listener
        llSetTimerEvent(0); //set listen remove timer back to off
    }
        
    
    listen(integer ch, string name, key id, string msg)//When a response is received
    {
        llListenRemove(LISTENER); //remove the listener
        llSetTimerEvent(0); //set listen remove timer back to off
        if(msg == "Move Av")
        {
            llSetTimerEvent(600); //Set up a timer to kill the listen if no response is received
            LISTENER = llListen(9, "", id, "");//open  a listen
            llInstantMessage(id, "Please type the amount to move in this format  Front/Back, Left/Right, Up/Down   on channel 9. For example to move your avatar down 0.25m type  /9 0,0,-0.25");
            return;
        }
        else if(msg == "Next")
        {
            float MAX = llGetInventoryNumber(INVENTORY_ANIMATION);
            MAX = MAX / 9.0;
            integer MAXIMUM = llCeil(MAX);
            ++COUNT;
            if(COUNT > MAXIMUM)
            {
                COUNT = 1;
            }
            PresentMenu();
        }
        else if(msg == "Previous")
        {
            if(COUNT > 1)
            {
                --COUNT;
            }
            else
            {
                float MAX = llGetInventoryNumber(INVENTORY_TEXTURE);
                MAX = MAX / 10.0;
                integer MAXIMUM = llCeil(MAX);
                COUNT = MAXIMUM;
            }
            PresentMenu();
        }
        else if(ch == 9)
        {
            msg = "<"+msg+">";
            POS += (vector)msg;
            llSetLinkPrimitiveParams(2, [PRIM_POSITION, POS]);
            return;
        }
        else if(PERMISSION_TRIGGER_ANIMATION && id == llAvatarOnSitTarget())//if we have permisson is to animate them, and they are still sitting on this.
        {
            Stop_All_Animations(id);
            integer pos = llListFindList(REF_MENU, [msg]);
            msg = llList2String(ANIM_MENU, pos);
            llStartAnimation(msg);
        }
        else//if we don't have permission to animate them
        {
            if(llAvatarOnSitTarget() != NULL_KEY)//if someone is on me
            {
                llRequestPermissions(llAvatarOnSitTarget(), PERMISSION_TRIGGER_ANIMATION);//request permission to animate them
            }
        }        
    }
}
// END //
