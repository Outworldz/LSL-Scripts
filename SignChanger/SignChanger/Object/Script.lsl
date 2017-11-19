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
  //  touch_start(integer n) {
    //    integer face = llDetectedTouchFace(0);
      //  llSay(0,(string) face);
    //}
    
}