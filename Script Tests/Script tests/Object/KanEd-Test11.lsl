// :SHOW:
// :CATEGORY:Scripting
// :NAME:Script Tests
// :AUTHOR:Justin Clark-Casey (justincc)
// :KEYWORDS:Opensim
// :CREATED:2019-03-18 23:44:21
// :EDITED:2019-03-18  22:44:21
// :ID:1116
// :NUM:1932
// :REV:1
// :WORLD:Opensim
// :DESCRIPTION:
// One of many tests for Opensim
// :CODE:

integer dialog_channel= 427; // set a dialog channel
list menu = [ "Go up", "Go down" ]; 
vector startPosition;
float groundLevel;

default 
{
   state_entry() 
   {
       // arrange to listen for dialog answers (from multiple users)
       llListen( dialog_channel, "", NULL_KEY, ""); 

       startPosition = llGetPos();
       groundLevel = llGround( startPosition );
   }
    
   touch_start(integer total_number) 
   {
       llDialog( llDetectedKey( 0 ), "What do you want to do?", menu, 
                dialog_channel );
   }
    
   listen(integer channel, string name, key id, string choice )
   {
       vector position = llGetPos();
    
       // if a valid choice was made, implement that choice if possible.
       // (llListFindList returns -1 if choice is not in the menu list.)
       if ( llListFindList( menu, [ choice ]) != -1 )  
       { 
           if ( choice == "Go up" )
           {
              if( position.z < ( startPosition.z + 10.0 ) )
              {
                 llSetPos( llGetPos() + < 0, 0, 1.0 > ); // move up
              } 
           }
           else if( choice == "Go down" )
           { 
              if( position.z > ( groundLevel + 1.0 ) ) 
              {
                 llSetPos( llGetPos() + < 0, 0, -1.0 > ); // move down
              }
           }
       }
       else
       {
           llSay( 0, "Invalid choice: " + choice );
       }
   }
}

