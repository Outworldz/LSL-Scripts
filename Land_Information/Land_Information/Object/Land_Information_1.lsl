// :CATEGORY:Land Info
// :NAME:Land_Information
// :AUTHOR:Fred Kinsei
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:56
// :ID:454
// :NUM:610
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Returns land name, square meterage, prim usage out of total prims, and any land restrictions. 
// :CODE:
//Credit to the creator:
//Made by SL resident Fred Kinsei

land()
{
    list info = llGetParcelDetails(llGetPos(), [PARCEL_DETAILS_NAME, PARCEL_DETAILS_AREA]);
    string name = llList2String(info, 0);
    integer size = llList2Integer(info, 1);
    integer primMAX = llGetParcelMaxPrims(llGetPos(), FALSE);
    integer prims = llGetParcelPrimCount(llGetPos(), PARCEL_COUNT_TOTAL, FALSE);
    integer flags = llGetParcelFlags(llGetPos());
    string restrictions;
    if(!(flags & PARCEL_FLAG_ALLOW_FLY))
    {
        restrictions += " : No Fly";
    }
    if(flags & PARCEL_FLAG_ALLOW_DAMAGE)
    {
        restrictions += " : Damage Zone";
    }
    if(!(flags & PARCEL_FLAG_ALLOW_CREATE_OBJECTS))
    {
        restrictions += " : No Build";
    }
    if(!(flags & PARCEL_FLAG_RESTRICT_PUSHOBJECT))
    {
        restrictions += " : Push Enabled";
    }
    if(flags & PARCEL_FLAG_RESTRICT_PUSHOBJECT)
    {
        restrictions += " : Push Disabled";
    }
    restrictions += " :";
    llOwnerSay(name + " ~ " + (string)size + "sqm");
    llOwnerSay((string)prims + "/" + (string)primMAX + " prims.");
    llOwnerSay(restrictions);
}
default
{
    state_entry()
    {
        llListen(0, "", llGetOwner(), "");
    }
    listen(integer chan, string name, key id, string message)
    {
        if(message == ".land")
        {
            land();
        }
    }
}
