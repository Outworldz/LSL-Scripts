// :CATEGORY:Logging
// :NAME:Multiple_level_logger_for_debug
// :AUTHOR:kagefumi
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:58
// :ID:544
// :NUM:740
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Test Script
// :CODE:
default
{
	state_entry()
	{
		integer i;
		for (i = 0; i <= 4; i++)
		{
			log_level = i;
			logSayDebug("log_level" + (string) log_level + ". This is debug.");
			logSayInfo("log_level" + (string) log_level + ". This is info.");
			logSayWarn("log_level" + (string) log_level + ". This is warn.");
			logSayError("log_level" + (string) log_level + ". This is error.");
			logSayFatal("log_level" + (string) log_level + ". This is fatal.");
		}
	}
}
