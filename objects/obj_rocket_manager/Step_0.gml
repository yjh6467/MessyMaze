if (scr_pause_step_guard()) {
    exit;
}

if (!instance_exists(obj_game_manager)) exit;
if (!instance_exists(obj_player)) exit;

spawn_timer -= 1;
if (spawn_timer > 0) exit;

spawn_timer = variable_global_exists("rocket_spawn_interval") ? global.rocket_spawn_interval : 240;

var _tile = variable_global_exists("tile_size") ? global.tile_size : tile_size;
var _horizontal = irandom(1) == 0;
var _warning;

if (_horizontal) {
    var _row_y = min(max(floor((obj_player.y + _tile * 0.5) / _tile) * _tile, 0), room_height - _tile);
    var _from_left = irandom(1) == 0;
    var _start_x = _from_left ? -_tile : room_width;

    _warning = instance_create_layer(_start_x, _row_y, "Instances", obj_rocket_warning);
    _warning.dir_x = _from_left ? 1 : -1;
    _warning.dir_y = 0;
} else {
    var _col_x = min(max(floor((obj_player.x + _tile * 0.5) / _tile) * _tile, 0), room_width - _tile);
    var _from_top = irandom(1) == 0;
    var _start_y = _from_top ? -_tile : room_height;

    _warning = instance_create_layer(_col_x, _start_y, "Instances", obj_rocket_warning);
    _warning.dir_x = 0;
    _warning.dir_y = _from_top ? 1 : -1;
}
