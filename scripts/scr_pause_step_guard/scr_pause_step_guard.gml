function scr_pause_step_guard() {
    if (!variable_global_exists("game_paused")) global.game_paused = false;
    if (!variable_global_exists("gameplay_frozen")) global.gameplay_frozen = false;

    var _result_active =
        (variable_global_exists("game_cleared") && global.game_cleared)
        || (variable_global_exists("game_over") && global.game_over);
    var _frozen = global.game_paused || global.gameplay_frozen || _result_active;

    if (!variable_instance_exists(id, "pause_image_speed_stored")) {
        pause_image_speed_stored = false;
        pause_image_speed_restore = image_speed;
    }

    if (_frozen) {
        if (!pause_image_speed_stored) {
            pause_image_speed_restore = image_speed;
            pause_image_speed_stored = true;
        }

        image_speed = 0;
        return true;
    }

    if (pause_image_speed_stored) {
        image_speed = pause_image_speed_restore;
        pause_image_speed_stored = false;
    }

    return false;
}
