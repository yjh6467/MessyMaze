if (!variable_global_exists("exit_open")) global.exit_open = false;
if (!variable_global_exists("game_cleared")) global.game_cleared = false;
if (!variable_global_exists("game_over")) global.game_over = false;
if (!variable_global_exists("game_paused")) global.game_paused = false;

visible = global.exit_open;

if (global.game_paused) {
    exit;
}

if (!global.exit_open || global.game_cleared || global.game_over) {
    exit;
}

if (instance_exists(obj_player)) {
    var _player = instance_nearest(x, y, obj_player);
    var _player_x = (_player.bbox_left + _player.bbox_right) * 0.5;
    var _player_y = (_player.bbox_top + _player.bbox_bottom) * 0.5;
    var _near_exit = point_distance(x, y, _player_x, _player_y) <= clear_radius;
    var _inside_exit_area = (
        _player.bbox_right >= x - clear_radius
        && _player.bbox_left <= x + clear_radius
        && _player.bbox_bottom >= y - clear_radius
        && _player.bbox_top <= y + clear_radius
    );

    if (_near_exit || _inside_exit_area) {
        global.game_cleared = true;
        show_debug_message("GAME CLEAR");
    }
}
