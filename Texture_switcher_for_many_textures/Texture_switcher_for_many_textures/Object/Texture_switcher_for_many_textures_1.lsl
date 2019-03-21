// :CATEGORY:Texture
// :NAME:Texture_switcher_for_many_textures
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2011-10-06 15:56:27.900
// :EDITED:2013-09-18 15:39:07
// :ID:880
// :NUM:1242
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Texture switcher with many levels of menus
// :CODE:
integer i = 0;
integer currentPos = 0;

integer listener;
integer MENU_CHANNEL ;
 
// opens menu channel and displays dialog
Dialog(key id)
{
    list MENU1 = [];

    // count the textures in the prim to see if we need pages
    integer c = llGetInventoryNumber(INVENTORY_TEXTURE);
    if (c <= 12)
    {
        for (i = 0; i < c; i++ ) {
            MENU1 += llGetInventoryName(INVENTORY_TEXTURE, i);
        }
    }
    else
    {           
        for (i = 10 * currentPos; i < (10 + (10 * currentPos)) ; i++) {
            
            // check to make sure name <= 24, or else the menu will not work.
            string aname = llGetInventoryName(INVENTORY_TEXTURE, i);
            if ( llStringLength(aname) >24) 
            {
                llOwnerSay("The texture  named " + aname + " has too long of a name to be used, please give it a shorter name <= 24 characters ");
            }   
            else
            {
             if (i < c ) {
                    MENU1 += aname;
                }
            }
        }
        MENU1 += ">>";       
        if (currentPos != 0)
            MENU1 += "<<"; 
        else
            MENU1 += "-";  
    }
    
    
    MENU_CHANNEL = (integer) (llFrand(10000) + 10000);
    listener = llListen(MENU_CHANNEL, "", NULL_KEY, "");
    
    llDialog(id, "Select one object below: ", MENU1, MENU_CHANNEL);
}
 
default
{
    on_rez(integer num)
    {
        // reset scripts on rez
        llResetScript();
    }
 
    touch_start(integer total_number)
    {
        // display the dialog 
        Dialog(llDetectedKey(0));
    }
 
    listen(integer channel, string name, key id, string message) 
    {
        if (channel == MENU_CHANNEL)
        {
            llListenRemove(listener);  
            if (message == ">>")
            {
                currentPos ++;
                Dialog(id);
            }
            else if (message == "<<")
            {
                currentPos--;
                if (currentPos < 0)
                    currentPos = 0;
                Dialog(id);
            }        
            else                    
            {
                // display the texture from menu selection 
                llSetTexture(message, ALL_SIDES);
 
            }      
        }
    }  
}


