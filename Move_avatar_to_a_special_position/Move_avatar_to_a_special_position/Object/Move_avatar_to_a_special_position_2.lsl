// :CATEGORY:Movement
// :NAME:Move_avatar_to_a_special_position
// :AUTHOR:whcyc2002
// :CREATED:2013-05-29 03:10:41.293
// :EDITED:2013-09-18 15:38:57
// :ID:526
// :NUM:711
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// A pose ball-like sitter that will move to the position where the other script was rezzed
// :CODE:
vector target_pos ;
vector local_pos;
integer listen_handle;
integer listen_ch= -478312941;

default
{
    state_entry()
    {
		llSitTarget(<0.0, 0.0, 0.1>, ZERO_ROTATION);
		local_pos = target_pos = llGetLocalPos();
		listen_handle = llListen(listen_ch, "", "", "");
	}
	on_rez(integer num){
		llResetScript();
	}
	listen( integer channel, string name, key id, string message )
    {
		if(channel == listen_ch){
			target_pos = (vector) message;
			llListenRemove(listen_handle);
		}
    }	
    changed(integer change)
    {
        if (change & CHANGED_LINK)
        { 
            key av = llAvatarOnSitTarget();
            if (av) // evaluated as true if key is valid and not NULL_KEY
			{
				llSetRegionPos(target_pos);
				llUnSit(av);
				llSetRegionPos(local_pos);
			}
        }
    }
}
