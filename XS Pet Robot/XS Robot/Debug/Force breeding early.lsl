
string sex = "1";		// for the male, use a 1, for the female, use a 2


integer LINK_AGE_START = 800;      // when quail is rezzed and secret_number, is sent by brain to breeder, eater and informatic get booted up
integer LINK_SEX = 932;            // sex
integer LINK_MAGE = 940;           // xs_brain sends, xs_ager consumes, adds str to age, if older than 7 days, will grow the animal
integer LINK_PUT_AGE = 943;             // print age from xs_ager


default
{
	state_entry()
	{
		llMessageLinked(LINK_SET, LINK_PUT_AGE, "", "8");	// set the age to 8 days
		llSleep(2);
		llMessageLinked(LINK_SET, LINK_AGE_START, "", "");
		llSleep(2);
		llMessageLinked(LINK_SET, LINK_SEX, "", sex);		// make it male or female
		llSleep(2);
		llMessageLinked(LINK_SET, LINK_MAGE, "", "8");		// make them 8 days old
		
	}
}