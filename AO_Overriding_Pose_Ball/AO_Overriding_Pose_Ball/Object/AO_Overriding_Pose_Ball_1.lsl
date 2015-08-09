// :CATEGORY:Pose Balls
// :NAME:AO_Overriding_Pose_Ball
// :AUTHOR:jesse barnett
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:47
// :ID:47
// :NUM:65
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Tired of having to turn your animation overrider off and on whenever you want to sit on a poseball? Just drop this script in along with the pose and it will automatically stop your active animations. When you stand up, your AO will still be running and active. 
// :CODE:
//AO Overrider Pose Ball Script V 1.2
//Updated 11/09/2006
//Created by Jesse Barnett
//Edited to check if there is an animation to stop
//and Sit Position is stored in Object Description
//Drop this in a prim along with an animation. Store the sit
//position in the Object description
//Example;          <0.0, 0.0, 1.0>
//If you change this then reset the script by using right
//click/reset for changes to apply immediately. If you forget then it will display
//"reset script" when you sit. Just stand and sit again for changes to take effect
 
 
//To see how it works and hear it go through the animations it is stopping, then
//make idebug = TRUE;
integer idebug = FALSE;//if TRUE then llOwnerSay sdebugs
string sdebug;
integer perm;//permissions
string anim2run;//animation in inventory
vector sit_pos;//adjust as needed in object description Example: <0.0, 0.0, 1.0>
list anims2stop;//default or AO sit animation
float sleep = 0.5;//duration of llSleep in seconds
 
debug(){
	if(idebug == 1)
		llOwnerSay(sdebug);
}
 
sit_desc_change(){
	if((sit_pos + (vector)llGetObjectDesc()) != (sit_pos* 2))
		llResetScript();
	//This checks to see if the description field matchs the stored position
	else
		llSitTarget(sit_pos, ZERO_ROTATION);
}
 
stop_anim(){
	integer list_pos = 0;
	integer list_length = llGetListLength(anims2stop);
	sdebug = (string)list_length;
	debug();
	if(list_length > 0){
		while(list_pos < list_length){
			llStopAnimation(llList2String(anims2stop, list_pos));
			sdebug = (string)list_pos;
			debug();
			list_pos++;
		}
	}
}
 
default{
	state_entry(){
		llSetTouchText("Reset");
		llOwnerSay("Script Reset.");
		anim2run=llGetInventoryName(INVENTORY_ANIMATION,0)    ;
		sit_pos = (vector)llGetObjectDesc();
		sit_desc_change();
		perm=llGetPermissions();
	}
 
	touch_start(integer num_detected) {
		llResetScript();
	}
 
	changed(integer change){
		if (change & CHANGED_LINK)
			if (llAvatarOnSitTarget() != NULL_KEY){
				llRequestPermissions(llAvatarOnSitTarget(), PERMISSION_TRIGGER_ANIMATION);
			}
 
		else{
			perm=llGetPermissions();
			if ((perm & PERMISSION_TRIGGER_ANIMATION) && llStringLength(anim2run)>0)
				llStopAnimation(anim2run);
			llSetAlpha(1.0, ALL_SIDES);
		}
	}
	run_time_permissions(integer perm){
		if (perm & PERMISSION_TRIGGER_ANIMATION)
			anims2stop = [];//Clears the list
		sdebug = "perms granted";
		llStopAnimation("sit");
		llSleep(sleep);//need sleep to give avatar time to cycle from stand
		//to default sit to AO sit
		anims2stop = llGetAnimationList(llAvatarOnSitTarget());
		sdebug = llList2CSV(anims2stop);
		debug();
		stop_anim();//This runs the subroutine up top .
		llSetAlpha(0.0, ALL_SIDES);
		llStartAnimation(anim2run);
		sdebug = "anim2run started";
		debug();
	}
}
 
