// :CATEGORY:Prim Animator
// :NAME:Archipelis scripts for prim animator
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:48
// :ID:52
// :NUM:76
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Archipelis script to replace the buggy one that comes with Archipelis 2.0.
// It removes the extra images, leaving behind the one that is needed, and removes itself after making the Archipelis prims

// :CODE:

// With the courtesy of BestMomo Lagan.
// remove extra textures, script, and allow re-linked prim animation by Ferd Frederix

string generate_index(integer i)
{
    if (i < 10)
        return "0" + (string)i;

    return (string)i;
}


// remove all textures except the one on this prim.
clean(string index)
{
    string texture = "texture_" + index;
    string geometry = "geometry_" + index;

    integer j =  llGetInventoryNumber(INVENTORY_TEXTURE);
    integer i;
    for (i=0; i<j; i++)
    {
        string inventory = llGetInventoryName(INVENTORY_TEXTURE,i);
        if ( inventory != texture && inventory != geometry)
            llRemoveInventory(inventory);
    }
    llSetObjectName(index); // rename to allow re-linkable prim animation
    llRemoveInventory(llGetScriptName());	// delete this script, too
}



default
{
    on_rez(integer start_param)
    {
        if (start_param == 0)
            return;

        string message = (string)start_param;
        integer message_size = llStringLength(message);
        string index;
        string the_scale;

        if (message_size == 9)
        {
            index = llGetSubString(message, 0, 1);
            the_scale = "0." + llGetSubString(message, 2, 8);
        }
        else if (message_size == 8)
        {
            index = "0" + llGetSubString(message, 0, 0);
            the_scale = "." + llGetSubString(message, 1, 7);
        }
        else
        {
            index = "00";
            the_scale = "." + llGetSubString(message, 0, 6);
        }

        index = generate_index(((integer)index) - 1);

        rotation the_rotation = llEuler2Rot(<90.0 * DEG_TO_RAD, .0, .0>);
        llSetRot(the_rotation);

        float the_scale_value = (float)the_scale * 2.0 * 10.0;
        llSetScale(<the_scale_value, the_scale_value, the_scale_value>);

        string geometry = "geometry_" + index;
        llSetPrimitiveParams([PRIM_TYPE, PRIM_TYPE_SCULPT, geometry, PRIM_SCULPT_TYPE_SPHERE]);

        string texture = "texture_" + index;
        if(llGetInventoryType(texture) != INVENTORY_NONE)
            llSetTexture(texture, ALL_SIDES);

        clean(index);			// remove all but the necessary textures
    }
}


