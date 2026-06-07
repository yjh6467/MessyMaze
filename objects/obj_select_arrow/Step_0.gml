if (variable_global_exists("option_open") && global.option_open) {
    if (keyboard_check_pressed(vk_escape)) {
        global.option_open = false;
        exit;
    }

    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);

    var _box_w = 620;
    var _box_h = 460;
    var _box_x = (_gui_w - _box_w) * 0.5;
    var _box_y = (_gui_h - _box_h) * 0.5;
    var _slider_x = _box_x + 210;
    var _slider_w = 260;
    var _bgm_y = _box_y + 145;
    var _sfx_y = _box_y + 215;
    var _slider_h = 28;
    var _difficulty_y = _box_y + 290;
    var _arrow_w = 48;
    var _arrow_h = 42;
    var _left_x = _box_x + 210;
    var _right_x = _box_x + 412;
    var _button_y = _box_y + _box_h - 92;
    var _button_w = 150;
    var _button_h = 52;
    var _ok_x = _box_x + 145;
    var _close_x = _box_x + _box_w - 145 - _button_w;

    var _pressed = mouse_check_button_pressed(mb_left);
    var _held = mouse_check_button(mb_left);

    if (!variable_instance_exists(id, "dragging_slider")) {
        dragging_slider = -1;
    }

    if (_pressed) {
        if (_mx >= _slider_x - 10 && _mx <= _slider_x + _slider_w + 10 && _my >= _bgm_y - _slider_h * 0.5 && _my <= _bgm_y + _slider_h * 0.5) {
            dragging_slider = 0;
        } else if (_mx >= _slider_x - 10 && _mx <= _slider_x + _slider_w + 10 && _my >= _sfx_y - _slider_h * 0.5 && _my <= _sfx_y + _slider_h * 0.5) {
            dragging_slider = 1;
        } else if (_mx >= _left_x && _mx <= _left_x + _arrow_w && _my >= _difficulty_y - _arrow_h * 0.5 && _my <= _difficulty_y + _arrow_h * 0.5) {
            global.difficulty = (global.difficulty + 2) mod 3;
        } else if (_mx >= _right_x && _mx <= _right_x + _arrow_w && _my >= _difficulty_y - _arrow_h * 0.5 && _my <= _difficulty_y + _arrow_h * 0.5) {
            global.difficulty = (global.difficulty + 1) mod 3;
        } else if (_mx >= _ok_x && _mx <= _ok_x + _button_w && _my >= _button_y && _my <= _button_y + _button_h) {
            global.option_open = false;
        } else if (_mx >= _close_x && _mx <= _close_x + _button_w && _my >= _button_y && _my <= _button_y + _button_h) {
            global.option_open = false;
        }
    }

    if (_held && dragging_slider != -1) {
        var _value = clamp((_mx - _slider_x) / _slider_w, 0, 1);

        if (dragging_slider == 0) {
            global.bgm_volume = _value;
        } else {
            global.sfx_volume = _value;
            audio_sound_gain(sfx_vacuum, global.sfx_volume, 0);
            audio_sound_gain(sfx_vacuum_warning, global.sfx_volume, 0);
            audio_sound_gain(sfx_boom_explosion, global.sfx_volume, 0);
        }
    }

    if (!_held) {
        dragging_slider = -1;
    }

    exit;
}

if (keyboard_check_pressed(vk_up)) {
    selected_index = max(0, selected_index - 1);
}

if (keyboard_check_pressed(vk_down)) {
    selected_index = min(menu_button_count - 1, selected_index + 1);
}

var _selected_button = noone;

for (var _i = 0; _i < menu_button_count; _i += 1) {
    var _button = instance_find(menu_buttons[_i], 0);

    if (_button != noone) {
        if (_i == selected_index) {
            _button.image_xscale = button_normal_xscale[_i] * selected_scale;
            _button.image_yscale = button_normal_yscale[_i] * selected_scale;
            _selected_button = _button;
        } else {
            _button.image_xscale = button_normal_xscale[_i];
            _button.image_yscale = button_normal_yscale[_i];
        }

        var _button_width = sprite_get_width(_button.sprite_index) * abs(_button.image_xscale);
        var _button_height = sprite_get_height(_button.sprite_index) * abs(_button.image_yscale);
        _button.x = button_base_x[_i] + (button_base_width[_i] - _button_width) * 0.5;
        _button.y = button_base_y[_i] + (button_base_height[_i] - _button_height) * 0.5;
    }
}

if (_selected_button != noone) {
    var _arrow_height = sprite_get_height(sprite_index) * abs(image_yscale);
    var _selected_height = sprite_get_height(_selected_button.sprite_index) * abs(_selected_button.image_yscale);

    x = _selected_button.x + arrow_inset;
    y = _selected_button.y + _selected_height * 0.5 - _arrow_height * 0.5;
}

var _mouse_pressed = mouse_check_button_pressed(mb_left);
var _button_clicked = false;

if (_mouse_pressed) {
    var _mx = mouse_x;
    var _my = mouse_y;

    for (var _i = 0; _i < menu_button_count; _i += 1) {
        var _button = instance_find(menu_buttons[_i], 0);

        if (_button != noone) {
            var _button_width = sprite_get_width(_button.sprite_index) * abs(_button.image_xscale);
            var _button_height = sprite_get_height(_button.sprite_index) * abs(_button.image_yscale);

            if (_mx >= _button.x && _mx <= _button.x + _button_width && _my >= _button.y && _my <= _button.y + _button_height) {
                selected_index = _i;
                _button_clicked = true;
                break;
            }
        }
    }
}

if (keyboard_check_pressed(vk_enter) || _button_clicked) {
    switch (selected_index) {
        case 0:
            room_goto(Maze);
            break;

        case 1:
            global.option_open = true;
            break;

        case 2:
            game_end();
            break;
    }
}
