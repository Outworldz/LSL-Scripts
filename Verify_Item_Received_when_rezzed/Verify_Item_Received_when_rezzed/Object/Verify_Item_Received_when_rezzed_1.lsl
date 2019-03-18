// :CATEGORY:Merchant Tools
// :NAME:Verify_Item_Received_when_rezzed
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:09
// :ID:953
// :NUM:1374
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Verify_Item_Received_when_rezzed
// :CODE:
Somebody posted some scripts recently that will send an email when an item is rezzed in world another will send an email when an item is unpacked. Not sure if I found this on Xstreet or someone else's site but this is what was there, haven't tested it yet might help you if they work.

My Apologies for not having the script writers name.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
okay - i think my first time posting code, so sorry if i get this messy the first couple tries...
after what seems to be a standing ovation of indifference... i am posting open-source my latest .
product packaging. i've yet to fully install this in my own inventory, but tests so far seem to work
out.

used in a packed-up product prim (three times fast!),
-zPackaging offers some helpful floating text for the customer, if they're newbish.
it also triggers off calls in two other (completely optional) scripts...
-PackagingReceipt1 (which sends a 'rezzed' email when the package is dragged out of the user's
inventory), and
-PackagingReceipt2 (which sends its email message when the prim is unpacked).

this uses three scripts primarily to make up for email's scriptlag.
(additionally, as i only wish to receive each notice only once, each receipt script will
delete itself after use.)

//////////////////////////////////////////////////////////////////////////////////////
///////////// SCRIPT 1 OF 3 SCRIPT 1 OF 3 SCRIPT 1 OF 3 SCRIPT 1 OF 3 ////////////////
//////////////////////////////////////////////////////////////////////////////////////

// -zPackaging

// package 'phones home' (emails message)
// 1) email on-rez - would apply to attachement or ground rez i think - great
// 2) email on inventory change - will this work upon avi unpacking a set?? - even better!!
// INVENTORY CHANGE DOES NOT TRIGGER on open/copy to inventory! so, use a timer. :\

// my own touch-controlled transfer, instead of prim-open?
// CANNOT USE llGiveInventoryList instead of open/copy or contents drag, 'cuz that seems restricted to full-perm stuff.

// this script can act as a standalone for floating text handling; just remove one or the other (or both) receipt scripts if you don't want to use them.

// this scripts are DISARMED by default for the creator to use and modify - no email will be sent; scripts will not self-destruct. only when the prim changes hands to a different owner will they activate. (i have some test booleans, but the logics may need cleaned up for them to work.)

// all three scripts should be set to no modify, copy, no transfer to work properly. (copy scripts prevents them from being removed before completing their process.

// ALTHOUGH THESE ARE INTENDED FOR OPEN-SOURCE, DO NOT RELEASE MODIFIABLE COPIES OF YOUR PACKAGED RECEIPT SCRIPTS!! you may be giving away whichever email address you are using included in the script. when exchanging copies, be sure your email address is deleted!!

// 071001 - NEW!! patching in Cubey Terra's ingenious 'detach if worn' script. very handy, and saves me all that nasty extra floating text i use...

//these are the 'most important' vars to change; read the script to change any scriptnames or linkmessage num hooks.
string STRownerTest="Avatar Name";

integer INTinventoryCount;
integer BLNtesting;//=TRUE;

testMessage(string STRmsg){//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
integer INTmemory=llGetFreeMemory();
if(BLNtesting==TRUE){
string STRtestAppend=llGetScriptName()+
"\ttime: "+(string)llGetTime()+
"\tmem: "+(string)INTmemory+
"\t"+STRmsg+"|";
llOwnerSay(STRtestAppend);
}
integer INTlowMemWarning=500;
if(INTmemory<INTlowMemWarning){
llOwnerSay(llGetScriptName()+"!!! LOW MEMORY WARNING: LESS THAN "+(string)INTlowMemWarning+"bytes!! "+(string)INTlowMemWarning);//also email home a warning??
}
}//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
resetAll(){//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
testMessage("resetAll");
string STRtext=llKey2Name(llGetOwner()) + "'s";
if(INTinventoryCount>inventoryCount() || inventoryCount()==0){
llMessageLinked(LINK_THIS, 924, "-PackagingReceipt2", NULL_KEY);
if(inventoryCount()==0){
STRtext=STRtext+"\nEMPTY PACKAGE :\\";
STRtext=STRtext+"\nDon't be a litterbug!! ";
STRtext=STRtext+"\nRight-click 'MORE-DELETE'!! ";
llSetText(STRtext, <1,1,1>, 1.0); //Display the string in solid black.
llMessageLinked(LINK_THIS, 927, "-Nyoko'sPackagingFX", NULL_KEY);//sending this extra trigger out to my 'special effects' script
llSleep(1.0);
deleteScripts();
}else{
STRtext=STRtext+"\n"+llGetObjectName();// + "\n---\n";
STRtext=STRtext+"\n-";
STRtext=STRtext+"\nALMOST THERE!! ";
STRtext=STRtext+"\nBe sure to drag";
STRtext=STRtext+"\neverything from 'contents.'";
llSetText(STRtext, <1,1,1>, 1.0); //Display the string in solid black.
llMessageLinked(LINK_THIS, 927, "-Nyoko'sPackagingFX", NULL_KEY);//sending this extra trigger out to my 'special effects' script
llSetTimerEvent(1.0);
}
}else{
STRtext=STRtext+"\n"+llGetObjectName();// + "\n---\n";
STRtext=STRtext+"\n-";
// STRtext=STRtext+"\n1) If you are holding the package,";
// STRtext=STRtext+"\nright-click 'DROP' ";
// STRtext=STRtext+"\n-";
STRtext=STRtext+"\nCLICK ME, or right-click 'OPEN'";
STRtext=STRtext+"\nthen 'COPY TO INVENTORY'!";
llSetText(STRtext, <1,1,1>, 1.0); //Display the string in solid black.
llMessageLinked(LINK_THIS, 923, "-PackagingReceipt1", NULL_KEY);
// llMessageLinked(LINK_THIS, 927, "-Nyoko'sPackagingFX", NULL_KEY);//sending this extra trigger out to my 'special effects' script
llSetTimerEvent(1.0);
}
INTinventoryCount=inventoryCount();
//text has a length limit of 255 characters.
testMessage("chars leftover: "+(string)(255-llStringLength(STRtext)));
}//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
integer inventoryCount(){
return llGetInventoryNumber(INVENTORY_OBJECT)
+llGetInventoryNumber(INVENTORY_CLOTHING)
+llGetInventoryNumber(INVENTORY_SOUND);
}
deleteScripts(){//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
if(llKey2Name(llGetOwner())!=STRownerTest){
if(llGetInventoryType("-PackagingReceipt1")!=INVENTORY_NONE){
llRemoveInventory("-PackagingReceipt1"); // delete this script
}
if(llGetInventoryType("-PackagingReceipt2")!=INVENTORY_NONE){
llRemoveInventory("-PackagingReceipt2"); // delete this script
}
testMessage("DELETING script. bb!! ");
llRemoveInventory(llGetScriptName()); // delete this script
}
}
default{//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
on_rez(integer start_param){//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
testMessage("default/on_rez");
llResetScript();
}
state_entry(){
testMessage("default/state_entry");
if(llKey2Name(llGetCreator())!=STRownerTest){//self-destruct
testMessage("i would be DELETING script (this prim was not created by me).");// bb!! ");
// deleteScripts();
// it seems that in laggier areas that the time to call up llGetCreator overtakes the logictest,
// and always seems to just come out TRUE (even though it is the original package that works just fine
// in quieter areas... advice??
}
if (llGetAttached()){ // llGetAttached returns non-zero if attached
// Must get perms before detaching. Attach/detach perms are given automatically (no blue popup) b/c the item is attached.
llRequestPermissions(llGetOwner(),PERMISSION_ATTAC H);
}
resetAll();
}
run_time_permissions(integer perm){
if (perm & PERMISSION_ATTACH){
llOwnerSay("PRIVATE MESSAGE: To prevent accidental loss, do not wear this item. Instead, drag it from your inventory onto the ground.");
llDetachFromAvatar();
}
}
changed(integer change){
testMessage("default/changed");
if(change==CHANGED_INVENTORY){
testMessage("My inventory has changed...");
resetAll();
}
}
timer() {
// testMessage("default/timer");
if(INTinventoryCount!=inventoryCount()){
testMessage("default/timer INSIDE");
llSetTimerEvent(0.0);
resetAll();
}
}// \\\\\\\\\\\\\\\
link_message(integer sender_num, integer num, string str, key id){//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
if(str==llGetScriptName()){
testMessage("default/link_message");
//these hooks allow for quicker deletion of the emailing scripts. so far i haven't had the amount of sleeptime
//overtake the emailing script, but that may happen in very crowded sims. advice??
if(num==925){
llSleep(1.0);
testMessage("DELETING script sPackagingReceipt1. bb!! ");
llRemoveInventory("-PackagingReceipt1"); // delete this script
}else if(num==926){
llSleep(1.0);
testMessage("DELETING script sPackagingReceipt2. bb!! ");
llRemoveInventory("-PackagingReceipt2"); // delete this script
}
}
}//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
}//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

//////////////////////////////////////////////////////////////////////////////////////
///////////// SCRIPT 2 OF 3 SCRIPT 2 OF 3 SCRIPT 2 OF 3 SCRIPT 2 OF 3 ////////////////
//////////////////////////////////////////////////////////////////////////////////////

// -PackagingReceipt1

//these are the 'most important' vars to change; read the script to change any scriptnames or linkmessage num hooks.
string STRownerTest="Avatar Name";
string STRownerEmail="your.email@home.com";

string STRmessage="rezzed";
string STRowner;
integer BLNemailCreator;//=TRUE;
integer BLNtesting;//=TRUE;//testing toggle, set FALSE for rollout.

testMessage(string STRmsg){//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
integer INTmemory=llGetFreeMemory();
if(BLNtesting==TRUE){
string STRtestAppend=llGetScriptName()+
"\ttime: "+(string)llGetTime()+
"\tmem: "+(string)INTmemory+
"\t"+STRmsg+"|";
llOwnerSay(STRtestAppend);
}
integer INTlowMemWarning=500;
if(INTmemory<INTlowMemWarning){
llOwnerSay(llGetScriptName()+"!!! LOW MEMORY WARNING: LESS THAN "+(string)INTlowMemWarning+"bytes!! "+(string)INTlowMemWarning);//also email home a warning??
}
}//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
sendEmail(){
if(llKey2Name(llGetOwner())!=STRownerTest || BLNemailCreator){
STRowner=llKey2Name(llGetOwner());//saving this to prevent accidental script deletion...
//may rerun the sequence if owners are different?? otherwise whole thing may stall on occassion...
string STRtemp;//=" Package contents:\n";

integer INTcount;//=llGetInventoryNumber(INVENTORY_ALL);
string STRname=llGetInventoryName(INVENTORY_ALL, INTcount);
while(STRname!=""){
STRtemp=STRtemp+"\n"+STRname;
INTcount=INTcount+1;
STRname=llGetInventoryName(INVENTORY_ALL, INTcount);
}
string STRsubject=llKey2Name(llGetOwner())+"-"+llGetObjectName()+" "+STRmessage;
testMessage("NOW PAUSING FOR emailing STRsubject="+STRsubject);
llMessageLinked(LINK_THIS, 925, "-zPackaging", NULL_KEY);
llEmail(STRownerEmail, STRsubject, STRsubject+"\n"+STRtemp);
deleteScript();
}else{
testMessage("SKIPPING EMAIL rezzed...");
}
}
deleteScript(){//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
if(llKey2Name(llGetOwner())!=STRownerTest && llKey2Name(llGetOwner())==STRowner){
testMessage("DELETING script. bb!! ");
llRemoveInventory(llGetScriptName()); // delete this script
}else{
testMessage("SKIPPING script deletion");
if(llKey2Name(llGetOwner())!=STRowner){
sendEmail();
}
}
}//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
default{//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
on_rez(integer start_param){//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
testMessage("default/on_rez");
llResetScript();
}//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
state_entry(){//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
testMessage("default/state_entry");
//check for other scripts; self-destruct if the others are not present...
//llGetCreator call is 'laggy'?? :\ always comes up TRUE
if(llKey2Name(llGetCreator())!=STRownerTest){
testMessage("i would be DELETING script (this prim was not created by me).");// bb!! ");
// deleteScript();
}
if(llGetInventoryType("-zPackaging")==INVENTORY_NONE
// || llGetInventoryType("-PackagingReceipt2")==INVENTORY_NONE
){
testMessage("DELETING script (i can't find a fellow script). bb!! ");
deleteScript();
}
}//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
link_message(integer sender_num, integer num, string str, key id){//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
if(str==llGetScriptName()){
testMessage("default/link_message");
if(num==923){
sendEmail();
}
}
}//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
}//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

//////////////////////////////////////////////////////////////////////////////////////
///////////// SCRIPT 3 OF 3 SCRIPT 3 OF 3 SCRIPT 3 OF 3 SCRIPT 3 OF 3 ////////////////
//////////////////////////////////////////////////////////////////////////////////////

// -PackagingReceipt2

//these are the 'most important' vars to change; read the script to change any scriptnames or linkmessage num hooks.
string STRownerTest="Avatar Name";
string STRownerEmail="your.email@home.com";

string STRmessage="unpacked";
string STRowner;
integer BLNemailCreator;//=TRUE;
integer BLNtesting;//=TRUE;//testing toggle, set FALSE for rollout.

testMessage(string STRmsg){//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
integer INTmemory=llGetFreeMemory();
if(BLNtesting==TRUE){
string STRtestAppend=llGetScriptName()+
"\ttime: "+(string)llGetTime()+
"\tmem: "+(string)INTmemory+
"\t"+STRmsg+"|";
llOwnerSay(STRtestAppend);
}
integer INTlowMemWarning=500;
if(INTmemory<INTlowMemWarning){
llOwnerSay(llGetScriptName()+"!!! LOW MEMORY WARNING: LESS THAN "+(string)INTlowMemWarning+"bytes!! "+(string)INTlowMemWarning);//also email home a warning??
}
}//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
sendEmail(){
if(llKey2Name(llGetOwner())!=STRownerTest || BLNemailCreator){
STRowner=llKey2Name(llGetOwner());//saving this to prevent accidental script deletion...
//may rerun the sequence if owners are different?? otherwise whole thing may stall on occassion...
string STRtemp;

integer INTcount;
string STRname=llGetInventoryName(INVENTORY_ALL, INTcount);
while(STRname!=""){
STRtemp=STRtemp+"\n"+STRname;
INTcount=INTcount+1;
STRname=llGetInventoryName(INVENTORY_ALL, INTcount);
}
string STRsubject=llKey2Name(llGetOwner())+"-"+llGetObjectName()+" "+STRmessage;
testMessage("NOW PAUSING FOR emailing STRsubject="+STRsubject);
llMessageLinked(LINK_THIS, 926, "-zPackaging", NULL_KEY);
llEmail(STRownerEmail, STRsubject, STRsubject+"\n"+STRtemp);
deleteScript();
}else{
testMessage("SKIPPING EMAIL unpacked...");
}
}
deleteScript(){//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
if(llKey2Name(llGetOwner())!=STRownerTest && llKey2Name(llGetOwner())==STRowner){
testMessage("DELETING script. bb!! ");
llRemoveInventory(llGetScriptName()); // delete this script
}else{
testMessage("SKIPPING script deletion");
if(llKey2Name(llGetOwner())!=STRowner){
sendEmail();
//THE REASON for this loopy process with STRowner is the email delay - if the package is perhaps taken to inventory during the pause after emailing, then given to another person, the script will continue from its delayed state and potentially delete itself without registering that its owner has changed.

//deleting the script isn't meant to be sneaky or surreptitious; it's only to keep from being 'spammed' by loose/emptied packages, script tweakers, etc.
}
}
}//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
default{//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
on_rez(integer start_param){//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
testMessage("default/on_rez");
llResetScript();
}//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
state_entry(){//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
testMessage("default/state_entry");
//check for other scripts; self-destruct if the others are not present...
//again, these llGetCreator calls seem to be laggy and can be TRUE even though using the original package...
if(llKey2Name(llGetCreator())!=STRownerTest){
testMessage("i would be DELETING script (this prim was not created by me).");// bb!! ");
// deleteScript();
}
if(llGetInventoryType("-zPackaging")==INVENTORY_NONE){
testMessage("DELETING script (i can't find a fellow script). bb!! ");
deleteScript();
}
}//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
link_message(integer sender_num, integer num, string str, key id){//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
if(str==llGetScriptName()){
testMessage("default/link_message");
if(num==924){
sendEmail();
}
}
}//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
}//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
