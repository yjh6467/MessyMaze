BOMB_IDLE = 0;
BOMB_WARNING = 1;
BOMB_EXPLODE = 2;
BOMB_DESTROY = 3;

bomb_state = BOMB_WARNING;
bomb_radius = variable_global_exists("bomb_radius") ? global.bomb_radius : 128;
warning_time = variable_global_exists("bomb_warning_time") ? global.bomb_warning_time : 300;
state_timer = warning_time;
explode_time = 12;
sprite_index = spr_boom;
image_index = 0;
image_speed = 0;
