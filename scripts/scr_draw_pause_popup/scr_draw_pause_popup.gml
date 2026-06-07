function scr_draw_pause_popup() {
    if (!variable_global_exists("game_paused") || !global.game_paused) return;
    if (variable_global_exists("game_cleared") && global.game_cleared) return;
    if (variable_global_exists("game_over") && global.game_over) return;

    var _gui_w = max(1, display_get_gui_width());
    var _gui_h = max(1, display_get_gui_height());
    var _popup_w = min(640, _gui_w - 80);
    var _popup_h = 360;
    var _popup_x = round((_gui_w - _popup_w) * 0.5);
    var _popup_y = round((_gui_h - _popup_h) * 0.5);
    var _button_w = 180;
    var _button_h = 50;
    var _button_gap = 18;
    var _button_y = round(_popup_y + _popup_h - 88);
    var _buttons_w = _button_w * 3 + _button_gap * 2;
    var _resume_x = round(_popup_x + (_popup_w - _buttons_w) * 0.5);
    var _retry_x = round(_resume_x + _button_w + _button_gap);
    var _menu_x = round(_retry_x + _button_w + _button_gap);
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);

    var _resume_hover = point_in_rectangle(_mx, _my, _resume_x, _button_y, _resume_x + _button_w, _button_y + _button_h);
    var _retry_hover = point_in_rectangle(_mx, _my, _retry_x, _button_y, _retry_x + _button_w, _button_y + _button_h);
    var _menu_hover = point_in_rectangle(_mx, _my, _menu_x, _button_y, _menu_x + _button_w, _button_y + _button_h);

    var _neon_blue = make_color_rgb(45, 220, 255);
    var _glow_blue = make_color_rgb(95, 235, 255);
    var _panel_blue = make_color_rgb(2, 8, 24);
    var _button_blue = make_color_rgb(4, 22, 58);
    var _lime = make_color_rgb(183, 255, 26);

    draw_set_alpha(1);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_set_color(c_black);
    draw_set_alpha(0.68);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);

    draw_set_color(_glow_blue);
    draw_set_alpha(0.18);
    draw_rectangle(_popup_x - 10, _popup_y - 10, _popup_x + _popup_w + 10, _popup_y + _popup_h + 10, true);
    draw_set_alpha(0.3);
    draw_rectangle(_popup_x - 5, _popup_y - 5, _popup_x + _popup_w + 5, _popup_y + _popup_h + 5, true);

    draw_set_color(_panel_blue);
    draw_set_alpha(0.98);
    draw_rectangle(_popup_x, _popup_y, _popup_x + _popup_w, _popup_y + _popup_h, false);

    draw_set_color(_neon_blue);
    draw_set_alpha(1);
    draw_rectangle(_popup_x, _popup_y, _popup_x + _popup_w, _popup_y + _popup_h, true);
    draw_set_alpha(0.38);
    draw_rectangle(_popup_x + 8, _popup_y + 8, _popup_x + _popup_w - 8, _popup_y + _popup_h - 8, true);

    draw_set_alpha(1);
    draw_set_color(_lime);
    draw_text(round(_gui_w * 0.5), round(_popup_y + 76), "일시정지");

    draw_set_color(c_white);
    draw_text(round(_gui_w * 0.5), round(_popup_y + 138), "게임이 멈췄습니다");

    draw_set_color(_lime);
    draw_set_alpha(_resume_hover ? 0.3 : 0.14);
    draw_rectangle(_resume_x - 3, _button_y - 3, _resume_x + _button_w + 3, _button_y + _button_h + 3, false);
    draw_set_color(_button_blue);
    draw_set_alpha(_resume_hover ? 0.96 : 0.84);
    draw_rectangle(_resume_x, _button_y, _resume_x + _button_w, _button_y + _button_h, false);
    draw_set_color(_lime);
    draw_set_alpha(0.9);
    draw_rectangle(_resume_x, _button_y, _resume_x + _button_w, _button_y + _button_h, true);
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_text(round(_resume_x + _button_w * 0.5), round(_button_y + _button_h * 0.5), "계속하기");

    draw_set_color(_neon_blue);
    draw_set_alpha(_retry_hover ? 0.3 : 0.14);
    draw_rectangle(_retry_x - 3, _button_y - 3, _retry_x + _button_w + 3, _button_y + _button_h + 3, false);
    draw_set_color(_button_blue);
    draw_set_alpha(_retry_hover ? 0.96 : 0.84);
    draw_rectangle(_retry_x, _button_y, _retry_x + _button_w, _button_y + _button_h, false);
    draw_set_color(_neon_blue);
    draw_set_alpha(0.9);
    draw_rectangle(_retry_x, _button_y, _retry_x + _button_w, _button_y + _button_h, true);
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_text(round(_retry_x + _button_w * 0.5), round(_button_y + _button_h * 0.5), "다시하기");

    draw_set_color(_neon_blue);
    draw_set_alpha(_menu_hover ? 0.3 : 0.14);
    draw_rectangle(_menu_x - 3, _button_y - 3, _menu_x + _button_w + 3, _button_y + _button_h + 3, false);
    draw_set_color(_button_blue);
    draw_set_alpha(_menu_hover ? 0.96 : 0.84);
    draw_rectangle(_menu_x, _button_y, _menu_x + _button_w, _button_y + _button_h, false);
    draw_set_color(_neon_blue);
    draw_set_alpha(0.9);
    draw_rectangle(_menu_x, _button_y, _menu_x + _button_w, _button_y + _button_h, true);
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_text(round(_menu_x + _button_w * 0.5), round(_button_y + _button_h * 0.5), "메인 메뉴");

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);
}
