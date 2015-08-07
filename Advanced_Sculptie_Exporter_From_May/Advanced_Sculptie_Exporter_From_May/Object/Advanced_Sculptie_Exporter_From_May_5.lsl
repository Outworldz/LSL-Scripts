// :CATEGORY:Maya
// :NAME:Advanced_Sculptie_Exporter_From_May
// :AUTHOR:Adelle Fitzgerald
// :CREATED:2010-11-18 21:08:40.607
// :EDITED:2013-09-18 15:38:47
// :ID:18
// :NUM:28
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// PrimScript
// :CODE:
// assembled by ../bin/lslcc -I. -I.. -I../.. primscript.lsl
// by qarl with qLab v0.0.3
// Tue Jun 19 09:27:34 PDT 2007
//
// Fixed for opensim by Adelle Fitzgerald - 5 november 2009


string parseWord;


qUserError(string message)
{
  llOwnerSay(message);
}




__qError(string error, string file, integer line)
{
  llOwnerSay(error + ":" +
          llGetScriptName() + ":" +
          file + "(" +
          (string)line + ")");
}


integer __qDebugLevel = 0;

qDebugSetLevel(integer level)
{
  __qDebugLevel = level;
}



__qDebug(string message, integer level, string file, integer line)
{
  if (level < __qDebugLevel)
    __qError("DEBUG: " + message, file, line);
}





list qCommandCreate(string commandName)
{
  list command;

  command = [ commandName ];

  return command;
}



list qCommandAddSwitch(list command, list switch)
{
  string switchName    = llList2String(switch, 0);
  integer settingCount = llGetListLength(switch) - 1;

  command += [switchName, settingCount];

  if (settingCount > 0)
    command += llList2List(switch, 1, settingCount);

  return command;
}


qCommandUsage(list command)
{
  qUserError("USAGE: " + llList2String(command, 0));

  integer commandLength = llGetListLength(command);

  integer i;
  for (i = 1; i < commandLength; i) // i incremented below
    {
      string output = "";

      string switch         = llList2String(command, i);
      i++;
      integer settingCount  = llList2Integer(command, i);
      i++;

      output = "     " + switch;

      integer j;
      for (j = 0; j < settingCount; j++)
    {
      output = output + " " + llList2String(command, i);
      i++;
    }

      qUserError(output);
    }
}




list qCommandParseText(list command, string text)
{
  integer commandLength = llGetListLength(command);

  list parse = llParseString2List(text, [" "], []);
  integer parseLength = llGetListLength(parse);

  // make sure this is our command
  string parseCommand   = llList2String(parse, 0);
  string commandCommand = llList2String(command, 0);

  string objectName = llGetObjectName();
  string objectKey  = (string)llGetKey();

  if ((parseCommand != "*") &&   // wildcard matches all commands
      (parseCommand != commandCommand) &&
      (parseCommand != objectName + "/" + commandCommand) &&
      (parseCommand != objectKey + "/" + commandCommand))
    return [];

  list switches = [ parseCommand ];;

  integer i;
  for (i = 1; i < parseLength; i) // i incremented below
    {
      parseWord = llList2String(parse, i);
      i++;

      integer found = 0;

      // scan switch list to see which one we've got:
      integer j;
      for (j = 1; (j < commandLength) && (found == 0); j) // j incremented below
    {

      string switch         = llList2String(command, j);
      j++;
      integer settingCount  = llList2Integer(command, j);
      j++;

      if (parseWord == switch)
        {
          found = 1;
          switches += [ switch ];

          integer k;
          for (k = 0; k < settingCount; k++)
        {
          if (i >= parseLength)
            {
              qUserError("\"" + switch + "\" requires " +
                 (string)settingCount + " options.");
              qCommandUsage(command);
              return [];
            }

          parseWord = llList2String(parse, i);
          i++;

          string settingType = llList2String(command, j+k);

          if (settingType == "float")
            switches += [(float) parseWord];

          else if (settingType == "integer")
            switches += [(integer) parseWord];

          else // assume string
            switches += [ llUnescapeURL(parseWord) ];
        }
        }
     
      j += settingCount;
    }


      if (!found)
    {
      qUserError("\"" + parseWord + "\" not understood.");
      qCommandUsage(command);
      return [];
    }
    }


  return switches;
}

// universal switches


list qCommandAddDebugSwitch(list command)
{
  return qCommandAddSwitch(command, ["-debug", "integer"]);
}

list qCommandAddResetSwitch(list command)
{
  return qCommandAddSwitch(command, ["-reset"]);
}

list qCommandAddDieSwitch(list command)
{
  return qCommandAddSwitch(command, ["-die"]);
}

list qCommandAddHelpSwitch(list command)
{
  if (llGetInventoryType("Instruction Manual") == INVENTORY_NOTECARD)
    return qCommandAddSwitch(command, ["-help"]);

  else
    return command;
}


list qCommandAddUniversalSwitches(list command)
{
  command = qCommandAddDebugSwitch(command);
  command = qCommandAddResetSwitch(command);
  command = qCommandAddDieSwitch(command);
  command = qCommandAddHelpSwitch(command);

  return command;
}

integer qCommandExecuteUniversalSwitch(list switches, integer i)
{
  string switch = llList2String(switches, i);

  if (switch == "-debug")
    {
      i++;
      qDebugSetLevel(llList2Integer(switches, i));
      i++;
    }
  else if (switch == "-reset")
    {
      llResetScript();
      i++;
    }
  else if (switch == "-die")
    {
      llDie();
      i++;
    }

  else if (switch == "-help")
    {
      llGiveInventory(llGetOwner(),     
              "Instruction Manual");
      i++;
    }

  return i;
}




// should make most of these #defines - to take advantage of pseudo polymorphism


float qMin(float a, float b)
{
  if (a < b)
    return a;
  else
    return b;
}

float qMax(float a, float b)
{
  if (a > b)
    return a;
  else
    return b;
}


float qClamp(float min, float max, float value)
{
  if (value < min)
    return min;
  if (value > max)
    return max;

  return value;
}



float qScale(float origMin, float origMax,
         float newMin, float newMax,
         float value)
{
  float x = (value - origMin)/(origMax - origMin);
 
  return newMin + x * (newMax - newMin);
}



float qSmoothstep (float edge0, float edge1, float x)
{
   if (x < edge0)
      return 0;

   if (x >= edge1)
      return 1;

   x = (x - edge0) / (edge1 - edge0);

   return x * x * (3.0 - 2.0 * x);
}


float qMod(float value, float divisor)
{
  integer m = llFloor(value / divisor);

  return value - m * divisor;
}

float qRandom(float min, float max)
{
  return llFrand(max - min) + min;
}




// computes bspline index - for either closed (periodic) or open bsplines.
integer qSplineIndex(integer index, integer length, integer closed)
{
  if (closed)
    return (integer) qMod(index, length);

  if (index > length - 1)
    return length - 1;

  if (index < 0)
    return 0;

  return index;
}

// vector spline function - takes a list of
// vectors and creates a spline over
// range [0..llGetListLength(vectors)] (uniform


vector qSplineV(list vectors, float value, integer closed)
{
  float length = llGetListLength(vectors);

  float floor   = (float)llFloor(value);
  float remains = value - floor;
 
  integer i1 = qSplineIndex((integer)(floor - 1.0), (integer)length, closed);
  integer i2 = qSplineIndex((integer)(floor + 0.0), (integer)length, closed);
  integer i3 = qSplineIndex((integer)(floor + 1.0), (integer)length, closed);
  integer i4 = qSplineIndex((integer)(floor + 2.0), (integer)length, closed);

  vector v1 = llList2Vector(vectors, i1);
  vector v2 = llList2Vector(vectors, i2);
  vector v3 = llList2Vector(vectors, i3);
  vector v4 = llList2Vector(vectors, i4);

  // weights derived from bspline matrix - [Foley1990, p. 493]
  float t  = remains;
  float t2 = t * remains;
  float t3 = t2 * remains;

  float w1 = -t3 + (3.0 * t2) - (3.0 * t) + 1.0;
  float w2 = (3.0 * t3) - (6.0 * t2) + 4.0;
  float w3 = (-3.0 * t3) + (3.0 * t2) + (3.0 * t) + 1.0;
  float w4 = t3;


  vector p = ( (w1 * v1) + (w2 * v2) + (w3 * v3) + (w4 * v4) ) / 6.0;

  return p;
}


// calculate approximate length of spline by stepping in segments.
// (you know, i bet this has a closed form.  too bad i'm too lazy/stupid to derive it.)
float qSplineVLength(list vectors, float v1, float v2, integer segments, integer closed)
{
  float length = 0;

  float segmentDelta = (v2 - v1) / segments;

  integer i;
  for (i = 0; i < segments; i++)
    {
      float s1 = v1 + segmentDelta * i;
      float s2 = s1 + segmentDelta;

      vector p1 = qSplineV(vectors, s1, closed);
      vector p2 = qSplineV(vectors, s2, closed);

      length += llVecDist(p1, p2);
    }

  return length;
}





rotation qRotationScale(float a, rotation r)
{
  rotation s;
 
  s.x = r.x * a;
  s.y = r.y * a;
  s.z = r.z * a;
  s.s = r.s * a;

  return s;
}



rotation qRotationMix(rotation a, rotation b, float t)
{
  float o = llAngleBetween(a, b) / 2.0;

  if (llFabs(llSin(o)) < 0.001) // too close!
    return a;

  if (o > PI/2.0)
    a = (a - a); // take shortest path, please

  rotation c = (qRotationScale(llSin((1.0 - t) * o), a) +
        qRotationScale(llSin(t * o), b));

  c = qRotationScale(1.0 / llSin(o), c);
                 
  return c;
}


string qFloat2String(float value, integer precision)
{
  integer base    = llFloor(value);
  float   remainder = value - base;

  string valueStr = (string) base;

  if (remainder != 0)
    {
      string remainderStr = (string) remainder;
      valueStr += llGetSubString(remainderStr, 1, precision + 1);
    }

  return valueStr;
}


string qVector2String(vector value, integer precision)
{

  return ("< " +
      qFloat2String(value.x, precision) + ", " +
      qFloat2String(value.y, precision) + ", " +
      qFloat2String(value.z, precision) + " >");
     
}



list __qDynaPrims;
float __qDynaRadius = 0;
integer __qDynaCount = 10;
vector __qDynaOrigin;


qDynaSetOrigin(vector o)
{
  __qDynaOrigin = o;
}

qDynaSetRadius(float r)
{
  __qDynaRadius = r;
}

qDynaSetCount(integer c)
{
  __qDynaCount = c;
}

integer qDynaRez()
{
  while(llGetListLength(__qDynaPrims) < __qDynaCount)
    {
      integer com = (integer)qRandom(10000, 10000000);

      vector place = (__qDynaOrigin +
              __qDynaRadius * llVecNorm(<llFrand(2.0) - 1,
                        llFrand(2.0) - 1,
                        llFrand(2.0) - 1>));

      llRezObject("qDynaPrim", llGetPos() + place,
          <0,0,0>, ZERO_ROTATION, com);

      // llSleep(1);

      __qDynaPrims = __qDynaPrims + [ com ];

    }

  integer front = llList2Integer(__qDynaPrims, 0);

  __qDynaPrims = llDeleteSubList(__qDynaPrims, 0, 0);

  return front;
}


qDynaCleanup()
{
  llSleep(10);
  while (llGetListLength(__qDynaPrims) > 0)
    {
      integer com = llList2Integer(__qDynaPrims, 0);
      llSay(com, "prim -die");
      __qDynaPrims = llDeleteSubList(__qDynaPrims, 0, 0);
    }
}



list command;
key scriptKey;
integer scriptLineNumber;
integer scriptRunning;
integer scriptCurrentPrim;




executeScriptLine(string line)
{
  __qDebug("executeScriptLine: " + line,  10, "primscript.lsl", 19);
  list words = llParseString2List(line, [" "], []);

  if ((llGetListLength(words) == 1) &&
      (llList2String(words, 0) == "newPrim"))
    scriptCurrentPrim = qDynaRez();
 
  else
    llSay(scriptCurrentPrim, line);
}


startScript(key script)
{
  __qDebug("startScript: " + (string)script,  5, "primscript.lsl", 33);
  scriptRunning = 1;
  scriptKey = script;
  scriptLineNumber = 0;
 
  llGetNotecardLine(scriptKey, scriptLineNumber);
}


endScript()
{
  __qDebug("endScript",  5, "primscript.lsl", 44);
  scriptRunning = 0;
  qDynaCleanup();
}



buildCommand()
{
  command = qCommandCreate("primscript");
  command = qCommandAddSwitch(command, ["-script", "string"]);
  command = qCommandAddUniversalSwitches(command);
}


initCommand()
{
  buildCommand();
 
  llListen(500, "", NULL_KEY, "");
}



executeCommand(list switches)
{
  integer switchesLength = llGetListLength(switches);

  integer i;
  for (i = 1; i < switchesLength; i)
    {
      string switch = llList2String(switches, i);

      if (switch == "-script")
        {
      startScript((key)llList2String(switches, i+1));
          i += 2;
        }
      else
        i = qCommandExecuteUniversalSwitch(switches, i);

    }
}


listenCommand(integer channel, string name, key id,  string message)
{
  // we only accept commands from our owner
  if (id != llGetOwner())
    return;

  list switches = qCommandParseText(command, message);

  if (switches != [])
    executeCommand(switches);
}



default
{
  state_entry()
    {
      scriptRunning = 0;
      initCommand();
    }

  dataserver(key id, string data)
    {
      if (data != EOF)
        {
      executeScriptLine(data);

          scriptLineNumber++;
          llGetNotecardLine(scriptKey, scriptLineNumber);
        }
      else
        endScript();
    }


  listen(integer channel, string name, key id,  string message)
    {
      if(!scriptRunning)
    listenCommand(channel, name, id, message);
    }

}
