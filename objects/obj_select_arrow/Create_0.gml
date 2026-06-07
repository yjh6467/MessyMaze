depth = -20000;

if (!variable_global_exists("option_open")) global.option_open = false;
if (!variable_global_exists("bgm_volume")) global.bgm_volume = 0.8;
if (!variable_global_exists("sfx_volume")) global.sfx_volume = 0.7;
if (!variable_global_exists("difficulty")) global.difficulty = 1;

menu_buttons = [obj_gamestart_btn, obj_option_btn, obj_quit_btn];
menu_button_count = array_length(menu_buttons);
selected_index = 0;
selected_scale = 1.08;
arrow_inset = 32;

button_base_x = array_create(menu_button_count, 0);
button_base_y = array_create(menu_button_count, 0);
button_base_width = array_create(menu_button_count, 0);
button_base_height = array_create(menu_button_count, 0);
button_normal_xscale = array_create(menu_button_count, 1);
button_normal_yscale = array_create(menu_button_count, 1);

if (abs(image_xscale) > 0.2) {
    image_xscale = 0.04;
}

if (abs(image_yscale) > 0.2) {
    image_yscale = 0.04;
}

var _closest_distance = 100000000;

for (var _i = 0; _i < menu_button_count; _i += 1) {
    var _button = instance_find(menu_buttons[_i], 0);

    if (_button != noone) {
        button_base_x[_i] = _button.x;
        button_base_y[_i] = _button.y;
        button_normal_xscale[_i] = _button.image_xscale;
        button_normal_yscale[_i] = _button.image_yscale;
        button_base_width[_i] = sprite_get_width(_button.sprite_index) * abs(_button.image_xscale);
        button_base_height[_i] = sprite_get_height(_button.sprite_index) * abs(_button.image_yscale);

        var _center_x = _button.x + button_base_width[_i] * 0.5;
        var _center_y = _button.y + button_base_height[_i] * 0.5;
        var _distance = point_distance(x, y, _center_x, _center_y);

        if (_distance < _closest_distance) {
            _closest_distance = _distance;
            selected_index = _i;
        }
    }
}
