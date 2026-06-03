draw_set_alpha(0.3);
draw_set_color(c_red);
if (dir_x != 0) {
    draw_rectangle(0, y, room_width, y + 32, false);
} else {
    draw_rectangle(x, 0, x + 32, room_height, false);
}
draw_set_alpha(1);
