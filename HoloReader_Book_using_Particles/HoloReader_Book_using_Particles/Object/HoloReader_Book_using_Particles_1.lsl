// :CATEGORY:Books
// :NAME:HoloReader_Book_using_Particles
// :AUTHOR:Moriash Moreau
// :CREATED:2010-11-18 20:56:30.087
// :EDITED:2013-09-18 15:38:54
// :ID:383
// :NUM:531
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// HoloReader_Book_using_Particles
// :CODE:
// Simplified HoloReader by Moriash Moreau, August 2005
// You may use this script for whatever purpose you like,
// provided it is legal and obeys the Terms of Service
// for Second Life. Please include the above information
// in any scripts derived from the following code.

// GENERAL USE
// Place this script and the textures for the book pages
// inside your book prim. The Z axis for the book prim
// should ideally point straight upward. Note that
// face 1 of the prim will be updated to show the next
// page each time the pages are flipped. This is so
// that the next page is loaded into the user's image
// cache. Ideally, the cover would be face 0 (top, or
// positive Z direction), and face 1 would be the bottom
// edge of the book. Your book design should take
// this preloading behavior into account.
// Note also that the object description line is used
// to store bookmark data.
// Note that the texture pages MUST be in alphabetical
// order, with the cover/title page as the first.
// They must also be the ONLY textures in the inventory.

// MODIFY THESE VALUES FOR YOUR BOOK.

// Set X equal to the desired width, Y to desired height.
// This size is in meters, with a max size of 4.0m in either dimension.
// Adjust as needed to keep height-to-width ratio right for
// the book pages. (The Z coordinate doesn't matter, but it
// needs to be there for vector formatting. Leave it at zero.)
// For example, <1.0,1.5,0> would be 1 meter wide by 1.5 meters tall.
// You'll have to look at the original sizes of the pre-upload
// images to determine this. All the pages must be the
// same size.

vector PageScale = <0.5,1.0, 0>;

// BaseOffset is the minimum height above the book page. This is
// mostly a matter of aesthetics. It controls how
// high the CENTER of the page will be above the
// book artifact. You'll want to at least clear
// the top of the book and the floating text for
// the page numbers.

float BaseOffset = 0.8;

// INTERNAL SYSTEM VARIABLES
// Do not modify.
string Page;
string NextPage;
string Description;
string FlickerMessage;
integer count = 0;
integer BookMark = 1;
integer PageCount;
integer ParticleCount = 8;
integer CommChannel;
integer Listener;
key BookUser;
float Offset;
vector Height;
integer Flicker = FALSE;

TakeControls()
{
llInstantMessage(BookUser,"Use Page Up and Page Down to turn pages. Best read in Mouselook.");
llInstantMessage(BookUser,"Touch again to bring up the additional functions menu.");
// Capture the page up and page down keys. Note that these keys will NOT perform their normal
// functions while these keys are captured.
llTakeControls(CONTROL_UP | CONTROL_DOWN,TRUE,FALSE);
}

// Check to see if we have PERMISSION_TAKE_CONTROLS. If so,
// take the controls, if not, request the permission
Init()
{
integer nMyPerms;
nMyPerms = llGetPermissions();
if (nMyPerms & PERMISSION_TAKE_CONTROLS)
{
TakeControls();
}
else
{
llRequestPermissions(BookUser, PERMISSION_TAKE_CONTROLS);
}
}

SetPage()
{
// Set the floating text to show the page number.
if (count == 0)
{
llSetText("Cover",<0,0,0>,1.0);
}
else
{
llSetText("Page " + (string)count,<0,0,0>,1.0);
}
// Read the next two pages from the inventory.
Page = llGetInventoryName(INVENTORY_TEXTURE, count);
if (count == PageCount || count == (PageCount - 1))
{
NextPage = llGetInventoryName(INVENTORY_TEXTURE, 1);
}
else
{
NextPage = llGetInventoryName(INVENTORY_TEXTURE, count + 1);
}
ShowPage();
llSetTexture(NextPage, 1);
}

MainMenu()
{
CommChannel = (integer)(llFrand(314159) + 1);
llDialog(BookUser,"Additional Book Functions:", ["Mark Page", "To Mark", "Flicker?", "Close Book"],CommChannel);
Listener = llListen(CommChannel,"",BookUser,""); // listen for the dialog answer
}

FlickerMenu()
{
CommChannel = (integer)(llFrand(420000) + 1);
FlickerMessage = "If the pages are flickering, try changing the particle count. Current particle count is " + (string)ParticleCount + ". Set the particle count to the minimum number necessary to remove flicker on your system.";
llDialog(BookUser, FlickerMessage, ["4", "8", "12", "16", "20", "24"],CommChannel);
Listener = llListen(CommChannel,"",BookUser,""); // listen for the dialog answer
}


ShowPage()
{
llParticleSystem([]);
llParticleSystem( [
// Appearance Settings
PSYS_PART_START_SCALE,(vector) PageScale,
PSYS_PART_END_SCALE,(vector) PageScale,
PSYS_PART_START_COLOR,(vector) <1,1,1>,
PSYS_PART_END_COLOR,(vector) <1,1,1>,
PSYS_PART_START_ALPHA,(float) 1.0,
PSYS_PART_END_ALPHA,(float) 1.0,
PSYS_SRC_TEXTURE,(string) Page,
// Time/Rate Settings
PSYS_SRC_BURST_PART_COUNT,(integer) ParticleCount, // # of particles per burst
PSYS_SRC_BURST_RATE,(float) 0.1, // delay between bursts
PSYS_PART_MAX_AGE,(float) 1.2, // particle life
PSYS_SRC_MAX_AGE,(float) 0,
// Placement Settings
PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_ANGLE_CONE,
PSYS_SRC_BURST_RADIUS,(float) Offset, // How far from the book the particles start
PSYS_SRC_INNERANGLE,(float) 0.0,
PSYS_SRC_OUTERANGLE,(float) 0.0,
PSYS_SRC_OMEGA,(vector) <0,0,0>,
// Movement Settings
PSYS_SRC_ACCEL,(vector) <0,0,0>,
PSYS_SRC_BURST_SPEED_MIN,(float) 0,
PSYS_SRC_BURST_SPEED_MAX,(float) 0,
PSYS_PART_FLAGS,
PSYS_PART_EMISSIVE_MASK | // particles glow
0
] );
}

default
{
state_entry()
{
llParticleSystem([]);
llSensorRemove();
// Check the number of pages (textures) in inventory.
PageCount = llGetInventoryNumber(INVENTORY_TEXTURE);
llSetText("",<0,0,0>,1.0);
}

on_rez(integer start_param)
{
llParticleSystem([]);
llSensorRemove();
PageCount = llGetInventoryNumber(INVENTORY_TEXTURE);
llSetText("",<0,0,0>,1.0);
}

touch_start(integer total_number)
{
Height = llDetectedPos(0) - llGetPos() + llGetAgentSize(BookUser)*0.6;
Offset = Height.z - BaseOffset;
if (Offset < BaseOffset)
{
Offset = BaseOffset;
}
BookUser = llDetectedKey(0);
state read;
}
}

state read
{
state_entry()
{
llParticleSystem([]);
PageCount = llGetInventoryNumber(INVENTORY_TEXTURE);
// Keep an eye on the user. Later, we'll kill the book
// if he walks out of range.
llSensorRepeat(llKey2Name(BookUser), BookUser, AGENT, 6, PI, 30);
Init();
count = 0;
SetPage();
}

// Return to standby/default mode if the book was copied/taken
// while it was in operation.
on_rez(integer start_param)
{
state default;
}

// If the touch is from the current user, call the functions menu.
// If not, inform the toucher that the book is in use.
// Use a random channel each time, to prevent the dialog
// box from being misdirected later on.
touch_start(integer total_number)
{
if (llDetectedKey(0) == BookUser)
{
MainMenu();
}
else
{
llInstantMessage(llDetectedKey(0),"This book is currently in use.");
}
}

// Process our various dialog box responses.
listen(integer channel, string name, key id, string message)
{
if (message == "Close Book")
{
llReleaseControls();
llParticleSystem([]);
llSleep(1.0);
BookUser = "";
state default;
}
else if (message == "Mark Page")
{
// Save the current page number to the object description line.
if (BookUser == llGetOwner())
{
BookMark = count;
llSetObjectDesc("Marked on page " + (string)BookMark + ".");
llInstantMessage(BookUser, "Bookmarking page " + (string)BookMark + ".");
}
else
{
llInstantMessage(BookUser,"Only the owner of this book can set the bookmark.");
}
}
else if (message == "To Mark")
{
Description = llGetObjectDesc();
count = (integer)llGetSubString(Description, 15, llStringLength(Description) - 2);
SetPage();
llInstantMessage(BookUser, "Jumping to marked page " + (string)count + ".");
}
// The Flicker menu is all numbers. Is this message a number?
else if ((integer)message > 1)
{
ParticleCount = (integer)message;
llInstantMessage(BookUser, "Setting particle count to " + (string)ParticleCount + ".");
ShowPage();
}
// Kill the old listen channel, call the flicker menu on a new channel.
else if (message == "Flicker?")
{
Flicker = TRUE;
}
// Shut down the menu listen channel.
llListenRemove(Listener);
if (Flicker == TRUE)
{
Flicker = FALSE;
FlickerMenu();
}
}

// Standard permissions event. We asked for permission to take
// controls above. This is triggered by that request.
run_time_permissions(integer nMyPerms)
{
if (nMyPerms & PERMISSION_TAKE_CONTROLS)
{
TakeControls();
}
else
{
llParticleSystem([]);
llSleep(1.0);
state default;
}
}

control(key id, integer level, integer edge)
{
if (level & edge & CONTROL_DOWN )
{
count = count + 1;
if (count >= PageCount)
{
count = 0;
}
SetPage();
}
else if (level & edge & CONTROL_UP )
{
count = count - 1;
if (count <= -1)
{
count = PageCount - 1;
}
SetPage();
}
}

// If the user walks out of range, reset the book.
no_sensor()
{
llReleaseControls();
llParticleSystem([]);
llSleep(1.0);
BookUser = "";
llSensorRemove();
state default;
}

sensor(integer num_detected)
{
// Just in case we need this later.
}
}
