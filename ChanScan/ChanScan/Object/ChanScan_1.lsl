// :CATEGORY:Scanner
// :NAME:ChanScan
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:50
// :ID:166
// :NUM:237
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// ChanScan.lsl
// :CODE:

list chans=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,10];
integer i;
default
{
    on_rez(integer foo)
    {
        llResetScript();
    }
    state_entry()
    {
        for(i=0;i<llGetListLength(chans);i++)
            llListen(llList2Integer(chans,i),"",NULL_KEY,"");
    }

    listen(integer channel, string name, key id, string message)
    {
        llOwnerSay("["+(string)channel+"] ["+name+"|"+llKey2Name(llGetOwnerKey(id))+"] "+message);
    }
}
// END //
