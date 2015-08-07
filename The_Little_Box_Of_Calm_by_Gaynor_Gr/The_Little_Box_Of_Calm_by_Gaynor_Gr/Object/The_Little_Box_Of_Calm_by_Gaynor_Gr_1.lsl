// :CATEGORY:World Peace
// :NAME:The_Little_Box_Of_Calm_by_Gaynor_Gr
// :AUTHOR:Gaynor Gritzi
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:07
// :ID:885
// :NUM:1254
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// The Little Box Of Calm by Gaynor Gritzi.lsl
// :CODE:

//********************************************************
//This Script was pulled out for you by YadNi Monde from the SL FORUMS at http://forums.secondlife.com/forumdisplay.php?f=15, it is intended to stay FREE by it s author(s) and all the comments here in ORANGE must NOT be deleted. They include notes on how to use it and no help will be provided either by YadNi Monde or it s Author(s). IF YOU DO NOT AGREE WITH THIS JUST DONT USE!!!
//********************************************************









//*************************************
//******* The Little Box Of Calm ******
//****** Script by Gaynor Gritzi ******
//*************************************

// The purpose of this script is to bring about World Peace.
// Well you've got to try haven't you!

// Offered free to the world, to use and alter as you will,
// though a namecheck would be appreciated.

//****** INSTRUCTIONS ******

// Create a standard empty cube.
// Put this script inside it.
// Take the cube into your inventory.
// Drag out and place on the ground as many boxes as you want.

// The boxes use llWhisper to talk to each other,
// So each box should be within 10m of another box,
// Or it won't be able to chant for World Peace.

// Click any box to start the chanting.

// You can also issue instructions using chat.
// The boxes use channel 99 to listen.
// This will only work when the boxes are quiet,
// Because when the boxes chant, they are deaf to all distractions.

// Saying "/99 Calm" will start all boxes in listening range chanting.
// Saying "/99 Clean" will delete all boxes in listening range - a big timesaver.
// The length of the chants can be adjusted by using these phrases.....
// "/99 Short", "/99 Medium", "/99 Long", "/99 Longer" or "/99 Longest".

//****** RECOMMENDATIONS ******

// Like many of the things that I build,
// The boxes have a lighting effect built in,
// And are best seen with your world turned to Midnight
// And Local Lights switched on.

// Try setting out the boxes in different configurations....
// In a straight line, thrown about at random, build a wall, put them in the air.
// Though if you want to create a neverending circle of chants,
// You'll have to start a broken circle chanting,
// And then fill it in once chanting is underway.
// Warning - if the circle is big enough,
// The chanting will carry on forever,
// Which may just be long enough to bring about World peace.

//****** ACKNOWLEDGEMENTS ******

// The chant is a six second clip taken from a 20 minute chant
// (and I like to think I picked the very best 6 seconds),
// Supplied copyright free from the nice people at....
// http://ayurveda-berkeley.com/
// Who specialise in Indian Ayurvedic Medicine.


integer length = 10;

default
{
    // Put a texture on the box, give it a name and set up listening
    state_entry()
    {
        llSetObjectName("The Little Box Of Calm - Created By Gaynor Gritzi");
        llSetTexture("93fb4717-449d-8235-d24e-2e0133de2a50", ALL_SIDES);
        llListen( 99, "", NULL_KEY, "" );
    }
    
    // Starting listening and message handling.
        listen(integer channel, string name, key id, string message)
    {
        if (llToLower(message) == "calm") { state chanting; }
        if (llToLower(message) == "clean") { llDie(); }
        if (llToLower(message) == "short") { length = 1; }
        if (llToLower(message) == "medium") { length = 10; }
        if (llToLower(message) == "long") { length = 30; }
        if (llToLower(message) == "longer") { length = 90; }
        if (llToLower(message) == "longest") { length = 270; }
    }

    // Start chanting if box is clicked
    touch_start(integer total_number) { state chanting; }
}


// This handles the chanting
state chanting
{    
    state_entry(){
        // Turn on light and set up hovering text
        llSetPrimitiveParams ([PRIM_POINT_LIGHT, TRUE, <1, 1, 1>, 1.0, 3.0, 0.75] );
        llSetText("Chanting For World Peace", <3,3,3>, 1.5);   
        
        // Set volume and start a loop for the chant  
        llAdjustSoundVolume( 1.0);
        llLoopSound("8c62cfcc-697c-d4de-a057-b16efd5b0c51", 1.0 );
        
        // A bit of a delay so everything doesnt happen at once
        llSleep (6);
        
        // Tell the next box to be calm too
        llWhisper(99, "calm");
        
        // Do nothing while the chant continues for right amount of time
        llSleep (length);

        // Do a slow fade out.
        float volume = 100;
        for (volume = 100; volume >= 0; volume --)
        {
        llAdjustSoundVolume( volume / 100);
        llSleep (0.2);
        }

        // Stop all sound
        llStopSound();
        
        // Reset hover text and turn off light.
        llSetText("", <3,3,3>, 1.5);
        llSetPrimitiveParams ([PRIM_POINT_LIGHT, FALSE, <1, 1, 1>, 1.0, 3.0, 0.75] );
        
        // Go back to default state and wait for something to happen.
        state default;
    }
} // END //
