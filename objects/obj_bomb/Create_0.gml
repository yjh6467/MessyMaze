BOMB_IDLE = 0;
BOMB_WARNING = 1;
BOMB_EXPLODE = 2;
BOMB_DESTROY = 3;

bomb_state = BOMB_IDLE;
bomb_radius = variable_global_exists("bomb_radius") ? global.bomb_radius : 64;
warning_time = variable_global_exists("bomb_warning_time") ? global.bomb_warning_time : 60;
state_timer = 0;
explode_time = 12;
