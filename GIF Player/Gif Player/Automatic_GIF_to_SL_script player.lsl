

// Put any texture converted by gif_2_SL_animation_v0.6.exe into a prim with this script to get it to play back automatically as a movie



//Effect parameters: (can be put in list together, to make animation have all of said effects)
//LOOP - loops the animation
//SMOOTH - plays animation smoothly
//REVERSE - plays animation in reverse
//PING_PONG - plays animation in one direction, then cycles in the opposite direction
list effects = [LOOP];  // LOOP for GIF89 movies
//Movement parameters (choose one):
//ROTATE - Rotates the texture
//SCALE - Scales the texture
//Set movement to 0 to slide animation in the X direction, without any special movement.
integer movement = 0;
integer face = ALL_SIDES; //Number representing the side to activate the animation on.
integer sideX = 1; //Represents how many horizontal images (frames) are contained in your texture.
integer sideY = 1; //Same as sideX, except represents vertical images (frames).
float start = 0.0; //Frame to start animation on. (0 to start at the first frame of the texture)
float length = 0.0; //Number of frames to animate, set to 0 to animate all frames.
float speed = 10.0; //Frames per second to play.


list choices;        // a list of all texture names

// from the menu system http://wiki.secondlife.com/wiki/SimpleDialogMenuSystem
integer N_DIALOG_CHOICES;
integer MAX_DIALOG_CHOICES_PER_PG = 8; // if not offering back button, increase this to 9
string PREV_PG_DIALOG_PREFIX = "< Page ";
string NEXT_PG_DIALOG_PREFIX = "> Page ";
string DIALOG_DONE_BTN = "Done";
string DIALOG_BACK_BTN = "<< Back";

integer pageNum;
list DIALOG_CHOICES;

giveDialog(key ID, integer pageNum) {

    list buttons;
    integer firstChoice;
    integer lastChoice;
    integer prevPage;
    integer nextPage;
    string OnePage;

    CancelListen();

    menuChannel = llCeil(llFrand(1000000) + 11000000);
    listen_id = llListen(menuChannel,"","","");
    mode = FALSE;
    llSetTimerEvent(60);


    N_DIALOG_CHOICES = llGetListLength(DIALOG_CHOICES);


    if (N_DIALOG_CHOICES <= 10) {
        buttons = DIALOG_CHOICES;
        OnePage = "Yes";
    }
    else {
        integer nPages = (N_DIALOG_CHOICES+MAX_DIALOG_CHOICES_PER_PG-1)/MAX_DIALOG_CHOICES_PER_PG;


        if (pageNum < 1 || pageNum > nPages) {
            pageNum = 1;
        }
        firstChoice = (pageNum-1)*MAX_DIALOG_CHOICES_PER_PG;

        lastChoice = firstChoice+MAX_DIALOG_CHOICES_PER_PG-1;


        if (lastChoice >= N_DIALOG_CHOICES) {
            lastChoice = N_DIALOG_CHOICES;
        }
        if (pageNum <= 1) {
            prevPage = nPages;
            nextPage = 2;
        }
        else if (pageNum >= nPages) {
            prevPage = nPages-1;
            nextPage = 1;
        }
        else {
            prevPage = pageNum-1;
            nextPage = pageNum+1;
        }
        buttons = llList2List(DIALOG_CHOICES, firstChoice, lastChoice);
    }


    // FYI, this puts the navigation button row first, so it is always at the bottom of the dialog
    list buttons01 = llList2List(buttons, 0, 2);
    list buttons02 = llList2List(buttons, 3, 5);
    list buttons03 = llList2List(buttons, 6, 8);
    list buttons04;
    if (OnePage == "Yes") {
        buttons04 = llList2List(buttons, 9, 11);
    }
    buttons = buttons04 + buttons03 + buttons02 + buttons01;

    if (OnePage == "Yes") {
        buttons = [ DIALOG_DONE_BTN, DIALOG_BACK_BTN ]+ buttons;
        //omit DIALOG_BACK_BTN in line above  if not offering

    }
    else {
        buttons = [
            PREV_PG_DIALOG_PREFIX + (string)prevPage,
            DIALOG_BACK_BTN, NEXT_PG_DIALOG_PREFIX+(string)nextPage, DIALOG_DONE_BTN
                ]+buttons;
        //omit DIALOG_BACK_BTN in line above if not offering
    }
    llDialog(ID, "Page "+(string)pageNum+"\nChoose one:", buttons, menuChannel);
}


CancelListen() {
    llListenRemove(listen_id);
    llSetTimerEvent(3600);
    mode = TRUE;
}




initAnim() //Call this when you want to change something in the texture animation.
{
    integer effectBits;
    integer i;
    for(i = 0; i < llGetListLength(effects); i++)
    {
        effectBits = (effectBits | llList2Integer(effects,i));
    }
    integer params = (effectBits|movement);
    llSetTextureAnim(ANIM_ON|params,face,sideX,sideY,     start,length,speed);
  }

fetch(string texture)
{

    integer i;
    integer j = llGetInventoryNumber(INVENTORY_TEXTURE);
    for (i = 0; i < j; i ++)
    {
        string texture = llGetInventoryName(INVENTORY_TEXTURE,i);
        list data  = llParseString2List(texture,[";"],[]);
        string name = llList2String(data,0);
        if (name == texture) {
            string X = llList2String(data,1);
            string Y = llList2String(data,2);
            string Z = llList2String(data,3);
            llSetTexture(texture,ALL_SIDES);
            sideX = (integer) X;
            sideY = (integer) Y;
            speed = (float) Z;
            llOwnerSay("X=" + X + " Y=" + Y + " Z = " + (string) Z);

            if (speed) {
                initAnim();
            }
        }
    }
}

// Make a list of all bare names for the dialog
fetchAll()
{
    choices = [];
    integer i;
    integer j = llGetInventoryNumber(INVENTORY_TEXTURE);
    for (i = 0; i < j; i ++)
    {
        string texture = llGetInventoryName(INVENTORY_TEXTURE,i);
        list data  = llParseString2List(texture,[";"],[]);
        string name = llList2String(data,0);
        choices ++ name;
    }
}


default
{
    state_entry()
    {
    }

    touch_start(integer who)
    {
        if (llDetectedKey(0) == llGetOwner() )
        {
             DIALOG_CHOICES = getImages(); 
             pageNum = 1;
             fetchAll();

             giveDialog(llGetOwner(), pageNum);
        }
    }

    listen(integer channel, string name, key id, string message)
    {
        integer where ;
        if (message == "-")
        {
            giveDialog(llGetOwner(), pageNum);
        }
        else if ( message == DIALOG_DONE_BTN)
        {
            CancelListen();
            return;
        }
        else if (message == DIALOG_BACK_BTN)
        {
            pageNum = 1;
            DIALOG_CHOICES = choices;
            giveDialog(llGetOwner(), pageNum);
        }
        else if (llSubStringIndex(message, PREV_PG_DIALOG_PREFIX) == 0)
        {
            pageNum = (integer)llGetSubString(message, llStringLength(PREV_PG_DIALOG_PREFIX), -1);
            giveDialog(llGetOwner(), pageNum);
        }
        else if (llSubStringIndex(message, NEXT_PG_DIALOG_PREFIX) == 0)
        {
            pageNum = (integer)llGetSubString(message, llStringLength(NEXT_PG_DIALOG_PREFIX), -1);
            giveDialog(llGetOwner(),  pageNum);

        } else { //this is the section where you do stuff
                CancelListen();

                where = llListFindList(choices,[message]);
                if (where >= 0)
                {
                    fetch(message);
                    giveDialog(llGetOwner(),  pageNum);
                }
            }
        }
    }

}


