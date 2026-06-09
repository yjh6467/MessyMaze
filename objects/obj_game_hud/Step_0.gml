if (!variable_global_exists("hud_height")) global.hud_height = 96;

if (!variable_global_exists("score")) global.score = 0;
if (!variable_global_exists("score_slime_piece_value")) global.score_slime_piece_value = 1;
if (!variable_global_exists("player_lives")) global.player_lives = 2;
if (!variable_global_exists("game_cleared")) global.game_cleared = false;
if (!variable_global_exists("game_over")) global.game_over = false;
if (!variable_global_exists("game_paused")) global.game_paused = false;
if (!variable_global_exists("gameplay_frozen")) global.gameplay_frozen = false;
if (!variable_global_exists("screen_shake_timer")) global.screen_shake_timer = 0;
if (!variable_global_exists("screen_shake_duration")) global.screen_shake_duration = 0;
if (!variable_global_exists("screen_shake_intensity")) global.screen_shake_intensity = 0;
if (!variable_global_exists("screen_shake_camera_base_x")) global.screen_shake_camera_base_x = 0;
if (!variable_global_exists("screen_shake_camera_base_y")) global.screen_shake_camera_base_y = 0;

if (global.screen_shake_timer > 0 && !global.game_paused && !global.game_cleared && !global.game_over) {
    var _shake_progress = global.screen_shake_timer / max(1, global.screen_shake_duration);
    var _shake_amount = global.screen_shake_intensity * _shake_progress;
    var _shake_x = round(random_range(-_shake_amount, _shake_amount));
    var _shake_y = round(random_range(-_shake_amount, _shake_amount));

    if (variable_global_exists("screen_shake_camera")) {
        camera_set_view_pos(
            global.screen_shake_camera,
            global.screen_shake_camera_base_x + _shake_x,
            global.screen_shake_camera_base_y + _shake_y
        );
    }

    global.screen_shake_timer -= 1;
} else {
    global.screen_shake_timer = 0;
    if (variable_global_exists("screen_shake_camera")) {
        camera_set_view_pos(
            global.screen_shake_camera,
            global.screen_shake_camera_base_x,
            global.screen_shake_camera_base_y
        );
    }
}

var _result_active = global.game_cleared || global.game_over;

if (_result_active) {
    scr_set_game_paused(false);

    var _result_sound_state = global.game_cleared ? 1 : 2;
    if (!variable_instance_exists(id, "result_popup_sound_state")) result_popup_sound_state = 0;

    if (result_popup_sound_state != _result_sound_state) {
        result_popup_sound_state = _result_sound_state;
        scr_cleanup_gameplay_audio();
        scr_play_sfx(global.game_cleared ? sfx_gameclear : sfx_gameover);
    }
}

if (_result_active) {
    var _gui_w = max(1, display_get_gui_width());
    var _gui_h = max(1, display_get_gui_height());
    var _popup_w = min(720, _gui_w - 80);
    var _popup_h = 420;
    var _popup_x = round((_gui_w - _popup_w) * 0.5);
    var _popup_y = round((_gui_h - _popup_h) * 0.5);
    var _button_w = 190;
    var _button_h = 50;
    var _button_gap = 28;
    var _button_y = round(_popup_y + _popup_h - 82);
    var _retry_x = round(_popup_x + (_popup_w - (_button_w * 2 + _button_gap)) * 0.5);
    var _menu_x = round(_retry_x + _button_w + _button_gap);

    var _retry_pressed = keyboard_check_pressed(ord("R"));
    var _menu_pressed = keyboard_check_pressed(ord("M"));

    if (mouse_check_button_pressed(mb_left)) {
        var _mx = device_mouse_x_to_gui(0);
        var _my = device_mouse_y_to_gui(0);
        _retry_pressed = _retry_pressed || point_in_rectangle(_mx, _my, _retry_x, _button_y, _retry_x + _button_w, _button_y + _button_h);
        _menu_pressed = _menu_pressed || point_in_rectangle(_mx, _my, _menu_x, _button_y, _menu_x + _button_w, _button_y + _button_h);
    }

    if (_retry_pressed) {
        global.game_cleared = false;
        global.game_over = false;
        scr_set_game_paused(false);
        scr_cleanup_gameplay_audio();
        room_restart();
    } else if (_menu_pressed) {
        global.game_cleared = false;
        global.game_over = false;
        scr_set_game_paused(false);
        scr_cleanup_gameplay_audio();
        room_goto(Main);
    }

    exit;
}

if (variable_instance_exists(id, "result_popup_sound_state")) {
    result_popup_sound_state = 0;
}

var _escape_pressed = keyboard_check_pressed(vk_escape);

if (global.game_paused) {
    var _pause_gui_w = max(1, display_get_gui_width());
    var _pause_gui_h = max(1, display_get_gui_height());
    var _pause_popup_w = min(640, _pause_gui_w - 80);
    var _pause_popup_h = 360;
    var _pause_popup_x = round((_pause_gui_w - _pause_popup_w) * 0.5);
    var _pause_popup_y = round((_pause_gui_h - _pause_popup_h) * 0.5);
    var _pause_button_w = 180;
    var _pause_button_h = 50;
    var _pause_button_gap = 18;
    var _pause_button_y = round(_pause_popup_y + _pause_popup_h - 88);
    var _pause_buttons_w = _pause_button_w * 3 + _pause_button_gap * 2;
    var _resume_x = round(_pause_popup_x + (_pause_popup_w - _pause_buttons_w) * 0.5);
    var _pause_retry_x = round(_resume_x + _pause_button_w + _pause_button_gap);
    var _pause_menu_x = round(_pause_retry_x + _pause_button_w + _pause_button_gap);

    var _resume_pressed = _escape_pressed;
    var _pause_retry_pressed = keyboard_check_pressed(ord("R"));
    var _pause_menu_pressed = keyboard_check_pressed(ord("M"));

    if (mouse_check_button_pressed(mb_left)) {
        var _pause_mx = device_mouse_x_to_gui(0);
        var _pause_my = device_mouse_y_to_gui(0);
        _resume_pressed = _resume_pressed || point_in_rectangle(_pause_mx, _pause_my, _resume_x, _pause_button_y, _resume_x + _pause_button_w, _pause_button_y + _pause_button_h);
        _pause_retry_pressed = _pause_retry_pressed || point_in_rectangle(_pause_mx, _pause_my, _pause_retry_x, _pause_button_y, _pause_retry_x + _pause_button_w, _pause_button_y + _pause_button_h);
        _pause_menu_pressed = _pause_menu_pressed || point_in_rectangle(_pause_mx, _pause_my, _pause_menu_x, _pause_button_y, _pause_menu_x + _pause_button_w, _pause_button_y + _pause_button_h);
    }

    if (_resume_pressed) {
        scr_set_game_paused(false);
    } else if (_pause_retry_pressed) {
        scr_set_game_paused(false);
        scr_cleanup_gameplay_audio();
        room_restart();
    } else if (_pause_menu_pressed) {
        scr_set_game_paused(false);
        scr_cleanup_gameplay_audio();
        room_goto(Main);
    }

    exit;
} else if (_escape_pressed) {
    scr_set_game_paused(true);
    exit;
}

if (!variable_instance_exists(id, "hud_elapsed_frames")) hud_elapsed_frames = global.elapsed_time * max(1, room_speed);
hud_elapsed_frames += 1;
global.elapsed_time = max(0, floor(hud_elapsed_frames / max(1, room_speed)));

if (!variable_global_exists("slime_piece_anim_tick")) global.slime_piece_anim_tick = 0;
if (!variable_global_exists("slime_piece_anim_frame_hold")) global.slime_piece_anim_frame_hold = max(1, round(room_speed / 8));

var _slime_anim_frame_count = max(1, sprite_get_number(spr_score_slime_piece));
global.slime_piece_anim_index = floor(global.slime_piece_anim_tick / max(1, global.slime_piece_anim_frame_hold)) mod _slime_anim_frame_count;
global.slime_piece_anim_tick += 1;

var _difficulty = variable_global_exists("difficulty") ? global.difficulty : 2;

if (_difficulty == 4) {
    scr_apply_infinite_difficulty(floor(global.elapsed_time / 60), false);
}

if (_difficulty == 0) {
    var _test_total = instance_number(obj_score_slime_piece);
    if (!variable_global_exists("total_slime_count") || global.total_slime_count < _test_total) {
        global.total_slime_count = _test_total;
    }

    global.slime_count = global.total_slime_count;
    global.score = global.total_slime_count * global.score_slime_piece_value;

    if (!variable_global_exists("exit_open") || !global.exit_open) {
        scr_check_exit_open();
    }
} else if (_difficulty == 4) {
    global.slime_count = floor(global.score / max(1, global.score_slime_piece_value));

    if (!variable_global_exists("total_slime_count") || global.total_slime_count <= 0) {
        global.total_slime_count = global.slime_count + instance_number(obj_score_slime_piece);
    }
} else {
    global.slime_count = floor(global.score / max(1, global.score_slime_piece_value));

    var _remaining_slime = instance_number(obj_score_slime_piece);
    var _detected_total = global.slime_count + _remaining_slime;
    if (!variable_global_exists("total_slime_count") || global.total_slime_count < _detected_total) {
        global.total_slime_count = _detected_total;
    }
}
