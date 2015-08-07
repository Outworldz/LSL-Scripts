// :CATEGORY:Rezzers
// :NAME:CaseInsensitiveListenRezzer
// :AUTHOR:Chasingred3 Ixtab
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:50
// :ID:160
// :NUM:228
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// CaseInsensitive-Listen-Rezzer.lsl
// :CODE:


//Deluxe Listen Rezzer
//Created By : Chasingred3 Ixtab
//Created For : Zippo Nabob
//No need to type in the right CaSe to make your
//Commands to work :)

integer channel = 0;//What channel you want it to listen on

////////////////////////////////////////////////////////////////////////////
/////////////////////////////////1st Object Info////////////////////////////
////////////////////////////////////////////////////////////////////////////
string object1command = "rez object1"; /////////////////////////////////
string object1Name = "Object1";//First objects name/////////////////////
vector object1Pos = <0,0,0>;//First Objects Position  Cordanates////////
rotation object1rotation = <0,0,0,1>;//First Objects Rotation///////////
////////////////////////////////////////////////////////////////////////////

//==========================================================================

////////////////////////////////////////////////////////////////////////////
/////////////////////////////////2nd Object Info////////////////////////////
////////////////////////////////////////////////////////////////////////////
string object2command = "rez object2"; /////////////////////////////////
string object2Name = "Object1";//Objects name/////////////////////
vector object2Pos = <0,0,0>;//Objects Position - Cordanates////////
rotation object2rotation = <0,0,0,1>;//Objects Rotation///////////
///////////////////////////////////////////////////////////////////////

//==========================================================================

////////////////////////////////////////////////////////////////////////////
/////////////////////////////////3nd Object Info////////////////////////////
////////////////////////////////////////////////////////////////////////////
string object3command = "rez object3"; /////////////////////////////////
string object3Name = "Object3";//Objects name/////////////////////
vector object3Pos = <0,0,0>;//Objects Position - Cordanates////////
rotation object3rotation = <0,0,0,1>;//Objects Rotation///////////
///////////////////////////////////////////////////////////////////////

//==========================================================================

////////////////////////////////////////////////////////////////////////////
/////////////////////////////////4th Object Info////////////////////////////
////////////////////////////////////////////////////////////////////////////
string object4command = "rez object4"; /////////////////////////////////
string object4Name = "Object4";//objects name/////////////////////
vector object4Pos = <0,0,0>;//Objects Position - Cordanates////////
rotation object4rotation = <0,0,0,1>;//Objects Rotation///////////
///////////////////////////////////////////////////////////////////////

//==========================================================================

////////////////////////////////////////////////////////////////////////////
/////////////////////////////////5th Object Info////////////////////////////
////////////////////////////////////////////////////////////////////////////
string object5command = "rez object5"; /////////////////////////////////
string object5Name = "Object5";//Objects name/////////////////////
vector object5Pos = <0,0,0>;//Objects Position - Cordanates////////
rotation object5rotation = <0,0,0,1>;//Objects Rotation///////////
///////////////////////////////////////////////////////////////////////

//==========================================================================

//Please, Dont touch anything down here :P

//==========================================================================
//==========================================================================
//==========================================================================
string obj1 = "";
string obj2 = "";
string obj3 = "";
string obj4 = "";
string obj5 = "";

default
{
    state_entry()
    {//llGetOwner --- NULL_KEY
        llListen(channel, "", llGetOwner(), "");
        string obj1 = llToLower(object1command);
        string obj2 = llToLower(object2command);//Changes all commands to
        string obj3 = llToLower(object3command);//lower case
        string obj4 = llToLower(object4command);
        string obj5 = llToLower(object5command);
    }

    listen(integer channel, string name, key id, string message)
    {
    string cmd;
    cmd = llToLower(message);//Turnes what YOU say to lower
                            //case letters  
        if(cmd == obj1)
        {
            llRezObject(object1Name, object1Pos, ZERO_VECTOR, object1rotation, 42);

        }
    
        if(cmd == obj2)
        {
            llRezObject(object2Name, object2Pos, ZERO_VECTOR, object2rotation, 42);
        }
    
        if(cmd == obj3)
        {
            llRezObject(object3Name, object3Pos, ZERO_VECTOR, object3rotation, 42);
        }
    
        if(cmd == obj4)
        {
        llRezObject(object4Name, object4Pos, ZERO_VECTOR, object4rotation, 42);
        }
    
        if(cmd == obj5)
        {
            llRezObject(object5Name, object5Pos, ZERO_VECTOR, object5rotation, 42);
        }
    }  
}     // end 
