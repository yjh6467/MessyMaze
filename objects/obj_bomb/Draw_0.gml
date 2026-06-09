var _cx = x + 16;
var _cy = y + 16;
var _tile = variable_global_exists("tile_size") ? global.tile_size : 32;

if (bomb_state == BOMB_IDLE || bomb_state == BOMB_WARNING) {
    var _flash = (state_timer div 6) mod 2;
    draw_set_alpha(0.25);
    draw_set_color(c_red);
    for (var _i = 0; _i < array_length(bomb_range_offsets_x); _i += 1) {
        var _cell_cx = _cx + bomb_range_offsets_x[_i] * _tile;
        var _cell_cy = _cy + bomb_range_offsets_y[_i] * _tile;
        draw_rectangle(_cell_cx - _tile * 0.5, _cell_cy - _tile * 0.5, _cell_cx + _tile * 0.5, _cell_cy + _tile * 0.5, false);
    }
    draw_set_alpha(1);

    var _warn_scale = 32 / sprite_get_width(sprite_index);
    var _warn_x = _cx - sprite_get_width(sprite_index) * _warn_scale * 0.5;
    var _warn_y = _cy - sprite_get_height(sprite_index) * _warn_scale * 0.5;
    draw_sprite_ext(sprite_index, 0, _warn_x, _warn_y, _warn_scale, _warn_scale, image_angle, _flash == 0 ? c_white : c_yellow, 1);
}

if (bomb_state == BOMB_EXPLODE) {
    draw_set_alpha(0.45);
    draw_set_color(c_orange);
    for (var _i = 0; _i < array_length(bomb_range_offsets_x); _i += 1) {
        var _cell_cx = _cx + bomb_range_offsets_x[_i] * _tile;
        var _cell_cy = _cy + bomb_range_offsets_y[_i] * _tile;
        draw_rectangle(_cell_cx - _tile * 0.5, _cell_cy - _tile * 0.5, _cell_cx + _tile * 0.5, _cell_cy + _tile * 0.5, false);
    }
    draw_set_alpha(1);

    var _explode_scale = 32 / sprite_get_width(sprite_index);
    var _explode_x = _cx - sprite_get_width(sprite_index) * _explode_scale * 0.5;
    var _explode_y = _cy - sprite_get_height(sprite_index) * _explode_scale * 0.5;
    draw_sprite_ext(sprite_index, image_index, _explode_x, _explode_y, _explode_scale, _explode_scale, image_angle, c_white, 1);
}
