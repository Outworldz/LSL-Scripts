// :CATEGORY:Particle
// :NAME:Particle to Viictim
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2014-04-04 22:02:10
// :EDITED:2014-04-04
// :ID:1033
// :NUM:1609
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Makes particles nto a weapon. Shoots them at avatars you choose from a menu
// :CODE:


string texture;

updateParticles(key target)
{
                                // MASK FLAGS: set  to "TRUE" to enable
integer glow = FALSE;                                // Makes the particles glow
integer bounce = FALSE;                             // Make particles bounce on Z plane of objects
integer interpColor = TRUE;                         // Color - from start value to end value
integer interpSize = TRUE;                          // Size - from start value to end value
integer wind = FALSE;                               // Particles effected by wind
integer followSource = TRUE;                       // Particles follow the source
integer followVel = TRUE;                       // Particles turn to velocity direction

// Choose a pattern from the following:
// PSYS_SRC_PATTERN_EXPLODE
// PSYS_SRC_PATTERN_DROP
// PSYS_SRC_PATTERN_ANGLE_CONE_EMPTY
// PSYS_SRC_PATTERN_ANGLE_CONE                                                 
// PSYS_SRC_PATTERN_ANGLE
integer pattern = PSYS_SRC_PATTERN_ANGLE_CONE_EMPTY;       
// PSYS_SRC_PATTERN_EXPLODE;

                                                
 // PARTICLE PARAMETERS
    
    float age = 5;                                // Life of each particle
    float maxSpeed = 1.0;                           // Max speed each particle is spit out at
    float minSpeed = 1.0;                             // Min speed each particle is spit out at

    float startAlpha = 1.0;                         // Start alpha (transparency) value
    float endAlpha = 1.0;                             // End alpha (transparency) value
    vector startColor = <1.0,1.0,1.0>;              // Start color of particles <R,G,B>
    vector endColor = <1.0,1.0,1.0>;                      // End color of particles <R,G,B> (if interpColor == TRUE)
    vector startSize = <1.0,1.0,1.0>;            // Start size of particles 
    vector endSize = <1.0,1.0,1.0>;                      // End size of particles (if interpSize == TRUE)
    vector push = <1.0,0.0,0.0>;                    // Force pushed on particles

// SYSTEM PARAMETERS
    
    float rate = .1;                               // How fast (rate) to emit particles
    float radius = 0.75;                            // Radius to emit particles for BURST pattern
    integer count = 10;                              // How many particles to emit per BURST 
    float outerAngle = TWO_PI;                        // Outer angle for all ANGLE patterns   PI/4
    float innerAngle = 0.5;                         // Inner angle for all ANGLE patterns
    vector omega = <0,0,0>;                         // Rotation of ANGLE patterns around the source
    float life = 5;                                 // Life in seconds for the system to make particles

// SCRIPT VARIABLES
    
    integer flags;
    
    if (glow) flags = flags | PSYS_PART_EMISSIVE_MASK;
    if (bounce) flags = flags | PSYS_PART_BOUNCE_MASK;
    if (interpColor) flags = flags | PSYS_PART_INTERP_COLOR_MASK;
    if (interpSize) flags = flags | PSYS_PART_INTERP_SCALE_MASK;
    if (wind) flags = flags | PSYS_PART_WIND_MASK;
    if (followSource) flags = flags | PSYS_PART_FOLLOW_SRC_MASK;
    if (followVel) flags = flags | PSYS_PART_FOLLOW_VELOCITY_MASK;
    if (target != "") flags = flags | PSYS_PART_TARGET_POS_MASK;

    llParticleSystem([  PSYS_PART_MAX_AGE,age,
                        PSYS_PART_FLAGS,flags,
                        PSYS_PART_START_COLOR, startColor,
                        PSYS_PART_END_COLOR, endColor,
                        PSYS_PART_START_SCALE,startSize,
                        PSYS_PART_END_SCALE,endSize, 
                        PSYS_SRC_PATTERN, pattern,
                        PSYS_SRC_BURST_RATE,rate,
                        PSYS_SRC_ACCEL, push,
                        PSYS_SRC_BURST_PART_COUNT,count,
                        PSYS_SRC_BURST_RADIUS,radius,
                        PSYS_SRC_BURST_SPEED_MIN,minSpeed,
                        PSYS_SRC_BURST_SPEED_MAX,maxSpeed,
                        PSYS_SRC_TARGET_KEY,target,
                        PSYS_SRC_INNERANGLE,innerAngle, 
                        PSYS_SRC_OUTERANGLE,outerAngle,
                        PSYS_SRC_OMEGA, omega,
                        PSYS_SRC_MAX_AGE, life,
                        PSYS_SRC_TEXTURE, texture,
                        PSYS_PART_START_ALPHA, startAlpha,
                        PSYS_PART_END_ALPHA, endAlpha
                            ]);
      
      
      
      
}
    
    // Multi-Page Dialog Menu System
// Omei Qunhua December 2013
 
integer    gActionsPerPage = 9;           // Number of action choice buttons per menu page (must be 1 to 10, or 12)
list       gListActions ;
list       gListKeys;
// ========================================================================================================
 
integer    gTotalActions;             
integer    gPage;                     // Current dialog page number (counting from zero)
integer    gMaxPage;                  // Highest page number (counting from zero)
integer    gChan;                     // Channel used for dialog communications. 
key        gUser;                     // Current user accessing the dialogs 
 
BuildDialogPage(key user)
{
    // Build a dialog menu for current page for given user
    integer start = gActionsPerPage * gPage;       // starting offset into action list for current page
    // set up scrolling buttons as needed
    list buttons = [ "<<", " ", ">>" ];
    if (gActionsPerPage == 10)           buttons = [ "<<", ">>" ];
    else if (gActionsPerPage > 10)       buttons = [];          // No room for paging buttons
 
    // 'start + gActionsPerPage -1' might point beyond the end of the list -
    // - but LSL stops at the list end, without throwing a wobbly
    buttons += llList2List(gListActions, start, start + gActionsPerPage - 1);
    llDialog(user, "\nPage " + (string) (gPage+1) + " of " + (string) (gMaxPage + 1) + "\n\nChoose an action", buttons, gChan);
    llSetTimerEvent(60);              // If no response in time, return to 'ready' state
}
 
default
{
    state_entry()
    {
         texture = llGetInventoryName(INVENTORY_TEXTURE, 0);
 
        gTotalActions = llGetListLength(gListActions);       
 
        // Validate 'ActionsPerPage' value
        if (gActionsPerPage < 1 || gActionsPerPage > 12)
        {
            llOwnerSay("Invalid 'gActionsPerPage' - must be 1 to 12");
            return;
        }
 
        // Compute number of menu pages that will be available
        gMaxPage = (gTotalActions - 1) / gActionsPerPage;
        if (gActionsPerPage > 10)
        {
            gMaxPage = 0;
            if (gTotalActions > gActionsPerPage)
            {
                llOwnerSay("Too many actions in total for this  setting");
                return;
            }
        }
 
        // Compute a negative communications channel based on prim UUID
        gChan = 0x80000000 | (integer) ( "0x" + (string) llGetKey() );
        state ready;
    }
}
state ready
{
    touch_start(integer total_number)
    {
        gUser = llDetectedKey(0);
        llSensor("","",AGENT,25.0,TWO_PI);        // seek out a person
    }

    sensor(integer n)
    {
        integer i;
        gListKeys = [];
        gListActions = [];
        
        for ( i = 0; i < n; i++)
        {
            gListActions += llDetectedName(i);
            gListKeys +=  llDetectedKey(i);
        }
        state busy;                                    
        // Changing state sets the application to a busy condition while one user is selecting from the dialogs
        // In the event of multiple 'simultaneous' touches, only one user will get a dialog
    }

    no_sensor()
    {
        llOwnerSay("No one is near you, range is set at max of 25 meters");
    }
}

state busy
{
    state_entry()
    {
        llListen(gChan, "", gUser, "");                // This listener will be used throughout this state
        gPage = 0;
        BuildDialogPage(gUser);                        // Show  Page 0 dialog to current user
    }
    listen (integer chan, string name, key id, string msg)
    {
        if (msg == "<<" || msg == ">>")                   // Page change ...
        {
            if (msg == "<<")        --gPage;              // Page back
            if (msg == ">>")        ++gPage;              // Page forward
            if (gPage < 0)          gPage = gMaxPage;     // cycle around pages
            if (gPage > gMaxPage)   gPage = 0;
            BuildDialogPage(id);
            return;
        }
        if (msg != " ")                                  // no action on blank menu button
        {
            // User has selected a person from the menu
            integer idx = llListFindList(gListActions,[msg]) ;
            if ( idx > -1)
            {
                key aviKey = llList2Key(gListKeys,idx);  // get the corresponding key
                updateParticles(aviKey);
                llOwnerSay("Sending particles to " + msg + " key: " + (string) aviKey);
            }
        }
        state ready;         // changing state will release ANY and ALL open listeners
    }
    timer()
    {
        llOwnerSay("Too slow, menu cancelled");
        state ready;
    }
    state_exit()
    {
        llSetTimerEvent(0);          // would be dangerous to leave a dormant timer
    }
}

