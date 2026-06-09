if (scr_pause_step_guard()) {
    exit;
}

if (!instance_exists(obj_game_manager)) exit;
if (!instance_exists(obj_player)) exit;
var _player = instance_find(obj_player, 0);

spawn_timer -= 1;
if (spawn_timer > 0) exit;

spawn_timer = variable_global_exists("rocket_spawn_interval") ? global.rocket_spawn_interval : 240;

var _tile = variable_global_exists("tile_size") ? global.tile_size : tile_size;
var _play_top = variable_global_exists("hud_height") ? global.hud_height : 96;
var _player_cx = scr_instance_center_x(_player);
var _player_cy = scr_instance_center_y(_player);
var _min_row_y = min(_play_top + _tile, room_height - _tile);
var _max_row_y = max(_min_row_y, room_height - _tile * 2);
var _min_col_x = min(_tile, room_width - _tile);
var _max_col_x = max(_min_col_x, room_width - _tile * 2);
var _horizontal = irandom(1) == 0;
var _warning;

if (_horizontal) {
    var _cell_x = clamp(floor(_player_cx / _tile) * _tile, _min_col_x, _max_col_x);
    var _base_y = clamp(floor(_player_cy / _tile) * _tile, _min_row_y, _max_row_y);
    var _row_y = _base_y;

    for (var _offset = 0; _offset <= room_height; _offset += _tile) {
        var _down_y = _base_y + _offset;
        if (_down_y <= _max_row_y && collision_rectangle(_cell_x, _down_y, _cell_x + _tile - 1, _down_y + _tile - 1, obj_wall_parent, false, true) == noone) {
            _row_y = _down_y;
            break;
        }

        var _up_y = _base_y - _offset;
        if (_offset > 0 && _up_y >= _min_row_y && collision_rectangle(_cell_x, _up_y, _cell_x + _tile - 1, _up_y + _tile - 1, obj_wall_parent, false, true) == noone) {
            _row_y = _up_y;
            break;
        }
    }

    var _from_left = irandom(1) == 0;
    var _start_x = _from_left ? -_tile : room_width;

    _warning = instance_create_layer(_start_x, _row_y, "Instances", obj_rocket_warning);
    _warning.dir_x = _from_left ? 1 : -1;
    _warning.dir_y = 0;
} else {
    var _cell_y = clamp(floor(_player_cy / _tile) * _tile, _min_row_y, _max_row_y);
    var _base_x = clamp(floor(_player_cx / _tile) * _tile, _min_col_x, _max_col_x);
    var _col_x = _base_x;

    for (var _offset = 0; _offset <= room_width; _offset += _tile) {
        var _right_x = _base_x + _offset;
        if (_right_x <= _max_col_x && collision_rectangle(_right_x, _cell_y, _right_x + _tile - 1, _cell_y + _tile - 1, obj_wall_parent, false, true) == noone) {
            _col_x = _right_x;
            break;
        }

        var _left_x = _base_x - _offset;
        if (_offset > 0 && _left_x >= _min_col_x && collision_rectangle(_left_x, _cell_y, _left_x + _tile - 1, _cell_y + _tile - 1, obj_wall_parent, false, true) == noone) {
            _col_x = _left_x;
            break;
        }
    }

    var _from_top = irandom(1) == 0;
    var _start_y = _from_top ? -_tile : room_height;

    _warning = instance_create_layer(_col_x, _start_y, "Instances", obj_rocket_warning);
    _warning.dir_x = 0;
    _warning.dir_y = _from_top ? 1 : -1;
}
