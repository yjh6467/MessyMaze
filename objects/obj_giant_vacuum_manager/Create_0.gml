VACUUM_WAIT = 0;
VACUUM_WARNING = 1;

vacuum_state = VACUUM_WAIT;
vacuum_interval = variable_global_exists("giant_vacuum_interval") ? global.giant_vacuum_interval : room_speed * 30;
warning_interval = variable_global_exists("giant_vacuum_warning_interval") ? global.giant_vacuum_warning_interval : room_speed * 2;
warning_count_max = variable_global_exists("giant_vacuum_warning_count") ? global.giant_vacuum_warning_count : 3;
warning_total_time = warning_interval * warning_count_max;
event_timer = max(1, vacuum_interval - warning_total_time);
warning_timer = 0;
warning_count = 0;
