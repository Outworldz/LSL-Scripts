// :CATEGORY:Pysics
// :NAME:Physics_Optimization_for_Prims
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2012-06-29 13:53:07.687
// :EDITED:2013-09-18 15:38:59
// :ID:627
// :NUM:854
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Use the following script to set all child prims to None. Be sure to check what physics are needed for your linkset prior to using, and/or add a simple cube as the root prim. 
// :CODE:
default
{
    state_entry()
    {
        llOwnerSay("Setting all child prims to PRIM_PHYSICS_SHAPE_NONE");
        llSetLinkPrimitiveParamsFast(LINK_ALL_CHILDREN, [PRIM_PHYSICS_SHAPE_TYPE, PRIM_PHYSICS_SHAPE_NONE]);
        llRemoveInventory(llGetScriptName());
    }
}
