// :SHOW:
// :CATEGORY:Color
// :NAME:Colorpicker
// :AUTHOR:Anonymous
// :KEYWORDS:
// :CREATED:2021-04-26 23:30:52
// :EDITED:2021-04-26  22:30:52
// :ID:1131
// :NUM:2021
// :REV:1.0
// :WORLD:Second Life, Opensim
// :DESCRIPTION:
// click a color and a brightness then click the preview to get an llOwnerSay with the color: ) <3
// :CODE:
//script found on a long lost forum and is by Anonymous
//click a color and a brightness then click the preview to get an llOwnerSay with the color: ) <3
float hue = 0.0; float lum = 0.5; float sat = 1.0;

integer start_face;

//hsl to rgb steps take from http://130.113.54.154/~monger/hsl-rgb.html
vector hsl_to_rbg(float h, float s, float l) {

	vector rbg;
	float temp1;
	float temp2;

	if(l < .5)
		temp2 = l*(1.0+s);
	else
		temp2 = l+s-l*s;

	temp1 = l*2.0-temp2;

	float Rtemp3 = h+1.0/3.0;
	if(Rtemp3 < 0.0)
		Rtemp3 = Rtemp3+1.0;
	else if(Rtemp3 > 1.0)
		Rtemp3 = Rtemp3-1.0;

	float Gtemp3 = h;
	if(Gtemp3 < 0.0)
		Gtemp3 = Gtemp3+1.0;
	else if(Gtemp3 > 1.0)
		Gtemp3 = Gtemp3-1.0;

	float Btemp3 = h-1.0/3.0;
	if(Btemp3 < 0.0)
		Btemp3 = Btemp3+1.0;
	else if(Btemp3 > 1.0)
		Btemp3 = Btemp3-1.0;

	if(6.0*Rtemp3 < 1.0)
		rbg.x = temp1+(temp2-temp1)*6.0*Rtemp3;
	else if(2.0*Rtemp3 < 1.0)
		rbg.x = temp2;
	else if(3.0*Rtemp3 < 2.0)
		rbg.x = temp1+(temp2-temp1)*((2.0/3.0)-Rtemp3)*6.0;
	else
		rbg.x = temp1;

	if(6.0*Gtemp3 < 1.0)
		rbg.y = temp1+(temp2-temp1)*6.0*Gtemp3;
	else if(2.0*Gtemp3 < 1.0)
		rbg.y = temp2;
	else if(3.0*Gtemp3 < 2.0)
		rbg.y = temp1+(temp2-temp1)*((2.0/3.0)-Gtemp3)*6.0;
	else
		rbg.y = temp1;

	if(6.0*Btemp3 < 1.0)
		rbg.z = temp1+(temp2-temp1)*6.0*Btemp3;
	else if(2.0*Btemp3 < 1.0)
		rbg.z = temp2;
	else if(3.0*Btemp3 < 2.0)
		rbg.z = temp1+(temp2-temp1)*((2.0/3.0)-Btemp3)*6.0;
	else
		rbg.z = temp1;

	return rbg;

}




default {

	state_entry()
	{
		llSetPrimitiveParams([
			PRIM_SIZE, <.5,.4,.01>,
			PRIM_TYPE, PRIM_TYPE_BOX, PRIM_HOLE_SQUARE, <0,1,0>, 0.0, <0,0,0>, <.8,1,0>, <.02,0,0>,
			PRIM_TEXTURE, ALL_SIDES, (key)"5748decc-f629-461c-9a36-a35a221fe21f", <1,1,0>, <0,0,0>, 0.0,
			PRIM_TEXTURE, 0, (key)"404e4461-8a22-fbf7-7652-4b81dc7da325", <1,1,0>, <0,0,0>, 0.0,
			PRIM_TEXTURE, 2, (key)"01c02d68-dfb0-d907-7397-cba857c61144", <1,1,0>, <0,0,0>, -PI_BY_TWO]);
	}


	touch_start(integer total_number)
	{
		start_face = llDetectedTouchFace(0);
		if(start_face == 4)
			llOwnerSay((string)hsl_to_rbg(hue, sat, lum));
	}

	touch(integer total_number)
	{
		vector st = llDetectedTouchST(0);
		integer face = llDetectedTouchFace(0);
		if(start_face != face) return;
		if(face == 0)
		{
			sat = st.y;
			hue = st.x;
			llSetColor(hsl_to_rbg(hue, sat, lum), 4);
		}
		else if(face == 2)
		{
			lum = st.x;
			llSetColor(hsl_to_rbg(hue, sat, lum), 4);
		}
	}

	changed(integer change)
	{
		if (change & CHANGED_OWNER)
		{
			llResetScript();
		}
	}

}


