// :CATEGORY:XS Pet
// :NAME:XS Pet Robot
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS: Pet,XS,breed,breedable,companion,Ozimal,Meeroo,Amaretto,critter,Fennux,Pets
// :CREATED:2013-09-06
// :EDITED:2014-01-30 12:24:20
// :ID:988
// :NUM:1441
// :REV:0.50
// :WORLD:Second Life, OpenSim
// :DESCRIPTION:
//  XS Pet rotate the globe 
// :CODE:

default
{
	state_entry()
	{

		llTargetOmega(<.5,0.0,0.0>*llGetRot(),0.1,0.01);
		//llTargetOmega(<0,0.0,0.0>*llGetRot(),0.1,0.01); // uncomment to stop rotation
	}


}

