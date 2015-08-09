// :CATEGORY:Prim
// :NAME:Linked_Prim_Animator
// :AUTHOR:Falados Kapuskas 
// :CREATED:2012-09-18 15:31:14.597
// :EDITED:2013-09-18 15:38:56
// :ID:474
// :NUM:636
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// LPA Protocol
// :CODE:
//         ID             STRING                  NUM                                          Description
//     loader    SCRIPT_NAME                    LINK_NUM      Tells SCRIPT_NAME (which is a recording modules) to load itself into LINK_NUM
//     root
//               ACK                                          Respond to children (They send SYN)
//               end                                          Tell child scripts to discard unused scripts
//               playback                      MAX_FRAMES     Tell the LPA Player script to enter the playback state
//               cap                             FRAME        Tells the children to capture their current state and save it in FRAME
//               ff                              FRAME        Tells the children to go forward to the FRAME
//               rwd                             FRAME        Tells the children to go backwards to the FRAME
//               reset                           FRAME        Tell sthe children to reset their state to FRAME
//               setup                                        Start the setup in child module
//     link
//               <CSV of all scripts>              1          Tell the LPA Editor what scripts this object has
//               SYN                               0          Try to syncronize with the LPA Editor script
//                                             MODULENUM      Announces the number of record modules currently in the linked prim (send_num used as ID)
//     wizard
//               lpa_back                                     Tell LPA Player to play animations backward (Reverse)
//               lpa_brang off                                Tell LPA Player to play looped animations normally (Loops wrap around)
//               lpa_brang on                                 Tell LPA Player to play animations in Boomerange mode (Back and Forth)
//               lpa_capture                     FRAME        Tell LPA Editor to capture the current state in FRAME
//               lpa_done                                     Tell LPA Editor to end the capture stage and clean up
//               lpa_ff                                       Tell LPA Editor to set all prims forward one frame
//               lpa_fwd                                      Tell LPA Player to play animations forward (Normal)

//               lpa_loop off                                 Tell LPA Player to stop animations after they finish (No Loop)
//               lpa_loop on                                  Tell LPA Player to loop animations
//               lpa_rwd                                      Tell LPA Editor to set all prims back one frame
//               lpa_sdn                                      Tell LPA Player to remove .1 seconds from the wait time between frames (Faster)
//               lpa_start                                    Tell LPA Player to start the animation with the current parameters
//               lpa_stop                                     Tell LPA Player to stop the current animation
//               lpa_sup                                      Tell LPA Player to add .1 seconds to the wait time between frames (Slower)
//               setup                                        Tell LPA Editor to go into setup mode
//     player
//               brang                         BOOMERANG      Announcement of the BOOMERANG status (TRUE or FALSE)
//               direction                     DIRECTION      Announcement of the playback direction (1 = Forward, -1 = Backward)
//               frame                           FRAME        Tell all children to set their state to FRAME
//               loop                             LOOP        Announcement of the LOOP status (TRUE or FALSE)
//               play                            SPEED        Announcement of the playback SPEED (in tenths of a second)
