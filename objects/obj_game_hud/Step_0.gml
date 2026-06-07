if (!variable_global_exists("hud_height")) global.hud_height = 96;

if (!variable_global_exists("score")) global.score = 0;
if (!variable_global_exists("score_slime_piece_value")) global.score_slime_piece_value = 1;
if (!variable_global_exists("player_lives")) global.player_lives = 2;
if (!variable_global_exists("game_cleared")) global.game_cleared = false;
if (!variable_global_exists("game_over")) global.game_over = false;

var _result_active = global.game_cleared || global.game_over;

if (!_result_active) {
    global.elapsed_time = max(0, floor((current_time - hud_start_time_ms) / 1000));
}

if (variable_global_exists("difficulty") && global.difficulty == 0) {
    var _test_total = instance_number(obj_score_slime_piece);
    if (!variable_global_exists("total_slime_count") || global.total_slime_count < _test_total) {
        global.total_slime_count = _test_total;
    }

    global.slime_count = global.total_slime_count;
    global.score = global.total_slime_count * global.score_slime_piece_value;

    if (!variable_global_exists("exit_open") || !global.exit_open) {
        scr_check_exit_open();
    }
} else {
    global.slime_count = floor(global.score / max(1, global.score_slime_piece_value));

    var _remaining_slime = instance_number(obj_score_slime_piece);
    var _detected_total = global.slime_count + _remaining_slime;
    if (!variable_global_exists("total_slime_count") || global.total_slime_count < _detected_total) {
        global.total_slime_count = _detected_total;
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
    var _menu_pressed = keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("M"));

    if (mouse_check_button_pressed(mb_left)) {
        var _mx = device_mouse_x_to_gui(0);
        var _my = device_mouse_y_to_gui(0);
        _retry_pressed = _retry_pressed || point_in_rectangle(_mx, _my, _retry_x, _button_y, _retry_x + _button_w, _button_y + _button_h);
        _menu_pressed = _menu_pressed || point_in_rectangle(_mx, _my, _menu_x, _button_y, _menu_x + _button_w, _button_y + _button_h);
    }

    if (_retry_pressed) {
        room_restart();
    } else if (_menu_pressed) {
        room_goto(Main);
    }
}
