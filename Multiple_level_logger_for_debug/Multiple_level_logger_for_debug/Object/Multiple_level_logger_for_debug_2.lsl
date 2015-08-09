// :CATEGORY:Logging
// :NAME:Multiple_level_logger_for_debug
// :AUTHOR:kagefumi
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:58
// :ID:544
// :NUM:741
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Log Script
// :CODE:
//===============================================
//
// Logger
//
//===============================================

// Set log level.
// 0:DEBUG, 1:INFO, 2:WARN, 3:ERROR, 4:FATAL
integer log_level = 0;

//
// Says debug log.
//
logSayDebug(string message)
{
	logSay(0, "DEBUG: " + message);
}
//
// Says info log.
//
logSayInfo(string message)
{
	logSay(1, " INFO: " + message);
}
//
// Says warn log.
//
logSayWarn(string message)
{
	logSay(2, " WARN: " + message);
}
//
// Says error log.
//
logSayError(string message)
{
	logSay(3, "ERROR: " + message);
}
//
// Says fatal log.
//
logSayFatal(string message)
{
	logSay(4, "FATAL: " + message);
}
logSay(integer level, string message)
{
	if(log_level <= level)
	{
		llSay(0, message);
	}
}
