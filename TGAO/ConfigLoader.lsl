integer counter;

// List of all the animation states
list animState = [ "Sitting on Ground", "Sitting", "Striding", "Crouching", "CrouchWalking",
                   "Soft Landing", "Standing Up", "Falling", "Hovering Down", "Hovering Up",
                   "FlyingSlow", "Flying", "Hovering", "Jumping", "PreJumping", "Running",
                   "Turning Right", "Turning Left", "Walking", "Landing", "Standing", "Dancing" ];


// Logic change - we now have a list of tokens. The 'overrides' list is the same length as this, 
// i.e. it has one entry per token, *not* one entry per animation. Multiple options for a token 
// are stored as | separated strings in a single list entry. This was done to save memory, and 
// allow a larger number of stands etc. All the xxxIndex variables now refer to the token index, 
// since that's how long 'overrides' is.

// List of internal tokens. This *must* be in the same sequence as the animState list. Note that
// we combine some tokens after the notecard is read (striding/walking, landing/soft landing), etc.
// The publicized tokens list only contains one entry for each pair, but we'll accept both, and
// combine them later
list tokens = [
    "[ Sitting On Ground ]",    // 0
    "[ Sitting ]",              // 1
    "",                         // 2 - We don't allow Striding as a token
    "[ Crouching ]",            // 3
    "[ Crouch Walking ]",       // 4
    "",                         // 5 - We don't allow Soft Landing as a token
    "[ Standing Up ]",          // 6
    "[ Falling ]",              // 7
    "[ Flying Down ]",          // 8
    "[ Flying Up ]",            // 9
    "[ Flying Slow ]",          // 10
    "[ Flying ]",               // 11
    "[ Hovering ]",             // 12
    "[ Jumping ]",              // 13
    "[ Pre Jumping ]",          // 14
    "[ Running ]",              // 15
    "[ Turning Right ]",        // 16
    "[ Turning Left ]",         // 17
    "[ Walking ]",              // 18
    "[ Landing ]",              // 19
    "[ Standing ]",             // 20
    "[ Swimming Down ]",        // 21
    "[ Dancing ]",              // 22 For Dancing Animations
    "[ Swimming Up ]",          // 23
    "[ Swimming Forward ]",     // 24
    "[ Floating ]",             // 25
    "[ Typing ]",               // 26
    "[ Settings ]"              // 27 this is new... we'll see how i can make it work
    
];

// The tokens for which we allow multiple animations
list multiAnimTokenIndexes = [
    0,  // "[ Sitting On Ground ]"
    1,  // "[ Sitting ]"
    18, // "[ Walking ]"
    20, // "[ Standing ]"
    15, // "[ Running ]"
    22  // "[ Dancing ]"
];

// Index of interesting animations
integer noAnimIndex     = -1;
integer sitgroundIndex  = 0;
integer sittingIndex    = 1;
integer stridingIndex   = 2;
integer standingupIndex = 6;
integer hoverdownIndex  = 8;
integer hoverupIndex    = 9;
integer flyingslowIndex = 10;
integer flyingIndex     = 11;
integer hoverIndex      = 12;
integer walkingIndex    = 18;
integer standingIndex   = 20;
integer swimdownIndex   = 21;
integer swimupIndex     = 22;
integer swimmingIndex   = 23;
integer waterTreadIndex = 24;
integer typingIndex     = 25;
integer settingsIndex   = 26;
integer dancingIndex    = 22;


list overrides = [];                        // List of animations we override
key notecardLineKey;                        // notecard reading keys
integer notecardIndex;                      // current line being read from notecard
integer numOverrides;                       // # of overrides
string notecardName = "";                   // The notecard we're currently reading

// String constants to save a few bytes
string EMPTY = "";
string SEPARATOR = "|";
string TIMINGSEPARATOR = ":";
string TRYAGAIN = "Please correct the notecard and try again.";
string FLAG = "flag";
string VAR = "var";
string COMMANDS = "commands";

// Settings keywords, their type and respective command(s)
// e.g. Standtime would be tye variable and the command is ZHAO_STANDTIME|<time>
// "Time", VAR, "ZHAO_STANDTIME|",
// ... TypingAO is type flag and the commands are ZHAO_TYPEAO_ON/ZHAO_TYPEAO_OFF
// "Type", FLAG, "ZHAO_TYPE_"
// ... those 2 suck bad:
// ZHAO_RANDOMSTANDS                   Stands cycle randomly
// ZHAO_SEQUENTIALSTANDS               Stands cycle sequentially
// they get the type COMMANDS
list settingsKeywords = [
    "standtime",     "var",        "ZHAO_STANDTIME|",
    "random",   "commands",   "ZHAO_RANDOMSTANDS",    "ZHAO_SEQUENTIALSTANDS",
    "typingao",     "flag",       "ZHAO_TYPEAO_",
    "typingkill",    "flag",       "ZHAO_TYPEKILL_",
    "mouselook",    "flag",      "ZHAO_MOUSELOOK_"
];

// Load all the animation names from a notecard
loadNoteCard() 
{
    // Clear out saved override information, since we now allow sparse notecards
    overrides = [];
    integer i;
    for ( i=0; i<numOverrides; i++ )
        overrides += [EMPTY];
        
    llOwnerSay( "Loading notecard '" + notecardName + "'..." );

    // Faster events while processing our notecard
    llMinEventDelay( 0.0 );
    
    counter = 0;

    // Start reading the data
    notecardIndex = 0;
    notecardLineKey = llGetNotecardLine( notecardName, notecardIndex );
}

// Stop loading notecard
endNotecardLoad(integer success)
{
    if(success)
    {
        llOwnerSay((string)counter + " animation entries found in Notecard.");
        llMessageLinked(LINK_SET, success, "END_NC_LOAD|" + llList2CSV(overrides), NULL_KEY);
    }
    else
    {
        llMessageLinked(LINK_SET, success, "END_NC_LOAD|", NULL_KEY);
    }
    
    notecardName = EMPTY;
}

checkAnimInInventory( string _csvAnims )
{
    list anims = llCSV2List( _csvAnims );
    integer i;
    for( i=0; i<llGetListLength(anims); i++ ) {
        string animName = llList2String( anims, i );
        if ( llGetInventoryType( animName ) != INVENTORY_ANIMATION ) {
            // Only a warning, so built-in anims can be used
            llOwnerSay( "Warning: Couldn't find animation '" + animName + "' in inventory." );
        }
    }
}

// Checks for too many animations - can't do menus with > 12 animations
checkMultiAnim( integer _animIndex, string _animName )
{
    list animsList = llParseString2List( llList2String(overrides, _animIndex), [SEPARATOR], [] );
    if ( llGetListLength(animsList) > 12 )
        llOwnerSay( "You have more than 12 " + _animName + " animations (You will be able to choose from only the first 12). Please correct this." );
}

//read Settings from NC and send them
doSettings(string settingsPart)
{
    integer i = 0;
    list settings = llParseString2List( settingsPart, [SEPARATOR], [] );
    for( i=0; i < llGetListLength(settings); i++)
    {
        list aSetting = llParseString2List( llList2String(settings, i), [TIMINGSEPARATOR], [] );
        if( 2 == llGetListLength(aSetting) )
        {
            string settingName = llToLower(llList2String(aSetting, 0));
            integer settingValue = llList2Integer(aSetting, 1);
            if( ( settingValue >= 0 ) && ( settingValue <= 1000 ) )
            {
                integer sIndex = llListFindList(settingsKeywords, [settingName]);
                if( sIndex != -1 )
                {
                    string msg = "";
                    if(VAR == llList2String(settingsKeywords, (sIndex + 1)))
                    {
                        msg = llList2String(settingsKeywords, (sIndex + 2));
                        msg += (string)settingValue;
                    }
                    else if(FLAG == llList2String(settingsKeywords, (sIndex + 1)))
                    {
                        msg = llList2String(settingsKeywords, (sIndex + 2));
                        if(settingValue) 
                        {
                            msg += "ON";
                        }
                        else
                        {
                            msg += "OFF";
                        }
                    }
                    else if(FLAG == llList2String(settingsKeywords, (sIndex + 1)))
                    {
                        if(settingValue)
                        {
                            msg = llList2String(settingsKeywords, (sIndex + 2));
                        }
                        else
                        {
                            msg = llList2String(settingsKeywords, (sIndex + 3));
                        }
                    }
                    llMessageLinked(LINK_SET, 0,  msg, NULL_KEY);
                }
            }
        }
    }
}

default
{
    state_entry()
    {
        llMinEventDelay( 0 );
        numOverrides = llGetListLength( tokens );
    }
    
    link_message(integer _sender, integer _num, string _message, key _id)
    {
        if ( llGetSubString(_message, 0, 7) == "LOAD_NC|" ) {
            notecardName = llGetSubString(_message, 8,  llStringLength(_message) - 1);
            loadNoteCard();
        }
    }
    
    dataserver( key _query_id, string _data ) 
    {

        if ( _query_id != notecardLineKey ) {
            llOwnerSay( "Error in reading notecard. Please try again." );

            endNotecardLoad(FALSE);
            return;
        }

        if ( _data == EOF ) {
            // Now the read ends when we hit EOF
            
            // See how many walks/sits/ground-sits we have
            checkMultiAnim( walkingIndex, "walking" );
            checkMultiAnim( sittingIndex, "sitting" );
            checkMultiAnim( sitgroundIndex, "sitting on ground" );
            checkMultiAnim( dancingIndex, "dancing" );          

            endNotecardLoad(TRUE);
            return;
        }

        // We ignore blank lines and lines which start with a #
        if (( _data == EMPTY ) || ( llGetSubString(_data, 0, 0) == "#" )) {
            notecardLineKey = llGetNotecardLine( notecardName, ++notecardIndex );
            return;
        }

        // Check for a valid token
        integer i;
        integer found = FALSE;
        for ( i=0; i<numOverrides; i++ ) {
            string token = llList2String( tokens, i );          
            // We have some blank entries in 'tokens' to get it to line up with animState... make
            // sure we don't match on a blank. 
            if (( token != EMPTY ) && ( llGetSubString( _data, 0, llStringLength(token) - 1 ) == token )) {
                // We found a token on this line, so we don't have to throw an error or keep
                // trying to match tokens
                found = TRUE;
                // Make sure the line has data after the token, or our sub-string calculation goes off
                if ( _data != token ) {                    
                    string animPart = llGetSubString( _data, llStringLength(token), -1 );
                    //check for [ Settings ] token
                    if( llListFindList( tokens, [token] ) == settingsIndex ) {
                        doSettings(animPart);
                    }
                    // See if this is a token for which we allow multiple animations
                    else if ( llListFindList( multiAnimTokenIndexes, [i] ) != -1 ) {
                        list anims2Add = llParseString2List( animPart, [SEPARATOR], [] );
                        // Make sure the anims exist
                        integer j;
                        for ( j=0; j<llGetListLength(anims2Add); j++ ) {
//
//  Mod: Cut the animation name from time parameter:
                            list newAnim = llParseStringKeepNulls( llList2String(anims2Add,j), [TIMINGSEPARATOR], [] );
                            string newAnimName = llList2String(newAnim, 0);    
                            
                                                                            
                            
                            if(llGetListLength(newAnim) > 1)
                            {
                                
                                integer timr = FALSE;
                                
                                integer ix = 1;
                                
                                for(ix = 1; ix < llGetListLength(newAnim) ; ix++)
                                {
                                    timr = timr || llList2Integer(newAnim, ix);
                                }
                                                                
                                if(timr > 0)
                                {
                                    string str = llDumpList2String(newAnim, "²Ø");
                                    anims2Add = llListReplaceList(anims2Add, [ str ], j, j);
                                }
                                
                                if(!timr)
                                {
                                    newAnimName = llDumpList2String(newAnim, "");
                                }
                            }
//
//
//                            checkAnimInInventory( llList2String(anims2Add,j) );
                            checkAnimInInventory( newAnimName );
                            ++counter;
                        }

                        // Join the 2 lists and put it back into overrides
                        list currentAnimsList = llParseString2List( llList2String(overrides, i), [SEPARATOR], [] );
                        currentAnimsList = currentAnimsList + anims2Add;
                        overrides = llListReplaceList( overrides, [llDumpList2String(currentAnimsList, SEPARATOR)], i, i );
                    } else {
                        // This is an animation for which we only allow one override
                        if ( llSubStringIndex( animPart, SEPARATOR ) != -1 ) {
                            llOwnerSay( "Cannot have multiple animations for " + token + ". " + TRYAGAIN );

                            endNotecardLoad(FALSE);
                            return;
                        }

                        // Inventory check
                        checkAnimInInventory( animPart );
                        ++counter;

                        // We're good
                        overrides = llListReplaceList( overrides, [animPart], i, i );
                    } // End if-else for multi-anim vs. single-anim
                } // End if line has more than just a token

                // Break, no need to continue the search loop
                jump done;

            } // End if token matched
        } // End search for tokens

        @done;
        
        if ( !found ) {
            llOwnerSay( "Could not recognize token on line " + (string)notecardIndex + ": " + 
                        _data + ". " + TRYAGAIN );

            endNotecardLoad(FALSE);
            return;
        }

        // Wow, after all that, we read one line of the notecard
        notecardLineKey = llGetNotecardLine( notecardName, ++notecardIndex );
        return;
    }
}
