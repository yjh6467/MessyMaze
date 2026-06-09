if (scr_pause_step_guard()) {
    exit;
}

if ((variable_global_exists("game_cleared") && global.game_cleared) || (variable_global_exists("game_over") && global.game_over)) {
    exit;
}

if (is_dead) {
    death_timer -= 1;
    if (death_timer <= 0) {
        if (!variable_global_exists("player_lives")) global.player_lives = 2;

        if (global.player_lives <= 0) {
            global.game_over = true;
            show_debug_message("GAME OVER");
        } else {
            x = spawn_x;
            y = spawn_y;
            is_dead = false;
            death_timer = 0;
            dash_remaining = 0;
            dash_cooldown = 0;
            invisible_timer = 0;
            image_alpha = normal_image_alpha;
            image_speed = normal_image_speed;
            image_blend = c_white;
            respawn_grace_timer = respawn_grace_duration;
        }
    }
    exit;
}

if (respawn_grace_timer > 0) {
    respawn_grace_timer -= 1;
}

if (dash_cooldown > 0) dash_cooldown -= 1;
if (invisible_cooldown > 0) invisible_cooldown -= 1;
if (invisible_timer > 0) invisible_timer -= 1;

if (invisible_timer > 0) {
    image_alpha = invisible_image_alpha;
    image_speed = 0;
} else {
    image_alpha = normal_image_alpha;
    image_speed = normal_image_speed;
}

if (!variable_global_exists("score")) global.score = 0;
if (!variable_global_exists("score_slime_piece_value")) global.score_slime_piece_value = 1;

var _collect_score_slime_pieces = function() {
    var _piece = instance_place(x, y, obj_score_slime_piece);
    while (_piece != noone) {
        var _is_infinite = variable_global_exists("difficulty") && global.difficulty == 4;
        var _piece_x = _piece.x;
        var _piece_y = _piece.y;

        global.score += global.score_slime_piece_value;
        global.slime_count = floor(global.score / max(1, global.score_slime_piece_value));

        if (_is_infinite) {
            var _has_respawner = false;
            for (var _respawner_i = 0; _respawner_i < instance_number(obj_slime_respawner); _respawner_i += 1) {
                var _existing_respawner = instance_find(obj_slime_respawner, _respawner_i);
                if (abs(_existing_respawner.respawn_x - _piece_x) < 0.5 && abs(_existing_respawner.respawn_y - _piece_y) < 0.5) {
                    _has_respawner = true;
                    break;
                }
            }

            if (!_has_respawner) {
                var _respawner = instance_create_layer(_piece_x, _piece_y, _piece.layer, obj_slime_respawner);
                _respawner.respawn_layer = _piece.layer;
                _respawner.respawn_image_xscale = _piece.image_xscale;
                _respawner.respawn_image_yscale = _piece.image_yscale;
                _respawner.respawn_image_angle = _piece.image_angle;
                _respawner.respawn_image_index = _piece.image_index;
                _respawner.respawn_image_speed = _piece.image_speed;
                _respawner.respawn_image_blend = _piece.image_blend;
                _respawner.respawn_image_alpha = _piece.image_alpha;
                _respawner.respawn_piece_depth = _piece.depth;
            }
        }

        with (_piece) {
            instance_destroy();
        }

        if (!_is_infinite) {
            scr_check_exit_open();
        }

        _piece = instance_place(x, y, obj_score_slime_piece);
    }
};

var _place_meeting_static_wall = function(_test_x, _test_y) {
    var _static_walls = scr_get_static_wall_instances();

    for (var _wall_i = 0; _wall_i < array_length(_static_walls); _wall_i += 1) {
        var _wall = _static_walls[_wall_i];
        if (place_meeting(_test_x, _test_y, _wall)) {
            return true;
        }
    }

    if (!variable_global_exists("exit_open")) global.exit_open = false;
    if (!global.exit_open && place_meeting(_test_x, _test_y, obj_exit_wall)) {
        return true;
    }

    return false;
};

var _place_meeting_rotating_wall = function(_test_x, _test_y) {
    return scr_place_meeting_rotating_wall_visual(_test_x, _test_y);
};

var _push_out_of_rotating_walls = function() {
    var _rotating_walls = scr_get_rotating_wall_instances();

    for (var _i = 0; _i < array_length(_rotating_walls); _i += 1) {
        var _wall = _rotating_walls[_i];
        scr_rotating_wall_push_instance(id, _wall, "rotating_wall_crush");
    }
};

_push_out_of_rotating_walls();

var _right = keyboard_check(vk_right) || keyboard_check(ord("D"));
var _left = keyboard_check(vk_left) || keyboard_check(ord("A"));
var _down = keyboard_check(vk_down) || keyboard_check(ord("S"));
var _up = keyboard_check(vk_up) || keyboard_check(ord("W"));

var _mx = _right - _left;
var _my = _down - _up;

if (_mx != 0 || _my != 0) {
    var _len = point_distance(0, 0, _mx, _my);
    _mx /= _len;
    _my /= _len;
    facing_x = _mx;
    facing_y = _my;
}

if (_mx > 0) {
    sprite_index = spr_player_right;
} else if (_mx < 0) {
    sprite_index = spr_player_left;
}

if (keyboard_check_pressed(vk_control)) {
    if (invisible_timer > 0) {
        invisible_timer = 0;
    } else if (invisible_cooldown <= 0) {
        invisible_timer = invisible_duration;
        invisible_cooldown = invisible_cooldown_max;
        dash_remaining = 0;
    }
}

if (invisible_timer > 0) {
    _mx = 0;
    _my = 0;
}

if (keyboard_check_pressed(vk_shift) && invisible_timer <= 0 && dash_cooldown <= 0 && dash_remaining <= 0 && (_mx != 0 || _my != 0)) {
    dash_remaining = dash_distance;
    dash_dir_x = _mx;
    dash_dir_y = _my;
    dash_cooldown = dash_cooldown_max;
    afterimage_timer = 0;
}

var _distance = move_speed;
if (dash_remaining > 0) {
    _distance = min(dash_speed, dash_remaining);
    _mx = dash_dir_x;
    _my = dash_dir_y;

    if (afterimage_timer <= 0) {
        var _afterimage = instance_create_layer(x, y, layer, obj_afterimage);
        _afterimage.sprite_index = sprite_index;
        _afterimage.image_index = image_index;
        _afterimage.image_xscale = image_xscale;
        _afterimage.image_yscale = image_yscale;
        _afterimage.image_angle = image_angle;
        _afterimage.depth = depth + 1;
        afterimage_timer = afterimage_interval;
    } else {
        afterimage_timer -= 1;
    }
}

var _dx = round(_mx * _distance);
var _dy = round(_my * _distance);
var _sx = sign(_dx);
var _sy = sign(_dy);
var _moved = false;

repeat (abs(_dx)) {
    if (!_place_meeting_static_wall(x + _sx, y) && !_place_meeting_rotating_wall(x + _sx, y)) {
        x += _sx;
        _moved = true;
        _collect_score_slime_pieces();
    } else {
        dash_remaining = 0;
        break;
    }
}

repeat (abs(_dy)) {
    if (!_place_meeting_static_wall(x, y + _sy) && !_place_meeting_rotating_wall(x, y + _sy)) {
        y += _sy;
        _moved = true;
        _collect_score_slime_pieces();
    } else {
        dash_remaining = 0;
        break;
    }
}

if (dash_remaining > 0) {
    if (_moved) {
        dash_remaining -= _distance;
    } else {
        dash_remaining = 0;
    }
}

_collect_score_slime_pieces();
_push_out_of_rotating_walls();
