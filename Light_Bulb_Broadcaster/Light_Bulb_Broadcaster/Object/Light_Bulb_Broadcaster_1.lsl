// :CATEGORY:Light
// :NAME:Light_Bulb_Broadcaster
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:56
// :ID:468
// :NUM:629
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Light Bulb Broadcaster.lsl
// :CODE:

integer status = TRUE;
integer passtouches = FALSE;
list on = [PRIM_MATERIAL,PRIM_MATERIAL_LIGHT];
list off = [PRIM_MATERIAL,PRIM_MATERIAL_GLASS];
default
{
    state_entry()
    {
        llSetPrimitiveParams(on);
        llPassTouches(passtouches);
    }

    touch_start(integer total_number)
    {
        integer linkNum = llGetLinkNumber();
       
        status = !status;
       
        if(status){
            //llSetPrimitiveParams(on);
             llMessageLinked(LINK_ALL_OTHERS, 0, "", "on");
        }else{
             llMessageLinked(LINK_ALL_OTHERS, 0, "", "off");
             //llSetPrimitiveParams(off);
        }
    }
}


// END //
