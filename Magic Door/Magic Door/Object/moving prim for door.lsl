// :CATEGORY:Door
// :NAME:Magic Door
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:56
// :ID:499
// :NUM:668
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// moving prim 
// :CODE:

integer debug = 1;

integer channel = -44443;      // listener from other prim
integer listener;            // channel handle 
string myName;                // Name of this prim

vector OFFSET = <0,0,0.1>;                // offset to the other door
rotation ROT = <0,0,0,1>;    // rotation when we get there

vector MYOFFSET = <0,0,0.1>;                // offset to the other door
rotation MYROT = <0,0,0,1>;    // rotation when we get there

string animation ;

key AvatarKey;                // key of who touched the door

Go()
{
   
    if (debug) llOwnerSay("starting animation");
    llStartAnimation(animation);
    llSleep(3);
    if (debug) llOwnerSay("starting movement to " + (string )OFFSET);
    UpdateSitTarget(OFFSET,ROT);
    if (debug) llOwnerSay("ending  animation");
    llSleep(3);
    llStopAnimation(animation);
    llUnSit(AvatarKey);
    
     string location = (string) llGetPos() + "|" + (string) llGetRot();
    llRegionSay(channel,location);  

}


//Sets / Updates the sit target moving the avatar on it if necessary.
UpdateSitTarget(vector pos, rotation rot)
{
    //Using this while the object is moving may give unpredictable results.
    llSitTarget(pos, rot);//Set the sit target
    key user = llAvatarOnSitTarget();
    if(user)//true if there is a user seated on the sittarget, if so update their position
    {
        vector size = llGetAgentSize(user);
        if(size)//This tests to make sure the user really exists.
        {
            //We need to make the position and rotation local to the current prim
            rotation localrot = ZERO_ROTATION;
            vector localpos = ZERO_VECTOR;
            if(llGetLinkNumber() > 1)//only need the local rot if it's not the root.
            {
                localrot = llGetLocalRot();
                localpos = llGetLocalPos();
            }
            pos.z += 0.4;
            integer linkNum = llGetNumberOfPrims();
            do{
                if(user == llGetLinkKey( linkNum ))//just checking to make sure the index is valid.
                {
                    llSetLinkPrimitiveParams(linkNum,
                        [PRIM_POSITION, ((pos - (llRot2Up(rot) * size.z * 0.02638)) * localrot) + localpos,
                        PRIM_ROTATION, rot * localrot / llGetRootRotation()]);
                    jump end;//cheaper but a tad slower then return
                }
            }while( --linkNum );
        }
        else
        {//It is rare that the sit target will bork but it does happen, this can help to fix it.
            llUnSit(user);
        }
    }
    @end;
}   //Written by Strife Onizuka, size adjustment provided by Escort DeFarge




default
{
    state_entry()
    {
        animation = llGetInventoryName(INVENTORY_ANIMATION,0);
        llSetSitText("Enter");
        llSitTarget( MYOFFSET, MYROT);
        myName = llGetObjectName();
        listener = llListen(channel,myName,NULL_KEY,"");
        string location = (string) llGetPos() + "|" + (string) llGetRot();
        llRegionSay(channel,location);  
       
    }
    
    changed (integer what)
    {
        if (what & CHANGED_LINK)
        {
            if (debug) llOwnerSay("changed");
            if (llAvatarOnSitTarget() != NULL_KEY) 
            { 
                if (debug) llOwnerSay("request perms");
                AvatarKey = llAvatarOnSitTarget();
                llRequestPermissions(AvatarKey,PERMISSION_TRIGGER_ANIMATION );
            }
        }
        else
        {
            animation = llGetInventoryName(INVENTORY_ANIMATION,0);
        }
           
    }

    listen(integer channel,string name, key id, string message)
    {
        if(debug) llOwnerSay("Heard:" + message);
        if (id != llGetKey())
        {
            list params = llParseString2List(message,["|"],[""]);
            OFFSET = (vector) llList2String(params,0);
            ROT = (rotation) llList2String(params,1);
            if (debug) llOwnerSay("Set Pos:" + (string) OFFSET + " rot:" + (string) ROT);
        }        
    }

    run_time_permissions(integer perm)
    {
        if(PERMISSION_TRIGGER_ANIMATION & perm)
        {
            if (debug) llOwnerSay("perms granted");
            Go();
        }
    }
    
    on_rez(integer p)
    {
        llResetScript();
    }

}

