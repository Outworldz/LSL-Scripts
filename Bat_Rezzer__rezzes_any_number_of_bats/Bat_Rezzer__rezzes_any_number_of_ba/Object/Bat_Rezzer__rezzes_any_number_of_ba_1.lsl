// :CATEGORY:Bat Rezzer
// :NAME:Bat_Rezzer__rezzes_any_number_of_bats
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:48
// :ID:85
// :NUM:112
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// My best Bat rezzer script - Fred Frederix.... menu driven system for number, size and 
// :CODE:
// Description: Just add this to a prim and click it to get bats or other textures to appear in a slowly moving cloud
// Comment: My best Bat rezzer script - Fred Frederix.... menu driven system for number and size of bats, hearts, ghhosts, any texture loaded will rez
//
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// Hint, that means it is open source, and you must leave it full trasfer/copy/mod. Any changes or derivative must include this header, license, and must be full transfer/copy/mod.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

/// Just drag any number of textures in it, and click it.
// Author Fred Beckhusen (Ferd Frederix)..  

float COUNT = 2.0;
float scale = 0.5;
float speed = 0.0;

float TheAge = 30.0000; // increase to 1000

float CURRENT_RADIUS = 3.0;

string visible = "Hide";

// Modified values
integer IS_ON = FALSE;
float RADIUS = 2;               // picked randomly, must be less than MAX
string TEXTURE = NULL_KEY;  // a default texture in case none are found in inventory
float INTERVAL = 1.0;  // timer interval
//string boxcolor = "f39ca3bf-0058-9cd6-2a56-dd198a992fc0";  // the color of the box
integer BRIGHT = FALSE;


float x; float y; float z;

garden() 
{
    integer flag = 0;
    integer howmany = llRound( 2 * PI * RADIUS * COUNT/5);



    if (BRIGHT == TRUE)
        flag = PSYS_PART_EMISSIVE_MASK;
        
    llParticleSystem([
    PSYS_PART_FLAGS, 
    PSYS_PART_INTERP_COLOR_MASK | 
    PSYS_PART_INTERP_SCALE_MASK |
    flag,
    PSYS_SRC_PATTERN,PSYS_SRC_PATTERN_ANGLE_CONE,
    
    // Texture / Size / Alpha / Color
    PSYS_SRC_TEXTURE, TEXTURE ,
    PSYS_PART_START_SCALE,<scale, scale, 0.0000>, 
    PSYS_PART_END_SCALE,<scale, scale, 0.0000>,
    PSYS_PART_START_ALPHA,1.000000,
    PSYS_PART_END_ALPHA,1.000000,
    PSYS_PART_START_COLOR, <1.0,1.0,1.0>,
    PSYS_PART_END_COLOR, <1.0,1.0,1.0>, 
    
    PSYS_SRC_ACCEL,<x,y,z>,
    
    
    PSYS_SRC_ANGLE_END,PI,
    
    // Flow
    PSYS_PART_MAX_AGE, TheAge,
    PSYS_SRC_BURST_RATE,0.5 , 
    PSYS_SRC_BURST_PART_COUNT,howmany ,
    PSYS_SRC_MAX_AGE,0.000000,
    
    // Rez position
    PSYS_SRC_BURST_RADIUS,CURRENT_RADIUS,
    PSYS_SRC_INNERANGLE,0.0,
    PSYS_SRC_OUTERANGLE,PI,  
    PSYS_SRC_OMEGA,<0.00000, 0.0, 4>, 
    PSYS_SRC_BURST_SPEED_MIN,0.0,
    PSYS_SRC_BURST_SPEED_MAX,0.0
    ]);
}

stop() 
{
    llParticleSystem([]);
}

integer menu_handler;
integer menu_channel;

list order_buttons(list buttons)
{
    return llList2List(buttons, -3, -1) + llList2List(buttons, -6, -4)
         + llList2List(buttons, -9, -7) + llList2List(buttons, -12, -10);
}


key owner;
menu(key user)//make dialog easy, pick a channel by itself and destroy it after 5 seconds
{

    string title = "Pick one";
    list buttons =  ["On", "Off",visible,"Less","More","Bright","Radius-","Radius+","Dim"];
    llListenRemove(menu_handler);
    menu_handler = llListen(menu_channel,"","","");

    llDialog(user,title,order_buttons(buttons),menu_channel);
}




default 
{
    state_entry() 
    {
        
       //llSetTexture(boxcolor,ALL_SIDES); // visible
        // Create random channel within range [-1000000000,-2000000000]
        float achannel = (integer)(llFrand(-1000000000.0) - 1000000000.0);

        menu_channel = (integer) achannel;
        
        owner = llGetOwner();       

    
        if(IS_ON) 
        {
            llSetTimerEvent(INTERVAL);
            garden();
        } 
        else 
        {
             
            stop();
        }
    }
    
    touch_start(integer num_detected) 
    {
        integer i;
        for (i=0;i<num_detected;i++)
        {
            key target = llDetectedKey(i);
        
            if (target != owner)  // person clicking isn't owner 
            {
                llInstantMessage(target,"Sorry, only the owner is allowed to get my contents.");
                return;
            }
            menu(llDetectedKey(0));
        }
    }

    timer() 
    {
        TEXTURE = "a6c3d67d-a145-b6f5-80cd-c0c757b4c4d8"; //bat
        RADIUS = llFrand(CURRENT_RADIUS);

        
                
        x = llFrand(0.01);

        float dir = llFrand(1);
        if (dir > 0.5)
            x = -x;
        
        y = llFrand(0.01);

        dir = llFrand(1);
        if (dir > 0.5)
            y = -y;
            
        z = llFrand(0.01);

        dir = llFrand(1);
        if (dir > 0.5)
            z = -z;        

        
        scale = llFrand(0.4) + 0.1;
        
        garden();
    }

  
    // add all the lines blow inside "default'
    listen( integer thechannel, string name, key id, string message )
    {
        if (thechannel == menu_channel)
        {
            
            // On/Off
            if (message == "On")
                IS_ON = FALSE;
                
            if (message == "Off")
                IS_ON = TRUE;
                
                
                
             if (message == "Bright")
            {
                BRIGHT = TRUE;
            }
            else if (message == "Dim")
            {
                BRIGHT = FALSE;
            }                
                
                
                
            // More or less    
            if (message == "Less")
            {
                COUNT--;
            }
            else if (message == "More")
            {
                COUNT++;
            }
            
            if (COUNT < 1.0)
            {
               COUNT     = 1.0;                
            }

            // size
            if (message == "Radius-")
            {
                CURRENT_RADIUS -= 1;
            }
            else if (message == "Radius+")
            {
                CURRENT_RADIUS += 1;
            }
            else  if (message == "Show")
            {
                //llSetTexture(boxcolor,ALL_SIDES); // visible
                 visible = "Hide";
            }
            else  if (message == "Hide")
            {
                 visible = "Show";
                // llSetTexture("8dcd4a48-2d37-4909-9f78-f7a9eb4ef903",ALL_SIDES); // invisible
            }
            
            
            if (CURRENT_RADIUS > 50.0)
            {
               CURRENT_RADIUS     = 50.0;                
            } 
            else  if (CURRENT_RADIUS < 1.0)
            {
               CURRENT_RADIUS     = 1.0;                
            } 


           
                
                                
            if(IS_ON) 
            {
                
                llSetTimerEvent(0.0);
                stop();
                llOwnerSay("Garden has stopped");
            } else {
                integer max_inventory = llGetInventoryNumber(INVENTORY_TEXTURE);
                if(max_inventory > 0) 
                {
                    TEXTURE = llGetInventoryName(INVENTORY_TEXTURE, (integer)llFrand(max_inventory));
                }
                llSetTimerEvent(INTERVAL);
                garden();
                float diameter = 2 *  CURRENT_RADIUS;
                llOwnerSay("Garden is growing, diameter is " + (string) diameter + ", Count=" +  (string) COUNT);
                
                menu(llDetectedKey(0));
                
            }
        }
    }
   
    changed(integer mask)
    {   //Triggered when the object containing this script changes owner.
        if(mask & CHANGED_OWNER)
        {
            llResetScript();
        }
    }

    
    on_rez(integer param)
    {   //Triggered when the object is rezed, like after the object had been sold from a vendor
        llResetScript();//By resetting the script on rez it forces the listen to re-register.
    }



}



