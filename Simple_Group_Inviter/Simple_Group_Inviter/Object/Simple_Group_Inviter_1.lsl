// :CATEGORY:Group Inviter
// :NAME:Simple_Group_Inviter
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:02
// :ID:761
// :NUM:1048
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Simple_Group_Inviter
// :CODE:

// group id, you can determine this by doing a search in the new search. every group has a page and at the bottom it shows the id within a link, for example if it say "Link to this page: http://world.secondlife.com/group/Groups UUID". Pick your id and replace the one below
string group_id = "Your UUID Here";

// message to be shown before the link
string message = "Click here to join:";

default
{
    touch_start(integer total_number)
    {
        llInstantMessage(llDetectedKey(0), message + " secondlife:///app/group/" + group_id + "/about");
    }
}
