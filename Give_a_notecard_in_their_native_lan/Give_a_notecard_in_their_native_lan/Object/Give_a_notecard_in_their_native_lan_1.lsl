// :CATEGORY:Greeter
// :NAME:Give_a_notecard_in_their_native_lan
// :AUTHOR:Ferd Frederix
// :CREATED:2011-10-22 10:57:12.247
// :EDITED:2013-09-18 15:38:54
// :ID:350
// :NUM:473
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Put this in a box with as many notecards as you want. 
// :CODE:

integer found;
default
{
    state_entry()
    {
        integer j;
        string myname = llGetScriptName();

        integer inventory_count = llGetInventoryNumber(INVENTORY_NOTECARD);

        for (j=0; j<inventory_count;j++)
        {
            string objectname = llGetInventoryName(INVENTORY_NOTECARD,j);

            // find the stuff after an underscore.
            list parts = llParseString2List(objectname,["_"],[]);
            string cardlang = llList2String(parts,1);
            string agentlang = llGetAgentLanguage(llGetOwner());
        
            
            agentlang = llToLower(agentlang);
            
            if (agentlang != "zh-cn" && agentlang != "zh-tw")
            {
                agentlang = llGetSubString(agentlang,0,1);
            }
           
            if (agentlang == cardlang)  // don't give self out so the user doesn't get fifty thousand copies.
            {
                llOwnerSay("Giving Notecard " + objectname);
                llGiveInventory(llGetOwner(),objectname);
                found++;
            }
            
        }
        
        if (! found)
        {
            llGiveInventory(llGetOwner(),"Important Translator Information_en");
        }
            
    }

    on_rez(integer start_param)
    {
        llResetScript();
    }
}
