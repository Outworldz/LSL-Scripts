// :CATEGORY:Viewer 2
// :NAME:Notecard_Text_on_a_Prim
// :AUTHOR:Pavcules Superior
// :CREATED:2010-09-02 11:31:56.037
// :EDITED:2013-09-18 15:38:58
// :ID:564
// :NUM:768
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// For people who want to play with the Shared Media feature in LSL, I have developed a script that basically reads a Notecard and outputs the text on a side of a prim.  It uses the new "llSetPrimMediaParams" function, plus HTTP-In.  So its like a basic in-world mini web server!// // This script is only for demo purposes, so if things like the Region Restarts, the script would need to be reset to get a new HTTP-In URL.// // To set this up you need to do the following:// 
//     * Rez a normal prim on the ground.
//     * Create a Notecard with some text and place it inside the prim.
//     * Create a New Script.
//     * Copy the code below and paste it into the New Script.
//     * Save and run.
//     * The web page will appear on Face 0, which on top of the prim.  If you do not see the page, click on the top side and it will render.
//     * If you still do not see the page after a while, try setting the Texture > Media functionality on the top side of the prim.
//     * If you edit the notecard inside the prim, the script will re-read it, and refresh the URL.
// 
// I added a "?rand=" (with time value) parameter to the URL so that it makes the prim think its a new page and refreshes.
// 
// This new LL function is not officially released, so things may change on it.
// 
// Shared Media does open up many possibilities.
// :CODE:
// Notecard Text on a Prim
// Developed by: Pavcules Superior
// Developed on: February 2010
string g_strURL;
string g_strNotecardName;   
string g_strNotecardText;
integer g_intNotecardLine = 0;        
key g_keyNotecardQueryID; 
key g_keyURLRequestID;


// Start reading the notecard text.
ReadNotecardData()
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
        
        ReadNotecardData();

        g_keyURLRequestID = llRequestURL();

    }
    
    changed(integer change)
    {
        // If the inventory is updated, read the notecard data again.        
        if(change & CHANGED_INVENTORY)
        {
              ReadNotecardData();
        }       
    }
    
    
    dataserver(key query_id, string data) 
    {
        if (query_id == g_keyNotecardQueryID) 
        {
            if (data != EOF)
            {    
                // Store the data.
                g_strNotecardText += data + "\n";                
                
                // Read next notecard line.
                ++g_intNotecardLine;
                g_keyNotecardQueryID = llGetNotecardLine(g_strNotecardName, g_intNotecardLine);
            }
            else
            {
                // We have reached the end of the notecard.
                llOwnerSay("Rendering Media image.");
                
                // Refresh the URL again by setting a random URL parameter value.
                llSetPrimMediaParams(0,[ PRIM_MEDIA_CURRENT_URL, g_strURL + "/?rand=" + (string)llGetTime() ]);
            }
        }
    }    
    
    
   http_request(key id, string method, string body)
    {
        
        if (g_keyURLRequestID == id)
        {
            g_keyURLRequestID = "";
            
            if (method == URL_REQUEST_GRANTED)
            {
                g_strURL = body;
                
                // Set the URL.
                llSetPrimMediaParams(0,[ PRIM_MEDIA_CURRENT_URL, g_strURL]);
                
                llSay(0,"URL: " + body);
            }
            else if (method == URL_REQUEST_DENIED)
            {
                llSay(0, "Something went wrong, no url. " + body);
            }
        }
        else
        {
            // If the page is requested, show the notecard text.
            llHTTPResponse(id, 200, g_strNotecardText);
        }
    }    
    
    
}
