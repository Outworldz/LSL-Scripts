// :CATEGORY:Chain Particles
// :NAME:Amethyst_Chain_Script
// :AUTHOR:Amethyst Rosencrans
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:47
// :ID:31
// :NUM:42
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Amethyst Chain Script.lsl
// :CODE:

// Amethyst Chain Script
// By: Amethyst Rosencrans

// Customizable variables
string lockmeistername = "chainupperleft";  // Lockmeister name we respond to
string texturename = "chain";               // Name of the chain texture
list Names = [ "lcuff" ];                   // List of lockmeister names
list IDs = [ -1 ];                          // and associated IDs (use -1 for any)
string Card = "Chain Settings";             // Settings notecard

// Intgernal variables
string nullstr = "";
key nullkey = NULL_KEY;
key posekey = nullkey;
string lockmeistertarget = "lcuff";         // Lockmeister name to chain to
float age = 2;
float gravity = 0.7;
key currenttarget = nullkey;
string ourtarget = nullstr;
integer line;
key loadkey;
string ourtexture = texturename;

// Set the texture back to the original values after unsitting
ReloadDefaults()
{
    ourtexture = texturename;
    age = 2;
    gravity = 0.7;
}

UpdateParticles(key leashtarget)
{
    currenttarget = leashtarget;
    llParticleSystem( [
    // Appearance Settings
    PSYS_PART_START_SCALE,(vector) <0.1,0.1,0>,// Start Size, (minimum .04, max 10.0?)
    PSYS_PART_END_SCALE,(vector) <1,1,0>,     // End Size,  requires *_INTERP_SCALE_MASK
    PSYS_PART_START_COLOR,(vector) <1,1,1>,   // Start Color, (RGB, 0 to 1)
    PSYS_PART_END_COLOR,(vector) <1,1,1>,     // EndC olor, requires *_INTERP_COLOR_MASK
    PSYS_PART_START_ALPHA,(float) 1.0,        // startAlpha (0 to 1),
    PSYS_PART_END_ALPHA,(float) 1.0,          // endAlpha (0 to 1)
    PSYS_SRC_TEXTURE,(string) texturename,    // name of a 'texture' in emitters inventory
    // Flow Settings, keep (age/rate)*count well below 4096 !!!
    PSYS_SRC_BURST_PART_COUNT,(integer) 1,    // # of particles per burst
    PSYS_SRC_BURST_RATE,(float) 0.0,          // delay between bursts
    PSYS_PART_MAX_AGE,(float) age,              // how long particles live
    PSYS_SRC_MAX_AGE,(float) 0.0,             // turns emitter off after 15 minutes. (0.0 =never)
    // Placement Settings
    PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_DROP,
    // _PATTERN can be: *_EXPLODE, *_DROP, *_ANGLE, *ANGLE_CONE or *_ANGLE_CONE_EMPTY
    PSYS_SRC_BURST_RADIUS,(float) 0.5,        // How far from emitter new particles start,
    PSYS_SRC_INNERANGLE,(float) 0.0,          // aka 'spread' (0 to 2*PI),
    PSYS_SRC_OUTERANGLE,(float) 0.0,          // aka 'tilt' (0(up), PI(down) to 2*PI),
    PSYS_SRC_OMEGA,(vector) <0,0,0>,          // how much to rotate around x,y,z per burst,
    // Movement Settings
    PSYS_SRC_ACCEL,(vector) <0,0,-gravity>,          // aka gravity or push, ie <0,0,-1.0> = down
    PSYS_SRC_BURST_SPEED_MIN,(float) 1000.0,  // Minimum velocity for new particles
    PSYS_SRC_BURST_SPEED_MAX,(float) 1000.0,  // Maximum velocity for new particles
    PSYS_SRC_TARGET_KEY,(key) leashtarget,    // key of a target, requires *_TARGET_POS_MASK
    // for *_TARGET try llGetKey(), or llGetOwner(), or llDetectedKey(0) even. :)

    PSYS_PART_FLAGS,      // Remove the leading // from the options you want enabled:

     //PSYS_PART_EMISSIVE_MASK |           // particles glow
     //PSYS_PART_BOUNCE_MASK |             // particles bounce up from emitter's 'Z' altitude
     //PSYS_PART_WIND_MASK |               // particles get blown around by wind
     PSYS_PART_FOLLOW_VELOCITY_MASK |    // particles rotate towards where they're going
     PSYS_PART_FOLLOW_SRC_MASK |         // particles move as the emitter moves
     //PSYS_PART_INTERP_COLOR_MASK |       // particles change color depending on *_END_COLOR
     //PSYS_PART_INTERP_SCALE_MASK |       // particles change size using *_END_SCALE
     PSYS_PART_TARGET_POS_MASK |         // particles home on *_TARGET key
    0 // Unless you understand binary arithmetic, leave this 0 here. :)
    ] );
}

// Initiate a notecard reload
LoadCard()
{
    line = 0;
    if(llGetInventoryType(Card) == INVENTORY_NOTECARD)
    {
        loadkey = llGetNotecardLine(Card, line);
    }
}

// Validate a key
integer isKey(key in)
{
    if(in) return 2;
    return (in == nullkey);
}

default
{
    state_entry()
    {
        llListen(-8888, "", NULL_KEY, "");
        LoadCard();
    }
    
    on_rez(integer start_param)
    {
        llParticleSystem([]);
        llResetScript();
    }

    link_message(integer sender, integer num, string str, key id)
    {
        // Handle sit/unsit/change
        if(num == 50 || num == 51)
        {
            integer which = (integer)str;
            integer index = llListFindList(IDs, [ which ]);
    
            llParticleSystem([]);
            
            if(index == -1)
            {
                index = llListFindList(IDs, [ -1 ]);
            } 
            if(index > -1)
            {
                lockmeistertarget = llList2String(Names, index);
            
                if(num == 50 && lockmeistertarget != nullstr)
                {
                    posekey = id;
                    ourtarget = lockmeistertarget;
                    llWhisper(-8888, (string)id + lockmeistertarget);
                }
                else if(num == 51)
                {
                    posekey = nullkey;
                    ReloadDefaults();
                }
            }
        }
        // Handle lockmeister update
        else if(num == 52)
        {
            integer index = llListFindList(IDs, [ (integer)str ]);
            list templist = llParseString2List((string)id, [ " " ], []);
            integer current = 0;
                        
            while(llList2String(templist, current) != nullstr)
            {
                string us = llList2String(templist, current);
                string them = llList2String(templist, current + 1);
                    
                if(us == lockmeistername)
                {
                    if(index != -1)
                    {
                        IDs = llDeleteSubList(IDs, index, index);
                        Names = llDeleteSubList(Names, index, index);
                    }
                    IDs += (integer)str;
                    Names += them;
                    return;
                }
                current += 2;
            }
        }
    }
        
    listen(integer channel, string name, key id, string message)
    {
        // Handle lockmeister chatter
        if(channel == -8888)
        {
            key ltarget = (key)llGetSubString(message, 0, 35);
            string command = llGetSubString(message, 36, -1);
         
            llMessageLinked(LINK_SET, 352, message, id);
            
            if(ltarget == posekey)
            {
                list templist = llParseStringKeepNulls(command, [ "|" ], []);
                
                if(command == lockmeistername)
                {
                    llSay(-8888, (string)ltarget + lockmeistername + " ok");   
                }
                else if(llGetSubString(command, 0, 6) == "gravity")
                {
                    float newgrav = (float)llList2String(templist, 1);
                    string thistarget = llList2String(templist, 2);
                    
                    if(newgrav != 0 && (thistarget == nullstr || thistarget == lockmeistername))
                    {
                        gravity = newgrav;
                        if(currenttarget != nullkey)
                        {
                            UpdateParticles(currenttarget);
                        }
                    }
                }
                else if(llGetSubString(command, 0, 6) == "texture")
                {
                    string newtex = llList2String(templist, 1);
                    string thistarget = llList2String(templist, 2);
                    
                    if(isKey((key)newtex) && (thistarget == nullstr || thistarget == lockmeistername))
                    {
                        texturename = newtex;
                        if(currenttarget != nullkey)
                        {
                            UpdateParticles(currenttarget);
                        }
                    }
                }
                else if(llGetSubString(command, 0, 2) == "age")
                {
                    float newage = (float)llList2String(templist, 1);
                    string thistarget = llList2String(templist, 2);
                    
                    if(newage != 0 && (thistarget == nullstr || thistarget == lockmeistername))
                    {
                        age = newage;
                        if(currenttarget != nullkey)
                        {
                            UpdateParticles(currenttarget);
                        }
                    }
                }
                else if(llGetSubString(command, 0, 5) == "target")
                {
                    if(command == "target")
                    {
                        llParticleSystem([]);
                        currenttarget = nullkey;
                    }
                    else
                    {
                        integer current = 1;
                        
                        while(llList2String(templist, current) != nullstr)
                        {
                            string us = llList2String(templist, current);
                            string them = llList2String(templist, current + 1);
                        
                            if(us == lockmeistername)
                            {
                                if(them == nullstr)
                                {
                                    ourtarget = nullstr;
                                    llParticleSystem([]);
                                    currenttarget = nullkey;
                                }
                                else
                                {
                                    list dests = llParseStringKeepNulls(them, [ "-" ], []);
                                    integer z;
                                    ourtarget = them;
                                    for(z=0;z<llGetListLength(dests);z++)
                                    { 
                                        llWhisper(-8888, (string)posekey + llList2String(dests, z));
                                    }
                                }
                            }
                            current += 2;
                        }
                    }
                }
                else if(ourtarget != nullstr)
                {
                    list dests = llParseStringKeepNulls(ourtarget, [ "-" ], []);
                    integer z;
                    integer num = llGetListLength(dests);
                    
                    for(z=0;z<num;z++)
                    { 
                        if(command == (llList2String(dests, z) + " ok"))
                        {
                            ourtarget = nullstr;
                            if(num > z+1)
                            {
                                integer y;
                                ourtarget = llList2String(dests, z+1);
                                for(y=z+2;y<num;y++)
                                {
                                    ourtarget += "-" + llList2String(dests, y);
                                }
                            }
                            UpdateParticles(id);
                            return;
                        }
                    }
                }
            }
        }
    }
    
    // Handle loading of the config file...
    // Using Xcite format for compatibility
    dataserver(key query_id, string data) 
    {
        if(data != EOF) 
        {
            if(data != nullstr && llGetSubString(data, 0, 0) != "#" && query_id == loadkey)
            {
                list templist = llParseStringKeepNulls(data, ["|"], []);
                string category = llList2String(templist, 0);
                string text = llList2String(templist, 1);
                
                // Override name setting
                if(category == "name")
                {
                    if(text != nullstr)
                    {
                        lockmeistername = text;
                    }   
                }
                // Override texture setting
                if(category == "texture")
                {
                    if(text != nullstr)
                    {
                        texturename = text;
                    }   
                }
                // Override target setting
                if(category == "target")
                {
                    if(text != nullstr)
                    {
                        lockmeistertarget = text;
                    }   
                }
                // Override age setting
                if(category == "age")
                {
                    if(text != nullstr)
                    {
                        age = (float)text;
                    }   
                }
                // Override gravity setting
                if(category == "gravity")
                {
                    if(text != nullstr)
                    {
                        gravity = (float)text;
                    }   
                }
            }
            if(query_id == loadkey)
            {
                line++;                                             // increase line count
                loadkey = llGetNotecardLine(Card, line);            // request next line
            }
        }
    }
}
// END //
