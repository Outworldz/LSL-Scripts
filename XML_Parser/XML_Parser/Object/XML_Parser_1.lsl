// :CATEGORY:Utility
// :NAME:XML_Parser
// :AUTHOR:kagefumi
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:09
// :ID:986
// :NUM:1411
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// XML Parser Test script
// :CODE:
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

default
{
	state_entry()
	{
		xpParseXML("<a><b b1='ll' b2='mm nn'><c c1='oo=pp qq ' c2='='/><!-- ddd --></b></a><![CDATA[ eee < fff > ggg]]>");
		xpParseXML("<x><y y1=\"rr ss\">uuuu<z/>vvvv</y></x>");
	}
}
