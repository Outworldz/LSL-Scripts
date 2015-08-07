// :CATEGORY:Updater
// :NAME:UpdateSubscriber
// :AUTHOR:Emma Nowhere
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:08
// :ID:938
// :NUM:1348
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// UpdateSubscriber 1.lsl
// :CODE:

 //////////////////////////////////////////////////////////////////////////////////////
 //
 //    UpdateSubscriber
 //    Version 1.01 Release
 //    Copyright (C) 2007, Emma Nowhere
 //    emma.nowhere@yahoo.com
 //    
 //    Place inside a prim that you want to receive object updates from an
 //    UpdateServer.  You should have your UpdateServer already set up
 //    before adding this script to a prim.
 //
 //    At startup the script will broadcast a request for all UpdateServers 
 //    in the region and output the results to you.
 //
 //    You need to register with a specific UpdateServer to enable updates
 //    to be received.
 //
 //    To lock onto a specific UpdateServer, type:
 //
 //    /128 UpdateSubscriberRegister <subscriberkey> <serverkey>
 //
 //    where <subscriberkey> is the key of the prin containing the script
 //    and <serverkey> is the key shown next to the UpdateServer name that is
 //    displayed when this script displays the available UpdateServers in
 //    the region.
 //
 //    License:
 //    
 //    This library is free software; you can redistribute it and/or
 //    modify it under the terms of the GNU Lesser General Public License
 //    as published by the Free Software Foundation; either
 //    version 2.1 of the License, or (at your option) any later version.
 //    
 //    This library is distributed in the hope that it will be useful,
 //    but WITHOUT ANY WARRANTY; without even the implied warranty of
 //    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 //    GNU Lesser General Public License for more details.
 //    
 //    You should have received a copy of the GNU Lesser General Public License
 //    along with this library; if not, write to the Free Software
 //    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 //    
 //////////////////////////////////////////////////////////////////////////////////////
 
 integer listenChannel = 128;
 integer listenHandle = 0;
 string scriptName;
 key subscriberKey;
 key serverKey;
 integer registered = FALSE;
 
 integer containsItem(string itemName) {
 
     integer total = llGetInventoryNumber(INVENTORY_ALL);
     integer i;
     for (i = 0; i < total; i++) {
         string name = llGetInventoryName(INVENTORY_ALL, i);
         if ((name != scriptName) && (itemName == name)) return TRUE;
     }
     return FALSE;
 }
 
 default {
 
     state_entry() {
 
         scriptName = llGetScriptName();
         subscriberKey = llGetKey();
 
         llSay(0, "UpdateSubscriber installed in object " + llGetObjectName() + " (" + (string)subscriberKey + ")");
         listenHandle = llListen(listenChannel, "", NULL_KEY, "");
 
         llSay(0, "UpdateSubscriber listening on channel #" + (string)listenChannel);
         llRegionSay(listenChannel, "UpdateServersQuery");
     }  
 
     listen(integer channel, string name, key id, string message) {
 
         list parsed = llParseString2List(message, [" "], []);
         integer l = llGetListLength(parsed);
         if (l == 0) return;
 
         string command = llList2String(parsed, 0);
 
         if (!registered) {
 
                 if ((l == 3) && (command == "UpdateSubscriberRegister")) {
 
                     if ((key)llList2String(parsed, 1) != subscriberKey) return;
 
                     serverKey = (key)llList2String(parsed, 2);
 
                     llListenRemove(listenHandle);
 
                     listenHandle = llListen(listenChannel, "", serverKey, "");
 
                     llSay(0, "Registered to Update Server " + llKey2Name(serverKey) + " (" + (string)serverKey + ")"); 
 
                     registered = TRUE;
                 }
                 else if ((l == 2) && (command == "UpdateServerAvailable")) {
 
                     key serverKey = (key)llList2String(parsed, 1);
 
                     string msg = "Update Server available:\n" + llKey2Name(serverKey) + " (" + (string)serverKey + ")\n\n" +
                     "Copy and paste the following line to register to this server:\n\n" +
                     "/128 UpdateSubscriberRegister " + (string)subscriberKey + " " + (string)serverKey + "\n\n";
 
                     llSay(0, msg);        
                 }
 
 
                 return;
         }
 
 
         if ((l == 2) && (command == "UpdateAvailable")) {
 
             string itemName = llUnescapeURL(llList2String(parsed, 1));
 
             if (containsItem(itemName)) {
 
                 llSay(0, "Deleting old version of item " + itemName);
                 llRemoveInventory(itemName);
 
                 llSay(0, "Requesting new version of item " + itemName);
                 llRegionSay(listenChannel, "UpdateRequest " + llEscapeURL(itemName) + " " + (string)subscriberKey + " " + (string)serverKey);
             }
         }
         else if ((l == 2) && (command == "UpdateSubscribersQuery")) {
 
             key serverKey = (key)llList2String(parsed, 1);
 
             llRegionSay(listenChannel, "UpdateSubscriberRegistered " + (string)serverKey + " " + (string)subscriberKey);
         }
 
     }
 
 }
// END //
