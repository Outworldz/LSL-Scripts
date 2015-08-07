// :CATEGORY:Animation
// :NAME:Smile
// :AUTHOR:Kira Komarov
// :CREATED:2012-03-24 17:14:56.820
// :EDITED:2013-09-18 15:39:04
// :ID:802
// :NUM:1112
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Smile
// :CODE:
//////////////////////////////////////////////////////////
// [K] Kira Komarov - 2011, License: GPLv3              //
// Please see: http://www.gnu.org/licenses/gpl.html     //
// for legal details, rights of fair usage and          //
// the disclaimer and warranty conditions.              //
//////////////////////////////////////////////////////////
 
integer o = -1;
 
default
{
    state_entry()
    {
        llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
    } 
 
    run_time_permissions(integer perm) {
        if(perm & PERMISSION_TRIGGER_ANIMATION) {
            llSetTimerEvent(5+(integer)llFrand(10));
        }
    }
 
    timer() 
    {
        list smiles = [ "express_smile", "express_toothsmile" ];
        if(o = ~o) {
            llStartAnimation(llList2String(smiles, (integer)llFrand(2)));
            llSetTimerEvent(1.0);
            return;
        }
        integer itra;
        for(itra=0; itra<llGetListLength(smiles); itra++) {
            llStopAnimation(llList2String(smiles, itra));
        }
        llSetTimerEvent(5+(integer)llFrand(10));
    }
}
