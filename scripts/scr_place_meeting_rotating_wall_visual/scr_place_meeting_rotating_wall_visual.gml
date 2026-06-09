function scr_place_meeting_rotating_wall_visual(_test_x, _test_y) {
    var _target_wall = argument_count > 2 ? argument[2] : noone;
    var _target_instance = argument_count > 3 ? argument[3] : id;

    if (_target_instance == noone || !instance_exists(_target_instance)) return false;

    var _player_left = scr_instance_bbox_left_at(_target_instance, _test_x);
    var _player_right = scr_instance_bbox_right_at(_target_instance, _test_x);
    var _player_top = scr_instance_bbox_top_at(_target_instance, _test_y);
    var _player_bottom = scr_instance_bbox_bottom_at(_target_instance, _test_y);

    if (_target_wall != noone) {
        return scr_rotating_wall_visual_intersects_bounds(_player_left, _player_right, _player_top, _player_bottom, _target_wall);
    }

    var _rotating_walls = scr_get_rotating_wall_instances();
    for (var _i = 0; _i < array_length(_rotating_walls); _i += 1) {
        if (scr_rotating_wall_visual_intersects_bounds(_player_left, _player_right, _player_top, _player_bottom, _rotating_walls[_i])) {
            return true;
        }
    }

    return false;
}

function scr_debug_log(_message) {
    if (variable_global_exists("debug_logging") && global.debug_logging) {
        show_debug_message(_message);
    }
}

function scr_instance_width(_inst) {
    return sprite_get_width(_inst.sprite_index) * abs(_inst.image_xscale);
}

function scr_instance_height(_inst) {
    return sprite_get_height(_inst.sprite_index) * abs(_inst.image_yscale);
}

function scr_instance_center_x(_inst) {
    return _inst.x + scr_instance_width(_inst) * 0.5;
}

function scr_instance_center_y(_inst) {
    return _inst.y + scr_instance_height(_inst) * 0.5;
}

function scr_instance_bbox_left_at(_inst, _x) {
    return _x + sprite_get_bbox_left(_inst.sprite_index) * abs(_inst.image_xscale);
}

function scr_instance_bbox_right_at(_inst, _x) {
    return _x + (sprite_get_bbox_right(_inst.sprite_index) + 1) * abs(_inst.image_xscale);
}

function scr_instance_bbox_top_at(_inst, _y) {
    return _y + sprite_get_bbox_top(_inst.sprite_index) * abs(_inst.image_yscale);
}

function scr_instance_bbox_bottom_at(_inst, _y) {
    return _y + (sprite_get_bbox_bottom(_inst.sprite_index) + 1) * abs(_inst.image_yscale);
}

function scr_instances_need_rebuild(_instances) {
    for (var _i = 0; _i < array_length(_instances); _i += 1) {
        if (_instances[_i] == noone || !instance_exists(_instances[_i])) {
            return true;
        }
    }

    return false;
}

function scr_rotating_wall_visual_intersects_bounds(_player_left, _player_right, _player_top, _player_bottom, _wall) {
    if (_wall == noone || !instance_exists(_wall)) return false;

    var _wall_w = scr_instance_width(_wall);
    var _wall_h = scr_instance_height(_wall);
    var _wall_cx = scr_instance_center_x(_wall);
    var _wall_cy = scr_instance_center_y(_wall);
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

    var _wall_min = min(min(_wx1, _wx2), min(_wx3, _wx4));
    var _wall_max = max(max(_wx1, _wx2), max(_wx3, _wx4));
    if (_player_right <= _wall_min || _player_left >= _wall_max) return false;

    _wall_min = min(min(_wy1, _wy2), min(_wy3, _wy4));
    _wall_max = max(max(_wy1, _wy2), max(_wy3, _wy4));
    if (_player_bottom <= _wall_min || _player_top >= _wall_max) return false;

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
    if (_player_max <= _wall_min || _player_min >= _wall_max) return false;

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

    return !(_player_max <= _wall_min || _player_min >= _wall_max);
}

function scr_get_rotating_wall_objects() {
    if (!variable_global_exists("rotating_wall_objects")) {
        global.rotating_wall_objects = [
            obj_rotating_wall_horizontal,
            obj_rotating_wall_vertical,
            obj_rotating_wall_north,
            obj_rotating_wall_east,
            obj_rotating_wall_open_south,
            obj_rotating_wall_open_west
        ];
    }

    return global.rotating_wall_objects;
}

function scr_rebuild_rotating_wall_instances() {
    global.rotating_wall_instances = [];
    global.rotating_wall_instances_room = room;

    var _rotating_wall_objects = scr_get_rotating_wall_objects();
    for (var _i = 0; _i < array_length(_rotating_wall_objects); _i += 1) {
        for (var _j = 0; _j < instance_number(_rotating_wall_objects[_i]); _j += 1) {
            array_push(global.rotating_wall_instances, instance_find(_rotating_wall_objects[_i], _j));
        }
    }
}

function scr_get_rotating_wall_instances() {
    var _needs_rebuild = true;

    if (
        variable_global_exists("rotating_wall_instances")
        && variable_global_exists("rotating_wall_instances_room")
        && global.rotating_wall_instances_room == room
    ) {
        _needs_rebuild = scr_instances_need_rebuild(global.rotating_wall_instances);
    }

    if (_needs_rebuild) {
        scr_rebuild_rotating_wall_instances();
    }

    return global.rotating_wall_instances;
}

function scr_rebuild_rotating_wall_centers() {
    global.rotating_wall_centers = [];
    global.rotating_wall_centers_room = room;

    for (var _center_i = 0; _center_i < instance_number(obj_rotating_wall_center); _center_i += 1) {
        array_push(global.rotating_wall_centers, instance_find(obj_rotating_wall_center, _center_i));
    }
}

function scr_get_rotating_wall_centers() {
    var _needs_rebuild = true;

    if (
        variable_global_exists("rotating_wall_centers")
        && variable_global_exists("rotating_wall_centers_room")
        && global.rotating_wall_centers_room == room
    ) {
        _needs_rebuild = scr_instances_need_rebuild(global.rotating_wall_centers);
    }

    if (_needs_rebuild) {
        scr_rebuild_rotating_wall_centers();
    }

    return global.rotating_wall_centers;
}

function scr_is_rotating_wall_object(_object_index) {
    return _object_index == obj_rotating_wall_horizontal
        || _object_index == obj_rotating_wall_vertical
        || _object_index == obj_rotating_wall_north
        || _object_index == obj_rotating_wall_east
        || _object_index == obj_rotating_wall_open_south
        || _object_index == obj_rotating_wall_open_west
        || _object_index == obj_rotating_wall_center;
}

function scr_rebuild_static_wall_instances() {
    global.static_wall_instances = [];
    global.static_wall_instances_room = room;

    for (var _wall_i = 0; _wall_i < instance_number(obj_wall_parent); _wall_i += 1) {
        var _wall = instance_find(obj_wall_parent, _wall_i);
        if (scr_is_rotating_wall_object(_wall.object_index)) continue;

        array_push(global.static_wall_instances, _wall);
    }
}

function scr_get_static_wall_instances() {
    var _needs_rebuild = true;

    if (
        variable_global_exists("static_wall_instances")
        && variable_global_exists("static_wall_instances_room")
        && global.static_wall_instances_room == room
    ) {
        _needs_rebuild = scr_instances_need_rebuild(global.static_wall_instances);
    }

    if (_needs_rebuild) {
        scr_rebuild_static_wall_instances();
    }

    return global.static_wall_instances;
}

function scr_rotating_wall_push_instance(_target, _wall, _crush_reason) {
    if (_target == noone || _wall == noone) return false;
    if (!instance_exists(_target) || !instance_exists(_wall)) return false;
    if (_target.object_index == obj_player) {
        if (variable_instance_exists(_target, "is_dead") && _target.is_dead) return false;
        if (variable_global_exists("game_over") && global.game_over) return false;
    }

    var _target_x = _target.x;
    var _target_y = _target.y;
    if (!scr_place_meeting_rotating_wall_visual(_target_x, _target_y, _wall, _target)) return false;

    var _wall_center_x = scr_instance_center_x(_wall);
    var _wall_center_y = scr_instance_center_y(_wall);
    var _target_center_x = _target_x + scr_instance_width(_target) * 0.5;
    var _target_center_y = _target_y + scr_instance_height(_target) * 0.5;
    var _push_dir = point_direction(_wall_center_x, _wall_center_y, _target_center_x, _target_center_y);

    if (point_distance(_wall_center_x, _wall_center_y, _target_center_x, _target_center_y) <= 0) {
        _push_dir = 0;
    }

    repeat (32) {
        if (!instance_exists(_target) || !instance_exists(_wall)) return true;
        if (_target.object_index == obj_player) {
            if (variable_instance_exists(_target, "is_dead") && _target.is_dead) return true;
            if (variable_global_exists("game_over") && global.game_over) return true;
        }
        if (!scr_place_meeting_rotating_wall_visual(_target.x, _target.y, _wall, _target)) return true;

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
        var _target_test_left = scr_instance_bbox_left_at(_target, _target.x + _push_step_x);
        var _target_test_right = scr_instance_bbox_right_at(_target, _target.x + _push_step_x);
        var _target_test_top = scr_instance_bbox_top_at(_target, _target.y + _push_step_y);
        var _target_test_bottom = scr_instance_bbox_bottom_at(_target, _target.y + _push_step_y);

        var _static_walls = scr_get_static_wall_instances();
        for (var _wall_i = 0; _wall_i < array_length(_static_walls); _wall_i += 1) {
            var _block_wall = _static_walls[_wall_i];
            if (_block_wall == _wall) continue;
            if (_block_wall == noone || !instance_exists(_block_wall)) continue;

            if (collision_rectangle(_target_test_left, _target_test_top, _target_test_right, _target_test_bottom, _block_wall, false, true) != noone) {
                _blocked_by_wall = true;
                break;
            }
        }

        if (_blocked_by_wall) {
            if (_crush_reason != "") {
                scr_player_hit(_crush_reason);
            }
            return true;
        }

        _target.x += _push_step_x;
        _target.y += _push_step_y;
    }

    return true;
}
