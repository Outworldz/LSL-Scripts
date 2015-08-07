// :CATEGORY:Viewer 2
// :NAME:SVG_Scalable_Vector_Graphics_in_Sha
// :AUTHOR:Pavcules Superior
// :CREATED:2010-09-02 12:04:07.130
// :EDITED:2013-09-18 15:39:05
// :ID:853
// :NUM:1183
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
Example website: http://tutorials.jenkov.com/svg/index.html// // The demo script below, adapted from the Notecard on a Prim script, reads a notecard with SVG elements and puts it in the URL.  This is limited to 1024 characters.  Remember to create a notecard inside the prim for this to work.// // Unfortunately, SVG is more trickier to handle when trying to embed it into a web page via the same prim. Using the other techniques like Ajax to increase the size is running into problems.  To embed SVG into a page requires the use of the Object / Embed tags.  It has no problems linking to an external website with the SVG file.  But trying to reference a prim via HTTP-In to get the SVG code, is not working at all.  The only way around that I can see would be to have IFrames and embed the "Data:image/svg+xml" Mime type encoding of the SVG in the Iframe source path.
// :CODE:
// SVG on a Prim
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
  
    // Change the URL
    llSetPrimMediaParams(0,[ PRIM_MEDIA_CURRENT_URL, "data:text/plain,Loading Page...Please Wait..."  + (string)llGetUnixTime()]);
     
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
                llSetPrimMediaParams(0,
                    [PRIM_MEDIA_AUTO_PLAY,TRUE,
                     PRIM_MEDIA_CURRENT_URL,"data:image/svg+xml," + g_strNotecardText,
                     PRIM_MEDIA_HEIGHT_PIXELS,1024,
                     PRIM_MEDIA_WIDTH_PIXELS,1024]);                  
                    
            }
        }
    }    
    
}
