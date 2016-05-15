// :CATEGORY:Money Tree
// :NAME:Money Tree
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2014-02-20 14:27:38
// :ID:1027
// :NUM:1598
// :REV:2
// :WORLD:Opensim, SecondLife
// :DESCRIPTION:
// Makes a Money Tree. This is the Tree  Prim
// :CODE:
// Add a prim to this prims inventory with the FallingScript in it.

integer Amount = 1;     // Give one Linden each time.
integer Max = 100;     // the max $L to give away, then stop giving

integer rezTime = 10;  // The boxes will rez for 10 seconds, then die
float DIST = 10;   // Boxes will be rezzed within this radius of the giver. (!!! MAX = 10 )
// How often to rez objects
float min = 60;        // one minute minimum
float max = 300;       // 5 minutes sometimes
integer channel = -76576;  //  a very secret number/password also found in the boxes that fall.
integer Given;            
default
{
    state_entry()
    {
        llRequestPermissions(llGetOwner(), PERMISSION_DEBIT);
    }

    run_time_permissions(integer permissions)
    {
        if (permissions & PERMISSION_DEBIT)
        {
            llListen(channel,llGetInventoryName(INVENTORY_OBJECT,0),"","");    // listen for givers we rezzed by name
            llSetTimerEvent(llFrand(max - min) + min);
        }
    }

    timer()
    {
        vector myPos = llGetPos();   // this giver is HERE
        myPos.x = llFrand(DIST*2) - DIST + myPos.x;  // Make it +/- DIST away
        myPos.y = llFrand(DIST*2) - DIST + myPos.y;

        // And rez it with a start parameter 
        llRezObject(llGetInventoryName(INVENTORY_OBJECT,0),myPos,ZERO_VECTOR, ZERO_ROTATION,rezTime);
    }

    listen(integer channel, string name, key id, string message)
    {
        if (Given > Max) {
            llSetTimerEvent(0); // stop giving
            llInstantMessage(llGetOwner(), "Out of money to give");
            llSetText("Balance: 0 " , <1,0,0>,1.0);        // red text
            return;
        }

        Given += Amount;
        key avatarKey = (key) message;
        llGiveMoney(avatarKey, Amount);
        llSetText("Balance: " + (string) (Max - Given), <0,0,1>,1.0);// Green text
    }
    
}
