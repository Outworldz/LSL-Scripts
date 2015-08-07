// :CATEGORY:Animation
// :NAME:Nyterave_Anim8_Ball_2
// :AUTHOR:Sitting Lightcloud
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:58
// :ID:577
// :NUM:790
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Nyterave Anim8 Ball 2.lsl
// :CODE:

//*****************************************
//*     Nyterave animation ball script!   *
//*           FREE TO USE V2.1            * 
//*        by Sitting Lightcloud          *
//******************************************/

// * * * * * * * MODIFY BELOW * * * * * * *//


// position to sit on the ball e.g <0.0, 0.00, 0.95>
// sit  0.5 meter above the ball
vector POSITION=<0.0, 0.00, -0.5>;

// hovertext above ball. "" for none.
// add '\n ' at the end to move text up i.e.
// string HOVERTEXT="Sit Here\n ";
string HOVERTEXT="Sit Here";

// Pie Menu Sit Text. Will only work for the
// main prim but included it anyway. If no text
// is entered between "" it won't be used.
string SIT_TEXT="";


// hovertext color 'r,g,b' e.g. "255,255,255" (white)
string HOVER_RGB="255,255,255";

// LISTEN sets if this ball should listen for voice commands
// or not. You only need to enable this for 1 ball if you
// link several balls to an object. (to reduce lagg).
// Change to TRUE to enable FALSE to disable. 
integer LISTEN=FALSE;

// What channel to listen for hide/show on. If you want to
// listen to normal conversation (hide/show), set channel
// to 0 otherwise the command will be /channel hide, show 
integer CHANNEL=9;

// * * * * * * * STOP MODIFY * * * * * * * *//




set_text()
{
       if (llStringLength(HOVERTEXT)>0)
        {
            rgb=llCSV2List(HOVER_RGB);
            llSetText(HOVERTEXT,<llList2Float(rgb,0)*0.003921568627450980392156862745098,llList2Float(rgb,1)*0.003921568627450980392156862745098,llList2Float(rgb,2)*0.003921568627450980392156862745098>,1.0);
            
        }    
        else
           llSetText("",<0,0,0>,0.0);     
}
start_listen()
{
    llListenRemove(listener);
    if (LISTEN==TRUE)
        listener=llListen(CHANNEL,"","","");
}
hide_me()
{
    llSetAlpha(0.0, ALL_SIDES);
    llSetText("",<0,0,0>,0.0);     
}
show_me()
{
    llSetAlpha(1.0, ALL_SIDES);
    set_text();                
}
list rgb;
string animation;
integer listener;
default 
{
    state_entry() 
    {
        if (llStringLength(SIT_TEXT)>0)
            llSetSitText(SIT_TEXT);
        llSitTarget(POSITION, ZERO_ROTATION); 
        set_text();
        start_listen();
    }
    
    on_rez(integer r)
    {
        start_listen();
    }
    
    listen(integer channel, string name, key id, string msg)  
    {
        if (msg=="hide")
        {
            hide_me();
            llMessageLinked(LINK_SET,0,"hide", NULL_KEY);
        }
        else if (msg=="show")
        {
            show_me();
            llMessageLinked(LINK_SET,0,"show", NULL_KEY);
        }
    }
    
    changed(integer change) 
    { 
        if (change & CHANGED_LINK) 
        {
            
            if (llAvatarOnSitTarget() != NULL_KEY) 
            { 
                llRequestPermissions(llAvatarOnSitTarget(), PERMISSION_TRIGGER_ANIMATION);
            }
            else
            {
                integer perm=llGetPermissions();
                if ((perm & PERMISSION_TRIGGER_ANIMATION) && llStringLength(animation)>0)       
                llStopAnimation(animation);
                llSetAlpha(1.0, ALL_SIDES);
                set_text();
                animation="";
            }
        }
    }
    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_TRIGGER_ANIMATION)
        {
                llStopAnimation("sit");
                animation=llGetInventoryName(INVENTORY_ANIMATION,0);
                llStartAnimation(animation);
                llSetAlpha(0.0, ALL_SIDES);
                llSetText("",<0,0,0>,0.0);
        }
    }

    link_message(integer sender_num, integer num, string str, key id)
    {
        if (str=="hide")
        {
            hide_me();
        }
        else if (str=="show")
        {
            show_me();
        }
    }
}// END //
