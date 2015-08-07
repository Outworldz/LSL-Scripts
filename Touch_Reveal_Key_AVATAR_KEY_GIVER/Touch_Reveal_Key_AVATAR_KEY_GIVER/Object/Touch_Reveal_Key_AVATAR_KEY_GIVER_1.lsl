// :CATEGORY:Avatar Key
// :NAME:Touch_Reveal_Key_AVATAR_KEY_GIVER
// :AUTHOR:Hank Ramos
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:07
// :ID:905
// :NUM:1281
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
//  Touch Reveal Key (AVATAR KEY GIVER)
// :CODE:

default
{
    state_entry()
    {
        llSetText("
Know Thyself...
touch me
        ", <1,1,1>, 1);
    }

    touch_start(integer total_number)
    {
        integer x;
        
        for (x = 0;x < total_number;x += 1)
        {
            llSay(0, "The key for " + llDetectedName(x) + " is "  + (string)llDetectedKey(x));
        }
    }
}
// END //
