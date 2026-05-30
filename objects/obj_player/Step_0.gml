if (is_dead) {
    death_timer -= 1;
    if (death_timer <= 0) {
        room_restart();
    }
    exit;
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
        global.score += global.score_slime_piece_value;
        with (_piece) {
            instance_destroy();
        }
        _piece = instance_place(x, y, obj_score_slime_piece);
    }
};

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

if (keyboard_check_pressed(vk_space)) {
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
    if (!place_meeting(x + _sx, y, obj_wall_parent)) {
        x += _sx;
        _moved = true;
        _collect_score_slime_pieces();
    } else {
        dash_remaining = 0;
        break;
    }
}

repeat (abs(_dy)) {
    if (!place_meeting(x, y + _sy, obj_wall_parent)) {
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
