depth = -30000;
visible = true;
global.hud_height = 96;
display_set_gui_size(1600, 1056);

if (instance_number(obj_game_hud) > 1) {
    instance_destroy();
    exit;
}

hud_start_time_ms = current_time;
hud_elapsed_frames = 0;
result_popup_sound_state = 0;

if (!variable_global_exists("elapsed_time")) global.elapsed_time = 0;
if (!variable_global_exists("game_paused")) global.game_paused = false;
if (!variable_global_exists("gameplay_frozen")) global.gameplay_frozen = false;
if (!variable_global_exists("player_lives")) global.player_lives = 2;
if (!variable_global_exists("slime_count")) global.slime_count = variable_global_exists("score") ? global.score : 0;

// score currently tracks collected slime pieces, so total starts as collected + remaining placed pieces.
if (variable_global_exists("difficulty") && global.difficulty == 0) {
    global.total_slime_count = instance_number(obj_score_slime_piece);
    global.slime_count = global.total_slime_count;
    global.score = global.total_slime_count;
} else {
    global.total_slime_count = global.slime_count + instance_number(obj_score_slime_piece);
}
