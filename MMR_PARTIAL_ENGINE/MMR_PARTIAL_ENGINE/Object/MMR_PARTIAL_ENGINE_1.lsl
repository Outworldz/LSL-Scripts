// :CATEGORY:Vehicle
// :NAME:MMR_PARTIAL_ENGINE
// :AUTHOR:HESKEMO OYEN
// :CREATED:2010-10-04 01:48:28.093
// :EDITED:2013-09-18 15:38:57
// :ID:517
// :NUM:701
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// THERE IS NO SOUND NOR ANIMATIONS UUIDS
// :CODE:
//HKM GEARS TM
//PC Engine V-Tec
//by HESKEMO
//Date: 9/23/2010//
integer debug = FALSE;

//Basic settings
float       ForwardPower; //Forward power
list        ForwardPowerGears =[-10,-5,0,5,10,30,40,50,60,70,90];
float       ReversePower = -5; //Reverse power
list        TurnPowerL = [5,10,40,60];
float       TurnPower; //Turning power
//float       TurnPower = 100; //Turning power
float       TurnSpeedAdjust = 0.1; //how much
//effect speed has on turning, higher numbers effect more. 0.0 to disable
//====================CHANNELS
integer mainoutputchannel = 90081;
integer permscontrol_uuids = 90082;
integer resetscript = 90083;
integer config_constrainexport = 90084;
integer configimport = 90085;
integer configexport = 90086;
//===================CHANNELS END
float       aPower = 2000.0;
string      forwarddiection="Y";
integer     showvectors=FALSE;
//Other variables
vector      sittarget_pos = <.990,.5,0.83>;
vector      sittarget_rot = <0,0.00,0.00>;
float backupcameradistance = 5.2;
float dcamera_boosting = 7.3;
float backupCamera_release = 10.3;
float dcamera_norm=7.9;
float angle_norm=-35;
//==========================================================================
float       FlightForwardPower = 24;
float       FlightReversePower = 16;
float       FlightUpPower = 14;
float       FlightDownPower = 14;
float       FlightStrafePower = 12;
float       FlightTurnPower = 4;
string      SitText = "Lets Roll"; //Text to show on pie menu
string      NonOwnerMessage = "The car alarm is triggered. Ask the owner to get the car key start off the car."; //Message when someone other than owner tries to sit
//============PERMISSIONS
key 		agent;
key 		objectowner;
integer 	group;
integer 	permissionOptions = 0;
string      OwnerName;
list		accesslistuuids;
//======================================
integer     ListenCh = 0;
string      HornCommand = "h";
string      RevCommand = "r";
string      IdleCommand = "i";
string      StopCommand = "s";
string      FlightCommand = "fly";
string      GroundCommand = "drive";
string      LockCommand = "lock";
string        Accessdeny="";
string      FlightSound = "";
string      HornSound = "";
string      IdleSound = ""; //Sound to play when idling
string      RunSound = ""; //Sound to play when the gas in pressed
string      RunSoundaggressive = "6685b122-cdf5-786f-5b64-7d1a2e633a06"; //started from 3th gear
string        Run_gearUp = "";
string      RevSound = "";
string      StartupSound = ""; /  Sound to play when owner sits
string      DrivingAnim = "driving generic"; //Animation to play when owner sits

//==========================================================================
//Other variables
key         Owner;
integer     NumGears;
integer     Gear = 0;
integer     Gear2nd = 0;
integer     NewSound;
string      Sound;
integer     CurDir;
integer     LastDir;
integer     Forward;
vector      SpeedVec;
vector      Linear;
vector      Angular;
integer     Active;
key         sitting;
integer     Moving;
string      SimName;
float		velocity;
integer     DIR_STOP = 100;
integer     DIR_START = 101;
integer     DIR_NORM = 102;
integer     DIR_LEFT = 103;
integer     DIR_RIGHT = 104;
integer     DIR_FLIGHT = 105;
integer     listeningnum = -596;
//          channel
integer     DIE_ENGINE = -131;
float       camDrivDistance = 3.3;
//=======================BASIC MENU CODINGS
deBug(string k){
	if(debug){
		llSay(DEBUG_CHANNEL,k);
	}
}
permcontrol(string c, key h){
	if(c=="adduuid")accesslistuuids=addUsersUUID(h,accesslistuuids);
	if(c=="removeid")accesslistuuids=removeUsersUUID(h,accesslistuuids);
}
list addUsersUUID(key id, list l){ // ADD SINGLE UUID TO THE LIST AND CHECK FOR DUPLICATIONS
	list p = l;
	if(llListFindList(p,[id])==-1 && id!= NULL_KEY){
		p = p+[id];
	}
	return p;
}
list removeUsersUUID(key id,list l){
	list p = l ;
	integer h  =llListFindList(p,[id]);
	if(h!=-1){
		p = llDeleteSubList(p,h,h);
	}
	return p;
}
integer getPermUser(key id){ // THROW IN AN UUID AND SEE IF THE PERSON IS ALLOWED OR NOT
	group = llDetectedGroup(0); // Is the Agent in the objowners group?
	agent = id;   	//llDetectedKey(0);    // Agent's key
	Owner = llGetOwner(); // objowners key
	integer A= FALSE;
	integer B= FALSE;
	integer C= FALSE;
	integer D= FALSE;
	integer E=(objectowner == id);
	integer F=(id!=NULL_KEY);
	if(permissionOptions==0){// 0 for owner only
		A =E;
	}
	if(permissionOptions==1){// 1 for group only
		B=group;
	}
	if(permissionOptions==2){// 2 for the public
		C = TRUE;
	}
	if(permissionOptions==3){// 3 for the accesslist
		integer i = llListFindList(accesslistuuids,[id]);
		if(i!=-1)D = TRUE;
	}
	return E||A||B||C||D&&F;
}

//========================================PERMISSION OPTIONS
CAMERAFunction(){

	llSetCameraParams([
		CAMERA_ACTIVE, 1, // 1 is active, 0 is inactive
		CAMERA_BEHINDNESS_ANGLE, 2.0, // (0 to 180) degrees
		CAMERA_BEHINDNESS_LAG, 0.1, // (0 to 3) seconds
		CAMERA_DISTANCE, 8.0, // ( 0.5 to 10) meters
		// CAMERA_FOCUS, <0,0,0>, // region-relative position
		CAMERA_FOCUS_LAG, 0.1 , // (0 to 3) seconds
		CAMERA_FOCUS_LOCKED, FALSE, // (TRUE or FALSE)
		CAMERA_FOCUS_THRESHOLD, 0.5, // (0 to 4) meters
		CAMERA_PITCH, 20.0, // (-45 to 80) degrees
		// CAMERA_POSITION, <0,0,0>, // region-relative position
		CAMERA_POSITION_LAG, 0.1, // (0 to 3) seconds
		CAMERA_POSITION_LOCKED, FALSE, // (TRUE or FALSE)
		CAMERA_POSITION_THRESHOLD, 0.5, // (0 to 4) meters
		CAMERA_FOCUS_OFFSET, <0.10,0,0> // <-10,-10,-10> to <10,10,10> meters
			]);

	//             llSetCameraEyeOffset(<-2, 0, 1>);
	// the camera is 2m behind and 1m above the object

	//        llSetCameraAtOffset(<2, 0, 1>);

	// and looks at a point that is 2m in front and 1m above the object

	// sitting on this object will now place your camera
	// so it's looking straight ahead on a line parallel
	// to the objects x (forward) axis, 1m above the objects center.

}

VEHICLEFunction(){
	integer s1 =VEHICLE_FLAG_HOVER_WATER_ONLY | VEHICLE_FLAG_HOVER_TERRAIN_ONLY | VEHICLE_FLAG_HOVER_GLOBAL_HEIGHT;
	integer s2 = VEHICLE_FLAG_NO_DEFLECTION_UP | VEHICLE_FLAG_LIMIT_ROLL_ONLY | VEHICLE_FLAG_HOVER_UP_ONLY | VEHICLE_FLAG_LIMIT_MOTOR_UP;
	llSetVehicleType(VEHICLE_TYPE_CAR);
	llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 0.80);
	llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 1.0);

	llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 0.2);
	llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, 0.1);

	llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_TIMESCALE, 1.0);
	llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 0.1);

	llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_TIMESCALE, 0.3);
	llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, 0.2);

	llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <100.0, 2.0, 1000.0> );
	llSetVehicleVectorParam(VEHICLE_ANGULAR_FRICTION_TIMESCALE, <aPower, aPower, 1000.0> );

	llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, 0.0);
	llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 300.0);

	llSetVehicleFloatParam(VEHICLE_HOVER_HEIGHT, 0 );
	llSetVehicleFloatParam(VEHICLE_HOVER_EFFICIENCY, 0 );
	llSetVehicleFloatParam(VEHICLE_HOVER_TIMESCALE, 1000 );
	llSetVehicleFloatParam(VEHICLE_BUOYANCY, 0 );
	llSetVehicleRotationParam(VEHICLE_REFERENCE_FRAME, <0.00000, 0.00000, 0.00000, 0.332000>);
	llRemoveVehicleFlags(s1);
	llSetVehicleFlags(s2);
}
gearUP(integer g){
	TurnPower= llList2Integer(TurnPowerL,1);
	//if((g-Gear2nd)>2){
	//    llTriggerSound(RunSoundaggressive,1.0);
	//}
	//Gear2nd = g;
	//llSleep(1.0);
	//    Gear2nd = 0;
	if(g>2){
		//llSetCameraParams([CAMERA_FOCUS_OFFSET, <2.50,0,0>]);
	}
}
gearDOWN(integer g){
	//llSetCameraParams([CAMERA_FOCUS_OFFSET, <4.50,0,0>]);
	TurnPower= llList2Integer(TurnPowerL,2);
	//Gear2nd = -1;
	//llSleep(1.0);
	//Gear2nd = 0;
	if(g>2){
		//llSetCameraParams([CAMERA_FOCUS_OFFSET, <4.50,0,0>]);
	}
}
gearSignal(integer g){
	if(g == 2)
	{
		signaldata( "///<<PARK - (E) BRAKE>>///");
		llSetStatus(STATUS_PHYSICS, FALSE);
		Moving = 0;
		Linear.x = 0;
		vector rot = llRot2Euler(llGetRot());
		llSetRot(llEuler2Rot(<0,0,rot.z>));
		NewSound = 1;
	}
	else if(!Moving)
	{
		Moving = 1;
		llSetStatus(STATUS_PHYSICS, TRUE);
		//if(debug)llOwnerSay("unfreeze");
	}
	//if(g == 5)llSetCameraParams([CAMERA_FOCUS_OFFSET, <8.10,0,0>]);
	if(g > 2){signaldata("GEAR " + (string)(g - 2));
		llSetCameraParams([CAMERA_BEHINDNESS_ANGLE,0.0]);
		llSetCameraParams([CAMERA_DISTANCE,2.8]);
	}
	if(g < 2){signaldata("GEAR REVERSE : R" + (string)llFabs(g - 2));
		llSetCameraParams([CAMERA_BEHINDNESS_ANGLE,-45.0]);
		llSetCameraParams([CAMERA_DISTANCE,8.0]);
		//llSetCameraParams([CAMERA_FOCUS,<>]
	}
	ForwardPower = llList2Float(ForwardPowerGears, g);
	if(Linear.x > 0) Linear.x = ForwardPower;
}
preloadingsounds(){
	llSetText("Preloading....",<1,0,0>,1);
	llPreloadSound(FlightSound);
	llPreloadSound(HornSound);
	llPreloadSound(IdleSound);
	llPreloadSound(RunSound);
	llPreloadSound(RevSound);
	llPreloadSound(StartupSound);
	//llPreloadSound();
	llSetText("DONE",<0,0,1>,1);
	llSetText("",<1,1,1>,1);
}
int(){
	//Owner = llGetOwner();
	//OwnerName = llKey2Name(Owner);
	TurnSpeedAdjust *= 0.01;
	Gear = 3;
	ForwardPower = llList2Integer(ForwardPowerGears, 3);
	NumGears = llGetListLength(ForwardPowerGears);
	TurnPower= llList2Integer(TurnPowerL,1);
	llSetSitText(SitText);
	llCollisionSound("", 0.0);
	llSitTarget(sittarget_pos, llEuler2Rot(DEG_TO_RAD*sittarget_rot));
	llStopSound();
	exportconfiguration();
}
signaldata(string k){
	llMessageLinked(LINK_SET,mainoutputchannel,k,NULL_KEY);
	llSetText(k+"\n.\n.\n.\n.",<1,1,.6>,1.0);
	llSleep(5.0);
	llSetText("",<0,0,0>,1.0);
}
activecheck(){
	if(!Active){
		llSetStatus(STATUS_PHYSICS, FALSE);
		llMessageLinked(LINK_ALL_CHILDREN , DIR_STOP, "", NULL_KEY);
		//llSay(listeningnum,(string)DIR_STOP);
		llUnSit(llAvatarOnSitTarget());
		llSetRot(ZERO_ROTATION);
		llStopSound();
	}else{
			SimName = llGetRegionName();
		llMessageLinked(LINK_ALL_CHILDREN, DIR_START, "", NULL_KEY);
		//llSay(listeningnum,(string)DIR_START);
		llMessageLinked(LINK_ALL_CHILDREN, DIR_NORM, "", NULL_KEY);
		//llSay(listeningnum,(string)DIR_NORM);
		NewSound = 1;
		Sound = IdleSound;
		Linear = <0,0,-2>;
	}
}
vector vaildation_vector(string n)
{
	vector vec;
	integer length = llStringLength(n);
	string n0 = llGetSubString(n,0,0);
	string n1 = llGetSubString(n,length-1,length);
	if(n0=="<" && n1==">"){
		vec=(vector)llGetSubString(n,0,-1);
		return vec;
	}else{
			deBug("Cannot vaild the vector value: '"+n+"' misses '<' or '>'");
		return ZERO_VECTOR;
	}
}
exportconfiguration(){
	string n;
	//     vector   0             vector   1               string X/Y   2              float     3                    float     4             integer 5   		         string 2 list 6
	n=(string)sittarget_pos+";"+(string)sittarget_rot+";"+forwarddiection+";"+(string)backupcameradistance+";"+(string)backupCamera_release+";"+(string)showvectors+";"+(string)llList2CSV(accesslistuuids);
	llMessageLinked(LINK_SET,configexport,n,NULL_KEY);
}
vel_anaylsis(){
	velocity = llVecMag(llGetVel());

}
default
{
	state_entry()
	{
		int();
		state Ground;
	}
}
state Ground
{
	link_message(integer s, integer n, string m, key id)
	{
		if(n==configimport){ // IMPORT CONFIGURATIONS TO THE CAR
			llSetText("Sync....\n.\n.\n.\n.\n.\n.\n.\n.\n.",<1,0,0>,1);
			list cl;
			cl = llParseString2List(m,[";"],[]);
			sittarget_pos=vaildation_vector(llList2String(cl,0));
			sittarget_rot=vaildation_vector(llList2String(cl,1));
			forwarddiection=llList2String(cl,2);
			backupcameradistance=llList2Float(cl,3);
			backupCamera_release=llList2Float(cl,4);
			showvectors=llList2Integer(cl,5);
			permissionOptions=llList2Integer(cl,6);
			int();
			llSetText("",<1,0,0>,1);
		}
		if(n==config_constrainexport)exportconfiguration();
		if(n==resetscript)llResetScript();
		if(n==permscontrol_uuids){permcontrol(m,id);}
	}
	state_entry()
	{
		llListen(ListenCh, llKey2Name(llGetOwner()), NULL_KEY, "");
		activecheck();
		VEHICLEFunction();
	}
	on_rez(integer param)
	{
		preloadingsounds();
	}
	changed(integer change)
	{
		if((change & CHANGED_LINK) == CHANGED_LINK)
		{
			sitting = llAvatarOnSitTarget();
			if((sitting != NULL_KEY) && !Active) //ready to drive it
			{
				if(getPermUser(sitting)) //reject others
				{
					llWhisper(0, NonOwnerMessage);
					llTriggerSound(Accessdeny,1.0);
					llUnSit(sitting);
				}else{
						llRequestPermissions(sitting, PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS | PERMISSION_CONTROL_CAMERA);
					llTriggerSound(StartupSound, 1.0);
					llMessageLinked(LINK_ALL_CHILDREN, DIR_START, "", NULL_KEY);
					//llSay(listeningnum,(string)DIR_START);
					llSetPos(llGetPos() + <1,0,1.5>);
					llSetStatus(STATUS_PHYSICS, TRUE);
					SimName = llGetRegionName();
					llLoopSound(IdleSound,1);
					llSetTimerEvent(0.1);
					CurDir = DIR_NORM;
					LastDir = DIR_NORM;
				}
			}
			else if((sitting == NULL_KEY) && Active) // unsit and turn the car off
			{
				llSetTimerEvent(0.0);
				llStopAnimation(DrivingAnim);
				Active = 0;
				llStopSound();
				//llSetRot(z);
				llSetStatus(STATUS_PHYSICS, FALSE);
				llMessageLinked(LINK_ALL_CHILDREN , DIR_STOP, "", NULL_KEY);
				//llSay(listeningnum,(string)DIR_STOP);
				llReleaseControls();
			}
		}
	}

	run_time_permissions(integer perms)
	{
		if(perms == (PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS | PERMISSION_CONTROL_CAMERA))
		{
			Active = 1;
			Linear = <0,0,-2>;
			Angular = <0,0,0>;
			llStopAnimation("sit");
			llStartAnimation(DrivingAnim);
			llTakeControls(CONTROL_FWD | CONTROL_BACK | CONTROL_DOWN | CONTROL_UP | CONTROL_RIGHT | CONTROL_LEFT | CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT, TRUE, FALSE);
			CAMERAFunction();
		}
	}

	control(key id, integer levels, integer edges)
	{
		SpeedVec = llGetVel() / llGetRot();
		if((edges & levels & CONTROL_UP))
		{
			if(Gear<NumGears)
			{
				++Gear;
				if(!llGetStatus(STATUS_PHYSICS))llSetStatus(STATUS_PHYSICS, TRUE);
				gearSignal(Gear);
				gearUP(Gear);
			}
		}else if((edges & levels & CONTROL_DOWN))
	{
		if(Gear > 0)
		{
			--Gear;
			gearSignal(Gear);
			gearDOWN(Gear);
		}
	}
		if((edges & levels & CONTROL_FWD))
		{

			if(!Moving && Gear!=2){
				Moving = 1;
				llSetStatus(STATUS_PHYSICS, TRUE);
				Linear.x = ForwardPower;
				NewSound = 1;
				llSetCameraParams([CAMERA_BEHINDNESS_ANGLE,-55.0]);
				llSetCameraParams([CAMERA_DISTANCE,dcamera_boosting]);
				llSleep(3.0);
				llSetCameraParams([CAMERA_BEHINDNESS_ANGLE,angle_norm]);
				llSetCameraParams([CAMERA_DISTANCE,dcamera_norm]);
			}
			if(Moving){
				Linear.x = ForwardPower;
				NewSound = 1;
			}
			//llSetVehicleVectorParam(VEHICLE_ANGULAR_FRICTION_TIMESCALE, <aPower, aPower, 1000.0> );
		}else if((edges & ~levels & CONTROL_FWD))
	{
		//if(debug)llOwnerSay("release");
		if(Linear.x>0){
			Linear.x -= ForwardPower;
		}else{Linear.x=0;}
		NewSound = 1;
	}

		if((edges & levels & CONTROL_BACK))
		{
			llSetCameraParams([CAMERA_DISTANCE, backupcameradistance]);
			//llSetCameraParams([CAMERA_FOCUS_LAG, 0.3]);
		}else if((edges & ~levels & CONTROL_BACK))
	{
		llSetCameraParams([CAMERA_DISTANCE, backupCamera_release]);
		//llSetCameraParams([CAMERA_FOCUS_LAG, 0.1]);

		// llSetCameraParams([CAMERA_FOCUS_OFFSET, <0,0,0>]);
		//Linear.x -= ReversePower;
		//NewSound = 1;
	}else if((~edges & levels & CONTROL_BACK)){
			if((Linear.x-2)>0){
				Linear.x -=2;
			}else{Linear.x = 0;}

	}
		if(NewSound)
		{
			if(Linear.x==0)Sound = IdleSound;
			else{
				if(Linear.x<30) Sound = RunSound;
				else if (Linear.x>=30) Sound =     RunSoundaggressive;
			}
		}
		if(llFabs(SpeedVec.x) < 1.5)
		{
			if(levels & CONTROL_ROT_LEFT) CurDir = DIR_LEFT;
			else if(levels & CONTROL_ROT_RIGHT) CurDir = DIR_RIGHT;
			else CurDir = DIR_NORM;
			Angular.z = 0.0;
		}else{
				if(SpeedVec.x < 0.0){
					Forward = -1;
					SpeedVec.x *= -TurnSpeedAdjust;
				}else{
						Forward = 1;
					SpeedVec.x *= TurnSpeedAdjust;
				}
			if(levels & CONTROL_ROT_LEFT){
				CurDir = DIR_LEFT;
				//if(debug)llOwnerSay("L: .x:"+(string)SpeedVec.x+" tunring:"+(string)(TurnPower - SpeedVec.x));
				Angular.z = (TurnPower - SpeedVec.x) * Forward;
			}else if((edges & ~levels & CONTROL_ROT_LEFT)){
					CurDir = DIR_NORM;
				Angular.z = 0;
				// llSetCameraParams([CAMERA_FOCUS_OFFSET, <0,0,0>]);

			}else if ((edges & levels & CONTROL_ROT_LEFT)){
					//llSetCameraParams([CAMERA_FOCUS_OFFSET, <4.50,-2,0>]);
				}
			if(levels & CONTROL_ROT_RIGHT){
				CurDir = DIR_RIGHT;
				//if(debug)llOwnerSay("R: .x:"+(string)SpeedVec.x+" tunring:"+(string)(TurnPower - SpeedVec.x));
				Angular.z = -((TurnPower - SpeedVec.x) * Forward);
			}else if((edges & ~levels & CONTROL_ROT_RIGHT)){
					CurDir = DIR_NORM;
				Angular.z = 0;
				// llSetCameraParams([CAMERA_FOCUS_OFFSET, <0,0,0>]);
			}else if((edges & levels & CONTROL_ROT_RIGHT)){
					// llSetCameraParams([CAMERA_FOCUS_OFFSET, <4.50,2,0>]);
				}
		}
	}

	moving_end()
	{
		if(llGetRegionName() == SimName)
		{
			Moving = 0;
			llSetStatus(STATUS_PHYSICS, FALSE);
			//llOwnerSay("Region Hit "+SimName);
		}else{
				SimName = llGetRegionName();
		}
	}

	timer()
	{
		if(Linear != <0.0,  0.0, -2.0>)
		{
			llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, Linear);
			llApplyImpulse(Linear, TRUE);
		}
		if(Angular != <0.0, 0.0, 0.0>) llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, Angular);
		if(CurDir != LastDir)
		{
			llMessageLinked(LINK_ALL_CHILDREN, CurDir, "", NULL_KEY);
			llSay(listeningnum,(string)CurDir);
			LastDir = CurDir;
		}
		if(NewSound)
		{
			llStopSound();
			NewSound = 0;
			llLoopSound(Sound, 1.0);
		}
		if(showvectors){
			llSetText("linear vec:"+(string)Linear+"\n speedvec:"+(string)SpeedVec+"\n angular:"+(string)Angular+"\n.\n.\n.\n.\n.\n.",<1,1,1>,1.0);
		}else{
				llSetText("",<1,1,1>,1.0);
		}
	}
	listen(integer channel, string name, key id, string message)
	{
		if((channel == DIE_ENGINE) && Active && (message == FlightCommand))state Flight;
		if((channel == DIE_ENGINE) && Active && (message == LockCommand))state Lock;
		if(llGetOwnerKey(id) != Owner) return;
		message = llToLower(message);
		if(message == HornCommand) llMessageLinked(LINK_SET, 12345, HornSound, NULL_KEY);
		else if(message == RevCommand) llMessageLinked(LINK_SET, 12345, RevSound, NULL_KEY);
		else if(message == IdleCommand) llLoopSound(IdleSound, 1.0);
		else if(message == StopCommand) llStopSound();
		else if((message == FlightCommand) && Active) state Flight;
	}
}


state Lock
{
	state_entry()
	{   Linear = <0,0,0>;
			llStopSound();
			llMessageLinked(LINK_ALL_CHILDREN, DIR_FLIGHT, "", NULL_KEY);
			llSay(listeningnum,(string)DIR_FLIGHT);
			llLoopSound(FlightSound, 1.0);
			llSetStatus(STATUS_PHYSICS, FALSE);
			llSetPos(llGetPos() + <0,0,1.25>);
			vector rot = llRot2Euler(llGetRot());
			llSetRot(llEuler2Rot(<0,0,rot.z>));
		}
	listen(integer channel, string name, key id, string message)
	{
		if((channel == DIE_ENGINE) && Active && (message == FlightCommand))state Flight;
		if((channel == DIE_ENGINE) && Active && (message == GroundCommand))state Ground;
		if(llGetOwnerKey(id) != Owner) return;
		message = llToLower(message);
		if(message == GroundCommand) state Ground;
	}


}
state Flight
{
	state_entry()
	{
		Linear = <0,0,0>;
		llStopSound();
		llMessageLinked(LINK_ALL_CHILDREN, DIR_FLIGHT, "", NULL_KEY);
		llSay(listeningnum,(string)DIR_FLIGHT);
		llLoopSound(FlightSound, 1.0);
		llSetStatus(STATUS_PHYSICS, FALSE);
		llSetPos(llGetPos() + <0,0,0.25>);
		vector rot = llRot2Euler(llGetRot());
		llSetRot(llEuler2Rot(<0,0,rot.z>));
		llListen(ListenCh, OwnerName, NULL_KEY, "");
		llSetVehicleType(VEHICLE_TYPE_AIRPLANE);

		// linear friction
		llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <100.0, 100.0, 100.0>);

		// uniform angular friction
		llSetVehicleFloatParam(VEHICLE_ANGULAR_FRICTION_TIMESCALE, 0.5);

		// linear motor
		llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <0.0, 0.0, 0.0>);
		llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_TIMESCALE, 1.0);
		llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 1.0);

		// angular motor
		llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, <0.0, 0.0, 0.0>);
		llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_TIMESCALE, 1.0);
		llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, 2.0);

		// hover
		llSetVehicleFloatParam(VEHICLE_HOVER_HEIGHT, 0.0);
		llSetVehicleFloatParam(VEHICLE_HOVER_EFFICIENCY, 0.0);
		llSetVehicleFloatParam(VEHICLE_HOVER_TIMESCALE, 360.0);
		llSetVehicleFloatParam(VEHICLE_BUOYANCY, 0.988);

		// linear deflection
		llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 0.0);
		llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 1.0);

		// angular deflection
		llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 0.25);
		llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, 100.0);

		// vertical attractor
		llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, 0.5);
		llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 1.0);

		// banking
		llSetVehicleFloatParam(VEHICLE_BANKING_EFFICIENCY, -1.0);
		llSetVehicleFloatParam(VEHICLE_BANKING_MIX, 1.0);
		llSetVehicleFloatParam(VEHICLE_BANKING_TIMESCALE, 1.0);

		// default rotation of local frame
		llSetVehicleRotationParam(VEHICLE_REFERENCE_FRAME, <0.00000, 0.00000, 0.00000, 0.00000>);

		// removed vehicle flags
		llRemoveVehicleFlags(VEHICLE_FLAG_NO_DEFLECTION_UP | VEHICLE_FLAG_HOVER_WATER_ONLY | VEHICLE_FLAG_HOVER_TERRAIN_ONLY | VEHICLE_FLAG_HOVER_UP_ONLY | VEHICLE_FLAG_LIMIT_MOTOR_UP | VEHICLE_FLAG_LIMIT_ROLL_ONLY);

		// set vehicle flags
		llSetVehicleFlags(VEHICLE_FLAG_HOVER_GLOBAL_HEIGHT);
		llTakeControls(CONTROL_FWD | CONTROL_BACK | CONTROL_LEFT | CONTROL_RIGHT | CONTROL_ROT_LEFT | CONTROL_ROT_RIGHT | CONTROL_UP | CONTROL_DOWN | CONTROL_LBUTTON, TRUE, FALSE);

		llSetStatus(STATUS_PHYSICS, TRUE);
	}

	listen(integer channel, string name, key id, string message)
	{
		if(llGetOwnerKey(id) != Owner) return;
		message = llToLower(message);
		if(message == GroundCommand) state Ground;
	}

	control(key name, integer levels, integer edges)
	{
		if((levels & CONTROL_LBUTTON))
		{
			llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <0,0,0>);
			llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, <0,0,0>);
			llSetStatus(STATUS_PHYSICS, FALSE);
			llSleep(0.1);
			llSetStatus(STATUS_PHYSICS, TRUE);
			return;
		}

		if((edges & levels & CONTROL_UP)) Linear.z += FlightUpPower;
		else if((edges & ~levels & CONTROL_UP)) Linear.z = 0.0;

		if((edges & levels & CONTROL_DOWN)) Linear.z -= FlightDownPower;
		else if((edges & ~levels & CONTROL_DOWN)) Linear.z = 0.0;

		if((edges & levels & CONTROL_FWD)) Linear.x += FlightForwardPower;
		else if((edges & ~levels & CONTROL_FWD)) Linear.x = 0.0;

		if((edges & levels & CONTROL_BACK)) Linear.x -= FlightReversePower;
		else if((edges & ~levels & CONTROL_BACK)) Linear.x = 0.0;

		if((edges & levels & CONTROL_LEFT)) Linear.y += FlightStrafePower;
		else if((edges & ~levels & CONTROL_LEFT)) Linear.y = 0.0;

		if((edges & levels & CONTROL_RIGHT)) Linear.y -= FlightStrafePower;
		else if((edges & ~levels & CONTROL_RIGHT)) Linear.y = 0.0;

		if((edges & levels & CONTROL_ROT_LEFT)) Angular.z = FlightTurnPower;
		else if((edges & ~levels & CONTROL_ROT_LEFT)) Angular.z = 0;

		if((edges & levels & CONTROL_ROT_RIGHT)) Angular.z = -FlightTurnPower;
		else if((edges & ~levels & CONTROL_ROT_RIGHT)) Angular.z = 0;
	}

	changed(integer change)
	{
		if((change & CHANGED_LINK) == CHANGED_LINK)
		{
			sitting = llAvatarOnSitTarget();
			if(sitting == NULL_KEY)
			{
				llSetTimerEvent(0.0);
				llStopAnimation(DrivingAnim);
				Active = 0;
				llStopSound();
				llSetStatus(STATUS_PHYSICS, FALSE);
				llMessageLinked(LINK_ALL_CHILDREN , DIR_STOP, "", NULL_KEY);
				llSay(listeningnum,(string)DIR_STOP);
				llReleaseControls();
				state Ground;
			}
		}
	}

	timer()
	{
		llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, Linear);

		llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, Angular);
	}
}
