// :CATEGORY:Door
// :NAME:Simple_door_swinger_works_at_any_an
// :AUTHOR:Void SInger
// :CREATED:2012-03-24 22:09:02.320
// :EDITED:2013-09-18 15:39:02
// :ID:759
// :NUM:1046
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Simple_door_swinger_works_at_any_an
// :CODE:
/*//( v7-D Simple Hinge Action )--//*/
/*//-- Works At ANY Angle --//*/

/*//-- NOTES:
 works in ANY single prim door, linked or un-linked
 works in multi-prim doors NOT linked to a larger structure
 Never needs reset (even after rotating)
//*/

/*//-- REQUIREMENTS:
 Root must either be a cylinder (to represent a hinge) or
 cut prim; I suggest cube, pathcut start=.125, end=.625
//*/

/*//-- CAVEAT:
 Single prim doors are limited to 5m width
 Treats current position as closed when reset
//*/

 /*//-- USERS MODIFY HERE v --//*/
integer gIntSwing = 90;
/*//-- use -# to reverse the direction of swing, eg. -90; --//*/
rotation gRotSwing;

default{
    state_entry(){
        gRotSwing = llEuler2Rot( <0.0, 0.0, (float)gIntSwing * DEG_TO_RAD> );
    }
    
    touch_end( integer vIntNul ){
         llSetLocalRot( (gRotSwing = (ZERO_ROTATION / gRotSwing)) * llGetLocalRot() );
    }
}

/*//-- IF Redistributing as-is:
 Please leave script full permissions & include all comments so that others may learn and use
//*/

/*//--                       Anti-License Text                         --//*/
/*//     Contributed Freely to the Public Domain without limitation.     //*/
/*//   2009 (CC0)    //*/
/*//  Void Singer   //*/
