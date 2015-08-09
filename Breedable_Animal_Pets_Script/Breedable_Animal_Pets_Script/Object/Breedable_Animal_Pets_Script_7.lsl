// :CATEGORY:Animal
// :NAME:Breedable_Animal_Pets_Script
// :AUTHOR:Xundra Snowpaw
// :CREATED:2011-07-25 13:48:33.917
// :EDITED:2013-09-18 15:38:49
// :ID:115
// :NUM:162
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Animal: xs_movement.lsl
// :CODE:
float GROWTH_AMOUNT = 0.10;

vector home_location;
float roam_distance;
list food_bowls;
list food_bowl_keys;
list food_bowl_time;

vector destination;

integer sex_dest = 0;
integer food_dest = 0;
float tolerance = 0.15;
float increment = 0.1;
integer rest;
integer age;
float zoffset;
integer sleep_last_check ;
integer sound;
integer sleep_disabled;

face_target(vector lookat) {
    vector  fwd = llVecNorm(lookat-llGetPos());     //I assume you know the last and current position
    vector lft = llVecNorm(<0,0,1>%fwd);     //cross with <0,0,1> is parallel to ground
    rotation rot = llAxes2Rot(fwd,lft,fwd%lft);
    llSetRot(rot);
}

integer sleeping()
{
    vector sun = llGetSunDirection();
    if (!sleep_disabled) {
        if (sun.z < 0) {
            if (sleep_last_check == 0) {
                // close eyes
                llMessageLinked(LINK_SET, 990, "", "");
            }
            sleep_last_check = 1;
        } else {
                if (sleep_last_check == 1) {
                    // open eyes
                    llMessageLinked(LINK_SET, 991, "", "");
                }
            sleep_last_check = 0;
        }
        return sleep_last_check;
    } else {
            if (sleep_last_check == 1) {
                llMessageLinked(LINK_SET, 991, "", "");
                sleep_last_check = 0;
            }
        return 0;
    }
}

default
{
    link_message(integer sender, integer num, string str, key id)
    {
        if (num == 800) {
            state running;
        }
    }
}

state running
{
    state_entry()
    {
        home_location = <0,0,0>;
        roam_distance = 0;
        destination = <0,0,0>;
        age = 0;
        sleep_last_check = 0;
        sound = 1;
    }


    timer()
    {
        if (!sleeping()) {
            if (sound) {
                llMessageLinked(LINK_SET, 1001, "", "");
            }
            sound = !sound;

            vector my_pos = llGetPos();

            if (llVecDist(<destination.x, destination.y, 0>, <my_pos.x, my_pos.y, 0>) <= tolerance || destination == <0,0,0>) {
                // if at food_destination send 900 msg
                if (food_dest > 0) {
                    llMessageLinked(LINK_SET, 900, (string)food_dest, llList2Key(food_bowl_keys, 0));
                }

                if (sex_dest > 0) {
                    llMessageLinked(LINK_SET, 967, "", "");
                }

                // pick a new destination
                sex_dest = 0;
                food_dest = 0;
                destination.x = (llFrand(roam_distance * 2) - roam_distance) + home_location.x;
                destination.y = (llFrand(roam_distance * 2) - roam_distance) + home_location.y;

                destination.z = home_location.z + zoffset;

                //llOwnerSay("Moving to " + (string)destination + " but first, a rest!");
                rest = (integer)llFrand(60.0);
                // face it
                face_target(destination);
            }
            if (rest == 0) {
                // move towards destination
                vector position = llGetPos();
                float dis_x = llFabs(destination.x - position.x);
                float dis_y = llFabs(destination.y - position.y);

                float angle = llAtan2(dis_y, dis_x);

                float inc_x = llCos(angle) * increment;
                float inc_y = llSin(angle) * increment;

                if (inc_x > increment) {
                    llOwnerSay("BUG: X" + (string)inc_x + " > " + (string)increment);
                }
                if (inc_y > increment) {
                    llOwnerSay("BUG: Y" + (string)inc_y + " > " + (string)increment);
                }

                if (destination.x > position.x) {
                    position.x += inc_x;
                } else {
                        position.x -= inc_x;
                }

                if (destination.y > position.y) {
                    position.y += inc_y;
                } else {
                        position.y -= inc_y;
                }

                position.z = home_location.z + zoffset;

                llSetPos(position);
            } else {
                    rest--;
            }
        }
    }

    link_message(integer sender, integer num, string str, key id)
    {
        if (num == 903) {
            if (sex_dest == 0) {
                // move to food bowl, then send 900
                if (llGetListLength(food_bowl_keys) > 0) {
                    if (roam_distance == 0 || home_location == <0,0,0>) {
                        llOwnerSay("I'm hungry, but I'm not homed so I can not move! Attempting to use Jedi Mind Powers to teleport food to my belly.");
                        llMessageLinked(LINK_SET, 900, str, llList2Key(food_bowl_keys, 0));
                    } else {
                            // find nearest food bowl
                            integer i;
                        destination = (vector)llList2String(food_bowls, 0);
                        for (i=1;i<llGetListLength(food_bowls);i++) {
                            if (llVecDist(destination, llGetPos()) > llVecDist((vector)llList2String(food_bowls, i), llGetPos())) {
                                destination = (vector)llList2String(food_bowls, i);
                            }
                        }
                        destination.z = home_location.z + zoffset;
                        // set destination,
                        // face it
                        face_target(destination);
                        food_dest = (integer)str;
                        rest = 0;
                        //llMessageLinked(LINK_SET, 900, str, llList2Key(food_bowl_keys, 0));
                    }
                } else {
                        llOwnerSay("I'm hungry, but I can't seem to find any food bowls at present.");
                }
            }
        } else
        if (num == 910) {
            list values = llParseString2List(str, ["^"], []);
            home_location = (vector)llList2String(values, 0);
            roam_distance = llList2Float(values, 1);
            vector current_loc = llGetPos();

            food_bowls = [];
            food_bowl_keys = [];
            food_bowl_time = [];

            destination = <0,0,0>;
            food_dest = 0;

            llSetPos(<current_loc.x, current_loc.y, home_location.z + zoffset>);
            llSetTimerEvent(5.0);
        } else
        if (num == 911) {
            if (rest < (integer)str) {
                rest = (integer)str;
            }
        } else
        if (num == 920) {
            food_bowls = [];
            food_bowl_keys = [];
            food_bowl_time = [];
        } else
        if (num == 921) {
            vector food_loc = (vector)str;

            if (llVecDist(home_location, food_loc) <= roam_distance && llFabs(llFabs(home_location.z) - llFabs(food_loc.z)) < 2) {
                if(llListFindList(food_bowls, (list)str) == -1) {
                    integer id_pos = llListFindList(food_bowl_keys, (list)id);
                    if (id_pos == -1) {
                        food_bowls += str;
                        food_bowl_keys += id;
                        food_bowl_time += llGetUnixTime();
                    } else {
                            food_bowls = llListReplaceList(food_bowls, [str], id_pos, id_pos);
                        food_bowl_time  = llListReplaceList(food_bowl_time, [llGetUnixTime()], id_pos, id_pos);
                    }
                }

                integer iter;

                iter = 0;

                while(iter<llGetListLength(food_bowls)) {
                    if (llGetUnixTime() - llList2Integer(food_bowl_time, iter) > 3600) {//3600
                        food_bowls = llDeleteSubList(food_bowls, iter, iter);
                        food_bowl_keys = llDeleteSubList(food_bowl_keys, iter, iter);
                        food_bowl_time = llDeleteSubList(food_bowl_time, iter, iter);
                    } else {
                            iter++;
                    }
                }

                if (llGetListLength(food_bowls) > 0) {
                    llMessageLinked(LINK_SET, 8000, "", "");
                }

            }
        } else
        if (num == 966) {
            destination = (vector)str;
            face_target(destination);
            rest = 0;
            food_dest = 0;
            sex_dest = 1;
        } else
        if (num == 940) {
            integer heightm;
            age += (integer)str;
            heightm = age;

            if (heightm > 7)
                heightm = 7;
            float new_scale = (GROWTH_AMOUNT * heightm) + 1.0;

            float legsz = 0.064 * new_scale;
            float legso = 0.052399 * new_scale;

            zoffset = legsz / 2 + legso;
        } else
        if (num == 7999) {
            sleep_disabled = (integer)str;
        }
    }
}
