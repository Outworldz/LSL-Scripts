// :CATEGORY:Security
// :NAME:Security Orb
// :AUTHOR:Psyke Phaeton
// :KEYWORDS:
// :CREATED:2014-09-08 19:09:33
// :EDITED:2014-09-08
// :ID:1043
// :NUM:1647
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// 
// :CODE:
/*

CC-BY-NC-SA

This work by Psyke Phaeton is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
You can read the full licence here: http://creativecommons.org/licenses/by-nc-sa/4.0/

In sumary:

You are free to:

    Share — copy and redistribute the material in any medium or format
    Adapt — remix, transform, and build upon the material

    The licensor cannot revoke these freedoms as long as you follow the license terms.

Under the following terms:

    Attribution — You must give appropriate credit, provide a link to the license, and indicate if changes were made. You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.

    NonCommercial — You may not use the material for commercial purposes.

    ShareAlike — If you remix, transform, or build upon the material, you must distribute your contributions under the same license as the original.

    No additional restrictions — You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.

In addition:
    You can't use the trade mark "PDS HomeSecurity" or PDS logos.

*/

default
{

    state_entry() {
        if (llGetStartParameter() != 0) {
            //script sent from update disk
            //llSay(0,"(6EmailUUID2) Updated");
        }
    }
    
    link_message(integer sender_num, integer num, string str, key id)
    {
        if (num==6002) {
            string subject = llGetSubString(str, 0, llSubStringIndex(str,"|"));
            string message = llGetSubString(str,llSubStringIndex(str,"|"),-1);
            llEmail((string)id + "@lsl.secondlife.com",llGetSubString(subject,0,-1),llGetSubString(message,1,-1));
            //llRemoveInventory(llGetScriptName()); INFO!!
        }
        if (num==6100) llSay(0,"(6Email) " + llGetScriptName() + " is ready.");
    }
}
