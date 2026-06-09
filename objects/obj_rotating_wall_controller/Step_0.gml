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

        var _half_w = scr_instance_width(id) * 0.5;
        var _half_h = scr_instance_height(id) * 0.5;
        var _piece_x = scr_instance_center_x(id);
        var _piece_y = scr_instance_center_y(id);
        if (
            !variable_instance_exists(id, "rotation_center")
            || rotation_center == noone
            || !instance_exists(rotation_center)
        ) {
            rotation_center = noone;
            rotation_radius = 0;
            var _nearest_distance = 1000000000;
            var _rotating_centers = scr_get_rotating_wall_centers();

            for (var _center_i = 0; _center_i < array_length(_rotating_centers); _center_i += 1) {
                var _test_center = _rotating_centers[_center_i];
                var _test_distance = point_distance(_piece_x, _piece_y, scr_instance_center_x(_test_center), scr_instance_center_y(_test_center));

                if (_test_distance < _nearest_distance) {
                    _nearest_distance = _test_distance;
                    rotation_center = _test_center;
                    rotation_radius = _test_distance;
                }
            }
        }

        if (rotation_center != noone) {
            var _pivot_x = scr_instance_center_x(rotation_center);
            var _pivot_y = scr_instance_center_y(rotation_center);
            var _distance = rotation_radius;
            var _direction = point_direction(_pivot_x, _pivot_y, _piece_x, _piece_y) - other.rotation_speed;

            _piece_x = _pivot_x + lengthdir_x(_distance, _direction);
            _piece_y = _pivot_y + lengthdir_y(_distance, _direction);
            var _next_x = _piece_x - _half_w;
            var _next_y = _piece_y - _half_h;

            x = _next_x;
            y = _next_y;

            visual_angle -= other.rotation_speed;

            if (instance_exists(obj_player)) {
                var _player = instance_find(obj_player, 0);
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
