// :CATEGORY:Access
// :NAME:Access_NewAge
// :AUTHOR:Asia Snowfall
// :CREATED:2010-12-27 12:44:38.120
// :EDITED:2013-09-18 15:38:47
// :ID:13
// :NUM:18
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Change the Access variable to one of the three; 'Public' 'Group' 'Owner'// // Returns TRUE if user UUID is allowed to continue using. Returns FALSE if user UUID is not permitted to use. 
// :CODE:
/////////////////////////////////
// NewAge Access Script
// By Asia Snowfall
// Version 1.0
/////////////////////////////////
 
string Access = "public";
 
// Access Types;
// Public = Everyone can use
// Group = Group Only
// Owner = Owner Only
 
key asObjectOwner()
{
    list details = llGetObjectDetails(llGetKey(), [OBJECT_OWNER]);
    return (key)llList2CSV(details);
}
 
integer asAccessCheck(key id)
{
    if(llSubStringIndex(llToLower(Access), "public") != -1)
    {
        return TRUE;
    }
    else if((llSubStringIndex(llToLower(Access), "group") != -1)||(asObjectOwner() == id))
    {
        if(llSameGroup(id) == TRUE)
        {
            return TRUE;
        }
        else
        {
            return FALSE;
        }
    }
    else if(llSubStringIndex(llToLower(Access), "owner") != -1)
    {
        if(asObjectOwner() == id)
        {
            return TRUE;
        }
        else
        {
            return FALSE;
        }
    }
    else
    {
        return FALSE;
    }
}
 
default
{
    touch_start(integer x)
    {
        if(asAccessCheck(llDetectedKey(0)) == TRUE)
        {
            llWhisper(0, "Access Granted");
        }
        else
        {
            llWhisper(0, "Access Denied");
        }
    }
}
