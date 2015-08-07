// :CATEGORY:Building
// :NAME:Linkset_Resizer
// :AUTHOR:Brilliant Scientist
// :CREATED:2010-11-16 11:01:07.077
// :EDITED:2013-09-18 15:38:56
// :ID:475
// :NUM:642
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Linkset_Resizer
// :CODE:
// Linkset Resizer with Menu
// version 1.00 (25.04.2010)
// by: Brilliant Scientist
// --
// This script resizes all prims in a linkset, the process is controlled via a menu.
// The script works on arbitrary linksets and requires no configuration.
// The number of prims of the linkset it can process is limited only by the script's memory.
// The script is based on "Linkset Resizer" script by Maestro Linden.
// http://wiki.secondlife.com/wiki/Linkset_resizer
// This script still doesn't check prim linkability rules, which are described in:
// http://wiki.secondlife.com/wiki/Linkability_Rules
// Special thanks to:
// Ann Otoole
 
float MIN_DIMENSION=0.01; // the minimum scale of a prim allowed, in any dimension
float MAX_DIMENSION=10.0; // the maximum scale of a prim allowed, in any dimension
 
float max_scale;
float min_scale;
 
float   cur_scale = 1.0;
integer handle;
integer menuChan;
 
float min_original_scale=10.0; // minimum x/y/z component of the scales in the linkset
float max_original_scale=0.0; // minimum x/y/z component of the scales in the linkset
 
list link_scales = [];
list link_positions = [];
 
makeMenu()
{
	llListenRemove(handle);
	menuChan = 50000 + (integer)llFrand(50000.00);
	handle = llListen(menuChan,"",llGetOwner(),"");
 
	//the button values can be changed i.e. you can set a value like "-1.00" or "+2.00"
	//and it will work without changing anything else in the script
	llDialog(llGetOwner(),"Max scale: "+(string)max_scale+"\nMin scale: "+(string)min_scale+"\n \nCurrent scale: "+
        (string)cur_scale,["-0.05","-0.10","-0.25","+0.05","+0.10","+0.25","MIN SIZE","RESTORE","MAX SIZE","DELETE..."],menuChan);
}
 
integer scanLinkset()
{
	integer link_qty = llGetNumberOfPrims();
	integer link_idx;
	vector link_pos;
	vector link_scale;
 
	//script made specifically for linksets, not for single prims
	if (link_qty > 1)
	{
		//link numbering in linksets starts with 1
		for (link_idx=1; link_idx <= link_qty; link_idx++)
		{
			link_pos=llList2Vector(llGetLinkPrimitiveParams(link_idx,[PRIM_POSITION]),0);
			link_scale=llList2Vector(llGetLinkPrimitiveParams(link_idx,[PRIM_SIZE]),0);
 
			// determine the minimum and maximum prim scales in the linkset,
			// so that rescaling doesn't fail due to prim scale limitations
			if(link_scale.x<min_original_scale) min_original_scale=link_scale.x;
			else if(link_scale.x>max_original_scale) max_original_scale=link_scale.x;
			if(link_scale.y<min_original_scale) min_original_scale=link_scale.y;
			else if(link_scale.y>max_original_scale) max_original_scale=link_scale.y;
			if(link_scale.z<min_original_scale) min_original_scale=link_scale.z;
			else if(link_scale.z>max_original_scale) max_original_scale=link_scale.z;
 
			link_scales    += [link_scale];
			link_positions += [(link_pos-llGetRootPosition())/llGetRootRotation()];
		}
	}
	else
	{
		llOwnerSay("error: this script doesn't work for non-linked objects");
		return FALSE;
	}
 
	max_scale = MAX_DIMENSION/max_original_scale;
	min_scale = MIN_DIMENSION/min_original_scale;
 
	return TRUE;
}
 
resizeObject(float scale)
{
	integer link_qty = llGetNumberOfPrims();
	integer link_idx;
	vector new_size;
	vector new_pos;
 
	if (link_qty > 1)
	{
		//link numbering in linksets starts with 1
		for (link_idx=1; link_idx <= link_qty; link_idx++)
		{
			new_size   = scale * llList2Vector(link_scales, link_idx-1);
			new_pos    = scale * llList2Vector(link_positions, link_idx-1);
 
			if (link_idx == 1)
			{
				//because we don't really want to move the root prim as it moves the whole object
				llSetLinkPrimitiveParamsFast(link_idx, [PRIM_SIZE, new_size]);
			}
			else
			{
				llSetLinkPrimitiveParamsFast(link_idx, [PRIM_SIZE, new_size, PRIM_POSITION, new_pos]);
			}
		}
	}
}
 
default
{
	state_entry()
	{
		if (scanLinkset())
		{
			//llOwnerSay("resizer script ready");
		}
		else
		{
			llRemoveInventory(llGetScriptName());
		}
	}
 
	touch_start(integer total)
	{
		if (llDetectedKey(0) == llGetOwner()) makeMenu();
	}
 
	listen(integer channel, string name, key id, string msg)
	{
		//you can never be too secure
		if (id == llGetOwner())
		{
			if (msg == "RESTORE")
			{
				cur_scale = 1.0;
			}
			else if (msg == "MIN SIZE")
			{
				cur_scale = min_scale;
			}
			else if (msg == "MAX SIZE")
			{
				cur_scale = max_scale;
			}
			else if (msg == "DELETE...")
			{                
                           llDialog(llGetOwner(),"Are you sure you want to delete the resizer script?", 
                           ["DELETE","CANCEL"],menuChan);
                           return;				
			}				
			else if (msg == "DELETE")
			{                
                           llOwnerSay("deleting resizer script...");
			   llRemoveInventory(llGetScriptName());				
			}			
			else
			{
			    cur_scale += (float)msg;
			}
 
			//check that the scale doesn't go beyond the bounds
			if (cur_scale > max_scale) { cur_scale = max_scale; }
			if (cur_scale < min_scale) { cur_scale = min_scale; }
 
			resizeObject(cur_scale);
		}
	}
}
