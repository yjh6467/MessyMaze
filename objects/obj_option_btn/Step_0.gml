if (!variable_global_exists("option_open")) global.option_open = false;
if (!variable_global_exists("bgm_volume")) global.bgm_volume = 0.5;
if (!variable_global_exists("sfx_volume")) global.sfx_volume = 0.5;
if (!variable_global_exists("difficulty")) global.difficulty = 2;

if (global.option_open) {
    exit;
}

var _button_w = sprite_get_width(sprite_index) * abs(image_xscale);
var _button_h = sprite_get_height(sprite_index) * abs(image_yscale);
var _clicked = (
    mouse_x >= x
    && mouse_x <= x + _button_w
    && mouse_y >= y
    && mouse_y <= y + _button_h
);

if (mouse_check_button_pressed(mb_left) && _clicked) {
    if (instance_number(obj_option_popup) <= 0) {
        instance_create_layer(0, 0, "Instances", obj_option_popup);
    }

    global.option_open = true;
}
