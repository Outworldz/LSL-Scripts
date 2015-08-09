// :CATEGORY:Utility
// :NAME:XML_Parser
// :AUTHOR:kagefumi
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:09
// :ID:986
// :NUM:1412
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// XML Parser Main Script
// :CODE:
//===============================================
//
// XML Parser.
//
//===============================================

//
// Parses XML.
//
xpParseXML(string html)
{
	list tokens = llParseString2List(html, ["<"], []);
	integer tokens_size = llGetListLength(tokens);
	integer i;
	string content = "";
	string end_token = "";
	for (i = 0; i < tokens_size; ++i)
	{
		string token = llList2String(tokens, i);
		if (end_token == "")
		{
			if (llSubStringIndex(token, "!--") == 0)
				// Comment Start.
			{
				end_token = "-->";
				integer end_index = llSubStringIndex(token, end_token);
				content = llGetSubString(token, 3, end_index);
				if (0 <= end_index)
				{
					xpHandleComment(content);
					end_token = "";
					content = "";
				}
			}
			else if(llSubStringIndex(token, "![CDATA[") == 0)
				// CDATA Start.
			{
				end_token = "]]>";
				integer end_index = llSubStringIndex(token, end_token);
				content = llGetSubString(token, 8, end_index);
				if (0 <= end_index) {
					end_token = "";
					content = "";
				}
			}
			else if(llSubStringIndex(token, "?") == 0)
				// PI Start.
			{
				end_token = "?>";
				integer end_index = llSubStringIndex(token, end_token);
				content = llGetSubString(token, 1, end_index);
				if (0 <= end_index) {
					end_token = "";
					content = "";
				}
			}
			else if(llSubStringIndex(token, "/") == 0)
				// Element End
			{
				string name = "";
				string text = "";
				list elem_text = llParseString2List(token, [">"], []);
				name = llList2String(elem_text, 0);
				name = llGetSubString(name, 1, -1);
				xpHandleEndElement(name);
				if (llGetListLength(elem_text) == 2)
				{
					text = llList2String(elem_text, 1);
					if (0 < llStringLength(text))
					{
						xpHandleText(text);
					}
				}
			}
			else
				// Element Start
			{
				string name = "";
				string text = "";
				list attrs = [];
				// "elem>text" -> [elem, text]
				list elem_text = llParseString2List(token, [">"], []);
				string elem = llList2String(elem_text, 0);
				if (llGetListLength(elem_text) == 2)
				{
					text = llList2String(elem_text, 1);
				}
				// "name attr1=value1 attr2=value2" -> [name, attr1=value1, attr2=value2]
				list etokens = llParseString2List(elem, [" "], []);
				name = llList2String(etokens, 0);
				string quote = "";
				string attr_name = "";
				string attr_value = "";
				integer etokens_size = llGetListLength(etokens);
				integer j;
				for (j = 1; j < etokens_size; ++j)
				{
					string etoken = llList2String(etokens, j);
					if (quote == "")
					{
						// "attr1=value1" -> [attr1, value1]
						list atokens = llParseString2List(etoken, ["="], []);
						integer atokens_size = llGetListLength(atokens);
						if (2 <= atokens_size)
						{
							attr_name = llList2String(atokens, 0);
							attr_value = llList2String(atokens, 1);
							quote = llGetSubString(attr_value, 0, 0);
							if (quote == "\"" || quote == "'")
							{
								if (2 <= llStringLength(attr_value))
								{
									attr_value = llGetSubString(attr_value, 1, -1);
								}
								else
								{
									attr_value = "";
								}
							}
							else
							{
								quote = "";
							}
							integer k;
							for (k = 2; k < atokens_size; ++k)
							{
								attr_value += "=" + llList2String(atokens, k);
							}
							if (quote == "\"" || quote == "'")
							{
								integer attr_value_size = llStringLength(attr_value);
								if (1 <= attr_value_size && llSubStringIndex(attr_value, quote) == attr_value_size - 1)
								{
									if (2 <= attr_value_size)
									{
										attr_value = llGetSubString(attr_value, 0, attr_value_size - 2);
									}
									else
									{
										attr_value = "";
									}
									attrs += attr_name;
									attrs += attr_value;
									attr_name = "";
									attr_value = "";
									quote = "";
								}
							}
							else
							{
								attrs += attr_name;
								attrs += attr_value;
								attr_name = "";
								attr_value = "";
								quote = "";

							}
						}
						else if (atokens_size == 1)
						{
							attr_name = llList2String(atokens, 0);
							attr_value = "";
							attrs += attr_name;
							attrs += "";
							attr_name = "";
							attr_value = "";
							quote = "";
						}
					}
					else
					{
						attr_value += " " + etoken;
						integer attr_value_size = llStringLength(attr_value);
						if (1 <= attr_value_size && llSubStringIndex(attr_value, quote) == attr_value_size - 1)
						{
							if (2 <= attr_value_size)
							{
								attr_value = llGetSubString(attr_value, 0, attr_value_size - 2);
							}
							else
							{
								attr_value = "";
							}
							attrs += attr_name;
							attrs += attr_value;
							attr_name = "";
							attr_value = "";
							quote = "";
						}
					}
				}
				xpHandleStartElement(name, attrs);
				if (llGetSubString(elem, -1, -1) == "/")
				{
					xpHandleEndElement(name);
				}
				if (0 < llStringLength(text))
				{
					xpHandleText(text);
				}
			}
		}
		else
		{
			integer end_index = llSubStringIndex(token, end_token);
			if(0 <= end_index)
			{
				if (1 <= end_index)
				{
					content += "<" + llGetSubString(token, 0, end_index - 1);
				}
				if(end_token == "-->")
				{
					xpHandleComment(content);
				}
				else if (end_token == "]]>")
				{
					xpHandleCDATA(content);
				}
				else if (end_token == "?>")
				{
					//xpHandlePI(content);
				}
				else
				{
				}
				end_token = "";
				content = "";
			}
			else
			{
				content += token;
			}
		}
	}
}

xpHandleStartElement(string name, list attrs)
{
	string str = "START_TAG: " + name;
	integer i;
	for (i = 0; i < llGetListLength(attrs); i += 2)
	{
		str = str
			+ " "
			+ llList2String(attrs, i)
			+ "="
			+ llList2String(attrs, i + 1);
	}
	llSay(0, str);
}

xpHandleText(string text)
{
	llSay(0, "TEXT: " + text);
}

xpHandleEndElement(string name)
{
	llSay(0, "END_TAG: " + name);
}

xpHandleComment(string content)
{
	llSay(0, "COMMENT: " + content);
}

xpHandleCDATA(string content)
{
	llSay(0, "CDATA: " + content);
}
