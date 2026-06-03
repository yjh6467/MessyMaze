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
        if (state_timer <= 0) {
            bomb_state = BOMB_EXPLODE;
            state_timer = explode_time;
            explode_frame = 0;
            image_index = 0;
            image_speed = 0;

            for (var _tx = -bomb_range_tiles; _tx <= bomb_range_tiles; _tx += 1) {
                for (var _ty = -bomb_range_tiles; _ty <= bomb_range_tiles; _ty += 1) {
                    var _cell_cx = _cx + _tx * _tile;
                    var _cell_cy = _cy + _ty * _tile;

                    if (_tx * _tx + _ty * _ty > bomb_range_tiles_sq) continue;

                    var _hit = collision_rectangle(_cell_cx - _tile * 0.5, _cell_cy - _tile * 0.5, _cell_cx + _tile * 0.5, _cell_cy + _tile * 0.5, obj_player, false, true);
                    if (_hit != noone) {
                        scr_player_hit("bomb");
                        _tx = bomb_range_tiles + 1;
                        break;
                    }
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
