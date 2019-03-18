// :CATEGORY:Animal
// :NAME:The_Blue_Whale_project
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2010-05-28 12:46:01.023
// :EDITED:2013-09-18 15:39:07
// :ID:883
// :NUM:1251
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// ArchipelisRez.txt - // // Click on the "Create" button of the build window. Click somewhere on the floor to create a second object (whatever it is, cube, cylinder...). You can call this object "ArchipelisRez" but it is not mandatory.// Click on "Content". Click on "New Script...". Double click on the script called "New Script" that has been created. Copy the content of the file called "ArchipelisRez.txt". Replace the definition of the script by a paste action. Click on "Save" button and close the script window.// // Drag and drop the object called ArchipelisBase you created at step 4 (it is in "My Inventory > Objects") into the content of the current object you are editing. Then, delete the object "ArchipelisBase" in "My Inventory > Objects". 
// 
// eave the build mode by closing the build window. Click on the object ArchipelisRez in front of you to rez. Your 3D model appears. Now, you can delete the ArchipelisRez because it is no longer needed.
// By going back to the build mode (menu "View > Build") in "Edit" mode and by selecting all the shapes of your model, you can rotate or translate the selection
// :CODE:
// ArchipelisRez.txt - Archipelis SARL - 2008 - www.archipelis.com
// With the courtesy of BestMomo Lagan.

list the_values = [
  0.840197, 0.053115, -0.26187, 0.132, 
  0.235751, -0.629958, -0.0472265, 0.132, 
  0.342692, -0.0773743, -0.585281, 0.222, 
  0.206151, -0.740055, 0.199207, 0.132, 
  0
];

integer compile_message(integer index, float the_scale) 
{
  the_scale = the_scale / 10.0;
  string message = (string)the_scale;

  while(llStringLength(message) < 9)
  {
    message += "0";
  }

  message = llGetSubString(message, 2, 8);

  return (integer)((string)(index+1) + message);
}

default
{
  touch_start(integer total_number)
  {
    integer the_count = (integer)(llGetListLength(the_values) / 4);

    integer i;
    for(i = 0; i < the_count; i++)
    {
      float the_scale =   llList2Float(the_values, i * 4 + 0);
      float x         =   llList2Float(the_values, i * 4 + 1);
      float y         = - llList2Float(the_values, i * 4 + 3);
      float z         =   llList2Float(the_values, i * 4 + 2);

      vector offset = <0.0, 0.0, 1.0>;
      vector pos = llGetPos() + <x, y, z> + offset;

      integer message = compile_message(i, the_scale);

      llRezObject("ArchipelisBase", pos, ZERO_VECTOR, ZERO_ROTATION, message);
    }
  }
}

