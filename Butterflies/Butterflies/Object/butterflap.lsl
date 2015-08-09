// :CATEGORY:Butterflies
// :NAME:Butterflies
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:49
// :ID:133
// :NUM:196
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Butterflies
// :CODE:

// butterflap

default
{ 
    on_rez(integer startparam)
    {
        integer color = startparam & 0xf;
        
        string aname  = "wing" + (string) color;
        string abody  = "body" + (string) color;
        llSetTexture(aname,ALL_SIDES);
         llMessageLinked(LINK_SET,0,abody,"");
        //llSetLinkPrimitiveParams( 2,[ PRIM_TEXTURE, ALL_SIDES, abody, <1,1,0>,<0,0,0>, 0 ]  );  
    }
}

