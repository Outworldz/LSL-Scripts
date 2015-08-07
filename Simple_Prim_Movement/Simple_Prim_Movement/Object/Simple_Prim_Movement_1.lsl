// :CATEGORY:Movement
// :NAME:Simple_Prim_Movement
// :AUTHOR:mangowylder
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:02
// :ID:766
// :NUM:1053
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Up down script
// :CODE:
integer toggle;

default
{
    state_entry()
    {
    toggle = !toggle;
    }

    touch_start(integer total_number)
    {
// Adding .x .y or .z after the vector name can be used to get the float value of just that axis.
        vector pos = llGetPos();
        float X = pos.x; // <--- Like this.
        float Y = pos.y;
        float Zv = pos.z; 
        if (toggle){
        float Z = Zv + 1.0;
        llOwnerSay("I moved up a meter!");
        llSetPos (< X,Y,Z>);
    }
        else{
        float Z = Zv - 1.0;
        llSetPos (< X,Y,Z>);
        llOwnerSay("I moved down a meter!");
      
    }
       toggle = !toggle;    
}
}

