function scr_monster_is_rotating_wall_object(_object_index) {
    return scr_is_rotating_wall_object(_object_index);
}

function scr_monster_place_meeting_static_wall(_test_x, _test_y) {
    var _old_mask = mask_index;
    mask_index = spr_player_right;
    var _static_walls = scr_get_static_wall_instances();

    for (var _wall_i = 0; _wall_i < array_length(_static_walls); _wall_i += 1) {
        var _wall = _static_walls[_wall_i];
        if (place_meeting(_test_x, _test_y, _wall)) {
            mask_index = _old_mask;
            return true;
        }
    }

    mask_index = _old_mask;
    return false;
}

function scr_monster_place_meeting_rotating_wall(_test_x, _test_y) {
    var _rotating_wall_objects = scr_get_rotating_wall_objects();

    for (var _i = 0; _i < array_length(_rotating_wall_objects); _i += 1) {
        for (var _j = 0; _j < instance_number(_rotating_wall_objects[_i]); _j += 1) {
            var _wall = instance_find(_rotating_wall_objects[_i], _j);

            if (scr_place_meeting_rotating_wall_visual(_test_x, _test_y, _wall)) {
                return true;
            }
        }
    }

    return false;
}

function scr_monster_in_rotating_wall_zone(_test_x, _test_y) {
    var _cx = _test_x + sprite_get_width(sprite_index) * abs(image_xscale) * 0.5;
    var _cy = _test_y + sprite_get_height(sprite_index) * abs(image_yscale) * 0.5;
    var _radius = variable_instance_exists(id, "rotating_avoid_radius") ? rotating_avoid_radius : 128;

    for (var _i = 0; _i < instance_number(obj_rotating_wall_center); _i += 1) {
        var _center = instance_find(obj_rotating_wall_center, _i);
        var _center_cx = _center.x + sprite_get_width(_center.sprite_index) * abs(_center.image_xscale) * 0.5;
        var _center_cy = _center.y + sprite_get_height(_center.sprite_index) * abs(_center.image_yscale) * 0.5;

        if (point_distance(_cx, _cy, _center_cx, _center_cy) < _radius) {
            return true;
        }
    }

    return false;
}

function scr_monster_can_move_to(_test_x, _test_y) {
    if (_test_x < 0 || _test_y < 0 || _test_x > room_width - 1 || _test_y > room_height - 1) return false;
    if (scr_monster_place_meeting_static_wall(_test_x, _test_y)) return false;
    if (scr_monster_place_meeting_rotating_wall(_test_x, _test_y)) return false;
    if (scr_monster_in_rotating_wall_zone(_test_x, _test_y)) return false;

    return true;
}

function scr_monster_in_spawn_room() {
    return x >= spawn_room_left
        && x <= spawn_room_right
        && y >= spawn_room_top
        && y <= spawn_room_bottom;
}

function scr_monster_can_see_player() {
    if (!instance_exists(obj_player)) return false;
    if (obj_player.is_dead) return false;
    if (obj_player.invisible_timer > 0) return false;

    var _from_x = x + sprite_get_width(sprite_index) * abs(image_xscale) * 0.5;
    var _from_y = y + sprite_get_height(sprite_index) * abs(image_yscale) * 0.5;
    var _to_x = obj_player.x + sprite_get_width(obj_player.sprite_index) * abs(obj_player.image_xscale) * 0.5;
    var _to_y = obj_player.y + sprite_get_height(obj_player.sprite_index) * abs(obj_player.image_yscale) * 0.5;
    var _distance = point_distance(_from_x, _from_y, _to_x, _to_y);

    if (_distance > sight_radius) return false;
    if (scr_monster_in_rotating_wall_zone(x, y)) return false;

    var _static_walls = scr_get_static_wall_instances();
    for (var _wall_i = 0; _wall_i < array_length(_static_walls); _wall_i += 1) {
        var _wall = _static_walls[_wall_i];
        if (collision_line(_from_x, _from_y, _to_x, _to_y, _wall, false, true) != noone) {
            return false;
        }
    }

    var _samples = max(1, ceil(_distance / 16));
    for (var _i = 1; _i < _samples; _i += 1) {
        var _sample_x = lerp(_from_x, _to_x, _i / _samples);
        var _sample_y = lerp(_from_y, _to_y, _i / _samples);

        if (scr_monster_place_meeting_rotating_wall(_sample_x - 16, _sample_y - 16)) return false;
        if (scr_monster_in_rotating_wall_zone(_sample_x - 16, _sample_y - 16)) return false;
    }

    return true;
}

function scr_monster_direction_score(_dir_x, _dir_y, _chasing) {
    var _next_x = x + _dir_x * look_ahead_distance;
    var _next_y = y + _dir_y * look_ahead_distance;

    if (!scr_monster_can_move_to(_next_x, _next_y)) return 1000000;

    if (_chasing && instance_exists(obj_player)) {
        return point_distance(_next_x, _next_y, obj_player.x, obj_player.y);
    }

    var _reverse_penalty = (_dir_x == -dir_x && _dir_y == -dir_y) ? tile_size * 3 : 0;
    return random(100) + _reverse_penalty;
}

function scr_monster_choose_direction(_chasing) {
    var _dirs_x = [1, -1, 0, 0];
    var _dirs_y = [0, 0, 1, -1];
    var _best_score = 1000000;
    var _best_x = 0;
    var _best_y = 0;

    for (var _i = 0; _i < 4; _i += 1) {
        var _score = scr_monster_direction_score(_dirs_x[_i], _dirs_y[_i], _chasing);

        if (_score < _best_score) {
            _best_score = _score;
            _best_x = _dirs_x[_i];
            _best_y = _dirs_y[_i];
        }
    }

    if (_best_score < 1000000) {
        dir_x = _best_x;
        dir_y = _best_y;
        decision_timer = decision_interval;
    } else {
        dir_x = 0;
        dir_y = 0;
        decision_timer = max(8, decision_interval div 2);
    }
}

function scr_monster_start_escape() {
    escape_spawn_room = true;
    escape_mode = 0;
    escape_timer = 240;
    escape_target_x = 784;
    escape_side_target_x = x;
    escape_side_dir = choose(-1, 1);
    dir_x = 0;
    dir_y = 0;
    decision_timer = 6;
}

function scr_monster_choose_escape_direction() {
    if (!escape_spawn_room) return false;

    escape_timer -= 1;
    if (escape_timer <= 0) {
        escape_spawn_room = false;
        decision_timer = 0;
        return false;
    }

    if (escape_mode == 0) {
        if (abs(x - escape_target_x) <= 2) {
            escape_mode = 1;
        } else {
            var _target_dir = sign(escape_target_x - x);
            if (scr_monster_can_move_to(x + _target_dir, y)) {
                dir_x = _target_dir;
                dir_y = 0;
                decision_timer = 6;
                return true;
            }

            escape_mode = 1;
        }
    }

    if (escape_mode == 1) {
        if (scr_monster_can_move_to(x, y + look_ahead_distance) && y < escape_until_y) {
            dir_x = 0;
            dir_y = 1;
            decision_timer = 6;
            return true;
        }

        var _left_ok = scr_monster_can_move_to(x - look_ahead_distance, y);
        var _right_ok = scr_monster_can_move_to(x + look_ahead_distance, y);

        if (_left_ok && _right_ok) {
            escape_side_dir = choose(-1, 1);
        } else if (_left_ok) {
            escape_side_dir = -1;
        } else if (_right_ok) {
            escape_side_dir = 1;
        } else {
            escape_spawn_room = false;
            decision_timer = 0;
            return false;
        }

        escape_side_target_x = x + escape_side_dir * tile_size * irandom_range(2, 4);
        escape_mode = 2;
    }

    if (escape_mode == 2) {
        if (abs(x - escape_side_target_x) <= 2) {
            escape_spawn_room = false;
            decision_timer = 0;
            return false;
        }

        var _side_dir = sign(escape_side_target_x - x);
        if (scr_monster_can_move_to(x + _side_dir, y)) {
            dir_x = _side_dir;
            dir_y = 0;
            decision_timer = 6;
            return true;
        }

        escape_spawn_room = false;
        decision_timer = 0;
        return false;
    }

    dir_x = 0;
    dir_y = 0;
    decision_timer = 6;
    return true;
}

function scr_monster_apply_sprite(_moved) {
    if (!_moved) {
        sprite_index = idle_sprite;
        image_speed = 0.2;
        return;
    }

    walk_swap_timer -= 1;
    if (walk_swap_timer <= 0) {
        walk_swap_timer = walk_swap_interval;
        walk_swap_left = !walk_swap_left;
    }

    if (walk_swap_left) {
        sprite_index = walk_left_sprite;
    } else {
        sprite_index = walk_right_sprite;
    }

    image_speed = 1;
}

function scr_monster_try_move() {
    var _distance = move_speed;
    var _dx = round(dir_x * _distance);
    var _dy = round(dir_y * _distance);
    var _sx = sign(_dx);
    var _sy = sign(_dy);
    var _moved = false;

    repeat (abs(_dx)) {
        if (scr_monster_can_move_to(x + _sx, y)) {
            x += _sx;
            _moved = true;
        } else {
            decision_timer = 0;
            break;
        }
    }

    repeat (abs(_dy)) {
        if (scr_monster_can_move_to(x, y + _sy)) {
            y += _sy;
            _moved = true;
        } else {
            decision_timer = 0;
            break;
        }
    }

    scr_monster_apply_sprite(_moved);
}

function scr_monster_ai_init(_idle_sprite, _walk_left_sprite, _walk_right_sprite) {
    depth = -10000;
    idle_sprite = _idle_sprite;
    walk_left_sprite = _walk_left_sprite;
    walk_right_sprite = _walk_right_sprite;
    sprite_index = idle_sprite;

    tile_size = variable_global_exists("tile_size") ? global.tile_size : 32;
    move_speed = variable_global_exists("monster_patrol_speed") ? global.monster_patrol_speed : 1.7;
    chase_speed = variable_global_exists("monster_chase_speed") ? global.monster_chase_speed : 2.5;
    patrol_speed = variable_global_exists("monster_patrol_speed") ? global.monster_patrol_speed : 1.7;
    sight_radius = variable_global_exists("monster_sight_radius") ? global.monster_sight_radius : tile_size * 8;
    lose_radius = variable_global_exists("monster_lose_radius") ? global.monster_lose_radius : tile_size * 11;
    rotating_avoid_radius = variable_global_exists("monster_rotating_avoid_radius") ? global.monster_rotating_avoid_radius : tile_size * 4;
    look_ahead_distance = 8;
    walk_swap_interval = 8;
    walk_swap_timer = irandom(walk_swap_interval);
    walk_swap_left = choose(true, false);
    decision_interval = variable_global_exists("monster_direction_interval") ? global.monster_direction_interval : 18;
    decision_timer = irandom(decision_interval);
    sight_check_interval = 5;
    sight_check_timer = irandom(sight_check_interval);
    sight_check_result = false;
    chase_memory = 0;
    chase_memory_max = variable_global_exists("monster_chase_memory") ? global.monster_chase_memory : 45;
    spawn_x = x;
    spawn_y = y;
    escape_target_x = 784;
    spawn_room_left = escape_target_x - tile_size * 2.5;
    spawn_room_right = escape_target_x + tile_size * 2.5;
    spawn_room_top = spawn_y - tile_size * 2;
    spawn_room_bottom = spawn_y + tile_size * 3;
    escape_until_y = spawn_y + tile_size * 5;
    scr_monster_start_escape();
    image_speed = 0.2;
}

function scr_monster_ai_step() {
    if (scr_pause_step_guard()) exit;
    if (!instance_exists(obj_player)) exit;

    if (!escape_spawn_room && scr_monster_in_spawn_room()) {
        scr_monster_start_escape();
    }

    if (scr_monster_choose_escape_direction()) {
        move_speed = patrol_speed;
        scr_monster_try_move();

        if (place_meeting(x, y, obj_player)) {
            scr_player_hit("monster");
        }

        exit;
    }

    var _sees_player = false;
    if (obj_player.is_dead || obj_player.invisible_timer > 0) {
        sight_check_result = false;
        sight_check_timer = 0;
    } else {
        sight_check_timer -= 1;
        if (sight_check_timer <= 0) {
            sight_check_result = scr_monster_can_see_player();
            sight_check_timer = sight_check_interval + irandom(2);
        }

        _sees_player = sight_check_result;
    }

    if (_sees_player) {
        chase_memory = chase_memory_max;
    } else if (chase_memory > 0) {
        chase_memory -= 1;
    }

    var _player_far = point_distance(x, y, obj_player.x, obj_player.y) > lose_radius;
    var _chasing = chase_memory > 0 && !_player_far;

    move_speed = _chasing ? chase_speed : patrol_speed;
    decision_timer -= 1;

    if (decision_timer <= 0 || dir_x == 0 && dir_y == 0) {
        scr_monster_choose_direction(_chasing);
    }

    scr_monster_try_move();

    if (place_meeting(x, y, obj_player)) {
        scr_player_hit("monster");
    }
}
