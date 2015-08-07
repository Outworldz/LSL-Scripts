// :CATEGORY:Dialog
// :NAME:Formatted_Sensor_Dialog
// :AUTHOR:Evil Fool
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:53
// :ID:335
// :NUM:448
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Formatted Sensor Dialog script by Evil Fool.lsl
// :CODE:

//Formatted Sensor Dialog script by Evil Fool
// You may give this script away for free, but please leave creator information in.
// Next owner MUST have script modify access if any of this code is used in part or whole
//CONFIG
integer gOwnerOnly = FALSE;
integer gChann = -293190;
integer gStride = 9;
//END CONFIG

list names;
integer gPos = 0;
key tReq;

dialog(key id)
{
    integer nTop = gPos + gStride - 1;
    list buttons = llList2List(names, gPos, nTop);
    string msg = llDumpList2String(buttons, "\n");
    while(llGetListLength(buttons) % 3 != 0)
    {
        buttons = llListInsertList(buttons, [" "], gStride);
    }
    if (gPos >= gStride)
    {
        buttons += ["PREVIOUS"];
    }else{
        buttons += [" "];
    }
    buttons += [" "];
    if (nTop - 1 < llGetListLength(names))
    {
        buttons += ["NEXT"];
    }else{
        buttons += [" "];
    }
    
    llDialog(id, msg, buttons, gChann);
}

default
{
    state_entry()
    {
        llListen(gChann, "", NULL_KEY, "");
    }
    
    touch_start(integer num_times)
    {
        if ( ( gOwnerOnly == TRUE && llDetectedKey(0) == llGetOwner() ) || gOwnerOnly == FALSE)
        {
            tReq = llDetectedKey(0);
            llWhisper(0, "Restarting script for user " + llDetectedName(0) + "!");
            llSensor("", NULL_KEY, PASSIVE, 96.0, PI);
        }
    }
    
    sensor(integer num_detected)
    {
        names = [];
        gPos = 0;
        integer i;
        for (i = 0; i < num_detected; i++)
        {
            names = names + llDetectedName(i);
        }
        dialog(tReq);
    }
    
    listen(integer channel, string name, key id, string msg)
    {
        if (msg == "NEXT")
        {
            gPos = gPos + gStride;
            dialog(id);
        }else if (msg == "PREVIOUS")
        {
            gPos = gPos - gStride;
            dialog(id);
        }else if (msg == " ")
        {
            llSay(0, "Sorry, this is just a filler!");
        }else{
            llSay(0, msg);
        }
    }
} // END //
