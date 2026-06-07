draw_self();

if (!variable_global_exists("option_open") || !global.option_open) {
    exit;
}

if (!variable_global_exists("bgm_volume")) global.bgm_volume = 0.8;
if (!variable_global_exists("sfx_volume")) global.sfx_volume = 0.7;
if (!variable_global_exists("difficulty")) global.difficulty = 1;

draw_set_font(fnt_korean_ui);

var _w = room_width;
var _h = room_height;
var _mx = mouse_x;
var _my = mouse_y;
var _box_w = 620;
var _box_h = 460;
var _box_x = (_w - _box_w) * 0.5;
var _box_y = (_h - _box_h) * 0.5;
var _box_r = _box_x + _box_w;
var _box_b = _box_y + _box_h;

var _neon_blue = make_color_rgb(45, 220, 255);
var _deep_blue = make_color_rgb(5, 14, 34);
var _panel_blue = make_color_rgb(9, 28, 56);
var _button_blue = make_color_rgb(8, 35, 68);
var _button_hover = make_color_rgb(16, 58, 96);
var _lime = make_color_rgb(176, 255, 52);
var _lime_hot = make_color_rgb(220, 255, 120);
var _muted = make_color_rgb(48, 83, 112);

function _draw_neon_button_world(_x, _y, _w, _h, _label, _mx, _my, _edge, _fill, _hover_fill) {
    var _hover = (_mx >= _x && _mx <= _x + _w && _my >= _y && _my <= _y + _h);

    draw_set_color(_edge);
    draw_set_alpha(_hover ? 0.3 : 0.18);
    draw_rectangle(_x - 8, _y - 8, _x + _w + 8, _y + _h + 8, false);
    draw_set_alpha(_hover ? 0.48 : 0.28);
    draw_rectangle(_x - 4, _y - 4, _x + _w + 4, _y + _h + 4, false);
    draw_set_alpha(1);
    draw_rectangle(_x - 1, _y - 1, _x + _w + 1, _y + _h + 1, false);
    draw_set_color(_hover ? _hover_fill : _fill);
    draw_rectangle(_x, _y, _x + _w, _y + _h, false);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text(_x + _w * 0.5, _y + _h * 0.5, _label);
}

draw_set_alpha(0.72);
draw_set_color(c_black);
draw_rectangle(0, 0, _w, _h, false);
draw_set_alpha(1);

draw_set_color(_neon_blue);
draw_set_alpha(0.12);
draw_rectangle(_box_x - 18, _box_y - 18, _box_r + 18, _box_b + 18, false);
draw_set_alpha(0.2);
draw_rectangle(_box_x - 11, _box_y - 11, _box_r + 11, _box_b + 11, false);
draw_set_alpha(0.35);
draw_rectangle(_box_x - 6, _box_y - 6, _box_r + 6, _box_b + 6, false);
draw_set_alpha(1);
draw_rectangle(_box_x - 2, _box_y - 2, _box_r + 2, _box_b + 2, false);

draw_set_color(_deep_blue);
draw_rectangle(_box_x, _box_y, _box_r, _box_b, false);
draw_set_color(_panel_blue);
draw_set_alpha(0.84);
draw_rectangle(_box_x + 14, _box_y + 14, _box_r - 14, _box_b - 14, false);
draw_set_alpha(1);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text(_box_x + _box_w * 0.5, _box_y + 58, "옵션");

var _slider_x = _box_x + 210;
var _slider_w = 260;
var _bgm_y = _box_y + 145;
var _sfx_y = _box_y + 215;
var _track_h = 12;

draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text(_slider_x - 150, _bgm_y, "BGM");
draw_set_color(_muted);
draw_rectangle(_slider_x, _bgm_y - _track_h * 0.5, _slider_x + _slider_w, _bgm_y + _track_h * 0.5, false);
draw_set_color(_lime);
draw_rectangle(_slider_x, _bgm_y - _track_h * 0.5, _slider_x + _slider_w * global.bgm_volume, _bgm_y + _track_h * 0.5, false);
draw_set_alpha(0.28);
draw_rectangle(_slider_x, _bgm_y - _track_h, _slider_x + _slider_w * global.bgm_volume, _bgm_y + _track_h, false);
draw_set_alpha(1);
draw_set_color(_lime_hot);
draw_circle(_slider_x + _slider_w * global.bgm_volume, _bgm_y, 9, false);
draw_set_color(_neon_blue);
draw_circle(_slider_x + _slider_w * global.bgm_volume, _bgm_y, 15, true);
draw_set_color(c_white);
draw_text(_slider_x + _slider_w + 28, _bgm_y, string(round(global.bgm_volume * 100)) + "%");

draw_set_color(c_white);
draw_text(_slider_x - 150, _sfx_y, "효과음");
draw_set_color(_muted);
draw_rectangle(_slider_x, _sfx_y - _track_h * 0.5, _slider_x + _slider_w, _sfx_y + _track_h * 0.5, false);
draw_set_color(_lime);
draw_rectangle(_slider_x, _sfx_y - _track_h * 0.5, _slider_x + _slider_w * global.sfx_volume, _sfx_y + _track_h * 0.5, false);
draw_set_alpha(0.28);
draw_rectangle(_slider_x, _sfx_y - _track_h, _slider_x + _slider_w * global.sfx_volume, _sfx_y + _track_h, false);
draw_set_alpha(1);
draw_set_color(_lime_hot);
draw_circle(_slider_x + _slider_w * global.sfx_volume, _sfx_y, 9, false);
draw_set_color(_neon_blue);
draw_circle(_slider_x + _slider_w * global.sfx_volume, _sfx_y, 15, true);
draw_set_color(c_white);
draw_text(_slider_x + _slider_w + 28, _sfx_y, string(round(global.sfx_volume * 100)) + "%");

var _difficulty_y = _box_y + 290;
var _difficulty_names = ["쉬움", "보통", "어려움"];
var _difficulty_index = round(clamp(global.difficulty, 0, 2));
var _difficulty_color = _lime;

switch (_difficulty_index) {
    case 0:
        _difficulty_color = make_color_rgb(94, 231, 255);
        break;

    case 1:
        _difficulty_color = make_color_rgb(183, 255, 26);
        break;

    case 2:
        _difficulty_color = make_color_rgb(255, 74, 61);
        break;
}

draw_set_halign(fa_left);
draw_set_color(c_white);
draw_text(_box_x + 60, _difficulty_y, "난이도");

_draw_neon_button_world(_box_x + 210, _difficulty_y - 21, 48, 42, "<", _mx, _my, _neon_blue, _button_blue, _button_hover);
_draw_neon_button_world(_box_x + 412, _difficulty_y - 21, 48, 42, ">", _mx, _my, _neon_blue, _button_blue, _button_hover);

draw_set_halign(fa_center);
draw_set_color(_difficulty_color);
draw_text(_box_x + 335, _difficulty_y, _difficulty_names[_difficulty_index]);

var _button_y = _box_y + _box_h - 92;
_draw_neon_button_world(_box_x + 145, _button_y, 150, 52, "확인", _mx, _my, _neon_blue, _button_blue, _button_hover);
_draw_neon_button_world(_box_x + _box_w - 295, _button_y, 150, 52, "닫기", _mx, _my, _neon_blue, _button_blue, _button_hover);

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);
