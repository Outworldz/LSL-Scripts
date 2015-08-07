// :CATEGORY:Building
// :NAME:Fix_Repeats_Per_Meter
// :AUTHOR:NashBaldwin
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:53
// :ID:310
// :NUM:409
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Fix_Repeats_Per_Meter
// :CODE:
default
{
    state_entry()
    {
        // round position to grid
        float grid = 0.125;
        vector pos = llGetPos();
        pos.x = grid * llRound(pos.x / grid);
        pos.y = grid * llRound(pos.y / grid);
        pos.z = 27.750;
        llSetPos(pos);

        // round scale to twice grid
        grid *= 2.0;
        vector scale = llGetScale();
        scale.x = grid * llRound(scale.x / grid);
        if (scale.x == 0) { scale.x = grid; }
        scale.y = grid * llRound(scale.y / grid);
        if (scale.y == 0) { scale.y = grid; }
        scale.z = 3.0;
        llSetScale(scale);
        llSay(0, "scale " + (string)scale);
        
        // repeats per meter
        float r = 0.5;
        llScaleTexture(r*scale.x, r*scale.z, 1);
        llScaleTexture(r*scale.y, r*scale.z, 2);
        llScaleTexture(r*scale.x, r*scale.z, 3);
        llScaleTexture(r*scale.y, r*scale.z, 4);
        
        //string me = llGetInventoryName(INVENTORY_SCRIPT, 0);
        //llRemoveInventory(me);
        llRemoveInventory(llGetScriptName());
    }
}
