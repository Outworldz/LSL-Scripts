// :CATEGORY:Scanner
// :NAME:Language Scanner
// :AUTHOR:Ferd Fredderix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:56
// :ID:460
// :NUM:621
// :REV:1.0
// :WORLD:Second Life, Opensim
// :DESCRIPTION:
// HUD to show the language and name of any nearby avatars
// :CODE:

integer SENSOR_CHANNEL       = -71;     // the sensor channel
list Avatar_List = [];      // list of names we detected and info we need later
// distance, name, language, abbreviataion, key
// Distance is first, so we can sort by it

//integer AVATAR_DISTANCE = 0; // not needed    Avatar_List += distance; (float)
integer AVATAR_NAME = 1;    //                  Avatar_List += name;    (string)
integer AVATAR_LANG = 2;    //                  Avatar_List += lang;    (string)
integer AVATAR_ABBR = 3;    //                  Avatar_List += abbr;    (string)
integer STRIDE = 4;         // size of data we store to keep track of languages and distances

string MENU_ShowAll             = "Show All";      // Menu Items
string MENU_scanning_on_off     = "Scanner On";
string MENU_range               = "Short Range";
string abbreviation;    // temp storage

integer listener ;
integer listening = FALSE;

string OwnerLang = "en";    // viewer language at startup = english.
string MyAvatarName ; //place to ghold this, once, to save the system calls in a loop
integer channel;



DEBUG(string msg)
{
    if (FALSE)
        llOwnerSay(msg);
}


string left(string src, string divider) {
    integer index = llSubStringIndex( src, divider );
    if(~index)
        return llDeleteSubString( src, index , -1);
    return src;
}

string right(string src, string divider) {
    integer index = llSubStringIndex( src, divider );
    if(~index)
        return llDeleteSubString( src, 0, index + llStringLength(divider) - 1);
    return src;
}

// from the wiki, deletes one item in a strided list
list ListStridedRemove(list src, integer start, integer end, integer stride)
{
    return llDeleteSubList(src, start * stride, (stride * (end + 1)) - 1);
}

// Add language to the list
SetLang(string name, string abbr,  integer distance, key avikey, integer UpdateLang)
{
    ////DEBUG("name:" + name + "abbr:" + abbr +  " dist:" + (string) distance );

    string lang = ConvertLanguage(abbr);


    ////DEBUG("name:" + name + "abbr:" + abbr +  " lang:" + lang );
    // find it in the list, update the language distance if they speak

    integer placeinlist = llListFindList(Avatar_List, [name]);
    if (placeinlist > 0 )
    {
        //////DEBUG(name + " was located at  " + (string) ( placeinlist + 1)  + " speaking " + lang);

        if (llStringLength(lang) > 0 && UpdateLang)
            Avatar_List = llListReplaceList(Avatar_List, [lang], placeinlist + 1 , placeinlist + 1);            // replace lang, +1 offset from name

        if (llStringLength(abbreviation) > 0 && UpdateLang)
            Avatar_List = llListReplaceList(Avatar_List, [abbreviation], placeinlist + 2 , placeinlist + 2);    // replace abbr, +2 offset from name

        if(distance > 0 )
        {
            Avatar_List = llListReplaceList(Avatar_List, [distance], placeinlist -1 , placeinlist -1);    // replace abbr, +2 offset from name
        }
    }
    else
    {
        if (avikey != NULL_KEY)     // only add scanned avatars
        {
            Avatar_List += distance;
            Avatar_List += name;
            Avatar_List += lang;        // +1 from name
            Avatar_List += abbreviation;// +2 from name
            Avatar_List += avikey;
        }
    }
}



ClearDisplay()
{
    Avatar_List = [];
    UpdateDisplay();
}



string ConvertLanguage(string abbr)
{
    abbr = llToLower(abbr);

    abbreviation = abbr;    // stash the original, we will override it in some case

    
    string lang;
    
    if(abbr=="???") 
        lang = "?";             // unknown

    if (abbr != "zh-CN" && abbr != "zh-TW")            // V2
    {
        abbr =  llGetSubString( abbr, 0, 1);         // use 2 digits for all but chinese
    
        if(abbr=="al" || abbr=="sq")
        {
                lang = "Albanian";
        }                                              
        else if(abbr=="am")  lang = "Amharic";         // detect
        else if(abbr=="af")  lang = "Afrikaans";       // V2 detect    MSFT
        else if(abbr=="hy")  lang = "Armenian";        // detect
        else if(abbr=="ar")  lang = "Arabic";          // detect
        else if(abbr=="az")  lang = "Azerbaijania";    // detect
        else if(abbr=="eu")  lang = "Basque";          // detect
        else if(abbr=="be")  lang = "Belarusian";      // V2 detect
        else if(abbr=="bn")  lang = "Bengali";         // detect
        else if(abbr=="bh")  lang = "Bihari";          // detect
        else if(abbr=="bg")  lang = "Bulgarian";       // V2 PAIR
        else if(abbr=="my")  lang = "Burmese";         // detect
        else if(abbr=="ca")  lang = "Catalan";         // V2 PAIR
        else if(abbr=="ch")  lang = "Cherokee";        // detect
        else if(abbr=="hr")  lang = "Croatian";        // V2 PAIR
        else if(abbr=="cs")  lang = "Czech";           // V2 PAIR
        else if(abbr=="da")  lang = "Danish";          // V2 PAIR
        else if(abbr=="nl")  lang = "Dutch";           // V2 PAIR
        else if(abbr=="en")  lang = "English";         // V2 PAIR
        else if(abbr=="dv")  lang = "Dhiveli";         // detect
        else if(abbr=="eo")  lang = "Esperanto";       // detect
        else if(abbr=="et")  lang = "Estonian";        // V2 PAIR
        else if(abbr=="fo")  lang = "Faeroese";        // detect
        else if(abbr=="fa")  lang = "Persian";         // V2 detect
        else if(abbr=="tl")  
        {
            lang = "Tagalog"; 
        }                                             // V2 PAIR ODD
        else if(abbr=="fi")  lang = "Finnish";         // V2 PAIR
        else if(abbr=="fr")  lang = "French";        // V2 PAIR
        else if(abbr=="gd")  lang = "Gaelic";          // V2 detect
        else if(abbr=="gl")  lang = "Irish";           // V2 PAIR
        else if(abbr=="ka")  lang = "Georgian";        // detect
        else if(abbr=="de")  lang = "German";       // V2 PAIR
        else if(abbr=="el")  lang = "Greek";           // V2 PAIR
        else if(abbr=="gn")  lang = "Guarani";         // PAIR
        else if(abbr=="gu")  lang = "Guajarati";       // V2 detect
        else if(abbr=="iw" || abbr=="he" )
        {
            lang = "Hebrew";
        }                                              // PAIR takes IW, s/l takes iw
        else if(abbr=="hi")  lang = "Hindi";           // V2 PAIR
        else if(abbr=="hu")  lang = "Hungarian";       // V2 PAIR
        else if(abbr=="is")  lang = "Icelandic";       // V2 PAIR
        else if(abbr=="id")  lang = "Indonesian";      // V2 PAIR
        else if(abbr=="iu")  lang = "Inuktitut";       // detect
        else if(abbr=="it")  lang = "Italian";         // V2 PAIR
        else if(abbr=="ja")  lang = "Japanese";        // V2 PAIR
        else if(abbr=="kn")  lang = "Kannada";         // detect
        else if(abbr=="kk")  lang = "Kazakh";          // detect
        else if(abbr=="km")  lang = "Khmer";           // detect
        else if(abbr=="ko")  lang = "Korean";          // V2 PAIR
        else if(abbr=="ku")  lang = "Kurdish";         // detect
        else if(abbr=="ky")  lang = "Kyrgyz";          // detect
        else if(abbr=="lo")  lang = "Laotian";         // detect
        else if(abbr=="lv")  lang = "Latvian";         // V2 PAIR
        else if(abbr=="lt")  lang = "Lithuanian";      // V2 PAIR
        else if(abbr=="mk")  lang = "Macedonian";      // V2 detect
        else if(abbr=="ms")  lang = "Malay";           // V2 detect
        else if(abbr=="ml")  lang = "Malayalam";       // detect
        else if(abbr=="mt")  lang = "Maltese";         // V2 PAIR
        else if(abbr=="mr")  lang = "Marathi";         // detect
        else if(abbr=="mn")  lang = "Mongolian";       // detect
        else if(abbr=="ne")  lang = "Nepali";          // detect
        else if(abbr=="nb" || abbr == "no" )  
        {
            lang = "Norwegian"; 
        }                                              // V2 PAIR  'no' = google
        else if(abbr=="or")  lang = "Oriya";           // detect
        else if(abbr=="ps")  lang = "Pashto";          // detect
        else if(abbr=="pl")  lang = "Polish";          // V2 PAIR
        else if(abbr=="pt")  
        {
            lang = "Portugese";
        }                                              // PAIR V2  google uses pt-PT 
        else if(abbr=="pa")  lang = "Punjabi";         // detect
        else if(abbr=="ro")  lang = "Romanian";        // V2 PAIR
        else if(abbr=="rm")  lang = "Romanic";         // PAIR
        else if(abbr=="ru")  lang = "Russian";         // V2 PAIR
        else if(abbr=="sa")  lang = "Sanskrit";        // detect
        else if(abbr=="sr")  lang = "Serbian";         // V2 PAIR
        else if(abbr=="sb")  lang = "Sorbian";         // detect
        else if(abbr=="sd")  lang = "Sindhi";          // detect
        else if(abbr=="si")  lang = "SinHalese";       // detect
        else if(abbr=="sk")  lang = "Slovak";          // V2 PAIR
        else if(abbr=="sl")  lang = "Slovenian";       // V2 PAIR
        else if(abbr=="es")  lang = "Spanish";         // V2 PAIR
        else if(abbr=="sw")  lang = "Swahili";         // V2 detect
        else if(abbr=="sv")  lang = "Swedish";         // V2 detect
        else if(abbr=="sx")  lang = "Sutu";            // detect
        else if(abbr=="sz")  lang = "Sami";            // detect
        else if(abbr=="tg")  lang = "Tajik";           // detect
        else if(abbr=="ta")  lang = "Tamil";           // detect
        else if(abbr=="tl")  lang = "Tagalog";         // V2 PAIR
        else if(abbr=="ts")  lang = "Tsonga";          // detect
        else if(abbr=="te")  lang = "Telugu";          // detect
        else if(abbr=="th")  lang = "Thai";            // V2 PAIR
        else if(abbr=="tn")  lang = "Tswana";          // detect
        else if(abbr=="bo")  lang = "Tibetan";         // detect
        else if(abbr=="uk")  lang = "Ukranian";        // V2 detect
        else if(abbr=="uz")  lang = "Uzbek";           // detect
        else if(abbr=="ug")  lang = "Uighur";          // detect
        else if(abbr=="bo")  lang = "Tibetan";         // detect
        else if(abbr=="tr")  lang = "Turkish";         // V2 PAIR
        else if(abbr=="ur")  lang = "Urdu";            // detect
        else if(abbr=="ve")  lang = "Venda";           // detect
        else if(abbr=="vi")  lang = "Vietnamese";      // V2 PAIR
        else if(abbr=="ji")  lang = "Yiddish";         // V2 PAIR
        else if(abbr=="cy")  lang = "Welsh";           // V2 PAIR
        else if(abbr=="zu")  lang = "Zulu";            // PAIR
        else
        {
            lang = abbr;
        }
    }
    
    return lang;
}


// Display the scanner
UpdateDisplay()
{
    Avatar_List = llListSort(Avatar_List,STRIDE,TRUE);        // sort by range from near to far
    integer listLength = llGetListLength(Avatar_List);

    string result;
    integer i;
    integer count;



    for( i=0;i<listLength;i+=STRIDE)
    {
        integer distance     = llList2Integer(Avatar_List,i);
        string name         = llList2String(Avatar_List,i+AVATAR_NAME);
        
        string abbr         = llList2String(Avatar_List,i+AVATAR_ABBR);

        name = left(name," ");        // show first name only

        // some abbreviations need to be commonized
        string language = ConvertLanguage(abbr);
        string ToAdd = name + " [" + (string)distance + "m] [" + language + "]\n";

        if (llStringLength(ToAdd)  + llStringLength(result) < 240 )    // 254 is the max length of hover text
        {
            if ( MENU_ShowAll == "Show All" )
            {
                result += ToAdd;
                count++;
            }
            else
            {
                if (  abbr  != OwnerLang && abbr != "???" )
                {
                    result += ToAdd;
                    count++;
                }
            }
        }
    }

    if (MENU_scanning_on_off == "Scanner On")
    {
        result = (string) (count) + " Avatars\n" + result;
        llSetText(result,<1,1,1>,1.0);
    }
}


Menu()
{

    if (! listening) 
    {   
        listener = llListen(channel,"",llGetOwner(),"");
    }
    listening = TRUE;
    
    list menu = [MENU_ShowAll]  + [MENU_scanning_on_off] + [MENU_range] ;
    llDialog(llGetOwner(),"Free Memory:" + (string) llGetFreeMemory() + "\nAll Language/Other Languages\nOn/Off\nLong/Short range",menu,channel);
    llSetTimerEvent(60);
}


default
{
    state_entry()
    {
        channel = (integer) llFrand((10000) + 20000);
        MyAvatarName = llKey2Name(llGetOwner());
        Menu();
        llSensorRepeat("", "",AGENT, 20, PI,1);
    }
    
    
    touch_start(integer n)
    {
        Menu();
    }
    
    timer()
    {
        listening = FALSE;
        llListenRemove(listener);
        llSetTimerEvent(0);       
    }
    
    listen(integer sender_number, string name, key id, string message)
    {
        if (message == "Scanner Off")
        {
            llSetText("Scanning",<1,1,1>,1.0);
            {
                if (MENU_range == "Short Range")
                {
                    llSensorRepeat("", "",AGENT, 20, PI,1);
                }
                else 
                {
                    llSensorRepeat("", "",AGENT, 96, PI,1);
                }
            }
            MENU_scanning_on_off = "Scanner On";
            llOwnerSay("Scanning...");
        }
        else if (message == "Scanner On")
        {
            MENU_scanning_on_off = "Scanner Off";
            ClearDisplay();
            llSetText("Off",<1,1,1>,1.0);
            llSensorRemove();
        }     
        else if (message == "Long Range")
        {
            MENU_range = "Short Range";
            llSensorRepeat("", "",AGENT, 20, PI,1);
            llOwnerSay("Scanning 20 meters (chat range)");
        }
        else if (message == "Short Range")
        {
            MENU_range = "Long Range";
            llSensorRepeat("", "",AGENT, 96, PI,1);
            llOwnerSay("Scanning 96 meters");
        }
        else if (message == "Show Other")
        {
            MENU_ShowAll = "Show All";
            llOwnerSay("Showing all languages");
        }
        else if (message == "Show All")
        {
            MENU_ShowAll = "Show Other";
            llOwnerSay("Showing other languages");
        }

                        
        Menu();

    }


    sensor(integer num_detected)
    {
        integer i;
        string name;
        integer distance;

        //DEBUG("Detected:" + (string) num_detected);

        vector pos = llGetPos();

        list present = [];       // people that are here

        for(i=0;i<num_detected;i++)
        {
            name = llKey2Name(llDetectedKey(i));
            if (llStringLength(name) > 0)  // some ghosted avatars show up on scanner with NO NAME
            {
                if (name != MyAvatarName  ) 
                {
                    string lang=llGetAgentLanguage(llDetectedKey(i));

                    ////DEBUG( name +  "[" + lang + "]");


                    if (lang == "" )
                        lang = "???";


                    vector detPos = llDetectedPos(i);
                    distance = (integer)llVecDist(pos, detPos);


                    ////DEBUG("Sensed:" + name);
                    //SetLang(string name, string abbr,  integer distance, key avikey)

                   
                    SetLang(name,lang,distance,llDetectedKey(i), FALSE);    //
                    present += name;
               

                }
            }
            // else is me
        }

        // remove anybody out of range

        for(i=0; i < llGetListLength(Avatar_List) ;i+= STRIDE)
        {
            name = llList2String(Avatar_List,i+1);

            if( llListFindList(present, [name]) == -1 )
            {
                ////DEBUG("Removing:" + name + " index: " + (string) i); ///  ******

                Avatar_List = ListStridedRemove(Avatar_List, i/ STRIDE, i/STRIDE, STRIDE);
                i -= STRIDE; // redo over the one we just removed
            }
        }



        if (num_detected == 0)
            llSetText("0 Avatars",<1,1,1>,1.0);

        UpdateDisplay();
        llSleep(1.0);
        llSensorRepeat("", "",AGENT, 96, PI,1);

    }
    
    on_rez(integer start_param)
    {

        llResetScript();
    }
    

    no_sensor()
    {
        
        //DEBUG("0");
        ClearDisplay();
        llSetText("0 Avatars",<1,1,1>,1.0);
    }


    
}
