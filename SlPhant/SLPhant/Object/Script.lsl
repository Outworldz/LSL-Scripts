// :CATEGORY:Database
// :NAME:SlPhant
// :AUTHOR:SLPhant
// :KEYWORDS:
// :CREATED:2014-09-24 14:54:34
// :EDITED:2014-09-24
// :ID:1050
// :NUM:1664
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// A simple external database for SL
// :CODE:
// See https://data.sparkfun.com/

// SLPhant_v1_0.lsl
// *****************************************************************************************
// SLPhant v1.0 Header
// *** Enter Public/Private/Delete Keys below *** //
string sSLPHANT_PUBLIC_KEY  = "7JvgN1NbE5H2JwAvlza0";
string sSLPHANT_PRIVATE_KEY = "mzqm6g6GNaS0q6D7RrNy";
// Save your Delete Key here so you never lose it "xxxxxxxxxxxxxxxxxxxx";

// *** Enter your Field Names below (Case Sensitive!) in SAME ORDER as Phant Returns *** //
// *** For Example: list lSLPHANT_FIELDNAMES { Id, Temperature, Pressure, Humidity, WindSpeed };
//list lSLPHANT_FIELDNAMES    = [ "avatarname", "id", "regionname" ];
	
// *** If running your own Phant Server, enter URL below *** //
string sSLPHANT_BASE_URL    = "https://data.sparkfun.com/";

// SLPhant Data Formats (must begin w/ a period ".")
string sSLPHANT_FORMAT_CSV  = ".csv";
string sSLPHANT_FORMAT_JSON = ".json";
string sSLPHANT_FORMAT_SQL  = ".sql";
string sSLPHANT_FORMAT_PSQL = ".psql";
string sSLPHANT_FORMAT_ATOM = ".atom";
// string sSLPHANT_FORMAT_xxxx = ".";	// Place holder for future formats
// *****************************************************************************************
key SLPhant_Clear() {
	//	Clear All Data: http://data.sparkfun.com/input/PUBLIC_KEY/clear?private_key=PRIVATE_KEY
	return llHTTPRequest(sSLPHANT_BASE_URL+"input/"+sSLPHANT_PUBLIC_KEY+"/clear?private_key="+sSLPHANT_PRIVATE_KEY, [], "");
}
// *****************************************************************************************
// It is *YOUR* responsibility to have sData in format "Field1=Value1&Field2=Value2..."
//		Fields must be the valid names for YOUR stream.
//		Values must be put thru llEscapeURL(sURL).
//		Name/Value pairs must be separated by "&".
//
// *** For example...
//	SLPhant_AddData(
//		"avatarname="+llEscapeURL(llKey2Name(llGetOwner()))+
//		"&id="+llEscapeURL(llGetOwner())+
//		"&regionname="+llEscapeURL(llGetRegionName()));
key SLPhant_AddData(string sData) {
	//	Add Data: http://data.sparkfun.com/input/PUBLIC_KEY?private_key=PRIVATE_KEY&FIELD1=VALUE1&=FIELD2=VALUE2
	return llHTTPRequest(sSLPHANT_BASE_URL+"input/"+sSLPHANT_PUBLIC_KEY+"?private_key="+sSLPHANT_PRIVATE_KEY+"&"+sData, [], "");
}
// *****************************************************************************************
key SLPhant_RequestData(string sFormat) {
	// Get Data: http://data.sparkfun.com/output/PUBLIC_KEY.FORMAT?page=PAGE_NUMBER
	return llHTTPRequest(sSLPHANT_BASE_URL+"output/"+sSLPHANT_PUBLIC_KEY+sFormat, [], "");
}
// *****************************************************************************************
key SLPhant_RequestStats(string sFormat) {
	// Get Stats: http://data.sparkfun.com/output/PUBLIC_KEY/stats.FORMAT
	return llHTTPRequest(sSLPHANT_BASE_URL+"output/"+sSLPHANT_PUBLIC_KEY+"/stats"+sFormat, [], "");
}
// *****************************************************************************************
// *****************************************************************************************
// *****************************************************************************************
//
// Copy everything above this line to your own Program.
// Then modify the Key Constants to use your own Stream's Keys.
//
// *****************************************************************************************
// *****************************************************************************************
// *****************************************************************************************
//
// Example Program...
//
integer iTestNumber = 0;
key kSLPhantHttpRequest = NULL_KEY;

default {
	// *****************************************************************************************
	state_entry() {
		iTestNumber = 0;
		llOwnerSay("Test "+(string)iTestNumber+": Clearing Data...");
		kSLPhantHttpRequest = SLPhant_Clear();
	}
	// *****************************************************************************************
	http_response(key kRequestId, integer iStatus, list lMetadata, string sBody) {
		llOwnerSay("http_response("+(string)kRequestId+", "+(string)iStatus+", ["+llList2CSV(lMetadata)+"], "+sBody+")");
		if(kRequestId==kSLPhantHttpRequest) {
			llSleep(1.0);	// Phant sometimes messes up if polled too fast.
			if(iTestNumber==0) {
				iTestNumber++;
				llOwnerSay("Test "+(string)iTestNumber+": Adding Data...");
				kSLPhantHttpRequest = SLPhant_AddData("avatarname="+llEscapeURL(llKey2Name(llGetOwner()))+"&id="+llEscapeURL(llGetOwner())+"&regionname="+llEscapeURL(llGetRegionName()));
			} else if(iTestNumber==1) {
				iTestNumber++;
				llOwnerSay("Test "+(string)iTestNumber+": Requesting Data in Default Format...");
				kSLPhantHttpRequest = SLPhant_RequestData("");
			} else if(iTestNumber==2) {
				iTestNumber++;
				llOwnerSay("Test "+(string)iTestNumber+": Requesting Data in "+sSLPHANT_FORMAT_CSV+" Format...");
				kSLPhantHttpRequest = SLPhant_RequestData(sSLPHANT_FORMAT_CSV);
			} else if(iTestNumber==3) {
				iTestNumber++;
				llOwnerSay("Test "+(string)iTestNumber+": Requesting Data in "+sSLPHANT_FORMAT_JSON+" Format...");
				kSLPhantHttpRequest = SLPhant_RequestData(sSLPHANT_FORMAT_JSON);
			} else if(iTestNumber==4) {
				iTestNumber++;
				llOwnerSay("Test "+(string)iTestNumber+": Requesting Data in "+sSLPHANT_FORMAT_SQL+" Format...");
				kSLPhantHttpRequest = SLPhant_RequestData(sSLPHANT_FORMAT_SQL);
			} else if(iTestNumber==5) {
				iTestNumber++;
				llOwnerSay("Test "+(string)iTestNumber+": Requesting Data in "+sSLPHANT_FORMAT_PSQL+" Format...");
				kSLPhantHttpRequest = SLPhant_RequestData(sSLPHANT_FORMAT_PSQL);
			} else if(iTestNumber==6) {
				iTestNumber++;
				llOwnerSay("Test "+(string)iTestNumber+": Requesting Data in "+sSLPHANT_FORMAT_ATOM+" Format...");
				kSLPhantHttpRequest = SLPhant_RequestData(sSLPHANT_FORMAT_ATOM);
			} else if(iTestNumber==7) {
				iTestNumber++;
				llOwnerSay("Test "+(string)iTestNumber+": Requesting Stats in "+sSLPHANT_FORMAT_JSON+" Format...");
				kSLPhantHttpRequest = SLPhant_RequestStats(sSLPHANT_FORMAT_JSON);
			} else {
				llOwnerSay("Done. You can view your data at "+sSLPHANT_BASE_URL+"streams/"+sSLPHANT_PUBLIC_KEY);
			}
		}
	}
	// *****************************************************************************************
}
// *****************************************************************************************
