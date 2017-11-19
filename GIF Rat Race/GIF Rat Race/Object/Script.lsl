// :NAME:Rat Race
// :World: Opensim, Second Life
// :LICENSE: CC_BY-NC-SA
// :Author: Ferd Frederix
//: Category: GIF
//: Rev: 1.0


//:CODE:
// put this script and multiple llTextAnimation-type textures (gifs) into a prim.
// The gifs need to be named with the number of X, Y frames, and the speed separated by a semicolon.
// Example:
// name;X;Y;FPS, where X and Y are integers,a FPS is a float
// animated butterfly;5;2;15  will be a 5 X 2 array played at 15 fps
// moving2;10;1;6.5 is a 10 X 1 playes at 6.5 fps
//
// Link as many of these prims as you want into an array. Now touch the prim to see the GIFS.

integer i = 0;
integer max;

Bump(integer i)
{
    string name = llGetInventoryName(INVENTORY_TEXTURE,i);
  

     list my_list = llParseString2List(name,["-"],[""]);
     integer X = llList2Integer(my_list,1);
     integer Y = llList2Integer(my_list,2);
     float speed = llList2Float(my_list,3);

    
    llSetTextureAnim( ANIM_ON | LOOP, 1,X,Y,0,0,speed); 
    
    llSetTexture(name,1);
    
}
default
{
    state_entry()
    {
        max = llGetInventoryNumber(INVENTORY_TEXTURE);
        llOwnerSay("Loaded " + (string) max);
        Bump(0);
    }

    touch_start(integer total_number)
    {
          llMessageLinked(LINK_ALL_OTHERS, i, llDetectedName(0), llDetectedKey(0));
        Bump(i);
        i++;
        if (i >= max)
            i = 0;
    }
    
    changed(integer what)
    {
        if (what & CHANGED_INVENTORY)
            llResetScript();
    }
    
    link_message(integer source, integer num, string str, key id)
    {
        //llOwnerSay((string) num);
        Bump(num);
        llSleep(1.0);
    }




}
