// :CATEGORY:NPC
// :NAME:NPC HUD
// :AUTHOR:Anonymous
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:58
// :ID:568
// :NUM:775
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// come here
// :CODE:

// npc move to
vector offset = < 3, 0, 1.5>; //3 meter in front
vector npcPos;
key npc;
string clonetype;


default
{
    link_message(integer sender_number, integer number, string msg, key id)
    {
        if (number == 23)
        {
            // Owner detect
            list det = llGetObjectDetails(llGetOwner(),[OBJECT_POS,OBJECT_ROT]);
            npc=id;
            // Get position and rotation
            vector pos = llList2Vector(det,0);
            rotation rot = (rotation)llList2String(det,1);
            // use whatever offset you want.
            vector worldOffset = offset;
            // Offset relative to owner needs a quaternion.
            vector avOffset = offset * rot;
            pos += avOffset; 
            osNpcMoveToTarget(npc,pos, OS_NPC_NO_FLY );
        }
    }
    
}
