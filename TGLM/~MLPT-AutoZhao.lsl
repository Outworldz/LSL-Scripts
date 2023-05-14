// MLPV2.2 Add-On example.
// Use a script like this to support xcite, chains, etc.
// This one supports AutoZhao, whic h is a ZHAO variant that turns off
// automatically when you sit.

// LM parameters:
//
//  num = 0 and msg = "POSEB": new pose
//    id = is pose name
//
//  num = -11000: avatar sits
//    msg = ball number (0,1,...), as a string
//    id = avatar who
//
//  num = -11001: avatar unsits
//    msg = ball number (0,1,...), as a string
//    id = avatar who 

integer AutoZhaoChan    = -4200;

string  Pose;
string  Avname;
key     Avkey;

default
{
    link_message(integer from, integer num, string msg, key id) {
        if (msg == "POSEB") {
            Pose = (string)msg;
            return;
        }

        if (num == -11000) {
            // av hopped on, so turn ZHAO off
            llWhisper(AutoZhaoChan, "ZHAO_AOOFF");
            Avkey = id;
            Avname = llKey2Name(id);
        } else if (num == -11001) {
            // av hopped off, so turn ZHAO on
            llWhisper(AutoZhaoChan, "ZHAO_AOON");
            Avkey = NULL_KEY;
            Avname = "";
        } else {
            return;
        }
    }
}
