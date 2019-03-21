// :CATEGORY:OpenSim NPC
// :NAME:NPC_BotKiller
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2013-08-02 12:52:56.077
// :EDITED:2014-09-24
// :ID:571
// :NUM:1661
// :REV:1.1
// :WORLD:OpenSim
// :DESCRIPTION:
// A NPC killer that works only on nearby NPC's. Rez it and touch it.
// Tells you who and how many were deleted
// 
// License: 
// You are free:
// to Share — to copy, distribute and transmit the work
// to Remix — to adapt the work
// to make commercial use of the work
//  See http://creativecommons.org/licenses/by-sa/2.5/
// :CODE:
// OpenSimian BotKiller
// Kills all the NPC's in the region.. Please use with discretion.
// Iterate over a list of avatar keys, using them as an arguments to osNpcRemove
// Add a delay to the timer if sim performance starts to drag during logouts
// Feel free to use/distribute/modify to suit your needs
// Prepared for transfer to MOSES grid -  D Osborn  5.3.2013
// lots of mods for nearby and eliinate silly code  bits.   F Beckhusen 9/18/2014 

integer n;
default
{
    touch_start(integer ewe)
    {
        // owner only
        if (llDetectedKey(0) != llGetOwner())
            return;
            
        list avies = osGetAvatarList();
        integer len = llGetListLength(avies); // no need to recalculate ht length each loop check
        integer counter = 0;
        for(n=0; n<len; n=n+3)
        {
            key npcKey =  llList2Key(avies,n);
            if (osIsNpc(npcKey)) {
                list things = llGetObjectDetails(npcKey,[OBJECT_NAME,OBJECT_POS]);
                vector pos = llList2Vector(things,1);
                string name = llList2String(things,0);
                
                
                float dist = llVecDist(pos, llGetPos());
                if (dist < 10) {
                        counter ++;
                        llOwnerSay("Removing NPC named " + name);
                       osNpcRemove((key)llList2Key(avies,n));
                }

            }
        }
        if (counter)
            llOwnerSay("Removed " + (string) counter + " NPC's");
        else
            llOwnerSay("No NPC's within 10 meters to remove!");
                
    }
}
