function scr_place_meeting_rotating_wall_visual(_test_x, _test_y) {
    var _target_wall = argument_count > 2 ? argument[2] : noone;
    var _rotating_wall_objects = [
        obj_rotating_wall_horizontal,
        obj_rotating_wall_vertical,
        obj_rotating_wall_north,
        obj_rotating_wall_east,
        obj_rotating_wall_open_south,
        obj_rotating_wall_open_west
    ];

    var _player_left = _test_x + sprite_get_bbox_left(sprite_index) * abs(image_xscale);
    var _player_right = _test_x + (sprite_get_bbox_right(sprite_index) + 1) * abs(image_xscale);
    var _player_top = _test_y + sprite_get_bbox_top(sprite_index) * abs(image_yscale);
    var _player_bottom = _test_y + (sprite_get_bbox_bottom(sprite_index) + 1) * abs(image_yscale);

    for (var _i = 0; _i < array_length(_rotating_wall_objects); _i += 1) {
        for (var _j = 0; _j < instance_number(_rotating_wall_objects[_i]); _j += 1) {
            var _wall = instance_find(_rotating_wall_objects[_i], _j);
            if (_target_wall != noone && _wall != _target_wall) continue;

            var _wall_w = sprite_get_width(_wall.sprite_index) * abs(_wall.image_xscale);
            var _wall_h = sprite_get_height(_wall.sprite_index) * abs(_wall.image_yscale);
            var _wall_cx = _wall.x + _wall_w * 0.5;
            var _wall_cy = _wall.y + _wall_h * 0.5;
            var _wall_angle = variable_instance_exists(_wall, "visual_angle") ? _wall.visual_angle : _wall.image_angle;
            var _corner_distance = point_distance(0, 0, _wall_w * 0.5, _wall_h * 0.5);
            var _d1 = point_direction(0, 0, -_wall_w * 0.5, -_wall_h * 0.5) + _wall_angle;
            var _d2 = point_direction(0, 0, _wall_w * 0.5, -_wall_h * 0.5) + _wall_angle;
            var _d3 = point_direction(0, 0, _wall_w * 0.5, _wall_h * 0.5) + _wall_angle;
            var _d4 = point_direction(0, 0, -_wall_w * 0.5, _wall_h * 0.5) + _wall_angle;
            var _wx1 = _wall_cx + lengthdir_x(_corner_distance, _d1);
            var _wy1 = _wall_cy + lengthdir_y(_corner_distance, _d1);
            var _wx2 = _wall_cx + lengthdir_x(_corner_distance, _d2);
            var _wy2 = _wall_cy + lengthdir_y(_corner_distance, _d2);
            var _wx3 = _wall_cx + lengthdir_x(_corner_distance, _d3);
            var _wy3 = _wall_cy + lengthdir_y(_corner_distance, _d3);
            var _wx4 = _wall_cx + lengthdir_x(_corner_distance, _d4);
            var _wy4 = _wall_cy + lengthdir_y(_corner_distance, _d4);
            var _separated = false;

            var _wall_min = min(min(_wx1, _wx2), min(_wx3, _wx4));
            var _wall_max = max(max(_wx1, _wx2), max(_wx3, _wx4));
            if (_player_right <= _wall_min || _player_left >= _wall_max) _separated = true;

            _wall_min = min(min(_wy1, _wy2), min(_wy3, _wy4));
            _wall_max = max(max(_wy1, _wy2), max(_wy3, _wy4));
            if (_player_bottom <= _wall_min || _player_top >= _wall_max) _separated = true;

            var _axis_x = lengthdir_x(1, _wall_angle);
            var _axis_y = lengthdir_y(1, _wall_angle);
            var _p1 = _player_left * _axis_x + _player_top * _axis_y;
            var _p2 = _player_right * _axis_x + _player_top * _axis_y;
            var _p3 = _player_right * _axis_x + _player_bottom * _axis_y;
            var _p4 = _player_left * _axis_x + _player_bottom * _axis_y;
            var _player_min = min(min(_p1, _p2), min(_p3, _p4));
            var _player_max = max(max(_p1, _p2), max(_p3, _p4));
            _wall_min = min(min(_wx1 * _axis_x + _wy1 * _axis_y, _wx2 * _axis_x + _wy2 * _axis_y), min(_wx3 * _axis_x + _wy3 * _axis_y, _wx4 * _axis_x + _wy4 * _axis_y));
            _wall_max = max(max(_wx1 * _axis_x + _wy1 * _axis_y, _wx2 * _axis_x + _wy2 * _axis_y), max(_wx3 * _axis_x + _wy3 * _axis_y, _wx4 * _axis_x + _wy4 * _axis_y));
            if (_player_max <= _wall_min || _player_min >= _wall_max) _separated = true;

            _axis_x = lengthdir_x(1, _wall_angle + 90);
            _axis_y = lengthdir_y(1, _wall_angle + 90);
            _p1 = _player_left * _axis_x + _player_top * _axis_y;
            _p2 = _player_right * _axis_x + _player_top * _axis_y;
            _p3 = _player_right * _axis_x + _player_bottom * _axis_y;
            _p4 = _player_left * _axis_x + _player_bottom * _axis_y;
            _player_min = min(min(_p1, _p2), min(_p3, _p4));
            _player_max = max(max(_p1, _p2), max(_p3, _p4));
            _wall_min = min(min(_wx1 * _axis_x + _wy1 * _axis_y, _wx2 * _axis_x + _wy2 * _axis_y), min(_wx3 * _axis_x + _wy3 * _axis_y, _wx4 * _axis_x + _wy4 * _axis_y));
            _wall_max = max(max(_wx1 * _axis_x + _wy1 * _axis_y, _wx2 * _axis_x + _wy2 * _axis_y), max(_wx3 * _axis_x + _wy3 * _axis_y, _wx4 * _axis_x + _wy4 * _axis_y));
            if (_player_max <= _wall_min || _player_min >= _wall_max) _separated = true;

            if (!_separated) {
                return true;
            }
        }
    }

    return false;
}
