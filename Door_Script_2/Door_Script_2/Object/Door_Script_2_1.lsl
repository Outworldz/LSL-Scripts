// :CATEGORY:Door
// :NAME:Door_Script_2
// :AUTHOR:Melchoir Tokhes
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:52
// :ID:257
// :NUM:348
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Door Script 2.lsl
// :CODE:

//    Door Script 1.0 by Melchoir Tokhes
//    Copyright (C) 2007  Accountholder of Melchoir Tokhes(02/02/2007)
//
//    This program is free software; you can redistribute it and/or modify
//    it under the terms of the GNU General Public License version 2 as published
//    by the Free Software Foundation.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License along
//    with this program; if not, write to the Free Software Foundation, Inc.,
//    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
//
//    The full text of the GPL2 can be found at http://www.gnu.org/licenses/gpl.txt

//      If you find this script useful and you can spare it, please consider donating
//  a tad bit of money to me -- whatever you think is fair.  Depending on my availability
//  I will support this door.  If you have any questions drop me a line.

string  ACCESS_LIST     = "access list";    //name of notecard containing access list
integer DOOR_TYPE       = 1;                //1 for swinging, 2 for sliding #IMPORTANT NOTE AT BOTTOM#
integer OPEN_METHOD     = 1;                //1 for touch, 2 for collision
float   OPEN_DEGREES    = 90.0;             //degrees to swing open for swinging doors
integer NEED_ACCESS     = 1;                //use whitelist, 0 for no, non-0 for yes
float   OPEN_TIME       = 4.5;              //time(in seconds) to stay open
integer DIRECTION       = 1;                //which way the door moves (-1 or 1)*
float   EXPOSED_TIP     = 0.1;              //how much the open sliding door hangs out**
integer COM_CHAN        = 16777;            //channel used to communicate with synched doors***
integer TWO_PART_DOOR   = 0;                //set this to non-0 if the door communicates with
                                            //another door to open in synch****
                                            //See more notes at the bottom of this file
list accessList;
integer listCounter;

vector startingPosition;
rotation startingRotation;
vector doorScale;

key queryIDCheck;


close()
{
    llSetRot(startingRotation);
    llSetPos(startingPosition);
    llSetTimerEvent(0);
}

open()
{
    if(DOOR_TYPE == 1){//This is for the swinging door type
        llSetRot(startingRotation * llEuler2Rot(<0, 0, DIRECTION * OPEN_DEGREES * DEG_TO_RAD> ));
        llSetTimerEvent(OPEN_TIME);
    }
    
    if(DOOR_TYPE == 2){//This is for the sliding door type
        llSetPos(startingPosition + <0, doorScale.y * DIRECTION - (doorScale.y * DIRECTION * EXPOSED_TIP), 0>);//**
        llSetTimerEvent(OPEN_TIME);
    }
}


default
{
    state_entry()
    {        
        integer numberOfCards;
        integer foundCard;

        startingPosition = llGetPos();
        startingRotation = llGetRot();
        doorScale = llGetScale();
        if(TWO_PART_DOOR) llListen(COM_CHAN, "", NULL_KEY, ".");
        
        for(numberOfCards = llGetInventoryNumber(INVENTORY_NOTECARD); numberOfCards > 0; --numberOfCards)
            if(llGetInventoryName(INVENTORY_NOTECARD, numberOfCards - 1) == ACCESS_LIST) foundCard = 1;
        if(NEED_ACCESS){
            if(foundCard){queryIDCheck = llGetNotecardLine(ACCESS_LIST, listCounter++);}
            else llOwnerSay("Could not find access list");
        }
    }

    touch_start(integer num_detected)
    {
        if(OPEN_METHOD == 1){
            string accesseeCandidate = llToLower(llDetectedName(0));
            if(NEED_ACCESS){
                if(TWO_PART_DOOR) llWhisper(COM_CHAN, ".");
                if(llListFindList(accessList, [accesseeCandidate]) != -1) open();
                else llWhisper(0, "Locked.");
            }
        }
    }
    
    collision(integer num_detected)
    {
        if(OPEN_METHOD == 2){
            string accesseeCandidate = llToLower(llDetectedName(0));
            if(NEED_ACCESS){
                if(TWO_PART_DOOR) llWhisper(COM_CHAN, ".");
                if(llListFindList(accessList, [accesseeCandidate]) != -1) open();
                else llWhisper(0, "Locked.");
            }
        }
    }

    listen(integer channel, string name, key id, string message)
    {
        open();
    }
    
    timer()
    {
        close();
    }
        
    dataserver(key queryID, string data)
    {
        if(queryIDCheck == queryID){
            if(data != EOF){
                accessList += llToLower(data);
                queryIDCheck = llGetNotecardLine(ACCESS_LIST, listCounter++);
            }
            else llOwnerSay("Access list loading complete.");
        }
    }
    
}

//  *   For pairs of doors, typically one would need to invert the direction for the other
//  door that corresponds.  If the door is sliding on the wrong axis, move the expression
//  that determines the movement to the other axis, either X or W, and set the other to 0

//  **  This number represents how much(in factor of door width) of the door is left showing
//  in its opened position.  If the door is built using the technique of setting the cut
//  to 0.375 - 0.875 as is done for a swinging door then be sure to add " / 2 " immediately
//  after "doorScale.y" in the expression that determines its new position.  Depending on how
//  the door is built, you might have to use "doorScale.x" in the expression instead.
//  
//  It's feasable, using trickery of this number and the synched doors functionality to
//  make multi-section telescoping doors :)

//  *** This number represents the channel the door whispers on to activate the other door
//  in a synched pair of doors.  If you are using another pair of doors within this range
//  and one pair is interfering with the other, be sure to make this channel unique to
//  each pair of doors.

//  ****This number is either 1 or -1, which reverses the direction the door moves when
//  opened.  If you are using a synched pair of doors, first get one door to open the way
//  you want, then reverse it on the other one.

//  #   If you want to use the swinging door type, the door must be build as a block
//  with a cut from 0.375 - 0.875 such that the palpable portion of the door is only
//  half of it's true dimensions, and the true center of the door is at one edge of
//  the palpable portion.  Position the door so that this center location is at the
//  position from which you would like the door to pivot.
//      You may also be interested in setting the texture for the facial surfaces of
//  the door as 2 repeats per face and 0.5 offset on the X axis.
// END //
