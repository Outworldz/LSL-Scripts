// :CATEGORY:Weapons
// :NAME:Weapons-FF_Class_4_script_v2
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:09
// :ID:968
// :NUM:1390
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// F-F Class 4 script (v2).lsl
// :CODE:

integer z = FALSE; 
integer TRIGGER_CHANNEL = 100;
string main="hold_r_pistol";
string sound1 ="fire";
string bullet="bullet";
list weaponmain = ["Attachments","Bullet Type","More....","Credits"];
list attac = ["Laser","Back"];
list bt = ["Damage","Orbit","Back"];
list more=["Help File","Back"];
integer velocity=100;
integer sil;
integer newvel;
integer w;

stopall()
{
    llStopAnimation("hold_r_bazooka");
    llStopAnimation("hold_r_handgun");
    llStopAnimation("hold_r_rifle");
    llStopAnimation("aim_r_bazooka");
    llStopAnimation("aim_r_handgun");
    llStopAnimation("aim_r_rifle");
}
string owner;

checkown()
{
    llListenRemove(w);
    w=llListen(0,"",owner=llGetOwner(),""); 
}

default
{
    on_rez(integer c)
    {
        checkown();
        llSay(0,"For help on how to use this weapon , click me!");
    }
    state_entry()
    {
        checkown();
    }
    attach(key a)
    {
        if(a == NULL_KEY)
        {
            z=FALSE;
            llStopAnimation(main);
            llReleaseControls();
        }
        else
        {
            checkown();
            llRequestPermissions(a, PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION);
        }
    }
    run_time_permissions(integer a)
    {
        if(a > 0)
        {
            llStartAnimation(main);
            llTakeControls(CONTROL_ML_LBUTTON,TRUE, FALSE);
        }
    }
    control(key a, integer b, integer c) 
    {
        if(b & CONTROL_ML_LBUTTON)
        {
            llSleep(0.2);
            if(sil==TRUE)
                llMessageLinked(LINK_SET,0,"shotss",NULL_KEY);
            else if(sil==FALSE)
                llMessageLinked(LINK_SET,0,"shots",NULL_KEY);
        }
    }
    listen(integer c, string n, key id, string m)
    {
        if(llGetSubString(m,0,1)=="/v")
        {
            string mess=llGetSubString(m,3,-1);
            velocity-=velocity;
            velocity=(integer)mess;
            velocity/=50;
            newvel=velocity*50;
            llInstantMessage(owner,"The Velocity of your weapon is now "+(string)newvel);
        }
        else if(m=="/?v")
        {
            llSay(0,"The velocity of your weapon is currently " + (string)velocity);
        }
        else if(m=="las")
        {
            llMessageLinked(LINK_ALL_CHILDREN,0,"laser",NULL_KEY);
        }
        else if(m=="/na")
        {
            stopall();
        }
        else if(m=="/ap")
        {
            stopall();
            llStartAnimation("aim_r_handgun");
        }
        else if(m=="/hp")
        {
            stopall();
            llStartAnimation("hold_r_handgun");
            
        }
        else if(m=="/ab")
        {
            stopall();
            llStartAnimation("aim_r_bazooka");
        }
        else if(m=="/ar")
        {
            stopall();
            llStartAnimation("aim_r_rifle");
        }
        else if(m=="/hr")
        {
            stopall();
            llStartAnimation("hold_r_rifle");
        }
        else if(m=="/hb")
        {
            stopall();
            llStartAnimation("hold_r_bazooka");
        }
        
        if(m=="/r")
        {
            llResetScript();
        }
        if(m=="silencer")
        {
            sil=TRUE;
            llSay(0,"silencer on");
        }
        if(m=="silencer_off")
        {
            sil=FALSE;
            llSay(0,"silencer off");
        }
        if(m=="laser")
        {
            llMessageLinked(LINK_SET,0,"laser",NULL_KEY);
        }
        if(m=="scope")
        {
            llMessageLinked(LINK_SET,0,"scope",NULL_KEY);
        }
        if(m=="silencer")
        {
            llMessageLinked(LINK_SET,0,"sil",NULL_KEY);
        }
         if(m=="laser_off")
        {
            llMessageLinked(LINK_SET,0,"laser_off",NULL_KEY);
        }
         if(m=="scope_off")
        {
            llMessageLinked(LINK_SET,0,"scope_off",NULL_KEY);
        }
        if(m=="silencer_off")
        {
            llMessageLinked(LINK_SET,0,"sil_off",NULL_KEY);
        }
        if(m=="stock_off")
        {
            llMessageLinked(LINK_SET,0,"stock_off",NULL_KEY);
        }
        if(m=="stock")
        {
            llMessageLinked(LINK_SET,0,"stock",NULL_KEY);
        }
        if(m=="one_clip")
        {
            llMessageLinked(LINK_SET,0,"mc_off",NULL_KEY);
        }
        if(m=="muiltple_clips")
        {
            llMessageLinked(LINK_SET,0,"mc",NULL_KEY);
        }
    }
    touch_start(integer c) 
    {
        llGiveInventory(owner,"help");
    }
}

            

    // END //
