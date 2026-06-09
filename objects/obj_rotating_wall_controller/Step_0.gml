if (
    (variable_global_exists("game_paused") && global.game_paused)
    || (variable_global_exists("gameplay_frozen") && global.gameplay_frozen)
    || (variable_global_exists("game_cleared") && global.game_cleared)
    || (variable_global_exists("game_over") && global.game_over)
) {
    exit;
}

if (!enabled) exit;

var _rotating_wall_objects = scr_get_rotating_wall_objects();

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
        if (
            !variable_instance_exists(id, "rotation_center")
            || rotation_center == noone
            || !instance_exists(rotation_center)
        ) {
            rotation_center = noone;
            rotation_radius = 0;
            var _nearest_distance = 1000000000;

            for (var _center_i = 0; _center_i < instance_number(obj_rotating_wall_center); _center_i += 1) {
                var _test_center = instance_find(obj_rotating_wall_center, _center_i);
                var _test_distance = point_distance(_piece_x, _piece_y, _test_center.x + 16, _test_center.y + 16);

                if (_test_distance < _nearest_distance) {
                    _nearest_distance = _test_distance;
                    rotation_center = _test_center;
                    rotation_radius = _test_distance;
                }
            }
        }

        if (rotation_center != noone) {
            var _pivot_x = rotation_center.x + 16;
            var _pivot_y = rotation_center.y + 16;
            var _distance = rotation_radius;
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
                scr_rotating_wall_push_instance(_player, id, "rotating_wall_crush");
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
