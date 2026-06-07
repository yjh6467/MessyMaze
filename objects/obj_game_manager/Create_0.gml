if (!variable_global_exists("option_open")) global.option_open = false;
if (!variable_global_exists("bgm_volume")) global.bgm_volume = 0.8;
if (!variable_global_exists("sfx_volume")) global.sfx_volume = 0.7;
if (!variable_global_exists("difficulty")) global.difficulty = 2;

scr_apply_difficulty_settings();

global.score = 0;
global.score_slime_piece_value = 1;
global.elapsed_time = 0;
global.slime_piece_anim_tick = 0;
global.slime_piece_anim_frame_hold = max(1, round(room_speed / 8));
global.slime_piece_anim_index = 0;
global.player_lives = variable_global_exists("player_lives_max") ? global.player_lives_max : 2;
global.slime_count = 0;
global.total_slime_count = instance_number(obj_score_slime_piece);
if (global.difficulty == 0) {
    global.score = global.total_slime_count * global.score_slime_piece_value;
    global.slime_count = global.total_slime_count;
}
global.exit_open = false;
global.game_cleared = false;
global.game_over = false;
scr_set_game_paused(false);

if (instance_number(obj_exit_wall) > 0) {
    var _exit_wall = instance_find(obj_exit_wall, 0);
    global.clear_exit_x = (_exit_wall.bbox_left + _exit_wall.bbox_right) * 0.5;
    global.clear_exit_y = (_exit_wall.bbox_top + _exit_wall.bbox_bottom) * 0.5;
} else {
    // TODO: Place obj_exit_wall in Maze to define the clear exit position.
    global.clear_exit_x = room_width * 0.5;
    global.clear_exit_y = room_height - 32;
}

if (instance_number(obj_clear_exit) <= 0) {
    instance_create_layer(global.clear_exit_x, global.clear_exit_y, "Instances", obj_clear_exit);
}

scr_check_exit_open();

audio_stop_sound(sfx_vacuum);
audio_stop_sound(sfx_vacuum_warning);

if (instance_number(obj_rotating_wall_controller) <= 0) {
    instance_create_layer(0, 0, "Instances", obj_rotating_wall_controller);
}

if (instance_number(obj_rocket_manager) <= 0) {
    instance_create_layer(0, 0, "Instances", obj_rocket_manager);
}

if (instance_number(obj_giant_vacuum_manager) <= 0) {
    instance_create_layer(0, 0, "Instances", obj_giant_vacuum_manager);
}

if (instance_number(obj_game_hud) <= 0) {
    instance_create_layer(0, 0, "Instances", obj_game_hud);
}
