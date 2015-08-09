// :CATEGORY:Bee
// :NAME:Bee_and_Beehive
// :AUTHOR:Ferd Frederix
// :CREATED:2012-03-11 14:39:20.483
// :EDITED:2013-09-18 15:38:48
// :ID:86
// :NUM:113
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// The eye script
// :CODE:
default
{
    state_entry()
    {
         integer nTextures = llGetInventoryNumber(INVENTORY_TEXTURE);
        string texture1 = llGetInventoryName(INVENTORY_TEXTURE,0);
        
        list data  = llParseString2List(texture1,[";"],[]);
        string X = llList2String(data,1);
        string Y = llList2String(data,2);
        string Z = llList2String(data,3);
    
        integer sideX = (integer) X;
        integer sideY = (integer) Y;
        float speed = (float) Z;
    
        
        llSetTextureAnim(ANIM_ON|LOOP,ALL_SIDES,sideX,sideY,0,4,speed);
        llSetTexture(texture1,ALL_SIDES);
    }
} 
