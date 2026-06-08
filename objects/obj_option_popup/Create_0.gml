depth = -30000;
dragging_slider = -1;

if (!variable_global_exists("option_open")) global.option_open = false;
if (!variable_global_exists("bgm_volume")) global.bgm_volume = 0.5;
if (!variable_global_exists("sfx_volume")) global.sfx_volume = 0.5;
if (!variable_global_exists("difficulty")) global.difficulty = 2;
scr_apply_audio_volumes();
