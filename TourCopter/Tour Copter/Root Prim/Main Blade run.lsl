// :CATEGORY:Tour
// :NAME:TourCopter
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:08
// :ID:909
// :NUM:1297
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Tour
// :CODE:

﻿// ______           _  ______            _           _
// |  ___|         | | |  ___|          | |         (_)
// | |_ ___ _ __ __| | | |_ _ __ ___  __| | ___ _ __ ___  __
// |  _/ _ \ '__/ _` | |  _| '__/ _ \/ _` |/ _ \ '__| \ \/ /
// | ||  __/ | | (_| | | | | | |  __/ (_| |  __/ |  | |>  <
// \_| \___|_|  \__,_| \_| |_|  \___|\__,_|\___|_|  |_/_/\_\
//
// fred@mitsi.com
// tour copter script

// main blade run
//
//Revisions:
// 1/28/2010 initial release

Stopped()
{
	llSetTexture("70afec32-bdcc-474f-676f-9b9284d466d1" , ALL_SIDES);
	llSetTexture("a586c350-930b-8ca1-8d23-0e2d8c6bebf0", 1);
	llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 10);
	llSleep(1);
	llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 9);
	llSleep(1);
	llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 8);
	llSleep(1);
	llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 7);
	llSleep(1);
	llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 6);
	llSleep(1);
	llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 5);
	llSetTexture("3736ae8e-5792-e4b0-9627-804830ee4ba1" , ALL_SIDES);
	llSetTexture("6efb7d85-7684-b532-0a9d-08392eed326c", 1);
	llSleep(1);
	llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 4);
	llSleep(1);
	llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 3);
	llSleep(1);
	llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 2);
	llSleep(1);
	llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 1);
	llSetTexture("580964ba-6d9a-5e76-5db0-a5a669f35b35" , ALL_SIDES);
	llSetTexture("3736ae8e-5792-e4b0-9627-804830ee4ba1", 1);
	llSleep(1);
	llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 0);
	llSleep(1);

	llStopSound();
}

default
{
	state_entry()
	{
		Stopped();
	}
	
	link_message(integer from, integer int, string txt, key id)
	{
		if (txt == "on")
		{
			llSetAlpha(0,1);
			llSetTexture("580964ba-6d9a-5e76-5db0-a5a669f35b35" , ALL_SIDES);
			llSetTexture("3736ae8e-5792-e4b0-9627-804830ee4ba1", 1);
			llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 10);
			llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 1);
			llSleep(1);
			llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 2);
			llSleep(1);
			llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 3);
			llSleep(1);
			llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 4);
			llSleep(1);
			llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 5);
			llSleep(1);
			llSetTexture("3736ae8e-5792-e4b0-9627-804830ee4ba1" , ALL_SIDES);
			llSetTexture("6efb7d85-7684-b532-0a9d-08392eed326c", 1);
			llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 6);
			llSleep(1);
			llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 7);
			llSleep(1);
			llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 8);
			llSleep(1);
			llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 9);
			llSleep(1);
			llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 10);
			//  llLoopSound("f46d98b3-a812-0db8-a6d5-4943f1f7c1a3",1);

			llSetTexture("70afec32-bdcc-474f-676f-9b9284d466d1" , ALL_SIDES);
			llSetTexture("a586c350-930b-8ca1-8d23-0e2d8c6bebf0", 1);
		}
		else if (txt == "off")
		{
			Stopped();
		}

		else if (txt == "half")
		{
			llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 0);
			llSetTexture("580964ba-6d9a-5e76-5db0-a5a669f35b35" , ALL_SIDES);
			llSetTexture("3736ae8e-5792-e4b0-9627-804830ee4ba1", 1);
		}
	}


	on_rez(integer x)
	{
		llResetScript();
	}
}

