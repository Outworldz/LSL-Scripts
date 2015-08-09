// :CATEGORY:Utility
// :NAME:Pair_List_Parser
// :AUTHOR:kagefumi
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:59
// :ID:602
// :NUM:825
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// The Main Script
// :CODE:
//===============================================
//
// Pair List.
//
//  Example
//    pair_list
//                => ["MicroSoft", "Xbox360", "Sony", "PlayStation3"];
//    plGet(pair_list, ["Sony"] );
//              =>  ["PlayStation3"]
//    plSet(pair_list, ["Apple"], ["iPhone"]);
//            => ["MicroSoft", "Xbox360", "Sony", "PlayStation3", "Apple", "iPhone"]
//    plKeys(pair_list);
//                => ["MicroSoft", "Sony"]
//    plValues(pair_list);
//               =>  ["Xbox360", "PlayStation3"]
//
//===============================================

//
// Gets elements from pair list.
//
list plGet(list pair_list, list keys)
{
	list results = [];
	integer keys_length = llGetListLength(keys);
	integer pair_list_length = llGetListLength(pair_list);
	integer i;
	for (i = 0; i < keys_length; i++)
	{
		string xkey = llList2String(keys, i);
		integer key_index = llListFindList(pair_list, [xkey]);
		if (0 <= key_index && key_index <pair_list_length - 1)
		{
			integer type = llGetListEntryType(pair_list, key_index + 1);
			if (type == TYPE_FLOAT)
			{
				results += llList2Float(pair_list, key_index + 1);
			}
			else if (type == TYPE_INTEGER)
			{
				results += llList2Integer(pair_list, key_index + 1);
			}
			else if (type == TYPE_INVALID)
			{
				results += "???";
			}
			else if (type == TYPE_KEY)
			{
				results += llList2Key(pair_list, key_index + 1);
			}
			else if (type == TYPE_ROTATION)
			{
				results += llList2Rot(pair_list, key_index + 1);
			}
			else if (type == TYPE_STRING)
			{
				results += llList2String(pair_list, key_index + 1);
			}
			else if (type == TYPE_VECTOR)
			{
				results += llList2Vector(pair_list, key_index + 1);
			}
			else
			{
			}
		}
		else
		{
			llSay(DEBUG_CHANNEL, "Invalid element in " + llDumpList2String(pair_list, ","));
			results += "???";
		}
	}
	return results;
}

//
// Sets elements to pair list.
//
list plSet(list pair_list, list keys, list values)
{
	integer keys_length = llGetListLength(keys);
	integer values_length = llGetListLength(values);
	integer i;
	for (i = 0; (i < keys_length) && (i < values_length); i++)
	{
		string xkey = llList2String(keys, i);
		integer index = llListFindList(pair_list, [xkey]);
		integer type = llGetListEntryType(values, i);
		if (0 <= index)
		{
			if (type == TYPE_FLOAT)
			{
				float value = llList2Float(values, i);
				pair_list = llListReplaceList(pair_list, [value], index + 1, index + 1);
			}
			else if (type == TYPE_INTEGER)
			{
				integer value = llList2Integer(values, i);
				pair_list = llListReplaceList(pair_list, [value], index + 1, index + 1);
			}
			else if (type == TYPE_INVALID)
			{
			}
			else if (type == TYPE_KEY)
			{
				key value = llList2Key(values, i);
				pair_list = llListReplaceList(pair_list, [value], index + 1, index + 1);
			}
			else if (type == TYPE_ROTATION)
			{
				rotation value = llList2Rot(values, i);
				pair_list = llListReplaceList(pair_list, [value], index + 1, index + 1);
			}
			else if (type == TYPE_STRING)
			{
				string value = llList2String(values, i);
				pair_list = llListReplaceList(pair_list, [value], index + 1, index + 1);
			}
			else if (type == TYPE_VECTOR)
			{
				vector value = llList2Vector(values, i);
				pair_list = llListReplaceList(pair_list, [value], index + 1, index + 1);
			}
			else
			{
				llSay(DEBUG_CHANNEL, "Invalid element in " + llDumpList2String(values, ","));
			}
		}
		else
		{
			if (type == TYPE_FLOAT)
			{
				float value = llList2Float(values, i);
				pair_list += xkey;
				pair_list += value;
			}
			else if (type == TYPE_INTEGER)
			{
				integer value = llList2Integer(values, i);
				pair_list += xkey;
				pair_list += value;
			}
			else if (type == TYPE_INVALID)
			{
			}
			else if (type == TYPE_KEY)
			{
				key value = llList2Key(values, i);
				pair_list += xkey;
				pair_list += value;
			}
			else if (type == TYPE_ROTATION)
			{
				rotation value = llList2Rot(values, i);
				pair_list += xkey;
				pair_list += value;
			}
			else if (type == TYPE_STRING)
			{
				string value = llList2String(values, i);
				pair_list += xkey;
				pair_list += value;
			}
			else if (type == TYPE_VECTOR)
			{
				vector value = llList2Vector(values, i);
				pair_list += xkey;
				pair_list += value;
			}
			else
			{
				llSay(DEBUG_CHANNEL, "Invalid element in " + llDumpList2String(values, ","));
			}
		}
	}
	return pair_list;
}

//
// Gets keys from pair list.
//
list plKeys(list pair_list)
{
	return llList2ListStrided(llListInsertList(pair_list, ["?"], 0), 0, -1, 2);
}

//
// Gets values from pair list.
//
list plValues(list pair_list)
{
	return llList2ListStrided(pair_list, 0, -1, 2);
}
