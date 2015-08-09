// :CATEGORY:Viewer 2
// :NAME:HTML_Rendering_from_Notecard
// :AUTHOR:Pavcules Superior
// :CREATED:2010-09-02 11:32:44.597
// :EDITED:2013-09-18 15:38:55
// :ID:391
// :NUM:542
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// This script puts the data in the URL, and can render the HTML tags from the notecard.  Note, the URL limit is 1024 characters.  This script below does not need HTTP-IN to work, and is much simpler.
// :CODE:
// Notecard Text on a Prim
// Developed by: Pavcules Superior
// Developed on: March 2010

string g_strNotecardName;   
string g_strNotecardText;
integer g_intNotecardLine = 0;        
key g_keyNotecardQueryID; 
key g_keyURLRequestID;


// Start reading the notecard text.
ReadNotecardText()
{
    llOwnerSay("Reading Notecard...please wait.");
    
    g_intNotecardLine = 0;    
    g_strNotecardText = "";    
    g_strNotecardName = llGetInventoryName(INVENTORY_NOTECARD, 0);
    g_keyNotecardQueryID = llGetNotecardLine(g_strNotecardName, g_intNotecardLine);   
     
}


default
{
    state_entry()
    {
        
        ReadNotecardText();

        g_keyURLRequestID = llRequestURL();

    }
    
    changed(integer change)
    {
        // If the inventory is updated, read the notecard data again.        
        if(change & CHANGED_INVENTORY)
        {
              ReadNotecardText();
        }       
    }
    
    
    dataserver(key query_id, string data) 
    {
        if (query_id == g_keyNotecardQueryID) 
        {
            if (data != EOF)
            {    
                // Store the text.
                g_strNotecardText += data;
                
                // Read next notecard line.
                ++g_intNotecardLine;
                g_keyNotecardQueryID = llGetNotecardLine(g_strNotecardName, g_intNotecardLine);
            }
            else
            {
                // We have reached the end of the notecard.
                llOwnerSay("Size: " + (string)llStringLength(g_strNotecardText));
                llOwnerSay("Rendering Media image...please wait.");
                
                // Refresh the URL again by setting a random URL parameter value.
                llSetPrimMediaParams(0,[ PRIM_MEDIA_CURRENT_URL, 
                    "data:text/html," + g_strNotecardText ]);
            }
        }
    }    
    
}
