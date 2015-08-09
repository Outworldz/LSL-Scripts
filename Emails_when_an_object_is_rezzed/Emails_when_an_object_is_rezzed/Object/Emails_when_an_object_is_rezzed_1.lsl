// :CATEGORY:Email when rezzed
// :NAME:Emails_when_an_object_is_rezzed
// :AUTHOR:Insouciant Yue
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:52
// :ID:281
// :NUM:379
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Emails_when_an_object_is_rezzed
// :CODE:

// Phone Home
// Insouciant Yue  May 2008
//
// This script can be put inside a container object with other objects "goods" to be sold.
// When the owner rezzes this object, it will issue an invite to the "vendor's customer support/information
// SL group" [see line below to set] and then (secretly) send an email to an address [see line below to set]
// to report that the customer has indeed received this container object (and presumable other contents sold
// to them).  The email will also contain the location and you can get the date/time as well. After the email
// is sent (which has a 20 second delay built in by LSL), then this script deletes itself.
//
// Set this script to NOMOD NOCOPY to keep it hidden.  If revealed, the customers could get upset at being
// "spyed upon" or even learn of your email address and put it on a spammers list

// The next 3 paragraphs should be "set up" for your situation. They do NOT need to be changed every time
// for each customer, etc.  Just initially before you drop this script into the objects for sale.  The object will name
// themselves in the emails to you, so you can use the same script (after setting it up) for different sales.

string vendor_email = "SOMETHING@yahoo.com";
// CHANGE to your email address here (inside the quotes) where you want to receive the confirmations.
// Free email from @YAHOO.COM has been confirmed to work, but you can use any valid email address.
// I'd suggest a dedicated "sales verification" free email though soley for this purpose in case it is disclosed.
// The customer should NOT see this (nor anyone without full MOD privs on this script).

string group_uuid = "11111111-1111-1111-1111-111111111111";
// This NEEDS to be changed to the Seller's Customer Support/Info group's UUID.
// With recent changes in SL, it is harder to find a group's UUID, but there are some tools that help.

string join_message = "Click here to join our SL customer support group:";
// This is displayed when the link to join your group is given


// Don't modify anything below... unless you fully understand what happens.

string content = "";     // null initialize
key owner = "";          // null initialize

default
{
    on_rez(integer start_param)
    {
        llOwnerSay( join_message + " secondlife:///app/group/" + group_uuid + "/about");
        // send invite to group as a link for the recipient to click

        content = llKey2Name( llGetOwner()) + " has rezzed " + llGetObjectName() ;
        //build up something to send (owner of prim and message and object name)

        llEmail( vendor_email, content, content );
        // sends an email of subjext line "content" and body "content" to "ventor_email"

        llRemoveInventory(llGetScriptName());
        // delete this script from within the container
        }
}
