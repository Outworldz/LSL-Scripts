// :CATEGORY:Music
// :NAME:Caramell_Dansen_Song
// :AUTHOR:MachineCode
// :CREATED:2011-06-13 11:53:46.777
// :EDITED:2013-09-18 15:38:50
// :ID:158
// :NUM:226
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Caramell_Dansen_Song
// :CODE:
list music = [
"77a160fa-f8ef-3f1f-eb4a-8a6e422552e1",
"eed92d3e-404e-99b0-62b6-8a53fe66a661",
"36e2c7c4-b72d-34ff-a176-a018e383dc2f",
"5aaf5344-ee5e-b439-a533-ccfd38e96ca7",
"a45f162e-229e-4c4b-5230-40f3b1331075",
"e832ea7f-ba18-6318-f65b-b2aa905de565",
"061d2028-3878-ea5e-3de8-e0898f753e63",
"4390c4d0-843e-a9b1-8b3d-27389021d198",
"76eacfce-094f-2089-7ee1-35ea84cf47b4",
"45b2649f-1d2c-5455-ba9d-7ac9e7b1672c",
"72226579-eb24-3cbb-3ca8-4317ed4a57d0",
"054009aa-6034-9e34-39cb-60f4e8e171e3",
"9f38b9ec-fd0b-e51b-69e9-cb2f00e12027",
"c930c9d7-9539-86e7-65dd-aeb2789aecc2",
"9ec9c129-15f7-ec92-1b28-eaf772e372b5",
"53df30f4-33a5-3ae6-9888-d1f560cd9875",
"fa63c473-cb93-43cf-e4ce-fcb3d704b37b",
"1344cf7f-7d4d-f975-f47f-ea2ac6d1c956"];
default
{
    touch_start(integer zomg)
    {
        llSay(0, "Playing...");
        integer lolinteger =0;
        while(TRUE)
        {
            if(llList2String(music, lolinteger) != "")
            {
                llPlaySound(llList2String(music, lolinteger),1);
                llSleep(10);
                ++lolinteger;
            }
            if(llList2String(music, lolinteger) == "")
            {
                llResetScript();
            }
        }
    }
}
