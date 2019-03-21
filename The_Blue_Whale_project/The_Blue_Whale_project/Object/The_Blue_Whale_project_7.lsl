// :CATEGORY:Animal
// :NAME:The_Blue_Whale_project
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2010-05-28 12:46:01.023
// :EDITED:2013-09-18 15:39:07
// :ID:883
// :NUM:1252
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
ArchipelisBase.txt - form more help, see http://www.archipelis.com/userManual.php// // Go in build mode with the menu "View > Build B". Click on "Create" button. Click somewhere on the floor to create an object (whatever it is, cube, cylinder...). Here it is important to set the name "ArchipelisBase" to this object.// // Drag and drop all the previously generated images that are now in "My Inventory > Textures" into the content of the current object you are editing.// 
// Click on "Content". Click on "New Script...". Double click on the script called "New Script" that has been created. Copy the content of the file called "ArchipelisBase.txt". Replace the definition of the script by a paste action. Click on "Save" button and close the script window.
// 
// Select the object you are editing and with the right mouse button click on "Take" to put it into "My Inventory / Objects". 
// :CODE:
// ArchipelisBase.txt - Archipelis SARL - 2008 - www.archipelis.com
// With the courtesy of BestMomo Lagan.

string generate_index(integer i)
{
  if (i < 10)
    return "0" + (string)i;

  return (string)i;
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
  }
}

