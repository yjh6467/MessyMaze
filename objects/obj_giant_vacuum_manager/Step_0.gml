switch (vacuum_state) {
    case VACUUM_WAIT:
        event_timer -= 1;
        if (event_timer <= 0) {
            vacuum_state = VACUUM_WARNING;
            warning_count = warning_count_max;
            warning_timer = 0;
        }
        break;

    case VACUUM_WARNING:
        warning_timer -= 1;
        if (warning_timer <= 0) {
            if (warning_count > 0) {
                var _warning_sound = audio_play_sound(sfx_vacuum_warning, 10, false);
                audio_sound_gain(_warning_sound, variable_global_exists("sfx_volume") ? global.sfx_volume : 0.7, 0);
                warning_count -= 1;
                warning_timer = warning_interval;
            } else {
                var _vacuum_w = sprite_get_width(spr_giant_vacuum);
                var _vacuum_h = sprite_get_height(spr_giant_vacuum);
                var _spawn_extra_y = variable_global_exists("giant_vacuum_spawn_extra_y") ? global.giant_vacuum_spawn_extra_y : 300;
                var _spawn_x = room_width * 0.5 - _vacuum_w * 0.5;
                var _spawn_y = -_vacuum_h - _spawn_extra_y;
                instance_create_layer(_spawn_x, _spawn_y, "Instances", obj_giant_vacuum);

                vacuum_state = VACUUM_WAIT;
                event_timer = max(1, vacuum_interval - warning_total_time);
            }
        }
        break;
}
