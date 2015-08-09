// :CATEGORY:Bling
// :NAME:Bling_Scriptgood_one
// :AUTHOR:Particle Script
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:48
// :ID:100
// :NUM:135
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Malthus' Bling Script(good one).lsl
// :CODE:

// TOUCHSTONE Particle Script 
// Commented by Daryth Kennedy
// IM me with any questions
// 11-2-2005

// // NOTES // //

// YOU MUST CLICK SAVE BEFORE ANY CHANGES WILL BECOME VISIBLE

// If you remove a particle script from an object, the object will continue
// To emit particles forever no matter what you do, unless you replace it with
// A new particle script, I don't know why

// Particles targetted to AV's will go right for the crotch, Particles love crotches.

//  Vocabulary for Particles:
//  Emitter     = The object spitting out the particles
//  Particles   = The actual things being emitted
//  Radius      = The area particles can start within, Higher No. = Bigger Area
//  Alpha       = The Transparency value of the Particles
//  Omega       = The Spin of an emitter, or rather the stream of particles
//  Comment     = These things // are called commenting, anything after is read only 
//              = By humans and is not compiled by the system.


//  PARTICLE BEHAVIOR - TRUE = ON, FALSE = OFF
//  Change TRUE or FALSE only, and make sure to stay in CAPS, with a ; at the end

integer glow = TRUE;        // Make the particles glow from inside
                            // if FALSE they will be effected by the local light.
                            
integer bounce = FALSE;     // Particles won't go lower than the emitter and will                                  //bounce on the "ground" level if negative push is applied.

integer interpColor = TRUE;     // Changes from start to end color
                                // Start and End colors are set below

integer interpSize = TRUE;      // Changes from start to end size
                                // Also Set below

integer wind = FALSE;           // Particles effected by wind
                                // Particles REALLY effected, will fly like crazy

integer followSource = FALSE;    // Particles follow the emitter, so they will move
                                 // In direct lines even if emitter is in motion
                                 // IF FALSE they will sway like smoke, leaving a trail

integer followVel = TRUE;       // Particles will emit in direction object facing
                                 // Use with ANGLE Patterns and negative push to create                                  // waterfalls, etc







// PARTICLE PATTERNS

//  Choose a pattern from this list:
//  Cut and Paste "PSYS_SRC_PATTERN_*" from the red list into the blue one, the blue 
//  One is the actively selected particle style

// PSYS_SRC_PATTERN_EXPLODE
    // This one makes particles appear anywhere within the radius at random.

// PSYS_SRC_PATTERN_DROP
    // This one makes particles appear as if dropping from a small hole in the emitter

// PSYS_SRC_PATTERN_ANGLE_CONE_EMPTY
     // This one makes particles appear in the inverse of a cone, usually nothing.

// PSYS_SRC_PATTERN_ANGLE_CONE
     // This one makes particles appear in a cone, like a flashlight beam.

// PSYS_SRC_PATTERN_ANGLE
     // This one makes particles appear in a flat fan shape fanning out from emitter.

    //THE LINE BELOW THIS IS WHERE YOU PASTE THE PARTICLE PATTERN
integer pattern = PSYS_SRC_PATTERN_EXPLODE;





// PARTICLE TARGET

    // For no Target, leave this alone as:  key target = "";
    // To target the emitters OWNER, simply put: key target = "owner"; 
    // To target the emitter itself, simply put: key target = "self"; 
    // or if targetting another piece of the linked object the link number is placed be    // low in another section, just leave this as: key target = "";
key target = "Pink Metal Heel w/ Flower Decor R";



// PARTICLE SETTINGS
float age = .1;                // How long each particle will survive

float maxSpeed = 3;          // Max speed each particle is spit out at
float minSpeed = 3;          // Min speed each particle is spit out at
                                // To create bursts of particles all sticking together                                 // Set both min and max speed to the same thing.

string texture = "";            // Texture used for particles, default used if blank
                                // Type the name of the texture in the " ", Make sure 
                                // To drag the Texture into the emitters contents.

float startAlpha = 1.0;         // Start alpha (transparency) value
float endAlpha = 0.5;           // End alpha (transparency) value
                                // Alpha is between 0.0 and 1.0

vector startColor = <1.0, 1.0, 1.0>;    // Starting color of particles <R,G,B>
vector endColor = <1.0, 1.0, 1.0>;     // End color of particles <R,G,B> 
                                // <0,0,0> = Black <1,1,1> = White
                                // InterpColor (above) must be TRUE for color to change

vector startSize = <0.1, 0.1, 0>; // Start size of particles 
vector endSize = <0.1, 0.1, 0>;   // End size of particles (if interpSize == TRUE)
                                    // Size Range is 0.01 to 7.00
                                    // Further the 3rd number doesn't effect anything

vector push = <0,0,0>;          // Force pushed on particles (X,Y,Z)
                                  // X = East/West    Y = North/South    Z= Up/Down
    
    
// PARTICLE PARAMETERS
float rate = 3;           // How many seconds between particle emissions
float radius = .0000001;          // Starting radius for Particles to appear within
integer count = 1;           // How many particles per emission (Per Rate) 


float outerAngle = 1.54;    // Outer angle for all ANGLE patterns (for a stream 0.1)
float innerAngle = 1.55;    // Inner angle for all ANGLE patterns (for a stream 0.0)
                            // In Radians, so every 1 is 90 degrees between 0 and 3

vector omega = <0,0,0>;    // Rotation of ANGLE patterns (X,Y,Z axis (E/W,N/S,UP/DOWN)
                           // This rotates the spray in a circle, not the particles

float life = 0;             // Time from Start to Stop to emit Particles
        
// Script variables
integer flags;

updateParticles()
{   
    // PARTICLE TARGETTING WITHIN LINKED OBJECTS
    //  In an object composed of multiple prims they are assigned a specific number        //  based on the order in which they were linked.  Particles can be targetted to a 
    //  specific link number by simply removing the // from the line below this 
    //  paragraph and putting the link number in the ( )'s 
    
    //target = llGetLinkKey(0);
    
    // eg.:     target = llGetLinkKey(7);
    
    // use the link-num identifier script to get an objects number, IM me for that 
    // script if you don't have one.
    
    
    
    //  // DO NOT CHANGE ANY OF THESE FLAGS, THE PARTICLES WILL NOT FUNCTION // //
    
    flags = 0;
    if (target == "owner") target = llGetOwner();
    if (target == "self") target = llGetKey();
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

    //THE ACTUAL SCRIPT, NOT FOR BEGINNER MODIFICATION//
    
default
{
    state_entry()
    {
        updateParticles();
        
        //  To Set the Particles to start every few seconds requires a timer, this is
        //  Commented out below, to use this timer you must place // in front of the 
        //  updateParticles(); line above and remove the // from all lines below this
        //  paragraph, further llSetTimerEvent(0); 0 = the number of seconds per start
    
        //   llSetTimerEvent(0);
        //   }
    
        //   timer()
        //   {
        //   updateParticles();
    }
}// END //
