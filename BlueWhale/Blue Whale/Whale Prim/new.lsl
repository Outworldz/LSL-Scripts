integer debug = 0;

integer channel = -44443;  	// listener from other prim
integer listener;			// channel handle 
string myName;				// Name of this prim

vector OFFSET = <0,0,0>;				// offset to the other door
rotation ROT = <0,0,0,1>;	// rotation when we get there

vector MYOFFSET = <0,0,0>;				// offset to the other door
rotation MYROT = <0,0,0,1>;	// rotation when we get there


key AvatarKey;				// key of who touched the door


//Sets / Updates the sit target moving the avatar on it if necessary.
UpdateSitTarget(vector pos, rotation rot)
{
	//Using this while the object is moving may give unpredictable results.
	llSitTarget(pos, rot);//Set the sit target
	key user = llAvatarOnSitTarget();
	if(user)//true if there is a user seated on the sittarget, if so update their position
	{
		vector size = llGetAgentSize(user);
		if(size)//This tests to make sure the user really exists.
		{
			//We need to make the position and rotation local to the current prim
			rotation localrot = ZERO_ROTATION;
			vector localpos = ZERO_VECTOR;
			if(llGetLinkNumber() > 1)//only need the local rot if it's not the root.
			{
				localrot = llGetLocalRot();
				localpos = llGetLocalPos();
			}
			pos.z += 0.4;
			integer linkNum = llGetNumberOfPrims();
			do{
				if(user == llGetLinkKey( linkNum ))//just checking to make sure the index is valid.
				{
					llSetLinkPrimitiveParams(linkNum,
						[PRIM_POSITION, ((pos - (llRot2Up(rot) * size.z * 0.02638)) * localrot) + localpos,
						PRIM_ROTATION, rot * localrot / llGetRootRotation()]);
					jump end;//cheaper but a tad slower then return
				}
			}while( --linkNum );
		}
		else
		{//It is rare that the sit target will bork but it does happen, this can help to fix it.
			llUnSit(user);
		}
	}
	@end;
}   //Written by Strife Onizuka, size adjustment provided by Escort DeFarge




default
{
	state_entry()
	{
		myName = llGetObjectName();
		listener = llListen(channel,myName,NULL_KEY,"");
		llRegionSay(channel,"reset");

		llSitTarget( MYOFFSET, MYROT);
	}
	
	touch_start(integer total_number)
	{
		AvatarKey = llDetectedKey(0);
		llRequestPermissions(AvatarKey,PERMISSION_TRIGGER_ANIMATION	);
	}

	listen(integer channel,string name, key id, string message)
	{
		
		list params = llParseString2List(message,["|"],[""]);
		if (debug) llDumpList2String(params,":");
		OFFSET = (vector) llList2String(params,0);
		ROT = (rotation) llList2String(params,1);
		llListenRemove (listener);
	}

	 run_time_permissions(integer perm)
    {
        if(PERMISSION_TRIGGER_ANIMATION & perm)
		{
			if (OFFSET == <0,0,0>)
				return;
			llStartAnimation("nyanya");
			llSleep(5);
			UpdateSitTarget(OFFSET,ROT);
        }
    }

}
