if (!instance_exists(obj_game_manager)) exit;

spawn_timer -= 1;
if (spawn_timer > 0) exit;

spawn_timer = global.bomb_spawn_interval;
if (instance_number(obj_bomb) >= global.max_bomb_count) exit;

var _tile = global.tile_size;
var _cols = room_width div _tile;
var _rows = room_height div _tile;

repeat (spawn_attempts) {
    var _x = irandom(_cols - 1) * _tile;
    var _y = irandom(_rows - 1) * _tile;
    var _cx = _x + _tile * 0.5;
    var _cy = _y + _tile * 0.5;

    if (collision_rectangle(_x, _y, _x + _tile - 1, _y + _tile - 1, obj_wall_parent, false, true) != noone) continue;
    if (instance_exists(obj_player) && point_distance(_cx, _cy, obj_player.x + 16, obj_player.y + 16) < min_player_distance) continue;

    var _nearest_bomb = instance_nearest(_cx, _cy, obj_bomb);
    if (_nearest_bomb != noone && point_distance(_cx, _cy, _nearest_bomb.x + 16, _nearest_bomb.y + 16) < min_bomb_distance) continue;

    instance_create_layer(_x, _y, "Instances", obj_bomb);
    break;
}
