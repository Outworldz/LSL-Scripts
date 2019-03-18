// :SHOW:
// :CATEGORY:Sign
// :NAME:SignChanger
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2017-11-19 21:56:00
// :EDITED:2017-11-19  20:56:00
// :ID:1112
// :NUM:1915
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Timer-based Sign
// :CODE:
// This script will chance the texture on a sign every 5 seconds. The time can be changed by changing "llSetTimerEvent(5);" to the time you want.
integer count ;
integer current = 0;

SetLinkTextureFast( string texture, integer face)
{
    llSetLinkPrimitiveParamsFast(LINK_ROOT, [PRIM_TEXTURE, face, texture,<1,1,0>,<0,0,0>,0    
    ]);
}

// PRIM_TEXTURE, integer face, string texture, vector repeats, vector offsets, float rotation_in_radians 

default
{
    state_entry()
    {
        count = llGetInventoryNumber(INVENTORY_TEXTURE);
        llSetTimerEvent(5);
    }
    
    on_rez(integer p) {
        llResetScript();
    }
    timer() {
        
        string texturename = llGetInventoryName(INVENTORY_TEXTURE,current);
        SetLinkTextureFast(texturename,1);        // do side one 
        current++;
        if (current >= count)
            current = 0;
        texturename = llGetInventoryName(INVENTORY_TEXTURE,current);
        SetLinkTextureFast(texturename,2);  // do side two to cache it 
        
    }

    // if necessary, uncomment this, then touch a face to get the number for use with SetLinkTexture  
    //touch_start(integer n) {
    //    integer face = llDetectedTouchFace(0);
    //    llSay(0,(string) face);
    //}
    
}
