// :SHOW:
// :CATEGORY:Flying NPC's
// :NAME:Opensim Waypoint Recorder and Display
// :AUTHOR:De Asanta
// :KEYWORDS:
// :CREATED:2015-03-17 10:28:43
// :EDITED:2015-03-17  09:28:43
// :ID:1074
// :NUM:1734
// :REV:1
// :WORLD:OpenSim
// :DESCRIPTION:
// Waypoints
// :CODE:
//:Category:Movement
//:Description:
// Records, Store, Draw, and Return Waypoints that can be used for moving objects or NPCs.
// A basic waypoint recorder for scripters to assist them in recording in game waypoints that can can be used in other scripts.
// Feel free to use / modify to suit your needs.
// License: CC-0
//:World:Opensim
// From https://sites.google.com/site/dsopensim/inworldtoolkit/waypoint-recorder
// A very useful recorder that displays the waypoints on the prim surface in Opensim Onle

list wp;
integer screen;

AddWaypoint(vector a)
{
    wp=wp+a;
}

ClearWaypoints()
{
    wp=[];
}

DrawWaypoints()
{
    string CommandList = "";
    integer a;
    vector b;
    
    CommandList = osSetPenColor(CommandList, "White");
    CommandList = osSetPenSize(CommandList, 2);

        for(a=0;a<llGetListLength(wp);a++)
    {
        b=llList2Vector(wp,a);
        CommandList = osMovePen( CommandList, (integer)b.x, (integer)b.y );
        CommandList = osDrawText( CommandList, (string)a );
        if(a>0) { b=llList2Vector(wp,a-1); }
        CommandList = osDrawLine(CommandList,(integer)b.x, (integer)b.y);
        
    }

    osSetDynamicTextureDataBlendFace( "", "vector", CommandList, "bgcolour:Black,width:256,height:256", 0, 2 , 0, 0, 0);
}

SayWaypoints()
{
    string text="";
    string CommandList = "";
    integer a;
    vector b;
    
    for(a=0;a<llGetListLength(wp);a++)
    {
        b=llList2Vector(wp,a);
        text=text+(string)b;
        if(a<llGetListLength(wp)-1) { text=text+","; }
    }
    llSay(0,"list wp=["+text+"];");
}

RemoveWaypoint()
{
    integer a;
    list b;

    for(a=0;a<llGetListLength(wp);a++)
    {
        b=b+llList2Vector(wp,a);
    }
    wp=b;
}

UpdateScreen()
{ 
    string CommandList = "";
    CommandList = osSetPenColor(CommandList, "Black");
    CommandList = osMovePen( CommandList, 3,3 );
    CommandList = osDrawRectangle( CommandList, 249, 249 );
    CommandList = osSetFontSize(CommandList, 8);
    CommandList = osMovePen( CommandList, 8,8 );

    if(screen==0)
    {
        string text = "say any of the following:\n/99 help - to show this screen\n/99 1 - to clear all waypoints\n/99 2 - to add a waypoint\n/99 3 - to remove last waypoint\n/99 4 - Draw Waypoints\n/99 5 - Say Waypoints";
        CommandList = osDrawText( CommandList, text );
    }
    
    osSetDynamicTextureDataBlendFace( "", "vector", CommandList, "bgcolour:White,width:256,height:256", 0, 2 , 0, 0, 0);
}


default
{
    state_entry()
    {
        screen=0;
        UpdateScreen();
        ClearWaypoints();
        llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
        llListen(99,"","","");
    }
    
    listen(integer ch, string name, key id, string message)
    {
        if (message=="1")
        {
            ClearWaypoints();
        }
        if (message=="2")
        {
            AddWaypoint(llGetPos());
        }
        if (message=="3")
        {
            ClearWaypoints();
        }
        if (message=="4")
        {
            DrawWaypoints();
        }
        if (message=="5")
        {
            SayWaypoints();
        }
        if (message=="help")
        {
            screen=0;
            UpdateScreen();
        }
    }
    
    run_time_permissions(integer perm)
    {
        if(perm)
        {
             llStartAnimation("hold");
        }
    }
    
    dataserver(key id, string message)
    {
        //processReceived( id, message);
    }
    
    on_rez(integer start_param)
    {
        llResetScript();
    }
    
    changed(integer change)
    {
        if (change & CHANGED_OWNER) 
        {
            llResetScript();
        }
        if (change & CHANGED_REGION) 
        {
           llResetScript();
        }
        if (change & CHANGED_REGION_START) 
        {
            llResetScript();
        }
    }
    
    attach(key id)
    {
        if (id)     // is a valid key and not NULL_KEY
        {
            llResetScript();
        }
    }
}
