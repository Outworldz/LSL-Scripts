// :CATEGORY:Access List
// :NAME:llOverMyLand_DoubleTest
// :AUTHOR:mangowylder
// :CREATED:2012-04-10 23:06:50.373
// :EDITED:2013-09-18 15:38:56
// :ID:485
// :NUM:652
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Double Check Scan
// :CODE:
string  gParcelName;
key     gKeyToucherID;
integer toggle;
integer gIntActive;
integer gIntVectorX;

string parcelName(vector p) {
	return llList2String(llGetParcelDetails(p, [PARCEL_DETAILS_NAME]) , 0);
}
default
{
	state_entry()
	{
		gParcelName = parcelName(llGetPos());
		toggle = !toggle;
	}
	touch_start(integer total_number)
	{
		gKeyToucherID = llDetectedKey(0);
		if (toggle){
			gIntActive = 1;
			llSensorRepeat( "", "", AGENT, 96.0, PI, 10.0 );

			llInstantMessage(gKeyToucherID, "Scanner Started");
		}
		else{
			llInstantMessage(gKeyToucherID, "Scanner Stopped");
			gIntActive = 0;
			llSensorRemove();
		}
		toggle = !toggle;
	
	}
	sensor(integer nr)
	{ 
		if (gIntActive == 1)
		{
			integer i;
			do{
				vector pos = llDetectedPos(i);
				string pname = parcelName(pos);
				llInstantMessage(gKeyToucherID, pname);
				if (pname == gParcelName)
				{
					gIntVectorX = 1;
					llInstantMessage(gKeyToucherID, "Parcel name match!");
				}
				if (gIntVectorX == 1 && llOverMyLand(llDetectedKey(i)))
				{
					llInstantMessage(gKeyToucherID, "Conditions met!");
				}
					
			}while ((++i) < nr);
		}
	}
}
