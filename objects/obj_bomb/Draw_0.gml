var _cx = x + 16;
var _cy = y + 16;

if (bomb_state == BOMB_IDLE || bomb_state == BOMB_WARNING) {
    var _flash = (state_timer div 6) mod 2;
    draw_set_alpha(0.25);
    draw_set_color(c_red);
    draw_circle(_cx, _cy, bomb_radius, false);
    draw_set_alpha(1);

    var _warn_scale = 32 / sprite_get_width(sprite_index);
    var _warn_x = _cx - sprite_get_width(sprite_index) * _warn_scale * 0.5;
    var _warn_y = _cy - sprite_get_height(sprite_index) * _warn_scale * 0.5;
    draw_sprite_ext(sprite_index, 0, _warn_x, _warn_y, _warn_scale, _warn_scale, image_angle, _flash == 0 ? c_white : c_yellow, 1);
}

if (bomb_state == BOMB_EXPLODE) {
    draw_set_alpha(0.45);
    draw_set_color(c_orange);
    draw_circle(_cx, _cy, bomb_radius, false);
    draw_set_alpha(1);

    var _explode_scale = (bomb_radius * 2) / sprite_get_width(sprite_index);
    var _explode_x = _cx - sprite_get_width(sprite_index) * _explode_scale * 0.5;
    var _explode_y = _cy - sprite_get_height(sprite_index) * _explode_scale * 0.5;
    draw_sprite_ext(sprite_index, image_index, _explode_x, _explode_y, _explode_scale, _explode_scale, image_angle, c_white, 1);
}
