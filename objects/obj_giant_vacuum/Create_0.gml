vacuum_width = sprite_get_width(sprite_index) * abs(image_xscale);
vacuum_height = sprite_get_height(sprite_index) * abs(image_yscale);
depth = -10000;
move_speed = variable_global_exists("giant_vacuum_speed") ? global.giant_vacuum_speed : 8;
hit_margin_x = variable_global_exists("giant_vacuum_hit_margin_x") ? global.giant_vacuum_hit_margin_x : 100;
hit_margin_y = variable_global_exists("giant_vacuum_hit_margin_y") ? global.giant_vacuum_hit_margin_y : 100;
image_speed = 1;

vacuum_sound = audio_play_sound(sfx_vacuum, 10, false);
audio_sound_gain(vacuum_sound, variable_global_exists("sfx_volume") ? global.sfx_volume : 0.5, 0);
