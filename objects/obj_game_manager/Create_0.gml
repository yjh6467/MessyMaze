if (!variable_global_exists("option_open")) global.option_open = false;
if (!variable_global_exists("bgm_volume")) global.bgm_volume = 0.8;
if (!variable_global_exists("sfx_volume")) global.sfx_volume = 0.7;
if (!variable_global_exists("difficulty")) global.difficulty = 1;

global.tile_size = 32;
global.player_speed = 3;
global.bomb_spawn_interval = 180;
global.max_bomb_count = 3;
global.bomb_radius = 128;
global.bomb_warning_time = 300;
global.rocket_spawn_interval = 240;
global.rocket_warning_time = 180;
global.rocket_speed = 18;
global.giant_vacuum_interval = room_speed * 30;
global.giant_vacuum_warning_interval = room_speed * 2;
global.giant_vacuum_warning_count = 3;
global.giant_vacuum_speed = 8;
global.giant_vacuum_hit_margin_x = 100;
global.giant_vacuum_hit_margin_y = 100;
global.giant_vacuum_spawn_extra_y = 300;
global.monster_respawn_delay = room_speed * 5;
global.score = 0;
global.score_slime_piece_value = 1;

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
