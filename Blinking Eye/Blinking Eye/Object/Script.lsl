// :CATEGORY:Eye
// :NAME:Blinking Eye
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:49
// :ID:103
// :NUM:138
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Blinking-eye Script
// :CODE:
// This blink script uses a single texture with the frames set up as follows within the image.
//  
//   +-----+-----+
//   |  1  |  2  |
//   +-----+-----+
//   |  3  |  4  |
//   +-----+-----+

// The minimum time between blinks
float minBlinkTime = 0.5; // in seconds

// The Maximum time between blinks
float maxBlinkTime = 12.0; // in seconds

// The animation frame speed
float animationSpeed = 7; // in fps

// number of frames in the animation
integer numberFrames = 4;

// temporary variable
float waitTime;


// Returns a reandom number between min and max
float randBetween(float min, float max)
{
    return llFrand(max - min) + min;   
}


default
{
    // Main part of the program
    state_entry()
    {
        // Sets the size and position of the default frame
        llOffsetTexture(0.25,0.25,ALL_SIDES);
        llScaleTexture(0.5,0.5,ALL_SIDES);
        // Intialize time even        
        llSetTimerEvent(randBetween(minBlinkTime,maxBlinkTime));
        waitTime = (numberFrames * 2) / animationSpeed;
    }
    
    // Timer event    
    timer()
    {
        // Temporarily turn off the timer event
        llSetTimerEvent(0.0);
        // Animate the eyes onces.
        llSetTextureAnim(ANIM_ON|PING_PONG,ALL_SIDES,2,2,1,4,animationSpeed);
        // Wait for the eyes to finish animating
        llSleep(waitTime);
        // Turn off animation
        llSetTextureAnim(FALSE,ALL_SIDES,2,2,1,4,animationSpeed);
        // Reset Timer for next event        
        llSetTimerEvent(randBetween(minBlinkTime,maxBlinkTime));        
    }
}     // end 
// CREATOR:

