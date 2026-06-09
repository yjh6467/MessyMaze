if (scr_pause_step_guard()) {
    exit;
}

var _cx = x + 16;
var _cy = y + 16;
var _tile = variable_global_exists("tile_size") ? global.tile_size : 32;

switch (bomb_state) {
    case BOMB_IDLE:
        bomb_state = BOMB_WARNING;
        state_timer = warning_time;
        break;

    case BOMB_WARNING:
        state_timer -= 1;
        var _warning_progress = clamp(1 - state_timer / max(1, warning_time), 0, 0.9999);
        var _warning_index = clamp(floor(_warning_progress * array_length(bomb_warning_sprites)), 0, array_length(bomb_warning_sprites) - 1);
        sprite_index = bomb_warning_sprites[_warning_index];
        image_index = 0;
        image_speed = 0;

        if (state_timer <= 0) {
            bomb_state = BOMB_EXPLODE;
            sprite_index = spr_boom;
            state_timer = explode_time;
            explode_frame = 0;
            image_index = 0;
            image_speed = 0;

            for (var _i = 0; _i < array_length(bomb_range_offsets_x); _i += 1) {
                var _cell_cx = _cx + bomb_range_offsets_x[_i] * _tile;
                var _cell_cy = _cy + bomb_range_offsets_y[_i] * _tile;
                var _hit = collision_rectangle(_cell_cx - _tile * 0.5, _cell_cy - _tile * 0.5, _cell_cx + _tile * 0.5, _cell_cy + _tile * 0.5, obj_player, false, true);
                if (_hit != noone) {
                    scr_player_hit("bomb");
                    break;
                }
            }
        }
        break;

    case BOMB_EXPLODE:
        explode_frame = min(explode_frame + explode_frame_speed, sprite_get_number(sprite_index) - 1);
        image_index = explode_frame;
        state_timer -= 1;
        if (state_timer <= 0) {
            bomb_state = BOMB_DESTROY;
        }
        break;

    case BOMB_DESTROY:
        instance_destroy();
        break;
}
