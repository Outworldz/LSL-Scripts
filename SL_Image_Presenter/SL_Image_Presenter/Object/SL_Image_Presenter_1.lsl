// :CATEGORY:Texture
// :NAME:SL_Image_Presenter
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:03
// :ID:786
// :NUM:1075
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// the Script
// :CODE:
//

integer numberPicture = 0;
integer totalPictures = 0;
string nameObject = "blank";
//integer scan = 0;
string message = "";
// Scan to be counter number of displays
   
forward()
{
        numberPicture++; 
        if (numberPicture >= totalPictures) numberPicture = 0;
        nameObject = llGetInventoryName(INVENTORY_TEXTURE, numberPicture);
        llSetTexture(nameObject, 2);
        llSetObjectDesc(nameObject);
        llSetText(nameObject, < 1, 1, 1 >, 1.0 );
           
}

   
back()
{
        numberPicture = numberPicture - 1;
        if (numberPicture < 0) numberPicture = 0;
        if (numberPicture >= totalPictures) numberPicture = 0;
        nameObject = llGetInventoryName(INVENTORY_TEXTURE, numberPicture);
        llSetTexture(nameObject, 2);
        llSetObjectDesc(nameObject);
        llSetText(nameObject, < 1, 1, 1 >, 1.0 );
         
}      

jumpTo( string message )
{
        //llSay(0,message);
        numberPicture = (integer)message;
        if (numberPicture >= totalPictures) 
            {
            //numberPicture = 0;
            llSay(0,"Picture doesn't exist");
            }
        else    
        {
        nameObject = llGetInventoryName(INVENTORY_TEXTURE, numberPicture);
        llSetTexture(nameObject, 2);
        llSetObjectDesc(nameObject);
        llSetText(nameObject, < 1, 1, 1 >, 1.0 );
        }
        
}                 
                                    
default
{
    state_entry()
    {
        totalPictures = llGetInventoryNumber(INVENTORY_TEXTURE);
        
        //llListen(0, "", "", "" );
        llListen(14142, "", "", "" );
        numberPicture = 0;
        //llSay(0, (string)numberPicture);
        nameObject = llGetInventoryName(INVENTORY_TEXTURE, numberPicture);
        llSetTexture(nameObject, 2);
        llSetObjectDesc(nameObject);
        llSetText(nameObject, < 1, 1, 1 >, 1.0 );
        
    }

    on_rez(integer startParam)
    {
        llResetScript();
        //numberPicture = 0;
        
        
    }

    touch_start(integer duh)
    {
       forward();
    }
    

    
    listen(integer channel, string name, key id, string message)
    {
        if(message == "next" )
            {
            forward();
            }
        else if(message == "back")
            {
            back();
            }
        else if( ((integer)message >= 0) && ((integer)message < 111))
            {
                //llSay(0,message);
                jumpTo( message );
            }
        
    }
    
    changed(integer change)
    {
        if (change & CHANGED_INVENTORY)
            totalPictures = llGetInventoryNumber(INVENTORY_TEXTURE);
    }
}
