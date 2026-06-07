if (asset_get_index("fnt_galmuri11") != -1) {
    draw_set_font(fnt_galmuri11);
} else {
    // TODO: Add a Korean-capable HUD font if fnt_galmuri11 is unavailable.
    draw_set_font(-1);
}

if (!variable_global_exists("hud_height")) global.hud_height = 96;

var _hud_h = 96;
var _draw_w = room_width;
var _box_h = 60;
var _top = round((_hud_h - _box_h) * 0.5);

var _time_w = 250;
var _life_w = 230;
var _slime_w = 330;
var _left_x = 24;
var _center_x = round((_draw_w - _life_w) * 0.5);
var _right_x = round(_draw_w - 24 - _slime_w);

var _neon_blue = make_color_rgb(45, 220, 255);
var _glow_blue = make_color_rgb(95, 235, 255);
var _panel_blue = make_color_rgb(2, 8, 24);
var _lime = make_color_rgb(183, 255, 26);
var _white = c_white;

draw_set_alpha(1);
draw_set_valign(fa_middle);

draw_set_color(make_color_rgb(1, 8, 22));
draw_set_alpha(0.82);
draw_rectangle(0, 0, _draw_w, _hud_h, false);
draw_set_color(_neon_blue);
draw_set_alpha(0.55);
draw_rectangle(0, _hud_h - 2, _draw_w, _hud_h, false);

var _elapsed = variable_global_exists("elapsed_time") ? global.elapsed_time : 0;
var _minutes = floor(_elapsed / 60);
var _seconds = _elapsed mod 60;
var _minute_text = (_minutes < 10 ? "0" : "") + string(_minutes);
var _second_text = (_seconds < 10 ? "0" : "") + string(_seconds);
var _time_text = _minute_text + ":" + _second_text;

var _lives = variable_global_exists("player_lives") ? global.player_lives : 2;
var _slime = variable_global_exists("slime_count") ? global.slime_count : 0;
var _total_slime = variable_global_exists("total_slime_count") ? global.total_slime_count : instance_number(obj_score_slime_piece) + _slime;

for (var _i = 0; _i < 3; _i += 1) {
    var _box_w = (_i == 0) ? _life_w : ((_i == 1) ? _time_w : _slime_w);
    var _x = (_i == 0) ? _left_x : ((_i == 1) ? round((_draw_w - _time_w) * 0.5) : _right_x);
    var _y = round(clamp(_top, 0, _hud_h - _box_h));
    var _label = (_i == 0) ? "목숨" : ((_i == 1) ? "시간" : "조각");
    var _value = (_i == 0) ? "x " + string(_lives) : ((_i == 1) ? _time_text : string(_slime) + " / " + string(_total_slime));

    _x = round(_x);

    draw_set_color(_glow_blue);
    draw_set_alpha(0.18);
    draw_rectangle(_x - 4, _y - 4, _x + _box_w + 4, _y + _box_h + 4, true);

    draw_set_color(_panel_blue);
    draw_set_alpha(0.65);
    draw_rectangle(_x, _y, _x + _box_w, _y + _box_h, false);

    draw_set_color(_neon_blue);
    draw_set_alpha(0.85);
    draw_rectangle(_x, _y, _x + _box_w, _y + _box_h, true);

    var _label_x = round(_x + 18);
    var _value_x = round(_x + _box_w - 18);
    var _text_y = round(_y + _box_h * 0.5);

    draw_set_halign(fa_left);
    draw_set_color(_white);
    draw_text(_label_x, _text_y, _label);

    draw_set_halign(fa_right);
    draw_set_color(_lime);
    draw_text(_value_x, _text_y, _value);
}

if (
    (variable_global_exists("game_cleared") && global.game_cleared)
    || (variable_global_exists("game_over") && global.game_over)
) {
    scr_draw_result_popup(_time_text, _lives, _slime, _total_slime);
}

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);
