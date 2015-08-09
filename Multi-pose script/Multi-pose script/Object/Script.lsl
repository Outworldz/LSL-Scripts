// :CATEGORY:Animation
// :NAME:Multi-pose script
// :AUTHOR:Aine Caoimhe (aka Mata Hari)
// :KEYWORDS:
// :CREATED:2014-02-20 14:27:38
// :EDITED:2014-02-20
// :ID:1028
// :NUM:1599
// :REV:1
// :WORLD:Second Life, Opensim
// :DESCRIPTION:
// This script offers five different methods for animating an avatar seated on an object  that contains more than one animation
// :CODE:
// :SOURCE: http://forums.osgrid.org/viewtopic.php?f=5&t=4989

//This script offers five different methods for animating an avatar seated on an object
// that contains more than one animatio

// Paramour Multi-Method Multi-Animation Script
// by Aine Caolmhe (aka Mata Hari) - visit me by hypergrid at: aine.x64.me:9000:Paramour
// This script is full perm and can be altered, adjusted or changed any way you like
// (though I'd appreciate credit for having written the original)
//
// WHAT IT DOES
// This script offers five different methods for animating an avatar seated on an object
// that contains more than one animation (a far simpler script can be used if there's only 1)
// Assumes that all animations placed in the object play correctly using the SAME sit target
// If you use the dialog method (to pick which animation you want to play) it will only
// display the first 12 animations found in inventory.
//
// HOW TO USE IT
// Place this in any prim (root prim of a linkset) and set the user variables according to
// your requirements. You will also need to place at least one animation in the same prim.
// You can add or remove animations at any time (even during use) and the animation list will be updated
// automatically. The script will automatically reset itself in most (all?) situations that would require it.
//
// USER VARIABLES
// set the following to suit your needs
string floatyText="";               // if you want floating text to appear above your object, enter it here
vector floatyColour=<0.0,0.0,0.0>;  // colour of the text -- black = <0,0,0>, white = <1,1,1>
float floatyAlpha=1.0;              // transparency of the text -- 0.0 = invisible, 1.0 = opaque
vector sitPos=<0.0,0.0,0.0001>;     // sit target position and rotation to use -- I suggest using the Magic
rotation sitRot=ZERO_ROTATION;      //  Sit Kit to determine the best position and rotation for your sit target
                                    // Note: Sit target position cannot be <0,0,0>
// Uncomment one of the following five lines to choose your animation method:
string animMethod="SEQUENCE_TIMED"; // each animation will be played in sequence, cycling back to the first upon reaching the end
// string animMethod="RANDOM_TIMED";   // as above, except the order of animations is randomly shuffled
// string animMethod="SEQUENCE_TOUCH"; // each animation will be played in sequence, but only advances when the seated person touches the object
// string animMethod="RANDOM_TOUCH";   // as above, in random order
// string animMethod="DIALOG_SELECT"; // upon sitting the avatar will be asked to pick the animation they wish to play. Once seated, touching
                                    // the object will display the dialog again, allowing you to pick a different animation. Maximum of 12 animations.
float animTimer=45.0;               // if using either of the two TIMED methods, how long (in seconds) to wait before advancing to the next animation
                                    // this is ignored if you are using one of the other 3 methods

// # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
// #    DO NOT CHANGE ANYTHING BELOW THIS LINE UNLESS YOU KNOW WHAT YOU'RE DOING     #
// # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
string currentAnim;
list anList;
integer anQty;
key mySitter=NULL_KEY;
integer handle;
integer myChannel;
float diaWait=60;
integer diaFirst=TRUE;

buildAnimList()
{
    anQty=llGetInventoryNumber(INVENTORY_ANIMATION);
    if (!anQty)
    {
        llOwnerSay("Unable to find any animations in inventory");
        return;
    }
    anList=[];
    integer i;
    while (i<anQty)
    {
        anList+=llGetInventoryName(INVENTORY_ANIMATION,i);
        i++;
    }
    if (llGetSubString(animMethod,0,5)=="RANDOM") anList=llListRandomize(anList,1);
    if (mySitter==NULL_KEY) currentAnim=llList2String(anList,0);
}
startAnim()
{
    llStartAnimation(currentAnim);
    key dontStop=llGetInventoryKey(currentAnim);
    list anToStop=llGetAnimationList(mySitter);
    integer indexToStop=llGetListLength(anToStop);
    while (--indexToStop>-1)
    {
        if (llList2Key(anToStop,indexToStop)!=dontStop) llStopAnimation(llList2Key(anToStop,indexToStop));
    }
    if (llSubStringIndex(animMethod,"TIMED")>-1) llSetTimerEvent(animTimer);
}
nextAnim()
{
    integer curInd=llListFindList(anList,[currentAnim]);
    if (curInd==-1) // either no animations or current was deleted
    {
        if (!anQty) return; // just keep playing current if there are no animations at all
        else curInd=anQty--; // set to last so it rolls over
    }
    if (++curInd==anQty)
    {
        curInd=0;
        if (llSubStringIndex(animMethod,"RANDOM")>-1) anList=llListRandomize(anList,1);
    }
    string nextAnim=llList2String(anList,curInd);
    if (nextAnim!=currentAnim)
    {
        llStartAnimation(nextAnim);
        llStopAnimation(currentAnim);
    }
    currentAnim=nextAnim;
}
getAnim()
{
    // uses numbered buttons and a txt list in the dialogue since animation names usually don't fit on buttons
    // and could also result in error if they exceed maximum button text length limit
    list butR1;
    list butR2;
    list butR3;
    list butR4;
    list butDia;
    integer i;
    string txtDia="Please select the animation you would like to play:\n\n";
    while (i<anQty)
    {
        if (i<3) butR1+=(string)(i+1);
        else if (i<6) butR2+=(string)(i+1);
        else if (i<9) butR3+=(string)(i+1);
        else butR4+=(string)(i+1);
        txtDia+=(string)(i+1)+". "+llList2String(anList,i)+"\n";
        i++;
    }
    while (i<12)
    {
        if (i<3) butR1+=["-"];
        else if (i==3) i=12;
        else if (i<6) butR2+=["-"];
        else if (i==6) i=12;
        else if (i<9) butR3+=["-"];
        else if (i==9) i=12;
        else butR4+=["-"];
        i++;
    }
    butDia=butR4+butR3+butR2+butR1;
    handle=llListen(myChannel,"",mySitter,"");
    llDialog(mySitter,txtDia,butDia,myChannel);
    llSetTimerEvent(diaWait);
}
shutDown()
{
    llSetTimerEvent(0.0);
    llStartAnimation("stand");
    llStopAnimation(currentAnim);
    mySitter=NULL_KEY;
    diaFirst=TRUE;
    if (handle) llListenRemove(handle);
    if (llGetSubString(animMethod,0,5)=="RANDOM") anList=llListRandomize(anList,1);
}
default
{
    state_entry()
    {
        llSetText(floatyText,floatyColour,floatyAlpha);
        if (sitPos==ZERO_VECTOR) sitPos=<0.0,0.0,0.00001>;
        llSitTarget(sitPos,sitRot);
        myChannel=(integer)("0x"+llGetSubString((string)llGetKey(),-8,-1)); // set unique channel based on key
        buildAnimList();
    }
    on_rez(integer nullInt)
    {
        llResetScript();
    }
    touch_end(integer num_detected)
    {
        if (mySitter==NULL_KEY) return; // ignore if no sitter
        if (llDetectedKey(0)!=mySitter) return; // ignore if not current sitter
        if (llSubStringIndex(animMethod,"TIMED")>-1) return; // ignore if using timed method
        if (animMethod=="DIALOG_SELECT") getAnim();
        else nextAnim();
    }
    timer()
    {
        if (llSubStringIndex(animMethod,"TIMED")>-1)
        {
            if (llAvatarOnSitTarget() ==NULL_KEY) shutDown(); // make sure there is actually an avatar there
            else nextAnim();
        }
        else if (animMethod=="DIALOG_SELECT")
        {
            llRegionSayTo(mySitter,0,"Sorry, I did not hear your response to the dialog asking for your next animation. Please touch me to try again.");
            llSetTimerEvent(0.0);
            llListenRemove(handle);
        }
        else llResetScript(); // shouldn't be possible anyway
    }
    changed (integer change)
    {
        if (change & CHANGED_INVENTORY)
        {
            if (llGetInventoryNumber(INVENTORY_ANIMATION)!=anQty) buildAnimList();
            return;
        }
        if (change & CHANGED_LINK)
        {
            key sitterKey=llAvatarOnSitTarget();
            if (mySitter==NULL_KEY && sitterKey!=NULL_KEY) // someone sitting down
            {
                mySitter=sitterKey;
                llRequestPermissions(mySitter,PERMISSION_TRIGGER_ANIMATION);
            }
            else if (mySitter!=NULL_KEY && sitterKey==NULL_KEY) shutDown(); // someone standing up
            else if (mySitter!=NULL_KEY && sitterKey!=mySitter) // someone sitting but object already occupied by someone else
            {
                llUnSit(sitterKey);
                llRegionSayTo(sitterKey,0,"Sorry, someone else is already sitting here");
            }
            return;
        }
        if (change & CHANGED_REGION_START) llResetScript();
        if (change & CHANGED_OWNER) llResetScript();
    }
    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_TRIGGER_ANIMATION)
        {
            if (animMethod=="DIALOG_SELECT") getAnim();
            else startAnim();
        }
    }
    listen(integer channel, string name, key id, string message)
    {
        llListenRemove(handle);
        llSetTimerEvent(0.0);
        string nextAnim=llList2String(anList,((integer)message) - 1);
        if (diaFirst)
        {
            diaFirst=FALSE;
            currentAnim=nextAnim;
            startAnim();
        }
        else if (nextAnim!=currentAnim)
        {
            llStartAnimation(nextAnim);
            llStopAnimation(currentAnim);
            currentAnim=nextAnim;
        }
    }
}
