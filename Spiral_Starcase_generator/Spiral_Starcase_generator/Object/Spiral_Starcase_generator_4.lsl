// :CATEGORY:Stairs
// :NAME:Spiral_Starcase_generator
// :AUTHOR:Meyermagic Salome
// :CREATED:2010-12-27 12:13:52.583
// :EDITED:2013-09-18 15:39:05
// :ID:826
// :NUM:1153
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Conf_Baluster// // Drop this in a cylinder named "Baluster". 
// :CODE:
default
{
    on_rez(integer s)
    {
        if(s != 0)
        {
            string d = (string)s;
            float z = ((float)llGetSubString(d, 5, 9)) / 1000.0;//Height
            float y = ((float)llGetSubString(d, 1, 4)) / 1000.0;//Diameter
            float x = y;
            llSetScale(<x, y, z>);
            llRemoveInventory(llGetScriptName());
        }
    }
}
