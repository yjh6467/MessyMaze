draw_self();

if (invisible_timer > 0) {
    draw_set_alpha(0.35);
    draw_set_color(c_aqua);
    draw_circle(scr_instance_center_x(id), scr_instance_center_y(id), 22, false);
    draw_set_alpha(1);
}

if (dash_cooldown > 0) {
    draw_set_color(c_lime);
    draw_rectangle(x, y - 5, x + 32 * (1 - dash_cooldown / dash_cooldown_max), y - 2, false);
}

if (invisible_cooldown > 0) {
    draw_set_color(make_color_rgb(180, 92, 255));
    draw_rectangle(x, y - 9, x + 32 * (1 - invisible_cooldown / invisible_cooldown_max), y - 6, false);
}
