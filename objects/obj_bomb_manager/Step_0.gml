if (!instance_exists(obj_game_manager)) exit;

spawn_timer -= 1;
if (spawn_timer > 0) exit;

spawn_timer = global.bomb_spawn_interval;
if (instance_number(obj_bomb) >= global.max_bomb_count) exit;
if (!instance_exists(obj_player)) exit;

var _tile = global.tile_size;
var _cols = room_width div _tile;
var _rows = room_height div _tile;
var _radius = global.bomb_radius;
var _px = obj_player.x + 16;
var _py = obj_player.y + 16;

repeat (spawn_attempts) {
    var _angle = random(360);
    var _distance = random_range(spawn_distance_min, _radius);
    var _x = round((_px + lengthdir_x(_distance, _angle) - 16) / _tile) * _tile;
    var _y = round((_py + lengthdir_y(_distance, _angle) - 16) / _tile) * _tile;
    var _cx = _x + _tile * 0.5;
    var _cy = _y + _tile * 0.5;

    if (_x < 0 || _y < 0 || _x >= _cols * _tile || _y >= _rows * _tile) continue;
    if (collision_rectangle(_x, _y, _x + _tile - 1, _y + _tile - 1, obj_wall_parent, false, true) != noone) continue;
    if (point_distance(_cx, _cy, _px, _py) > _radius) continue;

    var _nearest_bomb = instance_nearest(_cx, _cy, obj_bomb);
    if (_nearest_bomb != noone && point_distance(_cx, _cy, _nearest_bomb.x + 16, _nearest_bomb.y + 16) < min_bomb_distance) continue;

    instance_create_layer(_x, _y, "Instances", obj_bomb);
    break;
}
