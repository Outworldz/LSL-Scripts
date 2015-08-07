// :CATEGORY:Building
// :NAME:Theds_MegaPrim_Script_4
// :AUTHOR:thedmanedman
// :CREATED:2011-09-25 21:03:01.683
// :EDITED:2013-09-18 15:39:07
// :ID:888
// :NUM:1264
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// This script allows you to resize the prim up to 64M per side, even if your SL client does not allow that yet.  Menus or use chat commands.  Examples:X = 5.5 // Sets the X plane to 5.5Y + .5 // Adds .5 to the Y planeZ - 10 // subtracts 10 from the Z planexyz * .5 // Reduces the prim by halfxyz * 2 // Doubles the size of the prim
Set  20 15 .5 // changes the prims X, Y and Z parameters to those numbers
undo //will undo the last command
// :CODE:
// Thed's Megaprim Sizer
// 20110914
// By Thedman Edman

////////// ////////// //////////
//
// Version info:
//  0.1 Proof of concept release
//      fully debugged
//  0.2 Comment and variable clean up for open release
//  0.3 Corrected Multiplier bug
//      Help screen clean up
//  0.31 Changed variables in the size assign section
//  0.4 Added 'redo' to undo
//      Sore code clean up
//

////////// ////////// //////////
//
//  Constants
//
key ThedKey = "46a9dc6e-9fed-46f4-8975-f5ca526ce6a4";
list Commands = ["X", "Y", "Z", "XYZ", "Undo", "Remove",
    "=", "+", "-", "*",
    "0", ".", "Go", "1", "2", "3", "4", "5", "6", "7", "8", "9" ];
string Err01 = "Invalid number of arguements";
string Err02 = "I could not understand the vector supplied";

////////// ////////// //////////
//
//  Global Variables
//      available to all subroutines
//
integer MenuChannel=1222; // Is set random later to prevent crosstalk

key OwnerKey; // Holds owner's key
key ToucherKey;  // Last one to touch it

integer Handle_0; //Menu listen
integer Handle_1; // Owner/ All Listen
integer Handle_2; // Thed Listen

vector UndoSize; //Holds size before change for undo function
string Command = ""; //Built from menu functions


////////// ////////// //////////
//
//  Routine to display help screen
//
DisplayHelp()  {
    llSay(0,"\nThank you for choosing a scripted product by Thed.\n This script allows you to resize the prim up to 64M per side, even if your SL client does not allow that yet.  Click me to activate the menus or use chat commands\nExample commands:\n X = 5.5 // Sets the X plane to 5.5\n Y + .5 // Adds .5 to the Y plane\n Z - 10 // subtracts 10 from the Z plane\n xyz * .5 // Reduces the prim by half\n xyz * 2 // Doubles the size of the prim\n Set  20 15 .5 // changes the prims X, Y and Z parameters to those numbers\n undo //will undo the last command");
}


////////// ////////// //////////
//
//  Routine to set up Listen events
//
InitListen()  {
    Handle_0 = llListen(MenuChannel,"",NULL_KEY,""); //Listens to menu
    Handle_1 = llListen(0,"",OwnerKey,""); //Listens to owner
    Handle_2 = llListen(0,"",ThedKey,""); //Listens to Thed
}


////////// ////////// //////////
//
//  Routines to Display Menus
//
Display_Menu_Main(key Uid)  {
    Command=""; //Clear command
    list Menu = llList2List( Commands, 0, 5);
    llDialog (Uid, "Select from the options below" , Menu, MenuChannel);
}

Display_Menu_Functions(key Uid)  {
    list Menu = llList2List( Commands, 6, 9);
    llDialog(Uid, "Select a function ... \n" + Command , Menu, MenuChannel);
}

Display_Menu_Num (key Uid)  {
    list Menu = llList2List( Commands, 10, -1);
    llDialog(Uid, "Select an option ... \n" + Command , Menu, MenuChannel);
}


////////// ////////// //////////
//
//  Routine to remove this Script
//
KillScript()  {
    llRemoveInventory(llGetScriptName());
}


////////// ////////// //////////
//
//  Routine to display error
//
DisplayErr(string message)  {
    llInstantMessage(ToucherKey, message);
}


////////// ////////// //////////
//
//  Routine to process commands
//
ProcessCommands()  {
    Command=llToLower(Command);
    list Words = llParseString2List( Command, [" "], []);
    string Word1 = llList2String(Words,0);
    string Word2 = llList2String(Words,1);
    float F1 = llList2Float(Words,2);
    vector CurSize=llGetScale();
    vector V1 = ZERO_VECTOR;
//Note: May remove else commands to make it easier to follow
    //Build +/-/=  Vector in V1
    if (Word1 == "x") V1 += <F1,0,0>;
    if (Word1 == "y") V1 += <0,F1,0>;
    if (Word1 == "z") V1 += <0,0,F1>;
    if (Word1 == "xyz") V1 = <F1, F1, F1>;
    //Now set V1 to the desired size based on function
    if (Word2 == "+") V1 += CurSize;
    if (Word2 == "-") V1 = CurSize - V1;
    if (Word2 == "=")  {
        if (Word1 == "x") V1 = <F1,CurSize.y, CurSize.z>;
        else if (Word1 == "y") V1 = <CurSize.x, F1, CurSize.z>;
        else if (Word1 == "z") V1 = <CurSize.x, CurSize.y, F1>;
    }
    if (Word2 == "*")  {
        V1 = CurSize;
        if (Word1 == "x" || Word1 == "xyz") V1.x *= F1;
        if (Word1 == "y" || Word1 == "xyz") V1.y *= F1;
        if (Word1 == "z" || Word1 == "xyz") V1.z *= F1;
    }
    //Set new prim size
    ChangeSize(V1);
}// Process Commands


////////// ////////// //////////
//
// Verify routines
//
integer VerifyCommand (string passed)  {
    //Check Current Word agianst menu for number items
    return (llSubStringIndex( " xyzxyz", passed) >= 0 );
}

integer VerifyFunction (string passed)  {
    //Check Current Word agianst menu for number items
    return (llSubStringIndex( " +-*=", passed) >= 0 );
}

integer VerifyNumbers (string passed)  {
    //Check Current Word agianst menu for number items
    return (llSubStringIndex( " 0123456789.", passed) >= 0 );
}


////////// ////////// //////////
//
//  Routine to Change the size
//      Also saves the undo size
//
ChangeSize(vector PassVec)  {
    UndoSize = llGetScale();
    llSetScale (PassVec);
}


////////// ////////// //////////
//
//  Script Events start here
//
default  {

    changed(integer mask)  {  // something changed
        //Triggered when the object containing this script changes owner.
        if (mask & CHANGED_OWNER)  {
            llResetScript();
        }
    }// End of Event Changed


    on_rez  (integer Start_Param)  {
        //Remove script if accidentally left inside of a prim
        llSay(0,"Someone forgot to delete me, I'm outta here!  Poof!");
        KillScript();
        }// End of Event State_entry


    state_entry()  {
        OwnerKey = llGetOwner();
        ToucherKey = OwnerKey;
        UndoSize = llGetScale();
        DisplayHelp();
        //Randomize so it doesnt interfere with others
        MenuChannel = -llFloor(llFrand(100000.0));
        InitListen();
        Display_Menu_Main(OwnerKey);
    }// End of Event State_entry


    touch_start(integer total_number)  {
        ToucherKey = llDetectedKey(0);
        if (ToucherKey == OwnerKey || ToucherKey == ThedKey) {
            Display_Menu_Main(ToucherKey);
        }
    }//End of Event touch_start


    listen(integer FromMenu, string name, key id, string message)  {
        message=llToLower(message);
        list Words = llParseString2List( message, [" "], []);
        string Word1 = llList2String(Words,0);

        //
        //  Chat Only commands:
        //
        if (!FromMenu)  {
            //Set
            if (Word1 == "set")  {
                if (llGetListLength(Words) != 4)  {
                    DisplayErr (Err01);
                }
                else ChangeSize(<llList2Float(Words,1),llList2Float(Words,2),llList2Float(Words,3)>);   
            }
            
            // Verify real command other commands
            if (VerifyCommand(Word1))  {
                if (llGetListLength(Words) != 3) DisplayErr (Err01);
                else   {
                    Command = message;
                    ProcessCommands ();
                }
            }
        }

        //
        //  Menu driven command builder
        //
        if (FromMenu)  {
            //Add command to the command variable:
            if (Word1 == "x" || Word1 == "y" || Word1 == "z"
                || Word1 == "xyz")  {
                Command = Word1 + " ";
                Display_Menu_Functions(ToucherKey);
            }
            
            //Add function to the command variable:
            else if (Word1 == "+" || Word1 == "-" || Word1 == "*" || Word1 == "=")  {
                Command += Word1 + " ";
                Display_Menu_Num(ToucherKey);
            }
            //Add Numbers to command variable:
            //Check Current Word agianst menu for number items
            else if (llSubStringIndex( "0123456789.", Word1) >= 0 )  {
                Command += Word1;
                Display_Menu_Num(ToucherKey);
            }
            //Go
            else if (Word1 == "go")  {
                ProcessCommands();
                Display_Menu_Main(ToucherKey);
            }
        }
    
        //
        //  Menu or chat Commands
        //
        
        //Undo
        if (Word1 == "undo")  {
            ChangeSize (UndoSize);
            if (FromMenu) Display_Menu_Main(ToucherKey);
        }
        
        //Remove
        else if (Word1 == "remove")  {
            KillScript();
        }
                
    }//End of Event Listen


}// default State

