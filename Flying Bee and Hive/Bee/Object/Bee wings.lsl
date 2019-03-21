// :CATEGORY:Flying Bee
// :NAME:Flying Bee and Hive
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-08 12:59:24
// :EDITED:2013-09-18 15:38:53
// :ID:995
// :NUM:1490
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// A free flying bee that gathers pollen and takes it to his hive
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
    
        
        llSetTextureAnim(ANIM_ON|LOOP,ALL_SIDES,sideX,sideY,1,1,speed);
        llSetTexture(texture1,ALL_SIDES);
    }
}
