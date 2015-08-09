// :CATEGORY:Color
// :NAME:Cid_Jacob_s_Color_Change
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:50
// :ID:174
// :NUM:245
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Cid Jacob s Color Change.lsl
// :CODE:

vector red = <1,0,0>; 
vector green  = <0,1,0>; 
vector white  = <1,1,1>;
vector black  = <0,0,0>;
vector gold  = <0.5,0.5,0>;
vector blue  = <0,0,1>;
vector orange  = <1,0.5,0>;
vector yellow  = <1,1,0>;
vector brown  = <0.5,0.25,0>;
vector pink  = <1,0.5,0.5>;
vector purple  = <0.2,0,0.2>;
vector lime  = <0.5,1,0>;
vector sky  = <0.5,1,1>;
vector lavander  = <0.2,0.2,0.4>;

default
{
    state_entry()
    {
        llListen(0,"",llGetOwner(),"");
    }
    
    on_rez(integer num)
    {
        llResetScript();
    }

    listen(integer number, string name, key id, string message)
    {
        if(message=="red")
        {
            llSetColor(red, ALL_SIDES);
        }
        if(message=="green")
        {
            llSetColor(green, ALL_SIDES);
        }
        if(message=="lavander")
        {
            llSetColor(lavander, ALL_SIDES);
        }
        if(message=="sky")
        {
            llSetColor(sky, ALL_SIDES);
        }
        if(message=="purple")
        {
            llSetColor(purple, ALL_SIDES);
        }
        if(message=="lime")
        {
            llSetColor(lime, ALL_SIDES);
        }
        if(message=="brown")
        {
            llSetColor(brown, ALL_SIDES);
        }
        if(message=="orange")
        {
            llSetColor(orange, ALL_SIDES);
        }
        if(message=="gold")
        {
            llSetColor(gold, ALL_SIDES);
        }
        if(message=="white")
        {
            llSetColor(white, ALL_SIDES); 
        }
        if(message=="black")
        {
            llSetColor(black, ALL_SIDES);
        }
        if(message=="blue")
        {
            llSetColor(blue, ALL_SIDES);
        }
        if(message=="yellow")
        {
            llSetColor(yellow, ALL_SIDES);
        }
        if(message=="pink")
        {
            llSetColor(pink, ALL_SIDES);
        }
        if(message=="green")
        {
            llSetColor(green, ALL_SIDES); 
        }
   }

}// END //
