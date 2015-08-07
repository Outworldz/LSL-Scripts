// :CATEGORY:Dance
// :NAME:Spinning_DanceBall_with_random_colo
// :AUTHOR:Anylyn Hax
// :CREATED:2011-01-22 11:59:03.917
// :EDITED:2013-09-18 15:39:05
// :ID:825
// :NUM:1149
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Spinning_DanceBall_with_random_colo
// :CODE:
list anis;
integer CHANNEL;
integer lisi;
 
MakeTheBall()
{
    llSetTimerEvent(10);
    llSetPrimitiveParams([
        PRIM_FLEXIBLE, FALSE, 0, 0.0, 0.0, 0.0, 0.0, ZERO_VECTOR
      , PRIM_MATERIAL, PRIM_MATERIAL_WOOD
      , PRIM_PHANTOM, FALSE
      , PRIM_PHYSICS, FALSE
      , PRIM_POINT_LIGHT, FALSE, ZERO_VECTOR, 0.0, 0.0, 0.0
      , PRIM_SIZE, <1.5,1.5,1.5>
      , PRIM_TEMP_ON_REZ, FALSE
      , PRIM_TYPE, PRIM_TYPE_SPHERE, 0, <0.0,1.0,0.0>, 0.0, ZERO_VECTOR, <0.0,1.0,0.0>
      , PRIM_FULLBRIGHT, ALL_SIDES, TRUE
      , PRIM_BUMP_SHINY, ALL_SIDES, PRIM_SHINY_HIGH, PRIM_BUMP_NONE
      , PRIM_COLOR, ALL_SIDES, <0.705,0.449,0.807>, 1.0
      , PRIM_TEXGEN, ALL_SIDES, PRIM_TEXGEN_DEFAULT
      , PRIM_TEXTURE, ALL_SIDES, "42d9ac0b-d423-94f0-9fd5-db3162b0d4ea", <4.0,12.0,0.0>, <0,0,0>, 0.5
    ]);
    llSetTextureAnim(ANIM_ON | SMOOTH | LOOP , ALL_SIDES, 0, 1, 0.0, 1.0, 0.1);
    anis = ["STOP"];
    integer a=0;
    while(a<llGetInventoryNumber(INVENTORY_ANIMATION) && a<9){anis+=llGetInventoryName(INVENTORY_ANIMATION,a++);};
    return;    
}
 
default
{
    state_entry(){MakeTheBall();}
    changed(integer change){if (change & CHANGED_INVENTORY){MakeTheBall();}}
    timer()
    {
        float rot = llFrand(1.0);
        float gruen = llFrand(1.0);
        float blau = llFrand(1.0);        
        //llSetColor(<rot,gruen,blau> , ALL_SIDES );
        llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_COLOR, ALL_SIDES, <rot,gruen,blau>, 1.0]);
        llSetTimerEvent(llFrand(25.0));
    }    
    touch_start(integer total_number){llRequestPermissions(llDetectedKey(0), PERMISSION_TRIGGER_ANIMATION);}
    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_TRIGGER_ANIMATION)
        {
            CHANNEL = llRound(llFrand(-99999999.9));
            lisi = llListen(CHANNEL,"","","");
            llDialog(llGetPermissionsKey(), "Choose the dance ",anis,CHANNEL);
        }
    }
    listen(integer chan, string name, key id, string mess)
    {
        if ( chan==CHANNEL &&  id == llGetPermissionsKey() &&  mess != "STOP")
        {llStartAnimation(mess);llListenRemove(lisi);}   
        if ( chan==CHANNEL &&  id == llGetPermissionsKey() &&  mess == "STOP")
        {
            integer x = 0; while(x < llGetInventoryNumber(INVENTORY_ANIMATION))
            {llStopAnimation(llGetInventoryName(INVENTORY_ANIMATION, x++));}
            llListenRemove(lisi);
        }  
    }
}
