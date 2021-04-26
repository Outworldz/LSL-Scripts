// :CATEGORY:Furniture
// :NAME: Single-Prim Multi-Drawer Script
// :AUTHOR:Sheena  Desade
// :KEYWORDS:
// :REV:1.0
// :WORLD:Second Life, Opensim
// :DESCRIPTION:
// Opensim drawers in a check
// :CODE:

//list we're going to store our data in
list l_drawer_prims;

//i_is_backwards is for if they put a negative sign in front of the offset, indicating
//that they want it to open the opposite direction
integer i_is_backwards = FALSE;
//was the dresser set up properly?
integer i_proper_config = TRUE;

//integer i_global;
//which axis are they wanting to move it on?
string s_axis = "y";
//how much do they want it to move?
float f_offset = -0.5;
//how long should they hold the touch for until the script resets?
float f_reset_touch_time = 2.0;
//integer to tell if they held the touch
integer i_touch_held = FALSE;

get_drawers()
{
	integer i;
	integer i_length = llGetNumberOfPrims();
	for (i = 1;i <= i_length;i++)
	{
		string s_prim_name = llGetLinkName(i);
		vector v_root_position = llGetRootPosition();

		if (s_prim_name == "drawer")
		{
			//Gets child prim's UUID
			key k_link_key = llGetLinkKey(i);
			//Gets child prim's regional position
			vector v_link_vector = llList2Vector(llGetObjectDetails(k_link_key, [OBJECT_POS]), 0);
			//Gets child prim's local position, corrected for rotation
			v_link_vector = (v_link_vector - v_root_position) / llGetRootRotation();
			//updates the list with all the details of the new drawer
			l_drawer_prims = (l_drawer_prims=[])+l_drawer_prims+(i)+v_link_vector+"closed";
		}
	}
}

get_config()
{
	//Gets the object's description as a list, in all lower-case letters so we don't have to
	//worry about capitalizations later
	string s_desc = llToLower(llList2String(llGetPrimitiveParams([PRIM_DESC]), 0));
	//Seperates the variables and values in the object's description into a list,
	//discarding the seperators
	list s_desc2 = llParseString2List(s_desc, ["::", "="], [""]);
	//Used in initiating the for loop
	integer i;
	//Gets the number of entries in the list 'desc2'
	integer i_length = llGetListLength(s_desc2);
	//i starts at zero, and the for loop runs for as long as i is less than the length of the
	//list 'desc2.' at the end of every iteration, it increases i by two, bringing us to the next
	//set of variables and values
	for (i = 0;i < i_length; i = (i+2))
	{
		//result means the value of the variable, it will always be second
		string s_result = llStringTrim(llList2String(s_desc2, i+1), STRING_TRIM);
		//token means the variable name, it will allways be first
		string s_token = llStringTrim(llList2String(s_desc2, i), STRING_TRIM);

		//--- Took this out because it would take too much server time to set values for
		//individual drawers, especially if there's a lot of them ---
		//--- (Also, I'm lazy... maybe in a future version) ---
		//if(token == "configuration")
		//{
		//if(result == "global") i_global = TRUE;
		//else if(result == "individual") i_global = FALSE;
		//else
		//{
		//llOwnerSay("Oops! configuration must be set to 'global' or 'individual.'");
		//i_proper_config = FALSE;
		//}
		//}

		//If we're storing the value for the 'axis' variable
		if(s_token == "axis")
		{
			//if the value for 'axis' is 'x,' 'y,' or 'z'
			if(s_result == "x" || s_result == "y" || s_result == "z") s_axis = s_result;

			//if not, they put an incorrect value in
			else
			{
				llOwnerSay("Oops! axis must be set to 'x,' y,' or 'z.'");
				//it's not going to run correctly, so let's stop them from using it
				i_proper_config = FALSE;
				//let's reset the touch time to something really low, so it's easy to
				//reset
				f_reset_touch_time = 0.1;
			}
		}

		//if we're storing the value for the 'offset' variable
		else if(s_token == "offset")
		{
			//temporary variable used later to check for a '-' symbol
			string s_offset = llList2String(s_desc2, i+1);
			//another temporary variable used to see if they put a '+' symbol (which isn't
			//allowed) in there.
			integer i4 = llSubStringIndex(s_offset, "+");
			//going ahead and setting the float as a float, to check and see if they
			//decided to put letters or symbols in it
			f_offset = llList2Float(s_desc2, i+1);
			//if they did put letters or symbols in it
			if(f_offset == 0.000000 || i4 != -1)
			{
				llOwnerSay("Oops! The offset value must be other than 0.000000 "
					+ "and must not contain any letters or special characters aside from a properly "
					+ "placed negative (-) symbol to indicate a reversed direction from the norm.");
				//it's not going to run correctly, so let's stop them from using it
				i_proper_config = FALSE;
				//let's reset the touch time to something really low, so it's easy to
				//reset
				f_reset_touch_time = 0.1;
			}

			//passed the symbol check, on to the next thing
			else
			{
				//i3 is used to see if there is a '-' symbol, along with the string version
				//of the float, which we saved earlier
				integer i3 = llSubStringIndex(s_offset, "-");
				//yep, there's a '-' symbol...
				if (i3 != -1)
				{
					//but it isn't at the beginning, where it's supposed to be.
					if(i3 != 1)
					{
						llOwnerSay("Oops! the negative symbol (-) can only be placed at the "
							+ "beginning of the float.");
						//it's not going to run correctly, so let's stop them from using it
						i_proper_config = FALSE;
						//let's reset the touch time to something really low, so it's easy to
						//reset
						f_reset_touch_time = 0.1;
					}

					//and the '-' symbol is at the beginning, where it's supposed to be.
					else
					{
						//gotta get rid of that pesky '-' symbol so it doesn't interfere with
						//our math later.
						s_offset = llDeleteSubString(s_offset, 0, i3);
						//okie dokie, got rid of it, now let's save the value for offset
						f_offset = (float)s_offset;
						//this is how we know there was originally a '-' symbol there
						i_is_backwards = TRUE;
					}
				}

				//can't move a prim more than ten meters, so let's reset it to ten if it's more
				if(f_offset > 10.00) f_offset = 10.00;
			}
		}

		//if we're storing the value for the 'touch time to reset' variable
		else if(s_token == "touch time to reset")
		{
			//gotta look for that '-' symbol again, this float isn't supposed to have it
			integer i3 = llSubStringIndex(llList2String(s_desc2, i+1), "-");
			//also gotta check if they put letters or other symbols in there. If not, we're good
			//to go
			f_reset_touch_time = llList2Float(s_desc2, i+1);

			//uh-oh, they put letters or symbols in there
			if(f_reset_touch_time == 0.000000 || i3 != -1)
			{
				llOwnerSay("Oops! The touch time to reset must be greater than 0.000000 "+
					"and must not contain any letters or special characters.");
				//it's not going to run correctly, so let's stop them from using it
				i_proper_config = FALSE;
				//let's reset the touch time to something really low, so it's easy to
				//reset
				f_reset_touch_time = 0.1;
			}
		}
	}

	//Let's leave this here for debugging purposes, but commented out
	/*llSay(0, "After For: axis is set to " + s_axis + "; offset is set to "
		+ (string) f_offset + "; i_is_backwards is set to " + (string)i_is_backwards
		+ "; i_proper_config is set to " + (string)i_proper_config + "; touch time to reset "
		+ "is set to: " +(string)f_reset_touch_time);*/
	}

default
{
	on_rez(integer start_param)
	{
		//we need to reset the script if it's just being rezzed.
		llResetScript();
	}

	state_entry()
	{
		llOwnerSay("Initializing drawer script...");
		//we don't want anyone to sit on this, so we'll set a sit target we can use later
		//to unsit the avatar so our dresser doesn't break
		llSitTarget(<0, 0, 0.1>, ZERO_ROTATION);
		//let's get the drawer list and positions as soon as we start up or reset
		get_drawers();
		//okay, now we have to get the configuration set-up
		get_config();
		if(!i_proper_config) llOwnerSay("...I seem to be configured incorrectly. Please fix "
			+ "me using the above error message or read the help card, then reset me by clicking me "
			+ "and holding for " + (string)f_reset_touch_time + " seconds.");
		else if (i_proper_config) llOwnerSay("...done.");
	}

	//whenever they touch it
	touch_start(integer total_number)
	{
		//Debugging purposes
		//llSay(0, "Link numbers with the name 'drawer': " + llDumpList2String(l_drawer_prims, ", "));
		//this is where the timer for the reset goes.
		if(llDetectedLinkNumber(0) == 1 && llDetectedKey(0) == llGetOwner())
		{ llSetTimerEvent(f_reset_touch_time); }
		//get the link number
		integer i_dln = llDetectedLinkNumber(0);
		//now we're going to actually check our drawer list and see if the prim's in there
		integer i_test = llListFindList(l_drawer_prims, [i_dln]);

		if (!i_proper_config && llDetectedKey(0) != llGetOwner()) llRegionSayTo(llDetectedKey(0), 0, "Sorry, but I wasn't "
			+ "configured properly, so I don't quite know where to move my bits and pieces to. "
			+ "Please talk to my owner," + llKey2Name(llGetOwner()) + " about this.");

		//if it's in the list AND the drawers are configured properly
		else if(i_test != -1 && i_proper_config)
		{
			//is the drawer opened or closed?
			string s_drawer_status = llList2String(l_drawer_prims, i_test+2);

			//if the drawer's closed
			if(s_drawer_status == "closed")
			{
				//we're going to make a temporary offset float so we don't overwrite
				//the original
				float f_temp_offset = f_offset;

				//if they used a negative float for the offset
				if(i_is_backwards) f_temp_offset = (0.0-f_temp_offset);
				//if they used a positive float for the offset
				else f_temp_offset = f_offset;

				//if they want it moved on the x axis
				if(s_axis == "x")
				{
					//let's retrieve the position info from our handy-dandy list
					vector v_link_position = llList2Vector(l_drawer_prims, i_test+1);
					//now we need to update the x value of the drawer's position
					//to reflect the offset they want
					v_link_position.x = v_link_position.x+f_temp_offset;
					//and finally we move it
					llSetLinkPrimitiveParamsFast(i_dln, [PRIM_POSITION, v_link_position]);
				}

				//if they want it moved on the x axis
				else if(s_axis == "y")
				{
					//let's retrieve the position info from our handy-dandy list
					vector v_link_position = llList2Vector(l_drawer_prims, i_test+1);
					//now we need to update the y value of the drawer's position
					//to reflect the offset they want
					v_link_position.y = v_link_position.y+f_temp_offset;
					//and finally we move it
					llSetLinkPrimitiveParamsFast(i_dln, [PRIM_POSITION, v_link_position]);
				}

				else if(s_axis == "z")
				{
					//let's retrieve the position info from our handy-dandy list
					vector v_link_position = llList2Vector(l_drawer_prims, i_test+1);                                 //now we need to update the y value of the drawer's position
					//to reflect the offset they want
					v_link_position.z = v_link_position.z+f_temp_offset;
					//and finally we move it
					llSetLinkPrimitiveParamsFast(i_dln, [PRIM_POSITION, v_link_position]);

				}

				//last in this section, we update the list to reflect our shiny new 'open' status
				l_drawer_prims = llListReplaceList(l_drawer_prims, ["open"], i_test+2, i_test+2);
			}

			//if the drawer is open
			else if(s_drawer_status == "open")
			{
				//let's retrieve what the drawer's position is supposed to be
				vector v_link_position = llList2Vector(l_drawer_prims, i_test+1);
				//let's move the drawer back to where it belongs
				llSetLinkPrimitiveParamsFast(i_dln, [PRIM_POSITION, v_link_position]);
				//then let's update the status of our drawer
				l_drawer_prims = llListReplaceList(l_drawer_prims, ["closed"], i_test+2, i_test+2);
			}
		}
	}

	//When the person releases the mouse from touching the object
	touch_end(integer num_detected)
	{
		//make it so we don't have a timer event any more (saves on memory in the long run)
		//(of course, we're about to reset the script, so it doesn't really matter, but
		//it never hurts to get in good practice)
		llSetTimerEvent(0.0);

		//if they held the touch for the entire reset script touch time
		if (i_touch_held == TRUE) llResetScript();
	}

	timer()
	{
		//lets them know that they can release their hold now
		llOwnerSay("Release me to reset the script.");
		//sets the touch held integer to true so the script will reset on touch end
		i_touch_held = TRUE;
		//again, good practice to reset the timer, even if we won't be using it
		llSetTimerEvent(0.0);
	}

	//if the person has changed the object
	changed(integer change)
	{
		//if the person has linked or de-linked the object, or if an avatar has sat on the object
		if(change & CHANGED_LINK)
		{
			//originally added to give the server time to adjust to someone sitting on this
			llSleep(0.5);
			//gets the avatar key from the SitTarget function used earlier...
			key k_avatar_key = llAvatarOnSitTarget();
			//...if an avatar is sitting on it, then we unsit him. Bad av!
			if (k_avatar_key) llUnSit(k_avatar_key);
			else
			{
				llOwnerSay("Remapping drawers...");
				get_drawers();
				llOwnerSay("Re-evaluating configuration...");
				if (i_proper_config) llOwnerSay("...done.");
				else llOwnerSay("...I seem to be configured incorrectly. Please fix "
					+ "me using the above error message or read the help card, then reset me by clicking me "
					+ "and holding for " + (string)f_reset_touch_time + " seconds.");
			}
		}
	}
}