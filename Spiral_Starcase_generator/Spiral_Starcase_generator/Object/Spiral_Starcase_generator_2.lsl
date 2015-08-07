// :CATEGORY:Stairs
// :NAME:Spiral_Starcase_generator
// :AUTHOR:Meyermagic Salome
// :CREATED:2010-12-27 12:13:52.583
// :EDITED:2013-09-18 15:39:05
// :ID:826
// :NUM:1151
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Conf_Step// // Drop this in a prim named "Step". (Box with x-taper 1.0 is recommended). 
// :CODE:
default
{
    on_rez(integer s)
    {
        if(s != 0)
        {
            string d = (string)s;
            float y = ((float)llGetSubString(d, 1, 2)) / 100.0;//Height
            float z = ((float)llGetSubString(d, 3, 5)) / 10.0;//Radius
            float x = ((float)llGetSubString(d, 6, 9)) / 100.0;//Length
            llSetScale(<x, y, z>);
            llRemoveInventory(llGetScriptName());
        }
    }
}
