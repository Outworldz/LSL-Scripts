// :CATEGORY:Security
// :NAME:Security Orb
// :AUTHOR:Psyke Phaeton
// :KEYWORDS:
// :CREATED:2014-09-08 19:08:15
// :EDITED:2014-09-08
// :ID:1043
// :NUM:1638
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// A high quality security systemk
// :CODE:
/*

CC-BY-NC-SA

This work by Psyke Phaeton is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
You can read the full licence here: http://creativecommons.org/licenses/by-nc-sa/4.0/

In sumary:

You are free to:

    Share — copy and redistribute the material in any medium or format
    Adapt — remix, transform, and build upon the material

    The licensor cannot revoke these freedoms as long as you follow the license terms.

Under the following terms:

    Attribution — You must give appropriate credit, provide a link to the license, and indicate if changes were made. You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.

    NonCommercial — You may not use the material for commercial purposes.

    ShareAlike — If you remix, transform, or build upon the material, you must distribute your contributions under the same license as the original.

    No additional restrictions — You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.

In addition:
    You can't use the trade mark "PDS HomeSecurity" or PDS logos.

*/

integer announce;       //channel replies are sent to
integer channel;        // channel we use for dialog box and user commands
integer list_number_offset; // the number of the name to display in the next /MAIN/TARGETS menu.
//integer tpd = 6;            // targets shown per dialog window in TARGETS menu
integer listen_id;          // id of the listen()er
key     menu_user_id;      // saves name of menu user so dataserver() can use it when calling granting_user() printed text
key     name_query_id;     // query id SL gave when i asked for a key->name from data server
integer basic_menu;

//Last sentence for list when in Wizard menus
string wiz_last = "\nYou can edit these lists in 'Names' later"; //SETTINGS/Lists later.";
//Last sentence for list when in ADVANCED/Settings or Lists menus
string set_last = "\nTo delete an entry press (Next>>)";

string menu1operator1 = "(1/18) Operators:\nOperators can operate the Orb. Add yourself as operator. To add joe.blogs as Operator type in chat:\t /";
string menu1operator2 = "addo joe.blogs\n";

string menu1access1 =
"(2/18) Visitor Lists
Access to your land is dual level.
Guests Mode: allows Friends, Guests & Group
Friends Mode: allows Friends only.
To add Guest type: /";
string menu1access2 = "addg persons.name
To add Friend type: /";
//"(7/18) Authorised List:
//Authorised people are never attacked & Orb owner is never attacked. To add Joe Bloggs as safe type:
//\t /";
string menu1access3 = "addf persons.name\n";

string menu1target1 =
"(3/18) Target List
Targets are attacked. Orb owner is never attacked. To have joe.bloggs attacked when armed type:
\t/";
string menu1target2 = "addt joe.bloggs\n";

string menu1limits1 =
"(16/18) Limits
Set up and down range limits. Commands:
\t/";
string menu1limits2 = "up=<number in meters>
\t/";
string menu1limits3 = "down=<number in meters>
Typed anytime. Width limits set with Range & land borders. Recommend 500";

string menu1visit_im =
"(17/18) Visit IM:

When a visitor comes or goes should you get an IM?

Recommend [On]";

string menu1lists1 =
"View/Edit Lists:
Visitors ·· To add a Guest: /";
string menu1lists2 = "addg name
　　　　　　 To add a Friend: /";
string menu1lists3 = "addf name
Operators ·· To add Operator: /";
string menu1lists4 = "addo name
Targets ·· To add Target: /";
string menu1lists5 = "addt name
Network ·· To network Orbs. /";
string menu1lists6 = "addn HSID
See TOP MENU/Help about Networking HSOrbs";

//MENU common items
string menu_groupset = 
"
SL Viewer Instructions:
- Right Click the HSOrb, choose Edit
- Click General tab
- Click the Group: button, select Group
- Tick Share (with group)
- Click Deed (& Deed on the popup)
- Press [On] in this window";


//MENUS!!!
string menu1main =
"SETUP ·· *START HERE!*
Help ·· documentation & instructions
TurnOn ·· your PDS HomeSecurity™ Orb
TurnOff ·· your PDS HomeSecurity™ Orb
Names ·· and networks. Add/Delete
Log ·· of commands and visitors
ListNear ·· avatars
SETTINGS ·· for your PDS HomeSecurity™ Orb
Updates ·· and fixes";

// ▷ ▻ > ▸ ‣ ⇰ ⇾ ⇨ ⇢ ⇒ ↦ → ↠ › ⇨ "　" <-- fixed space

string menu1turnOn =
"Choose a Mode: Guests Recommended
Friends ·· Allow Orb FRIENDS ONLY
Guests^ ·· Allow Orb Friends, Guests & Group^
Public ·· Attack Orb Targets ONLY
NoAttack ·· Scan, NEVER ATTACK

^ If Settings > Weapon > GroupSafe is ON people with same group ACTIVE as Orb are never attacked in Guests Mode";

string menu1wizard =
"Setup Wizard
Basic ·· 4 questions (Linden Home/New User)
Full ·· 18 questions (Experienced Users)

Experienced users can edit the 'HomeSecurity Settings' notecard and copy to other HSOrbs";

string menu1attackType =
"(4/18) Attack Type
Eject^ ·· them to outside your land (polite)
Teleport^ ·· the person back home (mean)
Push* ·· person gently away (useless)
^ Orb and land need exact same owner.
* Very weak attack! Land Restricted Push may need to be off. Recommend Eject";


string menu1groupOp =
"(5/18) Group Operated
To have group members operate the Orb do these steps then click [On].
Recommend [Off]\n";

//string menu1relay =
//
//"--- Networking Devices ---
//This option is for networking multiple Orb systems. See doco in me.
//
//The command to add Networked Devices is:
//\t/8addn <HSID number>
//
//Assuming the default channel 8 is used.";

string menu1scanRange =

"(6/18) NoAttack Range

NoAttack Mode NEVER attacks.
How far to scan in NoAttack Mode?
'LandOwners' is any Region land with this lands owner.
Recomend Region.";

string menu1armedRange =

"(7/18) Armed Range

When the Orb is armed, how close can they get before attacked?
'LandOwners' is any Region land with this lands owner.
Recommend ThisLand.";

string menu1scanTimer =

"(8/18) Scan/Warn Timer

How often do we scan the area and how much warning do we give? Takes 1 second to scan 15 avatars.
Linden's recomend 10 secs";

string menu1groupSafe =

"(9/18) Group Safe
For group members to be safe follow these instructions then click [On] To be safe group members will need to have the Group ACTIVE on their avatar! Recommend [Off]";

string menu1push =

"(10/18) Push Percent

If you were to use Push how hard is person pushed. People across region borders can't be pushed
Recommend [100%] which is still weak.";

string menu1foreignLand =

"(11/18) Foreign Land Safe
Keep EVERYONE over foreign land SAFE?
The Orb can tell if the target and the Orb are over land owned by the same person.
Recommend [On] SO YOU DON'T ATTACK YOUR NEIGHBOURS AND THEIR VISITORS!!";

string menu1otherLand =

"(12/18) Keep other land SAFE?
The Orb can tell if an avatar & Orb are over different land. Recomended [On] FOR RENTED LAND where neigbours land has same owner. 
Recommend [On] so any other land is ignored.";

string menu1sleep =
"(13/18) Sleep

SleepNever ·· Never sleep *Recommended*
SleepNoOp ·· Sleep when NO Operator present
SleepSeeOp ·· Sleep when Operator is present";


string menu1notifyOp =
"(14/18) Notify Op
Does the person who activates the Orb want an IM or Menu^ popup when it attacks?
Recommend [IM]
^ Menus can only be sent by SL if you have been in this region since logon";

string menu1notifyIntruder =
"(15/18) Notify Intruder

Do you want to tell the target who attacked them?

Recommend [On]";

string menu1wizcomp =
"Wizard Completed: Congratulations!

You have configured the Orb.

Click [TurnOn] and select an option
Click [Help] for advanced documentation";

//string menu1off = "
//
//
//\t\t\t\t\t -=[  Orb is Offline  ]=-";

//Deed to Group
//Group Land?
//LIST NEAR
//SETTINGS

//➔　SETUP · wizard ⬅ BEGIN HERE
//？　Help · documentation & instructions

//☠　TurnOn · your HomeSecurity™ Orb
//☮　TurnOff · your HomeSecurity™ Orb

//☺　Names · and networks. Add/Delete
//✎　Log · of commands and visitors
//♟　ListNear · avatars

//⚒　SETTINGS · for your HomeSecurity™ Orb
//✚　Updates · and fixes";

string menu1settings =
"SETTINGS:
SETUP ·· wizard
Security ·· Operators, Group Operation
Scanner ·· Timer, Range, Names, Sleep, VisitIM
Weapon ·· AttackType, Notifications, Bans,
                GroupSafe, Foreign/Other Land
Lists ·· Ops, Targets, Friends, Guests, Network
AvLimits ·· Avatar Script Limits, Age Limits,
                DisplayName Protection 

Click Help, Commands chapter for more.";

string menu1log =
"
Log Menu
VLog ·· Visitor log
CLog ·· Command log
VlogClear ·· Clear Visitor Log
CLogClear ·· Clear Command Log";

string menu1dispprot = 
"(18/18) Display Name Protection

If an avatar is not an Operator but does use an Operators name in his Display Name do you want them removed from this area?
Recommend [Off]";



show_menu(key id, string menu_name, list buttons) {
    llDialog(id, menu_name, buttons,channel);
}

main_menu(key id) {
    //llSay(0,"menu main_menu() id = " + (string)id);
    show_menu(id,menu1main,["TurnOff","ListNear","SETTINGS","TurnOn","Names","Log","SETUP","Help","Updates"]);
}

ml(integer num, string msg, key id) {
    llMessageLinked(LINK_THIS,num,msg,id);
}

access_granted(key id, string name) { //, string remote?) {
    llSay(announce,"(Menus) "+ //remote? +
        "Access granted to " + name);
}

print_status() {
    //llSay(0,"(Menus) Channel: " + (string)channel + " (" + (string)llGetFreeMemory() + " bytes free)");
    llSay(0,"(0Menus) " + (string)llGetUsedMemory() + "b");
}

basic_menu_check(key id) {
     if (basic_menu) show_menu(id, menu1wizcomp, ["TurnOn","Help","TOP MENU"]); //show wizcomp 
     else            show_menu(id, menu1groupOp + menu_groupset, ["5 Off","5 On"]); //ask more questions
     basic_menu = 0; 
}

default
{
    state_entry () {
        if (llGetMemoryLimit() < 65536) llSay(DEBUG_CHANNEL,"**** Memory limit too low. Mono disabled? ****");
        //channel number will be triggered from Settings Script detecting CHANGE_INVENTORY
        if (llGetStartParameter() == 1294853845) {
            //script sent from update disk
            //llSay(DEBUG_CHANNEL,"(Menus) Updated");

        } else {
                //script reset, or STOLEN from orb or UPDATE DISK
                llSay(0,"Restart detected. Script deleting.");
            if (llKey2Name(llGetOwner()) != "Psyke Phaeton") llRemoveInventory(llGetScriptName()); //not psyke, delete
            //recompiling script does not cause CHANGE_INVENTORY, therefore reget channel number
            llGetNotecardLine("HomeSecurity Channel",0);
            print_status();
        }
    }

    link_message(integer sender, integer num, string menu, key id) {
        
        //DEBUG
        //llSay(DEBUG_CHANNEL,"(0Debug) num=" +(string)num + " string=" + menu + " key=" + (string)id);
        
        if (num < 0 || num > 999) return; //not for me :)

        if (num == 1) channel = (integer)menu; //the string variable from ml we called menu because it mostly sends menu buttons here
        if (num == 2) announce = (integer)menu; //the string variable from ml we called menu because it mostly sends menu buttons here

        if (num == 100) print_status();

        if (num == 111) { //Security:detected a click and sent command 0111
            //llSay(0,"menu ++");
            main_menu(id);
            string name;
            if (llGetDisplayName(id) == "") name = llKey2Name(id) + " (" + llGetUsername(id) + ")";
            else name = llGetDisplayName(id) + " (" + llGetUsername(id) + ")";
            //if (name == "()") name = (string)id;
            access_granted(id,name); //,"");
        }
        if (num == 112) { //Security:sent command 0112 to show a menu
        
            //llSay(0,"(0Debug) menu click '" + menu + "'");
            //commonly used button sets
            list range_buttons  = ["10m.","15m.","20m.","30m.","50m.","100m.","150m.","200m.","500m.","ThisLand.","LandOwners.","Region."];//use by Wiz ScanRange
            list rate_buttons   = ["15 secs","20 secs","30 secs","6 secs","8 secs","10 secs","1 secs","2 secs","4 secs"];
            list pushpc_buttons = ["100%","85%","70%","60%","50%","40%","30%","20%","10%","5%","1%","0.001%"];
            list settings_buttons = ["Weapon","Lists","Help","SETUP","Security","Scanner","TOP MENU","AvLimits"];
            list log_buttons = ["CLog","CLogClear","VLogClear","VLog","TOP MENU"];
            //user commands converted to expected menu names

            menu = llToLower(menu);
            string suffix = llGetSubString(menu,llSubStringIndex(menu,"=") + 1,-1);
            string prefix = llToLower(llGetSubString(menu,0,llSubStringIndex(menu,"=")));

            
            //Turned On via network. Extract the Op UUID so VisitIM won't nag them from this Orb then process command as normal.
            integer localop = 1; //show menu after activating by default (unless turned via network)

            if (llGetSubString(menu,0,8) == "noattack=")    { menu="noattack"; localop = 0;} //id = (key)llGetSubString(menu,9,-10);
            if (llGetSubString(menu,0,6) == "public=")      { menu="public"; localop = 0;} //id = (key)llGetSubString(menu,7,-10);
            if (llGetSubString(menu,0,6) == "guests=")      { menu="guests"; localop = 0;} //id = (key)llGetSubString(menu,7,-10);
            if (llGetSubString(menu,0,7) == "friends=")     { menu="friends"; localop = 0;} //id = (key)llGetSubString(menu,8,-10);

            //if (llGetSubString(menu,0,1) == "◀ ") menu = llGetSubString(menu,2,-1); // ◀ TOP MENU = MAIN MENU
            
            //MENUS OR COMMANDS FROM (SECURITY)
            
            if (menu=="full")       {basic_menu = 0; ml(2000,llGetUsername(id),id); show_menu(id, menu1operator1 + (string)channel + menu1operator2 + wiz_last,["1 Next >"]); }
            else if (menu=="basic") {
                llSay(announce,"(0Menu) Configuring settings to Basic...");
                basic_menu = 1;
                ml(2000,llGetUsername(id),""); //"" key stops Sleep Menu popup being sent.
                ml(1500,"0",""); //groupop off
                ml(2500,"-4",""); //scanrange = Region
                ml(2501,"-1",""); //armed range = ThisLand
                ml(2502,"10",""); //scan timer
                ml(3501,"0",""); //groupsafe
                ml(3502,"1",""); //ForeignLand Safe on
                ml(3508,"1",""); //OtherLand Safe on
                ml(2104,"0",""); //sleepnever
                ml(3503,"1",""); //Notify Op
                ml(3504,"1",""); //Notify Intruder
                ml(2106,"1",""); //VisitIM yes
                ml(2650,"500",""); //Up 96m
                ml(2651,"500",""); //Down 96m
                ml(2020,"0",""); //Display Name Protection off
                //...add more default settings here....
                show_menu(id, menu1operator1 + (string)channel + menu1operator2 + wiz_last,["1 Next >","Help"]);
                //...more other questions up here for Linden Home users!!...
                //Targets
                //Friends/Guests
                //teleport/eject?
            }
            else if (menu=="1 next >") show_menu(id, menu1access1 + (string)channel + menu1access2 + (string)channel + menu1access3 + wiz_last,   ["2 Next >","Help"]);                    //ops -> visitors
            else if (menu=="2 next >")      show_menu(id, menu1target1 + (string)channel + menu1target2 + wiz_last,                             ["3 Next >","Help"]);                     //visitors -> targets
            else if (menu=="3 next >")     show_menu(id, menu1attackType,                                                                      ["4 Teleport","4 Push","Help","4 Eject"]); //targets -> attacktype
            else if (menu=="4 push")        {ml(3505,"0","");  ml(2201,"0",""); basic_menu_check(id); } //attacktype -> if not BASIC GroupOp else WizComp
            else if (menu=="4 teleport")    {ml(3505,"2","");  ml(2201,"2",""); basic_menu_check(id); } //attacktype -> if not BASIC GroupOp else WizComp
            else if (menu=="4 eject")       {ml(3505,"3","");  ml(2201,"3",""); basic_menu_check(id); } //attacktype -> if not BASIC GroupOp else WizComp
            //END BASIC QUESTIONS - START ADVANCED QUESTIONS
            
            //waiting for .. if basic_menu = 0 then AttackType to lead to GroupOp 
                    
            else if (menu=="5 on")         {ml(1500,"1",""); show_menu(id, menu1scanRange,         range_buttons);}
            else if (menu=="5 off")        {ml(1500,"0",""); show_menu(id, menu1scanRange,         range_buttons);}
            else if (llGetSubString(menu,-1,-1)==".")   {ml(2500,menu,id); show_menu(id, menu1armedRange,                      ["10m. ","15m. ","20m. ","30m. ","50m. ","100m. ","150m. ","200m. ","500m. ","ThisLand. ","LandOwners. ","Region. "]);}
            else if (llGetSubString(menu,-3,-1)=="m. ")  {ml(2501,menu,id); show_menu(id, menu1scanTimer,   rate_buttons);}
            else if (menu=="thisland. ")    {ml(2500,"-1",id); show_menu(id, menu1scanTimer,   rate_buttons);}
            else if (menu=="LandOwners. ")  {ml(2500,"-2",id); show_menu(id, menu1scanTimer,   rate_buttons);}
            else if (menu=="region. ")      {ml(2500,"-4",id); show_menu(id, menu1scanTimer,   rate_buttons);}
            else if (llGetSubString(menu,-4,-1)=="secs") {ml(2502,menu,id); show_menu(id, menu1groupSafe + menu_groupset,       ["9 Off","9 On"]); }
            else if (menu=="9 on")          {ml(3500,"1",""); show_menu(id, menu1push,                                          pushpc_buttons); }
            else if (menu=="9 off")         {ml(3500,"0",""); show_menu(id, menu1push,                                          pushpc_buttons); }
            else if (llGetSubString(menu,-1,-1)=="%") {ml(3501,menu,""); show_menu(id, menu1foreignLand,                        ["11 On","11 Off"]); }

            else if (menu=="11 on")   {ml(3502,"1",""); show_menu(id, menu1otherLand,                                            ["12 On","12 Off"]); }
            else if (menu=="11 off")  {ml(3502,"0",""); show_menu(id, menu1otherLand,                                            ["12 On","12 Off"]); }

            //was
            //else if (menu=="      ☑ On")  {ml(3508,"1",""); show_menu(id, menu1notifyOp,                                      [" Menu"," IM","    ☐ Off"]); }
            //else if (menu=="       ☐ Off") {ml(3508,"0",""); show_menu(id, menu1notifyOp,                                     [" Menu"," IM","    ☐ Off"]); }

            //will be
            else if (menu=="12 on")          {ml(3508,"1",""); show_menu(id, menu1sleep,                                         [" SleepNever"," SleepNoOp"," SleepSeeOp"]); }
            else if (menu=="12 off")         {ml(3508,"0",""); show_menu(id, menu1sleep,                                         [" SleepNever"," SleepNoOp"," SleepSeeOp"]); }
            else if (menu==" sleepseeop")   {ml(2104,"2",""); show_menu(id, menu1notifyOp,                                      ["14 IM","14 Menu","14 Off"]); }
            else if (menu==" sleepnoop")    {ml(2104,"1",""); show_menu(id, menu1notifyOp,                                      ["14 IM","14 Menu","14 Off"]); }
            else if (menu==" sleepnever")   {ml(2104,"0",""); show_menu(id, menu1notifyOp,                                      ["14 IM","14 Menu","14 Off"]); }
            //will be end

            else if (menu=="14 im")          {ml(3503,"1",""); show_menu(id, menu1notifyIntruder,                                ["15 On","15 Off"]); }
            else if (menu=="14 menu")        {ml(3503,"2",""); show_menu(id, menu1notifyIntruder,                                ["15 On","15 Off"]); }
            else if (menu=="14 off")         {ml(3503,"0",""); show_menu(id, menu1notifyIntruder,                                ["15 On","15 Off"]); }
            else if (menu=="15 on")          {ml(3504,"1",""); show_menu(id, menu1limits1 + (string)channel + menu1limits2 + (string)channel + menu1limits3,  ["16 Next >"]); }
            else if (menu=="15 off")         {ml(3504,"0",""); show_menu(id, menu1limits1 + (string)channel + menu1limits2 + (string)channel + menu1limits3,  ["16 Next >"]); }
            else if (menu=="16 next >")    show_menu(id, menu1visit_im, ["17 On","17 Off"]);
            else if (menu=="17 on")          {ml(2106,"1",id); show_menu(id, menu1dispprot,                                      ["18 On","18 Off"]); }
            else if (menu=="17 off")         {ml(2106,"0",id); show_menu(id, menu1dispprot,                                      ["18 On","18 Off"]); }
            else if (menu=="18 on")          {ml(2020,"1",id); show_menu(id, menu1wizcomp,                                       ["TurnOn","Help","TOP MENU"]); }
            else if (menu=="18 off")         {ml(2020,"0",id); show_menu(id, menu1wizcomp,                                       ["TurnOn","Help","TOP MENU"]); }
            
            //END SETUP
            //START NORMAL CHAT COMMANDS and MENU with stripped icons
            
            else {
                //strip prefixed symbol and space if exists
                if (llGetSubString(menu,1,1) == " ") menu = llGetSubString(menu,2,-1);
                
                if (menu=="top menu" || menu=="menu")       main_menu(id);
                else if (menu=="set up" || menu=="setup")   show_menu(id, menu1wizard,                                          ["Basic","Full","TOP MENU"]);
                else if (menu=="turnoff" || menu=="off")    {ml(2000,llGetUsername(id),id); ml(81304,"Offline","");} //show_menu(id, menu1off, ["TOP MENU"]);} //local turnoff
                else if (llGetSubString(menu,0,7) == "turnoff=") {ml(2000,"#"+llToUpper(llGetSubString(menu,-8,-1)),id); ml(81304,"Offline",""); } //remote turnoff
                //MAIN/Turn On
                else if (menu=="turnon")    show_menu(id, menu1turnOn,                                                          ["Friends","Guests","Public","TOP MENU","NoAttack"]);
                else if (menu=="noattack")  {ml(2001,"",id); if (localop) ml(2111,"",id);ml(81304,"Online","");} //SCANNER:set to Scan, then show status menu
                else if (menu=="public")    {ml(2002,"",id); ml(3010, llGetUsername(id),id); if (localop) ml(2111,"",id);ml(81304,"Online","");} //SCANNER:set to Scan, tell weapon activator name, then show status menu
                else if (menu=="guests")    {ml(2003,"",id); ml(3010, llGetUsername(id),id); if (localop) ml(2111,"",id);ml(81304,"Online","");} //as above
                else if (menu=="friends")   {ml(2004,"",id); ml(3010, llGetUsername(id),id); if (localop) ml(2111,"",id);ml(81304,"Online","");} //as above
                //MAIN/SETTINGS
                else if (menu=="settings")  show_menu(id, menu1settings + "\n(HSID:" + llGetSubString((string)llGetKey(),-8,-1) + ")",                                                        settings_buttons);
                //MAIN/SETTINGS/Security
                else if (menu=="security")  ml(1111,"",id); //Menu from Security
                else if (menu=="groupop")   show_menu(id, menu1groupOp + menu_groupset,                                         ["GO On","GO Off","< Security"]);
                else if (menu=="go on")     {ml(1500,"1",""); ml(1111,"",id);}
                else if (menu=="go off")    {ml(1500,"0",""); ml(1111,"",id);}
                //if (menu=="relays")       show_menu(id, menu1relay + set_last,                                                ["Next>> ","◀ Security"]);
                //if (menu=="next>> ")      ml(1900,"",id); //Relay List
                //if (menu=="operators")    show_menu(id, menu1operator + set_last,                                             ["Next>>  ","◀ Security"]);
                //if (menu=="next>>  ")     ml(1800,"",id); //Operator List
                //MAIN/SETTINGS/Scanner
                else if (menu=="scanner")   { ml(2111,"",id); } //Menu from Scanner (Scan Rate)(Scan Range)(ArmedRange)(Targets)(Authorised)
                else if (menu=="scantimer") show_menu(id, menu1scanTimer,                                                       ["ST=20","ST=25","ST=30","ST=10","ST=12","ST=15","ST=4","ST=6","ST=8","< Scanner","ST=1","ST=2"]);
                else if(prefix=="st=")      {ml(2502,suffix,id); ml(2111,"",id); } // Scanner:Change Scan Rate, Then Scanner:Status menu
                else if (menu=="scanrange") show_menu(id, menu1scanRange,                                                       ["ThisLand ","LandOwners ","Region ","< Scanner","SR=500","SR=200","SR=100","SR=75","SR=50","SR=30","SR=20","SR=10"]);
                else if(prefix=="sr=")      {ml(2500,suffix,id); ml(2111,"",id); } // Scanner:Change Scan Range, Then Scanner:Status menu
                else if(menu=="thisland ")      {ml(2500,"-1",id); ml(2111,"",id); } // Scanner:Change Scan Range, Then Scanner:Status menu
                else if(menu=="landowners ")      {ml(2500,"-2",id); ml(2111,"",id); } // Scanner:Change Scan Range, Then Scanner:Status menu
                else if(menu=="region ")      {ml(2500,"-4",id); ml(2111,"",id); } // Scanner:Change Scan Range, Then Scanner:Status menu
                else if (menu=="armedrng")  show_menu(id, menu1armedRange,                                                      ["ThisLand","LandOwners","Region","< Scanner","AR=500","AR=200","AR=100","AR=75","AR=50","AR=30","AR=20","AR=10"]);
                else if(prefix=="ar=")      {ml(2501,suffix,id); ml(2111,"",id); } // Scanner:Change Armed Range, Then Scanner:Status menu
                else if(menu=="thisland")      {ml(2501,"-1",id); ml(2111,"",id); } // Scanner:Change Scan Range, Then Scanner:Status menu
                else if(menu=="landowners")      {ml(2501,"-2",id); ml(2111,"",id); } // Scanner:Change Scan Range, Then Scanner:Status menu
                else if(menu=="region")      {ml(2501,"-4",id); ml(2111,"",id); } // Scanner:Change Scan Range, Then Scanner:Status menu
                else if (menu=="weapon")    ml(3111,"",id); //Menu from Weapon (Attack Type)(Push)(IM Owner)(Notify)(Group Safe)(ForeignLnd)
                else if (menu=="attacktype") show_menu(id, menu1attackType,                                                     ["Eject","Teleport","Push","< Weapon"]);
                else  if (menu=="push")     {ml(3505,"0",""); ml(2201,"0",""); ml(3111,"",id); }
                //if (menu=="Bullet")       {ml(3505,"1",""); ml(2201,"1",""); ml(3111,"",id); }
                else if (menu=="teleport")  {ml(3505,"2",""); ml(2201,"2",""); ml(3111,"",id); }
                else if (menu=="eject")     {ml(3505,"3",""); ml(2201,"3",""); ml(3111,"",id); }
                else if (menu=="pushpower") show_menu(id, menu1push,                                                ["Weapon","PP=85","PP=100","PP=40","PP=50","PP=70","PP=10","PP=20","PP=30", "PP=0.001","PP=1","PP=5"]);

                else if (prefix=="pp=")     {ml(3501,suffix,""); ml(3111,"",id); }

                else if (menu=="groupsafe") show_menu(id, menu1groupSafe + menu_groupset,                                       ["GS On","GS Off", "< Weapon"]);
                else  if (menu=="gs on")    {ml(3500,"1",""); ml(3111,"",id); }
                else  if (menu=="gs off")   {ml(3500,"0",""); ml(3111,"",id); }
                else if (menu=="foreignland" || menu=="✈foreignland")   show_menu(id, menu1foreignLand,                         ["FLS On","FLS Off", "< Weapon"]); //space didnt fit on button
                else  if (menu=="fls on")   {ml(3502,"1",""); ml(3111,"",id); }
                else  if (menu=="fls off")  {ml(3502,"0",""); ml(3111,"",id); }

                else if (menu=="otherland") show_menu(id, menu1otherLand,                                                       ["OLS On","OLS Off", "< Weapon"]);
                else  if (menu=="ols on")   {ml(3508,"1",""); ml(3111,"",id); }
                else  if (menu=="ols off")  {ml(3508,"0",""); ml(3111,"",id); }

                else if (menu=="notifyop")  show_menu(id, menu1notifyOp,                                                        ["NOp IM","NOp Menu","NOp Off", "< Weapon"]);
                else  if (menu=="nop im")   {ml(3503,"1",""); ml(3111,"",id); }
                else  if (menu=="nop menu") {ml(3503,"2",""); ml(3111,"",id); }
                else  if (menu=="nop off")  {ml(3503,"0",""); ml(3111,"",id); }
                else if (menu=="notifytarg") show_menu(id, menu1notifyIntruder,                                                 ["NT On","NT Off", "< Weapon"]);
                else  if (menu=="nt on")    {ml(3504,"1",""); ml(3111,"",id); }
                else  if (menu=="nt off")   {ml(3504,"0",""); ml(3111,"",id); }
                else  if (menu=="ban on")   {ml(3800,"1",""); ml(3111,"",id); }
                else  if (menu=="ban off")  {ml(3800,"0",""); ml(3111,"",id); }
                else if (menu=="sleep")     show_menu(id,menu1sleep,                                                            ["SleepNever","SleepNoOp","SleepSeeOp","< Scanner"]);
                else if (menu=="sleepnever") ml(2104,"0",id);
                else if (menu=="sleepnoop")  ml(2104,"1",id);
                else if (menu=="sleepseeop") ml(2104,"2",id);
                else if (menu=="visitim")    show_menu(id,menu1visit_im,                                                        ["VisitIM On","VisitIM Off", "< Scanner"]);
                else  if (menu=="visitim on") {ml(2106,"1",id); ml(2111,"",id); }
                else  if (menu=="visitim off") {ml(2106,"0",id); ml(2111,"",id); }
                else if (menu=="dispprot")    show_menu(id,menu1dispprot,                                                        ["DispProt On","DispProt Off", "< AvLimits"]);
                else  if (menu=="dispprot on") {ml(2020,"1",id); ml(2111,"",id); }
                else  if (menu=="dispprot off") {ml(2020,"0",id); ml(2111,"",id); }

                // logs

                else if (menu=="log")       show_menu(id,menu1log, log_buttons);
                else if (menu=="vlog")      {ml(81301,"",id); show_menu(id,menu1log,                                            log_buttons);}
                else if (menu=="clog")      {ml(8301,"",id); show_menu(id,menu1log,                                             log_buttons);}
                else if (menu=="clogclear") {ml(8666,"",""); show_menu(id,menu1log,                                             log_buttons);}
                else if (menu=="vlogclear") {ml(81666,"",""); show_menu(id,menu1log,                                            log_buttons);}
                
                //AvLimits - processed by 81VisitorLog
                
                else if (menu=="avlimits") ml(81502,"",id);
                else if (menu=="agehelp") llDialog(id,"AgeHelp: Type in Chat:\n/"+(string)channel+"age [days_old] [hours]\nor\n/"+(string)channel+"age off\n\nMeaning: For the next [hours], attack any avatar under age [days_old]\n\nIgnoring hours parameter means until year 2038",["< AvLimits"],channel);
                
                //misc
                else  if (menu=="nthop on")    ml(3510,"1",""); 
                else  if (menu=="nthop off")   ml(3510,"0",""); //hide "Operated by: Operator Name" in target notification pop-up
                else  if (menu=="stmon")       ml(2016,"",""); //script time monitor toggle
                

                //MAIN/SETTINGS/Lists
                else if (menu=="lists" || menu=="names") show_menu(id, menu1lists1 + (string)channel + menu1lists2 + (string)channel + menu1lists3 + (string)channel +
                    menu1lists4 + (string)channel + menu1lists5  + (string)channel + menu1lists6,                               ["SETTINGS","Targets","Network","TOP MENU","Visitors","Operators"]);

                else if (menu=="vrange")    show_menu(id, menu1limits1 + (string)channel + menu1limits2 + (string)channel + menu1limits3,  ["Scanner","SETTINGS","TOP MENU"]);
            } //end else if menu has " " at second char
                
            //END OF MENUS (link num = 0112)
        }
        //consider a valid number check here if we add more options
    }

    //dataserver(key requested, string notecard_line_string) //not needed a ml(1,"channel","") will set our channel
    //{
    //    if (llGetSubString(notecard_line_string,0, 7) == "channel=")     channel = (integer)llGetSubString(notecard_line_string,8,-1);
    //}
}
