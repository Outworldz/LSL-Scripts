// :CATEGORY:Utility
// :NAME:Pair_List_Parser
// :AUTHOR:kagefumi
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:59
// :ID:602
// :NUM:824
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Test Script
// :CODE:
default
{
	state_entry()
	{
		list pair_list = [];
		pair_list = plSet(pair_list, ["aaa"], [1.23]);
		pair_list = plSet(pair_list, ["bbb", "ccc"], [<1.11, 2.22, 3.33>, "hogehoge"]);
		llSay(0, llDumpList2String(plGet(pair_list, ["aaa", "bbb"]), ","));
		pair_list = plSet(pair_list, ["bbb"], ["piyopiyo"]);
		llSay(0, llDumpList2String(pair_list, ","));
		llSay(0, llDumpList2String(plKeys(pair_list), ","));
		llSay(0, llDumpList2String(plValues(pair_list), ","));
	}
}
