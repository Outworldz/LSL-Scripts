// :CATEGORY:Phantom
// :NAME:Phantom_Child
// :AUTHOR:Aeron Kohime
// :CREATED:2010-12-27 12:28:17.673
// :EDITED:2013-09-18 15:38:59
// :ID:623
// :NUM:850
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Advanced// // Unlike the versions above, this version will work with ANY prim type (torus, tube, box, sculpt etc.) with ANY shaping parameters (twist, hollow, taper, slice, dimple etc.) and ANY texturing applied (glow, texture, fullbright, color etc.) without changing those parameters. In other words... This version works in ALL cases without error (At least I'm pretty sure it does). The downside being a greater memory use and slower run time (Although this is negligible) for complex (tortured) prims. Should only be used on child prims. 
// :CODE:
list PRIM_PHANTOM_HACK = [
    PRIM_FLEXIBLE, 1, 0, 0.0, 0.0, 0.0, 0.0, <0,0,0>,
    PRIM_FLEXIBLE, 0, 0, 0.0, 0.0, 0.0, 0.0, <0,0,0>];
 
list Params()
{
    list result = [];
    integer i = 0;
    integer face = 0;
    list src = llGetPrimitiveParams([PRIM_TEXTURE, ALL_SIDES]);
    integer len = llGetListLength(src);
    do
    {
        result += [PRIM_TEXTURE, face] + llList2List(src, i, (i + 3));
        face++;
        i += 4;
    }
    while(i < len);
 
    i = 0;
    face = 0;
    src = llGetPrimitiveParams([PRIM_COLOR, ALL_SIDES]);
    len = llGetListLength(src);
    do
    {
        result += [PRIM_COLOR, face] + llList2List(src, i, (i + 1));
        face++;
        i += 2;
    }
    while(i < len);
 
    i = 0;
    face = 0;
    src = llGetPrimitiveParams([PRIM_BUMP_SHINY, ALL_SIDES]);
    len = llGetListLength(src);
    do
    {
        result += [PRIM_BUMP_SHINY, face] + llList2List(src, i, (i + 1));
        face++;
        i += 2;
    }
    while(i < len);
 
    i = 0;
    face = 0;
    src = llGetPrimitiveParams([PRIM_FULLBRIGHT, ALL_SIDES]);
    len = llGetListLength(src);
    do
    {
        result += [PRIM_FULLBRIGHT, face] + llList2List(src, i, i);
        face++;
        i++;
    }
    while(i < len);
    i = 0;
    face = 0;
    src = llGetPrimitiveParams([PRIM_TEXGEN, ALL_SIDES]);
    len = llGetListLength(src);
    do
    {
        result += [PRIM_TEXGEN, face] + llList2List(src, i, i);
        face++;
        i++;
    }
    while(i < len);
 
    i = 0;
    face = 0;
    src = llGetPrimitiveParams([PRIM_GLOW, ALL_SIDES]);
    len = llGetListLength(src);
    do
    {
        result += [PRIM_GLOW, face] + llList2List(src, i, i);
        face++;
        i++;
    }
    while(i < len);
 
    return result;
}
 
default
{
    state_entry()
    {
        list type_params = llGetPrimitiveParams([PRIM_TYPE]);
        integer type = llList2Integer(type_params, 0);
        if(type > PRIM_TYPE_PRISM)
        {
            // After prism comes sphere, torus, tube, ring and sculpt.
            if(type != PRIM_TYPE_SCULPT)
                type_params += Params();
 
            llSetPrimitiveParams([PRIM_TYPE, PRIM_TYPE_BOX, PRIM_HOLE_DEFAULT, <0,1,0>, 0, <0,0,0>, <1,1,0>, <0,0,0>]
                                  + PRIM_PHANTOM_HACK
                                  + [PRIM_TYPE] + type_params);
        }
        else
        {
            llSetPrimitiveParams(PRIM_PHANTOM_HACK);
        }
    }
    changed(integer change)
    {
        if(change & CHANGED_REGION_START)
            llResetScript();
    }
    on_rez(integer param)
    {
        llResetScript();
    }
    collision_start(integer nd)
    {
        llResetScript();
    }
}
