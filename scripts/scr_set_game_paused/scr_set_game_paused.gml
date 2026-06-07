function scr_set_game_paused(_paused) {
    if (!variable_global_exists("game_paused")) global.game_paused = false;
    if (!variable_global_exists("gameplay_frozen")) global.gameplay_frozen = false;

    var _result_active =
        (variable_global_exists("game_cleared") && global.game_cleared)
        || (variable_global_exists("game_over") && global.game_over);

    var _next_paused = _paused && !_result_active;
    var _next_frozen = _next_paused || _result_active;

    if (global.game_paused == _next_paused && global.gameplay_frozen == _next_frozen) return;

    global.game_paused = _next_paused;
    global.gameplay_frozen = _next_frozen;

    var _pause_objects = [
        obj_player,
        obj_monster1,
        obj_monster2,
        obj_monster3,
        obj_monster4,
        obj_bomb,
        obj_rocket,
        obj_rocket_warning,
        obj_giant_vacuum,
        obj_giant_monster,
        obj_afterimage,
        obj_score_slime_piece,
        obj_rotating_wall_horizontal,
        obj_rotating_wall_vertical,
        obj_rotating_wall_north,
        obj_rotating_wall_east,
        obj_rotating_wall_open_south,
        obj_rotating_wall_open_west,
        obj_rotating_wall_center
    ];

    for (var _i = 0; _i < array_length(_pause_objects); _i += 1) {
        with (_pause_objects[_i]) {
            if (!variable_instance_exists(id, "pause_image_speed_stored")) {
                pause_image_speed_stored = false;
                pause_image_speed_restore = image_speed;
            }

            if (global.gameplay_frozen) {
                if (!pause_image_speed_stored) {
                    pause_image_speed_restore = image_speed;
                    pause_image_speed_stored = true;
                }

                image_speed = 0;
            } else if (pause_image_speed_stored) {
                image_speed = pause_image_speed_restore;
                pause_image_speed_stored = false;
            }
        }
    }

    if (global.gameplay_frozen) {
        audio_pause_all();
    } else {
        audio_resume_all();
    }
}
