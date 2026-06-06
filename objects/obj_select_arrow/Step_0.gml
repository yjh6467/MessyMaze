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

if (keyboard_check_pressed(vk_enter)) {
    switch (selected_index) {
        case 0:
            room_goto(Maze);
            break;

        case 1:
            break;

        case 2:
            game_end();
            break;
    }
}
