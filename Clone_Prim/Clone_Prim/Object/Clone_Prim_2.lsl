// :CATEGORY:Building
// :NAME:Clone_Prim
// :AUTHOR:Clarknova Helvetic
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:50
// :ID:183
// :NUM:255
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Sample Output// // Here's an example of the output. This will make a shiny, metallic mobius strip. 
// :CODE:
default
{
    state_entry()
        {
         list params;
 
 
         // If you are cutting code out to paste into custon functions
         // Define "params" as a global list and start cutting below this line.
 
         params =
 
         [
         PRIM_TYPE,4,0,<0.000000, 1.000000, 0.000000>,0.000000,<0.500000, -0.500000, 0.000000>,<0.250000, 0.050000, 0.000000>,<0.000000, -0.100000, 0.000000>,<0.000000, 1.000000, 0.000000>,<0.000000, 0.000000, 0.000000>,1.000000,0.000000,0.000000 , 
         PRIM_MATERIAL,2 , 
         PRIM_PHYSICS,0 , 
         PRIM_TEMP_ON_REZ,0 , 
         PRIM_PHANTOM,2 , 
         // It's probably not a god idea to have your new prim jump to the old one
        // PRIM_POSITION,<84.270088, 36.444294, 231.487076> ] + (params = []) +
         PRIM_ROTATION,<-0.363768, 0.720439, 0.134244, 0.574995> , 
         PRIM_SIZE,<1.072797, 1.206897, 1.072797>
        ];
 
 
       // Set all of the above paramaters as a group.
         llSetPrimitiveParams(params);
        params = [];
 
 
       // We are breaking the llSetPtimitiveParam([]) calls into blocks, because some params are incompatible with others 
       // during the same call. This is an LsL bug.  See https://jira.secondlife.com/browse/SVC-38 for more info.
       // Please vote to fix it. 
 
 
       // This prim has 3 faces.
 
       params =
        [
 
        PRIM_TEXTURE,0,"5748decc-f629-461c-9a36-a35a221fe21f",<1.000000, 1.000000, 0.000000>,<0.000000, 0.000000, 0.000000>,0.000000 , 
        PRIM_TEXTURE,1,"5748decc-f629-461c-9a36-a35a221fe21f",<1.000000, 1.000000, 0.000000>,<0.000000, 0.000000, 0.000000>,0.000000 , 
        PRIM_TEXTURE,2,"5748decc-f629-461c-9a36-a35a221fe21f",<1.000000, 1.000000, 0.000000>,<0.000000, 0.000000, 0.000000>,0.000000
        ];
         llSetPrimitiveParams(params);
        params = [];
 
       // Note that you -cannot- define textures and colors in the same call!
      // If you're cutting out these params for your custom code watch out for this.
 
       params =
        [
 
         PRIM_COLOR,0,<0.054902, 0.654902, 0.062745>,1.000000 , 
         PRIM_COLOR,1,<0.054902, 0.654902, 0.062745>,1.000000 , 
         PRIM_COLOR,2,<0.054902, 0.654902, 0.062745>,1.000000
        ];
         llSetPrimitiveParams(params);
        params = [];
       params =
        [
 
         PRIM_BUMP_SHINY,0,3,0 , 
         PRIM_BUMP_SHINY,1,3,0 , 
         PRIM_BUMP_SHINY,2,3,0
        ];
         llSetPrimitiveParams(params);
        params = [];
       params =
      [
 
         PRIM_FULLBRIGHT,0,1 , 
         PRIM_FULLBRIGHT,1,1 , 
         PRIM_FULLBRIGHT,2,1 , 
         PRIM_FLEXIBLE,0,2,0.300000,2.000000,0.000000,1.000000,<0.000000, 0.000000, 0.000000> , 
         // PRIM_CAST_SHADOWS,1 , 
 
       // Planar mapping (PRIM_TEXGEN) is for correcting the what circular surfaces do to textures.
       // Most builds don't use it, so it's commented out to save bytes in auto-transform code.
        // The default value is 1 (distorted).
       // if you are metamorphing an object that already had planar mapping (rare)
       // uncomment those 0 lines.
       // This may not seem like much savings
       //  but if your script is trying to metamorph between as many as five objects
       // those few bytes saved might come in handy at the end.
 
       // If your textures are coming out with the offsets all wrong, try uncommenting them.
         // PRIM_TEXGEN,0,0 , 
         // PRIM_TEXGEN,1,0 , 
         // PRIM_TEXGEN,2,0 , 
         PRIM_POINT_LIGHT,1,<1.000000, 1.000000, 1.000000>,0.200000,20.000000,0.000000
        ];
         llSetPrimitiveParams(params);        params = [];
 
 
         // If you were cut/pasting this code into a custom transform function
         // end your cut above this comment.
         // Otherwise ignore this.
 
        llSetObjectName("Mobius Torus");
 
 
        llSetObjectDesc("Mobius Torus");
 
 
       // This next line deletes the script.  Comment it out if you want the script to persist
 
        llRemoveInventory(llGetScriptName());
     }
}
