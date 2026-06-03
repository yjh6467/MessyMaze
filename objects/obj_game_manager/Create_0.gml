global.tile_size = 32;
global.player_speed = 3;
global.bomb_spawn_interval = 180;
global.max_bomb_count = 3;
global.bomb_radius = 128;
global.bomb_warning_time = 300;
global.rocket_spawn_interval = 240;
global.rocket_warning_time = 180;
global.rocket_speed = 18;
global.score = 0;
global.score_slime_piece_value = 1;

if (instance_number(obj_rotating_wall_controller) <= 0) {
    instance_create_layer(0, 0, "Instances", obj_rotating_wall_controller);
}

if (instance_number(obj_rocket_manager) <= 0) {
    instance_create_layer(0, 0, "Instances", obj_rocket_manager);
}
