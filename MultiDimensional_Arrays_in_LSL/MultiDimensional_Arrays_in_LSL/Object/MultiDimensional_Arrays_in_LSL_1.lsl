// :CATEGORY:Arrays
// :NAME:MultiDimensional_Arrays_in_LSL
// :AUTHOR:Jamethiel Wickentower
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:57
// :ID:534
// :NUM:720
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// MultiDimensional_Arrays_in_LSL
// :CODE:
// Copyright 2008 Jamethiel Wickentower (David Lloyd)
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// #########################################################################

// This library implements single dimensional and multi-dimensional arrays.
//
// Currently implemented:
//
// * Searching for a value
//
// To be implemented:
//
// * Removing a single value or a whole row
// * Replacing a single value or a whole row
// * Inserting a single value or a whole row
//
// The last operation may not make sense with arrays, though.
//
// This does not handle hash maps.

key gOwner;
string gOwnerName;

list testList = [
	1, "DSL-",
	"DSL-1", "first", "row", "now",
	"DSL-2", "onto", "the", "chocolate", "boards", "we",
	"DSL-3", "go", "west"];

list fakeList = [
	1, "DSL-"];

list test2Dims = [
	2, "DSL-", "LSD-",
	"DSL-1",
	"LSD-1", "father", "christmas",
	"LSD-2", "easter", "bunny",
	"LSD-3", "saint", "nicholas"];

list test2Complex = [
	"DSL-1",
	"LSD-1", "David", "Lloyd",
	"LSD-2", "Janet", "Barker",
	"DSL-2",
	"LSD-1", "None",
	"DSL-3",
	"LSD-1", "Tony",
	"LSD-2", "Barber",
	"LSD-3", "Shindig", "Nonce"];

report(string msg) {
	llOwnerSay(msg);
}

// jw_auto_array_get
//
// This reads a special array that is setup like this:
//
// item[0] = number of dimensions
// item[0..N] = prefixes
//
// The prefixes MUST be unique and contained within the data or bad things
// will certain happen.
//
// You can search a one dimensional array by giving a single number in the
// needle list.
list jw_auto_array_get(list haystack, list needle) {
	integer where;

	integer haystack_len = llGetListLength(haystack);
	integer needle_len = llGetListLength(needle);

	if (haystack_len < 3) {
		report("Invalid or empty list.");
		return [];
	}

	integer dimensions = llList2Integer(haystack, 0);

	if (dimensions != needle_len) {
		report("Invalid haystack length.");
		return [];
	}

	list prefixes = llList2List(haystack, 1, dimensions);

	list result = jw_array_recursive(haystack, prefixes, needle, 0);
	return result;
}

// jw_custom_array_get
//
// Similar to jw_auto_array_get but the prefix information is given via a
// parameter. See the discussion above.
list jw_custom_array_get(list haystack, integer dimensions, list prefixes, list needle) {
	integer where;

	integer haysteck_len = llGetListLength(haystack);
	integer needle_len = llGetListLength(needle);

	if (dimensions != needle_len) {
		report("Invalid haystack length.");
		return [];
	}

	list result = jw_array_recursive(haystack, prefixes, needle, 0);
	return result;
}

// jw_get_multi_dim
//
// A recursive function that gets a particular multi-dimensional array. It calls itself
// on itself until it gets down to the requisite level and then returns everything in
// that level.
//
// That could be an array itself and, in fact, it is possible I could automate that
// process.
list jw_array_recursive(list haystack, list prefixes, list needle, integer count) {
	integer prefixes_len = llGetListLength(prefixes);

	if (count >= prefixes_len) {
		return haystack;
	}

	string what = llList2String(prefixes, count) + llList2String(needle, count);
	string expected = llList2String(prefixes, count) + (string)(llList2Integer(needle, count) + 1);

	haystack = jw_get_row(haystack, what, expected);

	// If we can't find a particular entry, we keep on returning
	if (haystack == [ ]) {
		return haystack;
	}

	count++;
	list result = jw_array_recursive(haystack, prefixes, needle, count);
	return result;
}

// Get Row
//
// Gets a particular row from the array; this can be used recursively to drill
// into multi-level arrays.
list jw_get_row(list haystack, string what, string expected) {
	list result;

	integer haystack_len = llGetListLength(haystack);
	integer where = llListFindList(haystack, [ what ]);

	// Couldn't find the first dimension...
	if (where < 0) {
		report("Unable to find " + what);
		return result;
	}

	integer i;
	for (i = where + 1; i < haystack_len; i++) {
		string item = llList2String(haystack, i);
		if (item == expected) {
			jump finished;
		}
		result += [ item ];
	}

	@finished;

	return result;
}

default
{
	state_entry()
	{
		gOwner = llGetOwner();
		gOwnerName  = llKey2Name(gOwner);

		llInstantMessage(gOwner, "Reset test list script...");
	}

	touch_start(integer total_number)
	{
		llOwnerSay("We found these:\n" + llDumpList2String(jw_auto_array_get(test2Dims,[ 1, 3 ]), "\n"));
		llOwnerSay("Complex, we found these:\n" + llDumpList2String(jw_custom_array_get(test2Complex, 2, [ "DSL-", "LSD-" ], [ 3, 3 ]), "\n"));
	}
}
