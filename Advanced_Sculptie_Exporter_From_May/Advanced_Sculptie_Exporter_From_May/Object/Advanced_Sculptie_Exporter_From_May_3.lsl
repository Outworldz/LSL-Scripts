// :CATEGORY:Maya
// :NAME:Advanced_Sculptie_Exporter_From_May
// :AUTHOR:Adelle Fitzgerald
// :CREATED:2010-11-18 21:08:40.607
// :EDITED:2013-09-18 15:38:47
// :ID:18
// :NUM:26
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Transform
// :CODE:
// assembled by ../bin/lslcc -I. -I.. -I../.. transform.lsl
// by qarl with qLab v0.0.3
// Mon Jun 18 19:11:27 PDT 2007
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




vector qGetLocalPosition()
{
  return llGetPos();
}

vector qGetGlobalPosition()
{
  return llGetPos() + llGetRegionCorner();
}

vector qGlobal2LocalPosition(vector global)
{
  return global - llGetRegionCorner();
}

vector qLocal2GlobalPosition(vector local)
{
  return local + llGetRegionCorner();
}

qSetLocalPosition(vector local)
{
  llSetPos(local);
}

qSetGlobalPosition(vector global)
{
  qSetLocalPosition(qGlobal2LocalPosition(global));
}

qGotoGlobalPosition(vector target)
{
  vector position = qGetGlobalPosition();

  integer i;
  for (i = 0;
       ((i < 1000) &&  // no infinite loops, thank you.
    (llVecDist(target, position) > 0.01));
       i++)
    {
      qSetGlobalPosition(target);
      position = qGetGlobalPosition();
    }
}







list transformCommand;

buildTransformCommand()
{
  transformCommand = qCommandCreate("transform");
  transformCommand = qCommandAddUniversalSwitches(transformCommand);

  transformCommand = qCommandAddSwitch(transformCommand, ["-setPos",
                                        "float", "float", "float"]);
  transformCommand = qCommandAddSwitch(transformCommand, ["-setGlobalPos",
                                        "float", "float", "float"]);
  transformCommand = qCommandAddSwitch(transformCommand, ["-setRelativePos",
                                        "float", "float", "float"]);
  transformCommand = qCommandAddSwitch(transformCommand, ["-setScale",
                                        "float", "float", "float"]);
  transformCommand = qCommandAddSwitch(transformCommand, ["-setRot",
                                        "float", "float", "float"]);

  transformCommand = qCommandAddSwitch(transformCommand, ["-gotoGlobalPos",
                                        "float", "float", "float"]);
  transformCommand = qCommandAddSwitch(transformCommand, ["-gotoRelativePos",
                                        "float", "float", "float"]);
  transformCommand = qCommandAddSwitch(transformCommand, ["-gotoSim",
                                        "integer", "integer"]);
  transformCommand = qCommandAddSwitch(transformCommand, ["-sleep",
                                        "integer"]);
  transformCommand = qCommandAddSwitch(transformCommand, ["-deleteScript"]);
}



initTransformCommand()
{
  buildTransformCommand();

  llListen(500, "", NULL_KEY, "");

  integer privateChannel = llGetStartParameter();
  if (privateChannel != 0)
    llListen(privateChannel, "", NULL_KEY, "");
}



executeTransformCommand(list switches)
{
  integer switchesLength = llGetListLength(switches);

  integer i;
  for (i = 1; i < switchesLength; i)
    {
      string switch = llList2String(switches, i);

      if (switch == "-setPos")
    {
      llSetPos(<llList2Float(switches, i+1),
           llList2Float(switches, i+2),
           llList2Float(switches, i+3)>);
      i+=4;
    }
      else if (switch == "-setGlobalPos")
    {
      qSetGlobalPosition(<llList2Float(switches, i+1),
                 llList2Float(switches, i+2),
                 llList2Float(switches, i+3)>);
      i+=4;
    }
      else if (switch == "-setRelativePos")
    {
      vector position = qGetGlobalPosition();

      qSetGlobalPosition(position + (<llList2Float(switches, i+1),
                     llList2Float(switches, i+2),
                     llList2Float(switches, i+3)>));
      i+=4;
    }
      else if (switch == "-setScale")
    {
      llSetScale(<llList2Float(switches, i+1),
             llList2Float(switches, i+2),
             llList2Float(switches, i+3)>);
      i+=4;
    }
      else if (switch == "-setRot")
    {
      llSetRot(llEuler2Rot(<llList2Float(switches, i+1),
                   llList2Float(switches, i+2),
                   llList2Float(switches, i+3)>));
      i+=4;
    }

      else if (switch == "-deleteScript")
    {
      llRemoveInventory(llGetScriptName());
      i++;
    }


      else if (switch == "-sleep")
    {
      llSleep(llList2Integer(switches, i+1));
      i+=2;
    }

      else if (switch == "-gotoSim")
    {
      vector position = qGetGlobalPosition();
      position.x = llList2Float(switches, i+1) * 256 + 128;
      position.y = llList2Float(switches, i+2) * 256 + 128;
      qGotoGlobalPosition(position);

      i+=3;
    }
      else if (switch == "-gotoGlobalPos")
    {
      qGotoGlobalPosition(<llList2Float(switches, i+1),
                  llList2Float(switches, i+2),
                  llList2Float(switches, i+3)>);
      i+=4;
    }
      else if (switch == "-gotoRelativePos")
    {
      vector position = qGetGlobalPosition();
      qGotoGlobalPosition(position + (<llList2Float(switches, i+1),
                      llList2Float(switches, i+2),
                      llList2Float(switches, i+3)>));
      i+=4;
    }

      else if (switch == "-gotoSim")
    {
      vector position = qGetGlobalPosition();
      position.x = llList2Float(switches, i+1) * 256 + 128;
      position.y = llList2Float(switches, i+2) * 256 + 128;
      qGotoGlobalPosition(position);

      i+=3;
    }



      else
    i = qCommandExecuteUniversalSwitch(switches, i);

    }
}


parseTransformCommand(string message)
{
list switches = qCommandParseText(transformCommand, message);

  if (switches != [])
    executeTransformCommand(switches);

}


listenTransformCommand(integer channel, string name, key id,  string message)
{
  // we only accept commands on the public channel from our owner
  if ((channel == 500) &&
      (name != llKey2Name(llGetOwner())))
    return;

  parseTransformCommand(message);
}


linkMessageTransformCommand(integer sender, integer num, string message, key id)
{
  parseTransformCommand(message);
}


default
{
  state_entry()
    {
      initTransformCommand();
    }

  on_rez(integer n)
    {
      initTransformCommand();
    }

  listen(integer channel, string name, key id,  string message)
    {
      listenTransformCommand(channel, name, id, message);
    }

  link_message(integer sender, integer num, string message, key id)
    {
      linkMessageTransformCommand(sender, num, message, id);
    }
}
