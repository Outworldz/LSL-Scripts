// :CATEGORY:TV
// :NAME:TV_Script
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:08
// :ID:924
// :NUM:1328
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// TV Script.lsl
// :CODE:

key ownerkey;

string tvname = "HiroTV";

integer numberitems = 0;
integer selected = 1;

integer storelisten = 0;

float r=1.0;
float g=1.0;
float b=1.0;

integer switchtime = 15;

updatetext()
{
    if(r==-1)
        llSetText("",<0,0,0>,100); 
    else
    llSetText(llGetInventoryName(INVENTORY_TEXTURE,(selected - 1))+
            "\nPicture "+(string) selected +" of "+(string)numberitems, <r,g,b>, 1.5);
            
    llSetTexture(llGetInventoryName(INVENTORY_TEXTURE,  (selected - 1)),ALL_SIDES);
}


Init()
{
        ownerkey = llGetOwner();
        llInstantMessage(ownerkey,"HiroTV script reset!");
        numberitems = llGetInventoryNumber(INVENTORY_TEXTURE);
        updatetext();

        llListenRemove(storelisten);
        storelisten = llListen(0,"",ownerkey,"");
        
}

switchpic()
{
    selected++;
    if (selected > numberitems)
        selected = selected - numberitems;
    updatetext();

}


default
{
    state_entry()
    {
        Init();
        llSetTimerEvent(switchtime);
    }  

    on_rez(integer param)
    {
        Init();
        llSetTimerEvent(switchtime);

    }
        
    listen(integer channel, string name, key id, string msg)                    
    {
        list command = llParseString2List(msg,[":"],[]);    
        if(llList2String(command,0)==tvname)
        // ALL COMMANDS MUST START WITH THE TVNAME
        {
            string whichcommand=llList2String(command,1);
            if(whichcommand=="setname")
            {
                string newname=llList2String(command,2);
                if(newname!="")
                {
                    llSay(0,"HiroTV '"+tvname+"' has been renamed: '"+newname+"'.");
                    tvname=newname;

                }
                else
                {
                    llSay(0,"Sorry, you must enter a name for your vendor. Please try again.");
                }
            }
           else if(whichcommand == "setcolor")
           {
               list colors = llParseString2List(llList2String(command,2),[","],[]);
               r = (float)(llList2String(colors,0));
               if(r != -1)
               {
                 r = r / 255;
                }
               g = ((float)(llList2String(colors,1))/255);
               b = ((float)(llList2String(colors,2))/255);
               updatetext();
           }
           else if(whichcommand == "settimer")
           {
               switchtime = (integer)llList2String(command,2);
               llInstantMessage(ownerkey,"HiroTV will now switch every "+(string)switchtime+" seconds.");
               llSetTimerEvent(switchtime);
            }
            else if(whichcommand == "reset")
            {
                llResetScript();
            }
        }
        else
        if(llList2String(command,0)=="GetHiroTVName")
        {
            llSay(0,"My name is: "+tvname);
        }
    } // end listen
    
    touch( integer n)
    {
//        llSay(0,"changing");
        switchpic();
    }
    
    timer()
    {
        switchpic();   
    }

}// END //
