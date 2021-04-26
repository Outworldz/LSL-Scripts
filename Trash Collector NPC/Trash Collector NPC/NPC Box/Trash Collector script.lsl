// :SHOW:1
// :CATEGORY:Presentation
// :NAME:Trash Collector NPC
// :AUTHOR:Unknown
// :KEYWORDS: NPC
// :CREATED:2021-04-26 23:58:23
// :EDITED:2021-04-26  22:58:23
// :ID:1144
// :NUM:2038
// :REV:1
// :WORLD:Opensim
// :DESCRIPTION:
// NPC that walks and collects trash
// :CODE:
// You newed a animation fort your NPC to bend overt and pick stuff up.
string pickup="pick up from ground animation";
// comment this line out for runtime, for LSLEditor use
integer OS_NPC_NO_FLY =  1;
float WAIT    = 10; // wait 10 secobnds
float range   = 15;  // how far to wander
vector start_location = <0,0,0>;

//CODDE

// define a box in front of the NPC size 'range'
vector top;
vector right;
vector left;

list positions;
integer destination;
key NPCKey;        // storage for NPC Key

float iWaitCounter;
vector newDest;
integer checkAV;

integer debug = TRUE;

DEBUG(string str)
{
	if (debug) llSay(0,str);
}

TimerEvent(float timesent)
{
	DEBUG("Setting timer: " + (string) timesent);
	llSetTimerEvent(timesent);
}
create_path(vector start,vector goal)
{
	vector pos = llGetPos();
	integer direct;
	list results = llCastRay(start, goal, [ RC_MAX_HITS, 1] );
	direct=llList2Integer(results, -1);
	if (!direct)
	{
		positions = [start, goal];
		return;
	}
	if (pos.y < goal.y)
		positions= [start,top, goal];
	else if (goal.x < pos.x)
		positions= [start,top,left,goal];
	else if (goal.x > pos.x)
		positions= [start,top,right,goal];
	return;
}

send_path(integer homewardbound, list path)
{
	integer length=llGetListLength(path);

	if(destination < length && destination >= -length)
	{
		DEBUG((string) destination);
		newDest = llList2Vector(path,destination);
		iWaitCounter = WAIT;            // wait to get to a destination.
		osNpcMoveToTarget(NPCKey, newDest, OS_NPC_NO_FLY );
		TimerEvent(1);
		return;
	} else if (destination == length) {
			osNpcPlayAnimation(NPCKey,pickup);
		TimerEvent(3.0);
	} else if (destination <= -length) {
			osNpcRemove(NPCKey);
		TimerEvent(480);
		checkAV=TRUE;
		return;
	}

	destination= -1;
	TimerEvent(1);
	iWaitCounter = WAIT;
	DEBUG((string)destination);

}

init()
{
	vector pos = llGetPos();
	top       = pos +  <0,range,0>;
	right     = pos + <range,0,0>;
	left      = pos - <range,0,0>;
	destination=0;
	TimerEvent(480); // 8 minutes !!!
	checkAV=FALSE;
	destination=0;
	create_path(llGetPos() + start_location,randompos());
	DEBUG((string)positions);
	NPCKey=osNpcCreate("Trash", "Bot", start_location, "Trash Bot");
	send_path(TRUE, positions);
}

vector randompos()
{
	vector pos= llGetPos();
	if(llFrand(1)<0.5)
	{
		float randx= 18*((llRound(llFrand(1))*2)-1);
		//llOwnerSay((string)randx);
		float randy=18*((llRound(llFrand(1))*2)-1);
		//llOwnerSay((string)randy);
		return pos+<randx+(3-llFrand(5)),randy+(3-llFrand(5)),0>;
	}
	else
	{
		return pos+<llFrand(18)-9,-llFrand(30)-7,0>;
	}
}
check_agents()
{
	integer nNew = 0;
	list avis = llGetAgentList(AGENT_LIST_REGION, []);
	integer howmany = llGetListLength(avis);
	integer i;
	for ( i = 0; i < howmany; i++ ) {
		if ( ! osIsNpc(llList2Key(avis, i)) )
			nNew++; // only non-NPC's
	}
	if (nNew>0)
	{
		checkAV=FALSE;
		destination=0;
		create_path(start_location,randompos());
		DEBUG((string)positions);
		NPCKey=osNpcCreate("Trash", "Bot", start_location, "Trash Bot");
		send_path(TRUE, positions);

	}
}
default
{
	state_entry()
	{
		init();
	}
	touch_start(integer total_number)
	{
		checkAV=FALSE;
		destination=0;
		create_path(start_location,randompos());
		//llOwnerSay((string)positions);
		NPCKey=osNpcCreate("Trash", "Bot", start_location, "Trash Bot");
		send_path(TRUE, positions);
	}
	timer() {
		if (checkAV)
		{
			check_agents();
		}
		if (--iWaitCounter) {

			vector tDest = newDest;
			tDest.z = 0;
			vector hisDest = osNpcGetPos(NPCKey);
			hisDest.z = 0;

			if (llVecDist(hisDest, newDest) > 1)  {
				return;
			}
		}
		//llSetTimerEvent(0);
		if (destination >= 0)
			destination++;
		else
			destination--;

		send_path(TRUE, positions);
	}

}
