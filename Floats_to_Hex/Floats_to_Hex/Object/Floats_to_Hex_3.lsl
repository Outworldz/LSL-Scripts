// :CATEGORY:Math
// :NAME:Floats_to_Hex
// :AUTHOR:StrifeOnizuka
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:53
// :ID:326
// :NUM:437
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Helper Functions:
// :CODE:
string Rot2Hex(rotation a)
{
    return "<"+Float2Hex(a.x)+","+Float2Hex(a.y)+","+Float2Hex(a.z)+","+Float2Hex(a.s)+">";
}

string Vec2Hex(vector a)
{
    return "<"+Float2Hex(a.x)+","+Float2Hex(a.y)+","+Float2Hex(a.z)+">";
}

string DumpList2String(list input, string seperator)// for csv use ", " as the seperator.
{
    integer b = (input != []);
    string c;
    string d;
    integer e;
    if(b)
    {
        @top;
        if((e = llGetListEntryType(input,--b)) == TYPE_FLOAT)
            d=Float2Hex(llList2Float(input,b));
        else if(e == TYPE_ROTATION)
            d=Rot2Hex(llList2Rot(input,b));
        else if(e == TYPE_VECTOR)
            d=Vec2Hex(llList2Vector(input,b));
        else
            d=llList2String(input,b);
        if(b)
        {
            c = d + (c=seperator) + c;
            jump top;
        }
    }
    return (c=d) + c;
}
