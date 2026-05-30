var _cx = x + 16;
var _cy = y + 16;

if (bomb_state == BOMB_IDLE) {
    draw_set_color(c_black);
    draw_circle(_cx, _cy, 12, false);
    draw_set_color(c_yellow);
    draw_circle(_cx + 5, _cy - 6, 3, false);
}

if (bomb_state == BOMB_WARNING) {
    var _flash = (state_timer div 6) mod 2;
    draw_set_alpha(0.25);
    draw_set_color(c_red);
    draw_circle(_cx, _cy, bomb_radius, false);
    draw_set_alpha(1);
    draw_set_color(_flash == 0 ? c_red : c_yellow);
    draw_circle(_cx, _cy, 13, false);
}

if (bomb_state == BOMB_EXPLODE) {
    draw_set_alpha(0.45);
    draw_set_color(c_orange);
    draw_circle(_cx, _cy, bomb_radius, false);
    draw_set_alpha(1);
}
