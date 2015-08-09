// :CATEGORY:Texture Organizer
// :NAME:Texture Organizer
// :AUTHOR:Solo Mornington
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:06
// :ID:876
// :NUM:1236
// :REV:1.0
// :WORLD:Second Life, OpenSim
// :DESCRIPTION:
// You basically lay out 22 box prims and link them.// Then you put the textures in it and install the script,// and you have an instant low-lag 20-pane texture organizer.// It has texture mode and sculpty mode, it checks for perms and// advises how many textures were not loaded due to perms issues// so you can deal with them, it assigns access to all, owner, or group,// and it can display sculpties.
// :CODE:

// Texture Organizer
// by
// Solo Mornington

// THIS NOTICE MUST REMAIN INTACT:
// Copyright 2011, Solo Mornington
// License: Use freely in any way you want. Modified versions
// may be used in any way. No credit or acknowledgement required.
// Definitive source and updates available here:
// https://github.com/SoloMornington/TextureOrganizer
// ** end notice


// Assumes the object has 22 prims: base, max 20 images, closebox.

// constant for which prim is the base.
integer BUTTON_PRIM = 1;
// These are constants for the controls on the faces of the base
integer BUTTON_CONFIG = 4;
integer BUTTON_NEXT = 7;
integer BUTTON_PREV = 6;

// Constants for gSecurityMode.
integer SECURITY_ALL = 1;
integer SECURITY_GROUP = 2;
integer SECURITY_OWNER = 3;
// Which security mode are we in?
integer gSecurityMode = 2;

integer gSculptMode = FALSE; // if this is true, show all textures as sculpties.

integer gFirstTextureIndex = 0; // The first texture for the current page of textures being browsed.

integer gZoomTextureIndex = -1; // index of zoomed texture
integer gZoomTexturePrimIndex = -1; // which prim has this texture on it?

list gTilePositions; // pre-calculated list of tile positions
float gCubeSize = 0.5;
float gTileMargin = 0.1; // fraction of cube size
integer gRows = 5;
integer gColumns = 4;
float gMargin = 0.1; // margin is calculated as fraction of cube size

// The base/root prim
list gBase = [
		PRIM_TYPE, PRIM_TYPE_TUBE, PRIM_HOLE_DEFAULT,
        <0.0, 0.5, 0.0>, // cut
        0.35, //hollow
        ZERO_VECTOR, // twist
        <1.0, 0.1, 0.0>, // hole size
        ZERO_VECTOR, // top shear
        <0.25, 1.0, 0.0>, // profile cut
        ZERO_VECTOR, // taper
        1.0, // revolutions
        0.0, // offset
        0.0, // skew
        PRIM_SIZE, <2.5, 0.5, 0.5>,
        // blank textures for all sides
        PRIM_TEXTURE, ALL_SIDES, TEXTURE_BLANK, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0,
        PRIM_FULLBRIGHT, ALL_SIDES, 0,
        PRIM_COLOR, ALL_SIDES, <1.0, 1.0, 1.0>, 1.0,
        // control textures for the control faces
        PRIM_TEXTURE, 6, "b6fd4e55-6120-abb5-af43-aa1f223dd4fd", <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0,
        PRIM_TEXTURE, 7, "b6fd4e55-6120-abb5-af43-aa1f223dd4fd", <-1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0,
        PRIM_TEXTURE, 4, "b6fd4e55-6120-abb5-af43-aa1f223dd4fd", <5.0, 1.0, 0.0>, <0.150, -0.5, 0.0>, 0.0
        ];

// A default cube....
list gCube = [PRIM_TYPE, PRIM_TYPE_BOX, PRIM_HOLE_DEFAULT,
        <0.0, 1.0, 0.0>, // cut
        0.0, //hollow
        ZERO_VECTOR, // twist
        <1.0, 1.0, 0.0>, // top size/taper
        ZERO_VECTOR, // top shear
        // we add size per application....
        PRIM_ROT_LOCAL, ZERO_ROTATION,
        //PRIM_ROT_LOCAL, <0.707107, -0.000000, -0.000000, 0.707107>,
        PRIM_TEXTURE, ALL_SIDES, TEXTURE_BLANK, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0,
        PRIM_FULLBRIGHT, ALL_SIDES, 0,
        PRIM_COLOR, ALL_SIDES, <0.5, 0.5, 0.5>, 1.0
        ];

// constants for the close button
list gCloseButton = [PRIM_TYPE, PRIM_TYPE_CYLINDER, PRIM_HOLE_DEFAULT,
        <0.0, 1.0, 0.0>, // cut
        0.0, //hollow
        ZERO_VECTOR, // twist
        <1.0, 1.0, 0.0>, // top size/taper
        ZERO_VECTOR, // top shear
        // we add size per application....
        //PRIM_ROT_LOCAL, ZERO_ROTATION,
        PRIM_ROT_LOCAL, <0.707107, -0.000000, -0.000000, 0.707107>,
        PRIM_TEXTURE, ALL_SIDES, TEXTURE_BLANK, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0,
        PRIM_FULLBRIGHT, ALL_SIDES, 0,
        PRIM_COLOR, ALL_SIDES, <0.5, 0.5, 0.5>, 1.0,
        PRIM_TEXTURE, 0, "b6fd4e55-6120-abb5-af43-aa1f223dd4fd", <0.5, 0.5, 0.0>, <0.25, 0.25, 0.0>, 0.0,
        PRIM_FULLBRIGHT, 0, 1,
        PRIM_COLOR, 0, <1, 1, 1>, 1.0,
        PRIM_TEXTURE, 2, "b6fd4e55-6120-abb5-af43-aa1f223dd4fd", <0.5, 0.5, 0.0>, <0.25, 0.25, 0.0>, 0.0,
        PRIM_FULLBRIGHT, 2, 1,
        PRIM_COLOR, 2, <1, 1, 1>, 1.0
        ];

list gTextures; // all the textures we can display

list gHiddenPrims; // list of prims that are already hidden. add to this when you hide one.

// PRIMS IN SPACE!!!

// This will all be refactored.

vector gOrigin = ZERO_VECTOR; // top-left coordinate

key gConfigOperator; // Who clicked on the config button? state config needs this.
integer gConfigSculptModePrim; // which prim is the sculpt mode button?
integer gConfigGiveAllPrim; // which prim is the give all button?
integer gConfigSecurityOwnerPrim;
integer gConfigSecurityGroupPrim;
integer gConfigSecurityAllPrim;

// the textures we like.
string gModeTexture = "c6ece822-b257-9dbd-a583-1111ca9cb728"; // sculpty/texture mode/give all
string gSecurityTexture = "842a2cb2-fd8f-d456-3b30-bbb762f2028f"; // owner/group/all

// how long should we show the config menu before timing-out
// to browse mode?
float gConfigTimeout = 360.0; // five minutes long enough?

repositionPrims()
{
	// This function makes sure that there are enough
	// tile prims positioned for browsing.
	// Gathers tile positions from gTilePositions.
	// In order to prevent unneccesary lag, it will avoid
	// repositioning prims that are already positioned.
	// This assumes that non-hidden prims are already in position,
	// so if you never called zeroAllPrimsExcept(), this function
	// won't do much.
    list hiddenPrims;
    integer row;
    integer column;
    integer link = 2; // start at the first child prim
    integer linked = llGetObjectPrimCount(llGetKey());
    float cubeDivisor = 5.0;
    if (gSculptMode) cubeDivisor = 2.0;
    for (row=0; row < gRows; ++row)
    {
        for (column=0; column < gColumns; ++column)
        {
            // if this prim is hidden, we need to un-hide it.
            // but if it's not, we don't need to do anything.
            if (llListFindList(gHiddenPrims, [link]) > -1)
            {
                vector newPos = llList2Vector(gTilePositions, link - 2);
                llSetLinkPrimitiveParamsFast(link,
                    gCube +
                    [PRIM_POSITION, newPos,
                    PRIM_SIZE, <gCubeSize, gCubeSize/cubeDivisor, gCubeSize>
                    ]);
             }
            ++link;
        }
    }
    // hide any extra prims....
    while(link <= linked)
    {
        if (llListFindList(gHiddenPrims, [link]) <= -1)
        {
             llSetLinkPrimitiveParamsFast(link,
                 gCube + [PRIM_POSITION, ZERO_VECTOR, PRIM_SIZE, ZERO_VECTOR]);
         }
        hiddenPrims += [link];
        ++link;
    }
    // update the global list of hidden prims with our new one
    gHiddenPrims = hiddenPrims;
}

calculateTilePositions()
{
	// fill gTilePositions with precalculated positions
	// so that we can just loop through them to put the
	// tiles in place.
    gTilePositions = [];
    integer row;
    integer column;
    float halfCube = gCubeSize / 2.0;
    for (row=0; row < gRows; ++row)
    {
        for (column=0; column < gColumns; ++column)
        {
            vector newPos = <
                 gOrigin.x + gMargin + halfCube + ((float)column) * (gCubeSize + gMargin), // x
                 gOrigin.y, // y
                 gOrigin.z + gMargin + halfCube + (((float)row) * (gCubeSize + gMargin)) //z
                 >;
            gTilePositions += [newPos];
        }
    }
}

gatherTextures()
{
    // clear the list...
    gTextures = [];
    // loop through all the textures,
    // see if they have proper perms
    // add them to the list if they do.
    integer PERM_COPYTRANS = (PERM_COPY | PERM_TRANSFER);
    string textureName;
    integer ownerPerms;
    integer count = llGetInventoryNumber(INVENTORY_TEXTURE);
    integer i;
    for (i=0; i<count; ++i)
    {
        textureName = llGetInventoryName(INVENTORY_TEXTURE, i);
        ownerPerms = llGetInventoryPermMask(textureName, MASK_OWNER);
        if ((ownerPerms & PERM_COPYTRANS) == PERM_COPYTRANS)
        {
            gTextures += [textureName];
        }
    }
    // compare inventory count to list count. this will tell us
    // if there are any textures that didn't pass muster
    // and we can tell the user.
    if (llGetListLength(gTextures) != count)
    {
        llSay(0,"Some textures in this organizer have restrictive permissions and will not be displayed.");
    }
}

showTextures()
{
    // display the textures
    // one per prim, face 1.
    // We assume that there are 20 textures max, and that the first child prim
    // is the first texture prim.
    if (gSculptMode)
    {
        showSculpts();
        return;
    }
    list blankParams = [PRIM_TEXTURE, ALL_SIDES, TEXTURE_BLANK, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0];
    list params; // primitive params
    integer texturesRemaining =
        llGetListLength(gTextures) - gFirstTextureIndex;
    integer i;
    integer numTextures = gRows * gColumns;
    for (i=0; i<numTextures; ++i)
    {
        integer linkNum = i+2;
        if (texturesRemaining <= i)
        {
            params = gCube + blankParams + [PRIM_POSITION, ZERO_VECTOR, PRIM_SIZE, ZERO_VECTOR];
            gHiddenPrims += [linkNum];
        }
        else
        {
            string textureName = llList2String(gTextures, i+gFirstTextureIndex);
            params = blankParams + [
                PRIM_TEXTURE, 1, textureName, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0,
                PRIM_TEXTURE, 3, textureName, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0,
                PRIM_COLOR, 1, <1.0, 1.0, 1.0>, 1.0,
                PRIM_COLOR, 3, <1.0, 1.0, 1.0>, 1.0,
                PRIM_FULLBRIGHT, 1, 1,
                PRIM_FULLBRIGHT, 3, 1
                ];
        }
        llSetLinkPrimitiveParamsFast(linkNum, params);
    }
}

showSculpts()
{
    list blankParams = [PRIM_TEXTURE, ALL_SIDES, TEXTURE_BLANK, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0];
    list params; // primitive params
    integer texturesRemaining =
        llGetListLength(gTextures) - gFirstTextureIndex;
    integer i;
    for (i=0; i<20; ++i)
    {
        integer linkNum = i+2;
        if (texturesRemaining <= i)
        {
            params = gCube + blankParams + [PRIM_POSITION, ZERO_VECTOR, PRIM_SIZE, ZERO_VECTOR];
            gHiddenPrims += [linkNum];
        }
        else
        {
            string textureName = llList2String(gTextures, i+gFirstTextureIndex);
            params = blankParams + [
                PRIM_TYPE, PRIM_TYPE_SCULPT,
                textureName, PRIM_SCULPT_TYPE_SPHERE,
                PRIM_TEXTURE, ALL_SIDES, TEXTURE_BLANK, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0,
                PRIM_COLOR, ALL_SIDES, <0.5, 0.5, 0.5>, 1.0,
                PRIM_FULLBRIGHT, ALL_SIDES, FALSE
                ];
        }
        llSetLinkPrimitiveParamsFast(linkNum, params);
    }
}

//featureTexture(integer primLink)
//{
   // prominently display gZoomTextureIndex if it's not -1
  //  if (gZoomTextureIndex > -1)
    //{
      //  llOwnerSay(llList2String(gTextures, gZoomTextureIndex));
    //}
//}

setupTileGeometry()
{
    // how many rows and columns?
    integer textureCount = llGetListLength(gTextures);
    if (textureCount < 1)
    {
        // there are no textures, so return.
        gColumns = 0;
        gRows = 0;
        return;
    }
    gColumns = llCeil(llSqrt(textureCount));
    // no more than 4 columns.
    if (gColumns > 4) gColumns = 4;
    // convert and store because we use it a few times
    float columns = (float)gColumns;
    // how many rows needed for this many columns?
    gRows = llCeil((float)textureCount / columns);
    // no more than 5 rows.
    if (gRows > 5) gRows = 5;
    // how big is the base?
    list params = llGetLinkPrimitiveParams(LINK_ROOT, [PRIM_SIZE]);
    vector baseSize = llList2Vector(params,0);
    float marginsPerTile = 1.0 / gTileMargin;
    // common denominator....
    float marginsPerDisplay = (marginsPerTile * columns) + columns + 1.0;
    gMargin = baseSize.x / marginsPerDisplay;
    gCubeSize = gMargin * marginsPerTile;

    gTilePositions = [];

    // setup gOrigin
    gOrigin.x = 0.0 - (baseSize.x / 2.0);
    gOrigin.y = 0.0;
    gOrigin.z = baseSize.z;
}

integer security(key avatar)
{
    // given an avatar, figure out if they pass the security set
    // for the object in preferences
    if (gSecurityMode == SECURITY_ALL) return TRUE;
    if (gSecurityMode == SECURITY_GROUP) return llSameGroup(avatar);
    if (gSecurityMode == SECURITY_OWNER) return (avatar == llGetOwner());
    return FALSE;
}

base_browsePrevNext()
{
    // show if there are prev or next buttons available
    vector nextColor = <0.0, 0.0, 0.0>;
    vector prevColor = <0.0, 0.0, 0.0>;
    if (gFirstTextureIndex > 0) prevColor = <1.0, 1.0, 1.0>;
    if (llGetListLength(gTextures) > gFirstTextureIndex + (gRows * gColumns)) nextColor = <1.0, 1.0, 1.0>;
    llSetLinkPrimitiveParamsFast(LINK_ROOT, [PRIM_COLOR, 7, nextColor, 1.0,
                                            PRIM_COLOR, 6, prevColor, 1.0]);
}

base_noPrevNext()
{
    // hide both prev and next buttons
    vector nextColor = <0.0, 0.0, 0.0>;
    vector prevColor = <0.0, 0.0, 0.0>;
    llSetLinkPrimitiveParamsFast(LINK_ROOT, [PRIM_COLOR, 7, nextColor, 1.0,
                                            PRIM_COLOR, 6, prevColor, 1.0]);
}

integer base_processTouch(integer face)
{
    // given that the user has touched the base prim, we need to figure
    // out what control they hit.
    // This is factored out so we can change it easily if we need to.
    if (face == BUTTON_CONFIG) return BUTTON_CONFIG;
    if (face == BUTTON_PREV) return BUTTON_PREV;
    if (face == BUTTON_NEXT) return BUTTON_NEXT;
    return 0; // no-op
}

zeroAllPrimsExcept(integer exception)
{
    // put all non-root prims into a zeroed state, at ZERO_VECTOR and as small as possible
    // leave the textures/sculpts, so they don't have to reload.
    // ...Except of course the given exception link number. :-)
    // Also, keep track of which prims are hidden (zeroed) in gHiddenPrims.
    integer i;
    integer count = llGetObjectPrimCount(llGetKey());
    gHiddenPrims = [];
    for (i=2; i<count; ++i)
    {
        if (i != exception)
        {
             llSetLinkPrimitiveParamsFast(i,
                 [PRIM_POSITION, ZERO_VECTOR, PRIM_SIZE, ZERO_VECTOR]);
             gHiddenPrims += [i];
         }
    }
}

reportSculptMode(key avatar)
{
    if (avatar == NULL_KEY) avatar = llGetOwner();
    string message = "Organizer set to normal texture mode.";
    if (gSculptMode) message = "Organizer set to sculpty mode.";
    // llRegionSayTo has a strange way of reporting chat to an avatar.
    // it says 'objectname say, message'. This is acceptable but not ideal.
    // we'll use it anyway because llInstantMessage eats a 2-second delay.
    llRegionSayTo(avatar, 0, message);
}

reportSecurity(key avatar)
{
    if (avatar == NULL_KEY) avatar = llGetOwner();
    string message = "Organizer will only respond to the owner.";
    if (gSecurityMode == SECURITY_GROUP) message = "Organizer will respond to users in its group.";
    if (gSecurityMode == SECURITY_ALL) message = "Organizer will respond to all users.";
    // llRegionSayTo has a strange way of reporting chat to an avatar.
    // it says 'objectname say, message'. This is acceptable but not ideal.
    // we'll use it anyway because llInstantMessage eats a 2-second delay.
    llRegionSayTo(avatar, 0, message);
}


giveAllTextures(key avatar)
{
    llGiveInventoryList(avatar, llGetObjectName(), gTextures);
}

default
{
    state_entry()
    {
    	// Set up the base prim's geometry.
    	llSetLinkPrimitiveParamsFast(LINK_ROOT, gBase);
    	// zero all the prims, or the accounting will be completely off
    	// for the other states.
        zeroAllPrimsExcept(-1);
        state browse;
    }
}

state browse
{
    state_entry()
    {
        gZoomTextureIndex = -1; // nothing zoomed.
        gZoomTexturePrimIndex = -1;
        llSetTimerEvent(0.1);
    }

    changed(integer change)
    {
    	// did the user add some textures?
        if (change & CHANGED_INVENTORY)
        {
        	// yes, so update the object, after an acceptable delay.
            llSetTimerEvent(5.0);
        }
    }
    
    timer()
    {
        // we do all this on a timer so that there's some slack in the system
        // and we don't have to re-update for each texture added en-masse.
        gatherTextures();
        setupTileGeometry();
        calculateTilePositions();
        repositionPrims();
        showTextures();
        base_browsePrevNext();
        llSetTimerEvent(0.0);
    }
    
    touch_start(integer count)
    {
    	// CLICKY CLICKY!
        integer i;
        // loop through all the detected*
        for (i=0; i<count; ++i)
        {
            // check security on each touch.....
            if (security(llDetectedKey(i)))
            {
                integer touchLink = llDetectedLinkNumber(i);
                // did the user click the base control button prim?
                if (touchLink == BUTTON_PRIM)
                {
                	// yes, they did, so which button/face was it?
                    integer button = base_processTouch(llDetectedTouchFace(i));
                    if (button == BUTTON_PREV) // previous
                    {
                        if (gFirstTextureIndex <= 0) jump next;
                        else
                        {
                            gFirstTextureIndex -= gRows * gColumns;
                            if (gFirstTextureIndex < 0) gFirstTextureIndex = 0;
                        }
                        repositionPrims();
                        showTextures();
                        jump next;
                    }
                    if (button == BUTTON_NEXT) // next
                    {
                        integer textureCount = llGetListLength(gTextures);
                        integer tileCount = gRows * gColumns;
                        if (gFirstTextureIndex >= (textureCount - tileCount)) jump next;
                        else
                        {
                            gFirstTextureIndex += tileCount;
                        }
                        repositionPrims();
                        showTextures();
                        jump next;
                    }
                    if (button == BUTTON_CONFIG) // menu
                    {
                    	// store the key of the avatar that clicked, so
                    	// state config will know.
                        gConfigOperator = llDetectedKey(i);
                        state config;
                    }
                }
                else
                {
                	// figure out which tile the user clicked on
                    integer currentTexture = gFirstTextureIndex + touchLink - 2;
                    if (currentTexture < llGetListLength(gTextures))
                    {
                        gZoomTextureIndex = currentTexture;
                        gZoomTexturePrimIndex = touchLink;
                        state zoom;
                    }
                }
            }
            @next; // next for()....
        }
        // make sure the base shows the proper prev/next arrows
        base_browsePrevNext();
    }
}

state zoom
{
    // this is where we zoom in on a given texture
    state_entry()
    {
        // sanity check: if we don't have a current texture then go back to browsing.
        if (gZoomTextureIndex == -1) state browse;
        // first we hide all the non-zoom prims
        zeroAllPrimsExcept(gZoomTexturePrimIndex);
        // now we get the base size so we can figure out the zoom prim size
        list params = llGetLinkPrimitiveParams(LINK_ROOT, [PRIM_SIZE]);
        vector baseSize = llList2Vector(params, 0);
        // set the zoom prim size. It should already have the texture on it.
        float zoomDivisor = 15.0;
        // wider prim for scupt mode
        if (gSculptMode) zoomDivisor = 2.0;
        llSetLinkPrimitiveParamsFast(gZoomTexturePrimIndex, [PRIM_SIZE,
            <baseSize.x, baseSize.x/zoomDivisor, baseSize.x>,
            PRIM_POSITION,
            <0.0, 0.0, (baseSize.x/2.0) + baseSize.z>
            ]);
        // and set the close button prim, which is always the last prim.
        llSetLinkPrimitiveParamsFast(llGetObjectPrimCount(llGetKey()), gCloseButton +
        [PRIM_SIZE, <baseSize.x * gTileMargin, baseSize.x * gTileMargin, baseSize.x/12.0>,
        PRIM_POSITION, <baseSize.x / 2.0, 0.0, baseSize.z>
        ]);
        // turn off the prev/next buttons...
        base_noPrevNext();
    }
    
    touch_start(integer count)
    {
        integer i;
        // store this because we'll likely need it.
        integer primCount = llGetObjectPrimCount(llGetKey());
        // cycle through per touch....
        for (i=0; i<count; ++i)
        {
            // check security on each touch....
            if (security(llDetectedKey(i)))
            {
                integer touchLink = llDetectedLinkNumber(i);
                if (touchLink == BUTTON_PRIM)
                {
                    integer baseButton = base_processTouch(llDetectedTouchFace(i));
                    if (baseButton == BUTTON_CONFIG)
                    {
                        gConfigOperator = llDetectedKey(i);
                        state config;
                    }
                }
                if (touchLink == gZoomTexturePrimIndex)
                {
                    llGiveInventory(llDetectedKey(i), llList2String(gTextures, gZoomTextureIndex));
                    jump next;
                }
                if (touchLink == primCount)
                {
                    llSetLinkPrimitiveParamsFast(primCount - 1, gCube + [PRIM_SIZE, ZERO_VECTOR, PRIM_POSITION, ZERO_VECTOR]);
                    state browse;
                }
            }
            @next;
        }
    }
    
    changed(integer what)
    {
    	if (what & CHANGED_INVENTORY)
    	{
    		// the user updated the inventory in some way, so we
    		// go back to browsing.
    		state browse;
    	}
    }
    
    state_exit()
    {
    	// force the other states to update the zoomed prim
        gHiddenPrims += [gZoomTexturePrimIndex];
    }
}

state config
{
    // config is where we hide all the tiles,
    // allow the user to get all of the textures in one folder, and sculpt mode.
    // also let the owner set the security mode (owner, group, all)
    state_entry()
    {
        key owner = llGetOwner();
        // put away all the prims
        zeroAllPrimsExcept(-1);

        // put together the buttons
        // which prims do we use for the buttons?
        // we start at the highest prim and go backwards to preserve
        // the textures on as many prims as possible. This way the
        // viewer doesn't have to reload them.
        integer count = llGetObjectPrimCount(llGetKey());
        gConfigSculptModePrim = count;
        gConfigGiveAllPrim = count - 1;
        gConfigSecurityOwnerPrim = count - 2;
        gConfigSecurityGroupPrim = count - 3;
        gConfigSecurityAllPrim = count - 4;

        // now we get the base size so we can figure out the control prim sizes
        list params = llGetLinkPrimitiveParams(LINK_ROOT, [PRIM_SIZE]);
        vector baseSize = llList2Vector(params, 0);
        // buttonSize is for the give-all and sculpty/texture-mode buttons.
        vector buttonSize = <baseSize.x/2.5, baseSize.x/15.0, baseSize.x/2.5>;
        // securityButtonSize is for the owner/group/all buttons
        vector securityButtonSize = ZERO_VECTOR;
        // if the user isn't also the owner, then don't show the security buttons.
        if (gConfigOperator == llGetOwner())
        {
            float securityWidth = baseSize.x/3.05;
            securityButtonSize = <securityWidth, baseSize.x/15.0, securityWidth/1.5>;
        }

        list buttonParams = gCube + [PRIM_SIZE, buttonSize,
            PRIM_TEXTURE, ALL_SIDES, TEXTURE_BLANK, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0,
            PRIM_FULLBRIGHT, ALL_SIDES, 0,
            PRIM_COLOR, ALL_SIDES, <0.5, 0.5, 0.5>, 1.0,
            PRIM_FULLBRIGHT, 1, 1,
            PRIM_COLOR, 1, <1, 1, 1>, 1.0,
            PRIM_FULLBRIGHT, 3, 1,
            PRIM_COLOR, 3, <1, 1, 1>, 1.0
            ];

        // set the sculpt mode prim....
        vector sculptTextureOffset = <0.0, 0.333, 0.0>; // 'sculpt mode'
        if (gSculptMode) sculptTextureOffset = <0,0,0>; // 'texture mode'
        llSetLinkPrimitiveParamsFast(gConfigSculptModePrim, buttonParams +
            [PRIM_POSITION, <0.0, 0.0, buttonSize.z + securityButtonSize.z>,
            PRIM_TEXTURE, 1, gModeTexture, <1.0, 0.333, 0.0>, sculptTextureOffset, 0.0,
            PRIM_TEXTURE, 3, gModeTexture, <1.0, 0.333, 0.0>, sculptTextureOffset, 0.0
            ]);
        // set the give-all prim
        llSetLinkPrimitiveParamsFast(gConfigGiveAllPrim, buttonParams +
            [PRIM_POSITION, <0.0, 0.0, (buttonSize.z * 2.1) + securityButtonSize.z>,
            PRIM_TEXTURE, 1, gModeTexture, <1.0, 0.333, 0.0>, <0.0, -0.333, 0.0>, 0.0,
            PRIM_TEXTURE, 3, gModeTexture, <1.0, 0.333, 0.0>, <0.0, -0.333, 0.0>, 0.0
            ]);

        // Owner security
        llSetLinkPrimitiveParamsFast(gConfigSecurityOwnerPrim, buttonParams +
            [PRIM_POSITION, <securityButtonSize.x * 1.1, 0.0, securityButtonSize.z * 1.2>,
            PRIM_SIZE, securityButtonSize,
            PRIM_TEXTURE, 1, gSecurityTexture, <1.0, 0.333, 0.0>, <0.0, 0.333, 0.0>, 0.0,
            PRIM_TEXTURE, 3, gSecurityTexture, <1.0, 0.333, 0.0>, <0.0, 0.333, 0.0>, 0.0
            ]);
        // Group security
        llSetLinkPrimitiveParamsFast(gConfigSecurityGroupPrim, buttonParams +
            [PRIM_POSITION, <0.0, 0.0, securityButtonSize.z * 1.2>,
            PRIM_SIZE, securityButtonSize,
            PRIM_TEXTURE, 1, gSecurityTexture, <1.0, 0.333, 0.0>, <0.0, 0, 0.0>, 0.0,
            PRIM_TEXTURE, 3, gSecurityTexture, <1.0, 0.333, 0.0>, <0.0, 0, 0.0>, 0.0
            ]);
        // All security
        llSetLinkPrimitiveParamsFast(gConfigSecurityAllPrim, buttonParams +
            [PRIM_POSITION, <0.0 - (securityButtonSize.x * 1.1), 0.0, securityButtonSize.z * 1.2>,
            PRIM_SIZE, securityButtonSize,
            PRIM_TEXTURE, 1, gSecurityTexture, <1.0, 0.333, 0.0>, <0.0, -0.333, 0.0>, 0.0,
            PRIM_TEXTURE, 3, gSecurityTexture, <1.0, 0.333, 0.0>, <0.0, -0.333, 0.0>, 0.0
            ]);
        // turn off the prev/next controls
        base_noPrevNext();
        llSetTimerEvent(gConfigTimeout);
    }
    
    timer()
    {
    	// We want to go back to browsing from config mode
    	// after a certain time. If the timer ever makes it here,
    	// then boom.
    	state browse;
    }
    
    touch_start(integer count)
    {
    	llSetTimerEvent(gConfigTimeout);
        integer i;
        // cycle through per touch....
        for (i=0; i<count; ++i)
        {
            // check security on each touch....
            key av = llDetectedKey(i);
            if (security(av))
            {
                integer touchLink = llDetectedLinkNumber(i);
                if (touchLink == BUTTON_PRIM)
                {
                    integer baseButton = base_processTouch(llDetectedTouchFace(i));
                    if (baseButton == BUTTON_CONFIG)
                    {
                        state browse;
                    }
                }
                if (touchLink == gConfigSculptModePrim)
                {
                    if (gSculptMode) gSculptMode = FALSE;
                    else gSculptMode = TRUE;
                    vector sculptTextureOffset = <0.0, 0.333, 0.0>; // 'sculpt mode'
                    if (gSculptMode) sculptTextureOffset = <0,0,0>; // 'texture mode'
                    llSetLinkPrimitiveParamsFast(gConfigSculptModePrim, [
                        PRIM_TEXTURE, 1, gModeTexture, <1.0, 0.333, 0.0>, sculptTextureOffset, 0.0,
                        PRIM_TEXTURE, 3, gModeTexture, <1.0, 0.333, 0.0>, sculptTextureOffset, 0.0
                        ]);
                    reportSculptMode(av);
                    jump next;
                }
                if (touchLink == gConfigGiveAllPrim)
                {
                    giveAllTextures(av);
                    jump next;
                }
                // only let the owner do these....
                if (gConfigOperator == llGetOwner())
                {
	                if (touchLink == gConfigSecurityOwnerPrim)
	                {
	                    gSecurityMode = SECURITY_OWNER;
	                    reportSecurity(av);
	                    jump next;
	                }
	                if (touchLink == gConfigSecurityGroupPrim)
	                {
	                    gSecurityMode = SECURITY_GROUP;
	                    reportSecurity(av);
	                    jump next;
	                }
	                if (touchLink == gConfigSecurityAllPrim)
	                {
	                    gSecurityMode = SECURITY_ALL;
	                    reportSecurity(av);
	                    jump next;
	                }
	            }
            }
            @next;
        }
    }
    
    changed(integer what)
    {
    	if (what & CHANGED_INVENTORY)
    	{
    		// the user updated the inventory in some way, so we
    		// go back to browsing.
    		state browse;
    	}
    }

    state_exit()
    {
    	// hide all the prims so browse will re-init them
        zeroAllPrimsExcept(-1);
    }
}
