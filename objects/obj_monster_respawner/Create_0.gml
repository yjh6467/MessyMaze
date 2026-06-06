respawn_timer = variable_global_exists("monster_respawn_delay") ? global.monster_respawn_delay : room_speed * 5;
respawn_object = noone;
respawn_x = 0;
respawn_y = 0;
respawn_xscale = 0.08;
respawn_yscale = 0.08;
