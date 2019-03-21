// :CATEGORY:XS Quail
// :NAME:XS Pet Robot
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS: Pet,XS,breed,breedable,companion,Ozimal,Meeroo,Amaretto,critter,Fennux,Pets
// :CREATED:2013-09-06
// :EDITED:2014-01-30 12:24:20
// :ID:988
// :NUM:1431
// :REV:0.50
// :WORLD:Second Life, OpenSim
// :DESCRIPTION:
// XS Pet  makes a male pet 8 days old
// :CODE:

// used only to accelerate a pet from being born to being 8 days old for debug - they will give birth much quicker this way

string sex = "1"; // make it male, use 2 for female


integer LINK_AGE_START = 800;  // when quail is rezzed and secret_number, is sent by brain to breeder, eater and informatic get booted up
integer LINK_SEX = 932;     // sex
integer LINK_MAGE = 940;    // xs_brain sends, xs_ager consumes, adds str to age, if older than 7 days, will grow the animal

default
{
    state_entry()
    {
        llMessageLinked(LINK_SET, LINK_MAGE, "1", "");        // force it to be 8 days old
        llSleep(1);
        llMessageLinked(LINK_SET, LINK_MAGE, "1", "");        // force it to be 8 days old
        llSleep(1);
        llMessageLinked(LINK_SET, LINK_MAGE, "1", "");        // force it to be 8 days old
        llSleep(1);
        llMessageLinked(LINK_SET, LINK_MAGE, "1", "");        // force it to be 8 days old
        llSleep(1);
        llMessageLinked(LINK_SET, LINK_MAGE, "1", "");        // force it to be 8 days old
        llSleep(1);
        llMessageLinked(LINK_SET, LINK_MAGE, "1", "");        // force it to be 8 days old
        llSleep(1);
        llMessageLinked(LINK_SET, LINK_MAGE, "1", "");        // force it to be 8 days old
        llSleep(1);
        llMessageLinked(LINK_SET, LINK_SEX, sex, ""); // make it male, should trigger LINK_GET_AGE and the 3 hour timers
    }
}
