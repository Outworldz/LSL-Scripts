// rezzer & controller

integer startup = 0x050;    // 10 meters, color 0
integer counter = 0;
integer selected = 0;
float range = 20;           // sensor range
integer distance = 5;       // roaming range
integer timetick = 5;
integer listener;
integer wanted;
integer asensor = FALSE;
integer on_off;
integer bcolor = 0;
integer color = -1; // =1 = all
integer height = 1;

Rez()
{
    if (color == -1)
    {
        bcolor++;
        if (bcolor > 9)
            bcolor = 0;
    }
    else
        bcolor = color;
        
    startup = (height << 16) + (distance << 4) + bcolor;
    
    //llOwnerSay("Distance:" + (string) distance);
    //llOwnerSay("Color:" + (string) color);
    
    llRezObject(llGetInventoryName(INVENTORY_OBJECT,0), llGetPos() + <0.0,0.0,0.5>, <0.0,0.0,0.0>, <0.0,0.0,0.0,1.0>, startup);
}

MakeMenu()
{
    integer channel = llCeil(llFrand(1000) + 9000);
    string msg = "Select an item:\nOn|Off - enable or disable\nSensor = Only run when Avatars are in range\nDistance  - Set roaming and range\nMore - Increase the number of butterflies\nLess - decrease the number of butterflies\nColor - pick a color\nHeight - How hi they fly";
    list menu = ["Off","Sensor Off","Less","On","Sensor On","More","Distance","Color","Height"];
    listener = llListen(channel,"","","");
    llDialog(llGetOwner(),msg,menu,channel);
    
}

 
MenuDistance(string msg)
{
    integer channel = llCeil(llFrand(1000) + 9000);
    list menu = ["1","5","10","15","20","25","30","45","96"];
    listener = llListen(channel,"","","");
    llDialog(llGetOwner(),msg,menu,channel);
}

MenuColor(string msg)
{
    integer channel = llCeil(llFrand(1000) + 9000);
    list menu = ["0","1","2","3","4","5","6","7","8","9","All"];
    listener = llListen(channel,"","","");
    llDialog(llGetOwner(),msg,menu,channel);
}

MenuHeight(string msg)
{
    integer channel = llCeil(llFrand(1000) + 9000);
    list menu = ["0","1","2","3","4","5","6","7","8","9","10","15"];
    listener = llListen(channel,"","","");
    llDialog(llGetOwner(),msg,menu,channel);
}

default
{
    
    listen(integer channel,string name,key id, string msg)
    {
        
        llListenRemove(listener);
        if (msg == "On")
        {
            llSetTimerEvent(1.0);
            on_off= TRUE;
            llSetAlpha(0,ALL_SIDES);
        }
        else if (msg == "Off")
        {
            llSetTimerEvent(0);
            on_off= FALSE;
            llSensorRemove();
            llOwnerSay("Butterflies are stopped");
            llSetAlpha(1,ALL_SIDES);
        }
        else if (msg == "Sensor On")
        {
            llSetTimerEvent(0);
            wanted = 1;
            MenuDistance("Pick how far to detect avatars");            
        }
        else if (msg == "Sensor Off")
        {
            MakeMenu();
            llSensorRemove();
            llOwnerSay("Butterflies are stopped");
            asensor = FALSE;
            llSetAlpha(1,ALL_SIDES);
        }
        else if (msg == "Distance")
        {
            wanted = 2;
            MenuDistance("Pick the distance that the butterflies will roam");
        }
        else if (msg == "Color")
        {
            wanted = 3;
            MenuColor("Pick a color number");
        }
        else if (msg == "Height")
        {
            wanted = 4;
            MenuHeight("Pick a maximum height for flight");
        }
        else if (msg == "More")
        {
            timetick -=1;
            if (timetick <= 0)
                timetick = 1; 
            integer count = llCeil(60/timetick);
            llOwnerSay((string) count + " butterflies");;
            MakeMenu();
        }
        else if (msg == "Less")
        {
            timetick +=1;
            integer count = (integer) (60/timetick);
            llOwnerSay((string) count + " butterflies");
            MakeMenu();
        }
        else
        {
            if (wanted == 4 )
            {
                height = (integer) msg;
                llOwnerSay("Butterfly height is " + (string) height+ " meters");
                MakeMenu();
            }
            if (wanted == 3 )
            {
                if (msg == "All")
                {
                    color = -1;
                    llOwnerSay("Butterfly color is is all colors");
                }
                else
                {
                    color = (integer) msg;
                    llOwnerSay("Butterfly color is is " + (string) color );
                }
                
                MakeMenu();
            }
            if (wanted == 2 )
            {
                distance = (integer) msg;
                llOwnerSay("Butterfly roaming range is " + (string) distance + " meters");
                integer count = (integer) (60/timetick);
                MakeMenu();
            }
            else if (wanted == 1 )
            {
                range = (integer) msg;
                llOwnerSay("Avatar detection range is " + (string) range + " meters");
                asensor = TRUE;
                llSensorRepeat("","",AGENT,range,PI,timetick);
                llOwnerSay("Butterflies should appear every " + (string) timetick + " seconds");
                integer count = (integer) (60/timetick);
                MakeMenu();
                llSetAlpha(0,ALL_SIDES);
            }
        }
        
        
        
    }
    
    state_entry()
    {
        MakeMenu();
        llSetAlpha(1,ALL_SIDES);
    }

    touch_start(integer total_number)
    {
        if (llDetectedKey(0) != llGetOwner())
        {
            return;
        }
        if (asensor)
        {
            llOwnerSay("Avatar detection range is " + (string) range + " meters");    
        }
        if (on_off)
        {
            llOwnerSay("Butterflies are on" );        
        }
        else
        {
            llOwnerSay("Butterflies are off" );        
        }
        
        llOwnerSay("Butterfly roaming range is " + (string) distance + " meters");
        integer count = (integer) (60/timetick);
        llOwnerSay("About " + (string) count + " butterflies a minute");
        if (llDetectedKey(0) == llGetOwner())
            MakeMenu();
    }
    
    
    timer()
    {
        llSetTimerEvent(timetick);
        Rez();
    }
    
    sensor(integer num_detected)
    {
        Rez();
    }
    
    on_rez(integer startparam)
    {
        llResetScript();
    }
}
