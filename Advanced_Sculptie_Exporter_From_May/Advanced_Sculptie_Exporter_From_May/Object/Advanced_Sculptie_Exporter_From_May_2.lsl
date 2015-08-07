// :CATEGORY:Maya
// :NAME:Advanced_Sculptie_Exporter_From_May
// :AUTHOR:Adelle Fitzgerald
// :CREATED:2010-11-18 21:08:40.607
// :EDITED:2013-09-18 15:38:47
// :ID:18
// :NUM:25
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// // Texture
// :CODE:
// assembled by ../bin/lslcc -I. -I.. -I../.. texture.lsl
// by qarl with qLab v0.0.3
// Tue Jun 19 13:54:40 PDT 2007
//
// Fixed for opensim by Adelle Fitzgerald and also added clean up routine to remove all the left over textures - 5 november 2009



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







list textureCommand;

buildTextureCommand()
{
  textureCommand = qCommandCreate("texture");
  textureCommand = qCommandAddUniversalSwitches(textureCommand);

  textureCommand = qCommandAddSwitch(textureCommand, ["-setColor",
                                        "float", "float", "float", "integer"]);
  textureCommand = qCommandAddSwitch(textureCommand, ["-setAlpha",
                                        "float", "integer"]);
  textureCommand = qCommandAddSwitch(textureCommand, ["-setTexture",
                                        "string", "integer"]);
  textureCommand = qCommandAddSwitch(textureCommand, ["-setTexturePos",
                                        "float", "float", "float", "float", "float", "integer"]);
  textureCommand = qCommandAddSwitch(textureCommand, ["-setFullBright", "integer", "integer" ]);
  textureCommand = qCommandAddSwitch(textureCommand, ["-sleep",
                                        "integer"]);
  textureCommand = qCommandAddSwitch(textureCommand, ["-deleteScript"]);
}



initTextureCommand()
{
  buildTextureCommand();

  llListen(500, "", NULL_KEY, "");

  integer privateChannel = llGetStartParameter();
  if (privateChannel != 0)
    llListen(privateChannel, "", NULL_KEY, "");
}



executeTextureCommand(list switches)
{
  integer switchesLength = llGetListLength(switches);

  integer i;
  for (i = 1; i < switchesLength; i)
    {
      string switch = llList2String(switches, i);

      if (switch == "-setColor")
    {
      llSetColor(<llList2Float(switches, i+1),
             llList2Float(switches, i+2),
             llList2Float(switches, i+3)>,
             llList2Integer(switches, i+4));
      i+=5;
    }
 
      else if (switch == "-setAlpha")
    {
      llSetAlpha(llList2Float(switches, i+1),
             llList2Integer(switches, i+2));
      i+=3;
    }

      else if (switch == "-setTexture")
    {
      string texture = llList2String(switches, i+1);

      if (texture == "blank")
        texture = "5748decc-f629-461c-9a36-a35a221fe21f";

      // if inventory name give, convert to asset id when possible
      key uuid = llGetInventoryKey(texture);
      if (uuid != NULL_KEY)
        texture = (string)uuid;

      llSay(0, "setting texture to: " + texture);

      llSetTexture(texture,
               llList2Integer(switches, i+2));
      i+=3;
    }

      else if (switch == "-setTexturePos")
    {
      integer side = llList2Integer(switches, i+6);

      llOffsetTexture(llList2Float(switches, i+1),
              llList2Float(switches, i+2),
              side);
      llRotateTexture(llList2Float(switches, i+3),
              side);
      llScaleTexture(llList2Float(switches, i+4),
             llList2Float(switches, i+5),
             side);

      i+=7;
    }

      else if (switch == "-setFullBright")
    {
      integer side = llList2Integer(switches, i+1);
      integer on = llList2Integer(switches, i+2);

      llSetPrimitiveParams([PRIM_FULLBRIGHT, side, on]);

      i+=3;
    }

      else if (switch == "-deleteScript")
    {
      llSetTimerEvent(1);
      i++;
    }


      else if (switch == "-sleep")
    {
      llSleep(llList2Integer(switches, i+1));
      i+=2;
    }


      else
    i = qCommandExecuteUniversalSwitch(switches, i);

    }
}


parseTextureCommand(string message)
{
list switches = qCommandParseText(textureCommand, message);

  if (switches != [])
    executeTextureCommand(switches);

}


listenTextureCommand(integer channel, string name, key id,  string message)
{
  // we only accept commands on the public channel from our owner
  if ((channel == 500) &&
      (name != llKey2Name(llGetOwner())))
    return;

  parseTextureCommand(message);
}


linkMessageTextureCommand(integer sender, integer num, string message, key id)
{
  parseTextureCommand(message);
}


default
{
  state_entry()
    {
      initTextureCommand();
    }

  on_rez(integer n)
    {
      initTextureCommand();
    }

  listen(integer channel, string name, key id,  string message)
    {
      listenTextureCommand(channel, name, id, message);
    }

  link_message(integer sender, integer num, string message, key id)
    {
      linkMessageTextureCommand(sender, num, message, id);
    }
    timer()
    {
        //Check to make sure all scripts have removed themselves then clean up textures and remove this script
        if (llGetInventoryNumber(INVENTORY_SCRIPT) == 1)
        {
            integer textureNo = llGetInventoryNumber(INVENTORY_TEXTURE);
            integer i;
            for (i = 0; i < textureNo; i++)
            {
                string textureName = llGetInventoryName(INVENTORY_TEXTURE,0);
                llRemoveInventory(textureName);
                llSleep(0.2);
            }
            llRemoveInventory(llGetScriptName());
        }
        else
        {
            llSetTimerEvent(1);
        }
    }   
}
