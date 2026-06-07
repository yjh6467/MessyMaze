function scr_draw_result_popup(_time_text, _lives, _slime, _total_slime) {
    var _is_clear = variable_global_exists("game_cleared") && global.game_cleared;
    var _gui_w = max(1, display_get_gui_width());
    var _gui_h = max(1, display_get_gui_height());
    var _popup_w = min(720, _gui_w - 80);
    var _popup_h = 420;
    var _popup_x = round((_gui_w - _popup_w) * 0.5);
    var _popup_y = round((_gui_h - _popup_h) * 0.5);
    var _button_w = 190;
    var _button_h = 50;
    var _button_gap = 28;
    var _button_y = round(_popup_y + _popup_h - 82);
    var _retry_x = round(_popup_x + (_popup_w - (_button_w * 2 + _button_gap)) * 0.5);
    var _menu_x = round(_retry_x + _button_w + _button_gap);
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);
    var _retry_hover = point_in_rectangle(_mx, _my, _retry_x, _button_y, _retry_x + _button_w, _button_y + _button_h);
    var _menu_hover = point_in_rectangle(_mx, _my, _menu_x, _button_y, _menu_x + _button_w, _button_y + _button_h);

    var _neon_blue = make_color_rgb(45, 220, 255);
    var _glow_blue = make_color_rgb(95, 235, 255);
    var _panel_blue = make_color_rgb(2, 8, 24);
    var _button_blue = make_color_rgb(4, 22, 58);
    var _lime = make_color_rgb(183, 255, 26);
    var _danger = make_color_rgb(255, 74, 61);
    var _title_color = _is_clear ? _lime : _danger;
    var _retry_accent = _is_clear ? _lime : _neon_blue;

    draw_set_alpha(1);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_set_color(c_black);
    draw_set_alpha(0.72);
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
    draw_set_color(_title_color);
    draw_text(round(_gui_w * 0.5), round(_popup_y + 68), _is_clear ? "게임 클리어!" : "게임 오버");

    draw_set_color(c_white);
    draw_text(round(_gui_w * 0.5), round(_popup_y + 118), _is_clear ? "모든 슬라임 조각을 모으고 출구에 도착했어요!" : "목숨을 모두 잃었어요... 다시 도전해볼까요?");

    var _row_x = round(_popup_x + 150);
    var _value_x = round(_popup_x + _popup_w - 150);
    var _row_y = round(_popup_y + 178);
    var _row_gap = 44;

    draw_set_halign(fa_left);
    draw_set_color(c_white);
    draw_text(_row_x, _row_y, _is_clear ? "경과 시간" : "생존 시간");
    draw_text(_row_x, _row_y + _row_gap, "남은 목숨");
    draw_text(_row_x, _row_y + _row_gap * 2, "모은 조각");

    draw_set_halign(fa_right);
    draw_set_color(_neon_blue);
    draw_text(_value_x, _row_y, _time_text);
    draw_set_color(_lime);
    draw_text(_value_x, _row_y + _row_gap, "x " + string(_lives));
    draw_text(_value_x, _row_y + _row_gap * 2, string(_slime) + " / " + string(_total_slime));

    draw_set_halign(fa_center);

    draw_set_color(_retry_accent);
    draw_set_alpha(_retry_hover ? 0.28 : 0.14);
    draw_rectangle(_retry_x - 3, _button_y - 3, _retry_x + _button_w + 3, _button_y + _button_h + 3, false);
    draw_set_color(_button_blue);
    draw_set_alpha(_retry_hover ? 0.96 : 0.84);
    draw_rectangle(_retry_x, _button_y, _retry_x + _button_w, _button_y + _button_h, false);
    draw_set_color(_retry_accent);
    draw_set_alpha(0.9);
    draw_rectangle(_retry_x, _button_y, _retry_x + _button_w, _button_y + _button_h, true);
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_text(round(_retry_x + _button_w * 0.5), round(_button_y + _button_h * 0.5), "다시하기");

    draw_set_color(_neon_blue);
    draw_set_alpha(_menu_hover ? 0.28 : 0.14);
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
