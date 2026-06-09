draw_set_alpha(0.3);
draw_set_color(c_red);
var _tile = variable_global_exists("tile_size") ? global.tile_size : 32;
if (dir_x != 0) {
    draw_rectangle(0, y, room_width, y + _tile, false);
} else {
    draw_rectangle(x, 0, x + _tile, room_height, false);
}
draw_set_alpha(1);
