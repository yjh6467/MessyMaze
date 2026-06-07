if (scr_pause_step_guard()) {
    exit;
}

if (!instance_exists(obj_game_manager)) exit;

spawn_timer -= 1;
if (spawn_timer > 0) exit;

spawn_timer = global.bomb_spawn_interval;
if (instance_number(obj_bomb) >= global.max_bomb_count) exit;
if (!instance_exists(obj_player)) exit;

var _tile = global.tile_size;
var _cols = room_width div _tile;
var _rows = room_height div _tile;
var _radius = variable_global_exists("bomb_spawn_radius") ? global.bomb_spawn_radius : spawn_radius;
var _explosion_radius = variable_global_exists("bomb_radius") ? global.bomb_radius : 128;
var _range_tiles = max(1, round(_explosion_radius / _tile));
var _range_tiles_sq = _range_tiles * _range_tiles;
var _play_top = variable_global_exists("hud_height") ? global.hud_height : 96;
var _px = obj_player.x + 16;
var _py = obj_player.y + 16;
var _spawned = false;

repeat (spawn_attempts) {
    var _off_x = random_range(-_radius, _radius);
    var _off_y = random_range(-_radius, _radius);
    if (abs(_off_x) < spawn_distance_min && abs(_off_y) < spawn_distance_min) continue;

    var _x = round((_px + _off_x - 16) / _tile) * _tile;
    var _y = round((_py + _off_y - 16) / _tile) * _tile;
    var _cx = _x + _tile * 0.5;
    var _cy = _y + _tile * 0.5;

    if (_x < 0 || _y < _play_top || _x >= _cols * _tile || _y >= _rows * _tile) continue;
    if (collision_rectangle(_x, _y, _x + _tile - 1, _y + _tile - 1, obj_wall_parent, false, true) != noone) continue;

    var _player_tile_dx = round((_px - _cx) / _tile);
    var _player_tile_dy = round((_py - _cy) / _tile);
    if (_player_tile_dx * _player_tile_dx + _player_tile_dy * _player_tile_dy > _range_tiles_sq) continue;

    var _nearest_bomb = instance_nearest(_cx, _cy, obj_bomb);
    if (_nearest_bomb != noone && point_distance(_cx, _cy, _nearest_bomb.x + 16, _nearest_bomb.y + 16) < min_bomb_distance) continue;

    instance_create_layer(_x, _y, "Instances", obj_bomb);
    _spawned = true;
    break;
}

if (!_spawned) {
    for (var _tx = -_range_tiles; _tx <= _range_tiles; _tx += 1) {
        for (var _ty = -_range_tiles; _ty <= _range_tiles; _ty += 1) {
            if (_tx == 0 && _ty == 0) continue;
            if (_tx * _tx + _ty * _ty > _range_tiles_sq) continue;

            var _fallback_x = round((_px - 16 + _tx * _tile) / _tile) * _tile;
            var _fallback_y = round((_py - 16 + _ty * _tile) / _tile) * _tile;
            var _fallback_cx = _fallback_x + _tile * 0.5;
            var _fallback_cy = _fallback_y + _tile * 0.5;

            if (_fallback_x < 0 || _fallback_y < _play_top || _fallback_x >= _cols * _tile || _fallback_y >= _rows * _tile) continue;
            if (point_distance(_px, _py, _fallback_cx, _fallback_cy) < spawn_distance_min) continue;
            if (collision_rectangle(_fallback_x, _fallback_y, _fallback_x + _tile - 1, _fallback_y + _tile - 1, obj_wall_parent, false, true) != noone) continue;

            var _fallback_nearest_bomb = instance_nearest(_fallback_cx, _fallback_cy, obj_bomb);
            if (_fallback_nearest_bomb != noone && point_distance(_fallback_cx, _fallback_cy, _fallback_nearest_bomb.x + 16, _fallback_nearest_bomb.y + 16) < min_bomb_distance) continue;

            instance_create_layer(_fallback_x, _fallback_y, "Instances", obj_bomb);
            _spawned = true;
            break;
        }

        if (_spawned) break;
    }
}
