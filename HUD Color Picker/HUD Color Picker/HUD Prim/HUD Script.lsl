// :SHOW:
// :CATEGORY:HUD
// :NAME:HUD Color Picker
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2015-07-15 10:04:24
// :EDITED:2015-07-15  09:04:24
// :ID:1082
// :NUM:1802
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Rainbow Palette Color picker for a HUD//:LICENSE: CC-BY-SA 3.0
// :CODE:

// add this script and the texture to a prim.  You can touch the prim to change the color of other,unlinked prims.

// Based on Rainbow Palette by Rui Clary
// Modified by Jor3l Boa. Better interface and more readable :P
// Modified by Rui Clary on 2011.06.20 - some corrections
// Modified by Fred Beckhusen (Ferd Frederix) 2015.07.14 to have intensity control and be non-UUID specific (Opensim compatible).

// Available under the Creative Commons Attribution-ShareAlike 3.0 license
// http://creativecommons.org/licenses/by-sa/3.0/

// tunable things
string productName = "pal";// change this to match your product prim  - they must match to prevent crosstalk between products.
integer channel = 4;  // pick a channel that matches the listener prim

// no changes needed after this
 
// devolverString -> Convert and return a vector without .0000 and other
// float things :)
devolverString(float r, float g, float b) {
    string _vector = "<";
    if(r <= 0)  {
        _vector += "0,";
    }
    else if(r == 1) {
        _vector += "1,";
    }
    else    {
        string temp = (string)r;
        while(llGetSubString(temp,llStringLength(temp)-1,-1) == "0")    {
            temp = llDeleteSubString(temp,llStringLength(temp)-1,-1);
        }
        _vector += temp+",";
    }
    //----------------
    if(g <= 0)  {
        _vector += "0,";
    }
    else if(g == 1) {
        _vector += "1,";
    }
    else    {
        string temp = (string)g;
        while(llGetSubString(temp,llStringLength(temp)-1,-1) == "0")    {
            temp = llDeleteSubString(temp,llStringLength(temp)-1,-1);
        }
        _vector += temp+",";
    }
    //----------------
    if(b <= 0)  {
        _vector += "0>";
    }
    else if(b == 1) {
        _vector += "1>";
    }
    else    {
        string temp = (string)b;
        while(llGetSubString(temp,llStringLength(temp)-1,-1) == "0")    {
            temp = llDeleteSubString(temp,llStringLength(temp)-1,-1);
        }
        _vector += temp+">";
    }
    //----------------
    llSay(channel,_vector );
}
 
default
{
    state_entry()
    {
        llSetObjectName(productName);
        llSetTexture("RGB",1);
    }
    touch(integer num_detected) 
    {
        float x;float r;float g;float b;
        vector touchedpos = llDetectedTouchST(0);   
 
        if(llDetectedTouchFace(0) != 1) { return;   }
 
        float i = touchedpos.y;
 
        x=360*touchedpos.x;
        r=0;
        g=0;
        b=0;
        if (x>=0&&x<=60){
            r=255;
            g=x*255/60;
        }
        if (x>60&&x<=120){
            r=255-(x-60)*255/60;
            g=255;
        }
        if (x>120&&x<=180){
            g=255;
            b=(x-120)*255/60;
        }
        if (x>180&&x<240){
            g=255-(x-180)*255/60;
            b=255;
        }        
        if (x>240&&x<300){
            r=(x-240)*255/60;
            b=255;
        }    
        if (x>300&&x<=360){
            r=255;
            b=255-(x-300)*255/60;
        }  
        r = (r/255);
        g = (g/255);
        b = (b/255);
        //CONVERSION
        devolverString(r* i,g*i,b*i );
    }
 
}
