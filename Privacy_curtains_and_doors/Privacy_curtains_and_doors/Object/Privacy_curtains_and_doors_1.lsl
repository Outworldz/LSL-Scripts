// :CATEGORY:Privacy
// :NAME:Privacy_curtains_and_doors
// :AUTHOR:Avatar42 Farspire
// :CREATED:2010-07-01 12:18:49.510
// :EDITED:2013-09-18 15:39:00
// :ID:659
// :NUM:896
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// The controller script
// :CODE:

integer channel2 = 1234;
integer privacy = 0;

default
{
    state_entry()
    {
        llSetText("Touch me to toggle privacy drapes", <1.0, 1.0, 1.0>, 1.0);
        llSay(0, "Home controller online.");
    }

    touch_start(integer total_number)
    {
        if (privacy == 0) {
            llShout(channel2, "privacy:on");
            llOwnerSay("privacy:on.");
            privacy = 1;
        } else {
            llShout(channel2, "privacy:off");
            llOwnerSay("privacy:off.");
            privacy = 0;
        }
    }
}
