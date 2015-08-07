// :CATEGORY:Notecard Reader
// :NAME:Configuration_Notecard_Reader
// :AUTHOR:Dedric Mauriac
// :CREATED:2011-01-22 12:16:49.847
// :EDITED:2013-09-18 15:38:51
// :ID:201
// :NUM:275
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// The script.
// :CODE:
integer line;
string configurationFile = "Application.Config";
key readLineId;
string AvatarName;
string FavoriteColor;
 
init()
{
    // reset configuration values to default
    AvatarName = "Unknown";
    FavoriteColor = "None";
 
    // make sure the file exists and is a notecard
    if(llGetInventoryType(configurationFile) != INVENTORY_NOTECARD)
    {
        // notify owner of missing file
        llOwnerSay("Missing inventory notecard: " + configurationFile);
        return; // don't do anything else
    }
 
    // initialize to start reading from first line
    line = 0;
 
    // read the first line
    readLineId = llGetNotecardLine(configurationFile, line++);
 
}
processConfiguration(string data)
{
    // if we are at the end of the file
    if(data == EOF)
    {
        // notify the owner
        llOwnerSay("We are done reading the configuration");
 
        // notify what was read
        llOwnerSay("The avatar name is: " + AvatarName);
        llOwnerSay("The favorite color is: " + FavoriteColor);
 
        // do not do anything else
        return;
    }
 
    // if we are not working with a blank line
    if(data != "")
    {
        // if the line does not begin with a comment
        if(llSubStringIndex(data, "#") != 0)
        {
            // find first equal sign
            integer i = llSubStringIndex(data, "=");
 
            // if line contains equal sign
            if(i != -1)
            {
                // get name of name/value pair
                string name = llGetSubString(data, 0, i - 1);
 
                // get value of name/value pair
                string value = llGetSubString(data, i + 1, -1);
 
                // trim name
                list temp = llParseString2List(name, [" "], []);
                name = llDumpList2String(temp, " ");
 
                // make name lowercase (case insensitive)
                name = llToLower(name);
 
                // trim value
                temp = llParseString2List(value, [" "], []);
                value = llDumpList2String(temp, " ");
 
                // name
                if(name == "name")
                    AvatarName = value;
 
                // color
                else if(name == "favorite color")
                    FavoriteColor = value;
 
                // unknown name    
                else
                    llOwnerSay("Unknown configuration value: " + name + " on line " + (string)line);
 
            }
            else  // line does not contain equal sign
            {
                llOwnerSay("Configuration could not be read on line " + (string)line);
            }
        }
    }
 
    // read the next line
    readLineId = llGetNotecardLine(configurationFile, line++);
 
}
default
{
    state_entry()
    {
        init();
    }
    on_rez(integer start_param)
    {
        init();
    }
    changed(integer change)
    {
        if(change & CHANGED_INVENTORY) init();
        else if(change & CHANGED_OWNER) init();
    }
    dataserver(key request_id, string data)
    {
        if(request_id == readLineId)
            processConfiguration(data);
 
    }
}
