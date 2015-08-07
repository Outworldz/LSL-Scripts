// :CATEGORY:Object Key
// :NAME:Object_Key_Lister
// :AUTHOR:Davy Maltz
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:58
// :ID:578
// :NUM:791
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Object_Key_Lister
// :CODE:
string search;
string originalname;
default
{
    on_rez(integer start_param)
    {
        llResetScript();
    }
    state_entry()
    {
        originalname = llGetObjectName();
        llListen(0,"",llGetOwner(),"");
    }
    listen(integer channel, string name, key id, string message)
    {
        if(llSubStringIndex(message,".okey ") != -1)
        {
            search = llToLower(llGetSubString(message,6,llStringLength(message)));
            llSensor("","",PASSIVE,90,TWO_PI);
        }
    }
    sensor(integer num_detected)
    {
        integer i;
        for(i = 0; i < num_detected; ++i)
        {
            if(llSubStringIndex(llToLower(llDetectedName(i)),search) != -1)
            {
                llSetObjectName("Result #" + (string)i);
                llSay(0,llDetectedName(i) + ": " + (string)llDetectedKey(i));
            }
                llSetObjectName(originalname);
        }
    }
}
