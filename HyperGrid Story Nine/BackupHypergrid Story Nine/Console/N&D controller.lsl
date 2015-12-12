integer busy ;
integer Helmet_Channel = 576;
key NamakasKey;
float MaxBeam = 2.0;    // how far the helmet beam happens
vector currPos();        // Namakas current position;
vector centerPoint = <128,128,32>; // the center of where Namaka can walk
list avatarPos = [<0,1,1>,<2,2,2>,<3,3,3> ];  // all 6 avatars are here

default
{
    state_entry()
    {

    }


    link_message(integer sender_number, integer number, string message, key id)
    {
        // -1 is Namakas key
        // 0 is for NPC direction commands
        // 1 is for doorway
        // 2 is the helment beam channel
        
        if (number == -1){
            NamakasKey = id;

        } else if (number == 0){
                if (! busy) {
                    llMessageLinked(LINK_SET,1,message);
                }
        } else if (number == 1) {
                vector direction =  (vector) message;



        } else if (number == 2){
                // GO
                llShout(Helmet_Channel,"BOOM");

            integer i;
            integer j = llGetListLength(avatarPos);
            for (i = 0; i < j; i++)
            {
                float dist = llVecDist(llList2Vector(avatarPos,i),centerPoint);
                if (dist > MaxBeam) {
                    ChangeNPC();
                    ToDo --;
                    if (ToDo == 0) {
                        Win();
                    }
                }
            }
        }
    }
}