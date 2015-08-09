// :CATEGORY:Attachment
// :NAME:Attach_to_Avatar
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:48
// :ID:56
// :NUM:83
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Attach to Avatar.lsl
// :CODE:


default

{

    attach(key attached)

    {

        if (attached != NULL_KEY)   // object has been //attached//

        {

            llWhisper( 0, "I'm stuck on you, " + llKey2Name(attached) );

            // etc.

        }

        else  // object has been detached

        {

            llWhisper( 0, "Why hast thou forsaken me?" );

            // etc.

        }

    }

}// END //
