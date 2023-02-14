default {
    link_message(integer sender, integer num, string msg, key id) {
        if (num == -1 && msg == "gameOver") llSetTexture("d039e927-7457-4560-b908-7d9d02f8dec1", 3);
        if (num == -1 && msg == "setPicture") llSetTexture((string)id, 3);
    }
}