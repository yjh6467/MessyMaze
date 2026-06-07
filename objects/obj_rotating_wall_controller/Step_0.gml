if (
    (variable_global_exists("game_paused") && global.game_paused)
    || (variable_global_exists("gameplay_frozen") && global.gameplay_frozen)
    || (variable_global_exists("game_cleared") && global.game_cleared)
    || (variable_global_exists("game_over") && global.game_over)
) {
    exit;
}

if (!enabled) exit;

var _rotating_wall_objects = [
    obj_rotating_wall_horizontal,
    obj_rotating_wall_vertical,
    obj_rotating_wall_north,
    obj_rotating_wall_east,
    obj_rotating_wall_open_south,
    obj_rotating_wall_open_west
];

for (var _i = 0; _i < array_length(_rotating_wall_objects); _i += 1) {
    with (_rotating_wall_objects[_i]) {
        if (!variable_instance_exists(id, "visual_angle")) {
            visual_angle = image_angle;
        }
        image_angle = 0;

        var _half_w = sprite_get_width(sprite_index) * abs(image_xscale) * 0.5;
        var _half_h = sprite_get_height(sprite_index) * abs(image_yscale) * 0.5;
        var _piece_x = x + _half_w;
        var _piece_y = y + _half_h;
        var _center = noone;
        var _nearest_distance = 1000000000;

        for (var _center_i = 0; _center_i < instance_number(obj_rotating_wall_center); _center_i += 1) {
            var _test_center = instance_find(obj_rotating_wall_center, _center_i);
            var _test_distance = point_distance(_piece_x, _piece_y, _test_center.x + 16, _test_center.y + 16);

            if (_test_distance < _nearest_distance) {
                _nearest_distance = _test_distance;
                _center = _test_center;
            }
        }

        if (_center != noone) {
            var _pivot_x = _center.x + 16;
            var _pivot_y = _center.y + 16;
            var _distance = point_distance(_pivot_x, _pivot_y, _piece_x, _piece_y);
            var _direction = point_direction(_pivot_x, _pivot_y, _piece_x, _piece_y) - other.rotation_speed;

            _piece_x = _pivot_x + lengthdir_x(_distance, _direction);
            _piece_y = _pivot_y + lengthdir_y(_distance, _direction);
            var _next_x = _piece_x - _half_w;
            var _next_y = _piece_y - _half_h;

            x = _next_x;
            y = _next_y;

            visual_angle -= other.rotation_speed;

            player_to_push = noone;
            with (obj_player) {
                if (scr_place_meeting_rotating_wall_visual(x, y, other.id)) {
                    other.player_to_push = id;
                }
            }

            var _player = player_to_push;
            if (_player != noone) {
                push_x = x + _half_w;
                push_y = y + _half_h;

                with (_player) {
                    var _player_half_w = sprite_get_width(sprite_index) * abs(image_xscale) * 0.5;
                    var _player_half_h = sprite_get_height(sprite_index) * abs(image_yscale) * 0.5;
                    var _push_dir = point_direction(other.push_x, other.push_y, x + _player_half_w, y + _player_half_h);
                    if (point_distance(other.push_x, other.push_y, x + _player_half_w, y + _player_half_h) <= 0) {
                        _push_dir = 0;
                    }

                    repeat (32) {
                        if (!scr_place_meeting_rotating_wall_visual(x, y, other.id)) break;

                        var _push_step_x = round(lengthdir_x(1, _push_dir));
                        var _push_step_y = round(lengthdir_y(1, _push_dir));
                        if (_push_step_x == 0 && _push_step_y == 0) {
                            if (abs(lengthdir_x(1, _push_dir)) >= abs(lengthdir_y(1, _push_dir))) {
                                _push_step_x = sign(lengthdir_x(1, _push_dir));
                            } else {
                                _push_step_y = sign(lengthdir_y(1, _push_dir));
                            }
                        }
                        var _blocked_by_wall = false;

                        for (var _wall_i = 0; _wall_i < instance_number(obj_wall_parent); _wall_i += 1) {
                            var _wall = instance_find(obj_wall_parent, _wall_i);
                            if (_wall == other.id) continue;
                            if (_wall.object_index == obj_rotating_wall_center) continue;
                            if (_wall.object_index == obj_rotating_wall_horizontal) continue;
                            if (_wall.object_index == obj_rotating_wall_vertical) continue;
                            if (_wall.object_index == obj_rotating_wall_north) continue;
                            if (_wall.object_index == obj_rotating_wall_east) continue;
                            if (_wall.object_index == obj_rotating_wall_open_south) continue;
                            if (_wall.object_index == obj_rotating_wall_open_west) continue;

                            if (place_meeting(x + _push_step_x, y + _push_step_y, _wall)) {
                                _blocked_by_wall = true;
                                break;
                            }
                        }

                        if (_blocked_by_wall) {
                            scr_player_hit("rotating_wall_crush");
                            break;
                        }

                        x += _push_step_x;
                        y += _push_step_y;
                    }
                }
            }
        }
    }
}

with (obj_rotating_wall_center) {
    if (!variable_instance_exists(id, "visual_angle")) {
        visual_angle = image_angle;
    }

    image_angle = 0;
    visual_angle -= other.rotation_speed;
}
