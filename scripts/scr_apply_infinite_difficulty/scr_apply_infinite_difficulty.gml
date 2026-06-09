function scr_apply_infinite_difficulty(_minute, _force) {
    if (!variable_global_exists("tile_size")) global.tile_size = 32;

    var _tier = floor(clamp(_minute, 0, 10));
    var _previous_tier = variable_global_exists("infinite_difficulty_tier") ? global.infinite_difficulty_tier : -1;

    if (!_force && _previous_tier == _tier) {
        return;
    }

    global.infinite_difficulty_tier = _tier;

    var _bomb_interval = [5.0, 4.8, 4.5, 4.0, 3.8, 3.5, 3.2, 3.0, 2.8, 2.6, 2.4];
    var _bomb_max = [2, 2, 2, 3, 3, 3, 3, 3, 4, 4, 4];
    var _bomb_range_tiles = [2, 2, 3, 3, 3, 4, 4, 4, 4, 4, 5];
    var _bomb_warning = [5.0, 5.0, 5.0, 5.0, 4.8, 4.8, 4.6, 4.5, 4.3, 4.1, 4.0];
    var _rocket_interval = [6.0, 5.8, 5.5, 5.0, 4.7, 4.4, 4.2, 4.0, 3.7, 3.4, 3.0];
    var _rocket_warning = [4.0, 3.8, 3.5, 3.0, 2.8, 2.7, 2.6, 2.5, 2.3, 2.1, 2.0];
    var _monster_chase = [2.0, 2.05, 2.15, 2.25, 2.35, 2.45, 2.55, 2.6, 2.75, 2.9, 3.05];
    var _monster_sight_tiles = [8, 8, 8, 8, 8, 9, 9, 9, 9, 10, 10];
    var _rotating_speed = [0.55, 0.6, 0.68, 0.75, 0.8, 0.85, 0.88, 0.9, 1.0, 1.1, 1.2];
    var _vacuum_interval = [60, 55, 50, 45, 40, 35, 32, 30, 28, 25, 22];

    global.player_lives_max = 3;

    global.bomb_spawn_interval = max(1, round(room_speed * _bomb_interval[_tier]));
    global.max_bomb_count = _bomb_max[_tier];
    global.bomb_spawn_radius = global.tile_size * 4;
    global.bomb_radius = global.tile_size * _bomb_range_tiles[_tier];
    global.bomb_warning_time = max(1, round(room_speed * _bomb_warning[_tier]));

    global.rocket_spawn_interval = max(1, round(room_speed * _rocket_interval[_tier]));
    global.rocket_warning_time = max(1, round(room_speed * _rocket_warning[_tier]));

    global.monster_chase_speed = _monster_chase[_tier];
    global.monster_sight_radius = global.tile_size * _monster_sight_tiles[_tier];

    global.rotating_wall_speed = _rotating_speed[_tier];

    global.giant_vacuum_interval = max(1, round(room_speed * _vacuum_interval[_tier]));

    with (obj_bomb_manager) {
        if (!variable_instance_exists(id, "spawn_timer")) spawn_timer = global.bomb_spawn_interval;
        if (!variable_instance_exists(id, "spawn_radius")) spawn_radius = global.bomb_spawn_radius;
        if (!variable_instance_exists(id, "spawn_attempts")) spawn_attempts = variable_global_exists("bomb_spawn_attempts") ? global.bomb_spawn_attempts : 30;
        if (!variable_instance_exists(id, "spawn_distance_min")) spawn_distance_min = variable_global_exists("bomb_spawn_distance_min") ? global.bomb_spawn_distance_min : 64;
        if (!variable_instance_exists(id, "min_bomb_distance")) min_bomb_distance = variable_global_exists("bomb_min_distance") ? global.bomb_min_distance : 96;

        spawn_timer = min(spawn_timer, global.bomb_spawn_interval);
        spawn_radius = global.bomb_spawn_radius;
        spawn_attempts = variable_global_exists("bomb_spawn_attempts") ? global.bomb_spawn_attempts : spawn_attempts;
        spawn_distance_min = variable_global_exists("bomb_spawn_distance_min") ? global.bomb_spawn_distance_min : spawn_distance_min;
        min_bomb_distance = variable_global_exists("bomb_min_distance") ? global.bomb_min_distance : min_bomb_distance;
    }

    with (obj_rocket_manager) {
        if (!variable_instance_exists(id, "spawn_timer")) spawn_timer = global.rocket_spawn_interval;
        if (!variable_instance_exists(id, "tile_size")) tile_size = global.tile_size;

        spawn_timer = min(spawn_timer, global.rocket_spawn_interval);
        tile_size = global.tile_size;
    }

    with (obj_giant_vacuum_manager) {
        if (!variable_instance_exists(id, "VACUUM_WAIT")) VACUUM_WAIT = 0;
        if (!variable_instance_exists(id, "vacuum_state")) vacuum_state = VACUUM_WAIT;
        if (!variable_instance_exists(id, "warning_interval")) warning_interval = variable_global_exists("giant_vacuum_warning_interval") ? global.giant_vacuum_warning_interval : room_speed * 2;
        if (!variable_instance_exists(id, "warning_count_max")) warning_count_max = variable_global_exists("giant_vacuum_warning_count") ? global.giant_vacuum_warning_count : 3;
        if (!variable_instance_exists(id, "warning_total_time")) warning_total_time = warning_interval * warning_count_max;
        if (!variable_instance_exists(id, "event_timer")) event_timer = max(1, global.giant_vacuum_interval - warning_total_time);

        vacuum_interval = global.giant_vacuum_interval;
        warning_interval = variable_global_exists("giant_vacuum_warning_interval") ? global.giant_vacuum_warning_interval : warning_interval;
        warning_count_max = variable_global_exists("giant_vacuum_warning_count") ? global.giant_vacuum_warning_count : warning_count_max;
        warning_total_time = warning_interval * warning_count_max;

        if (vacuum_state == VACUUM_WAIT) {
            event_timer = min(event_timer, max(1, vacuum_interval - warning_total_time));
        }
    }

    with (obj_rotating_wall_controller) {
        rotation_speed = global.rotating_wall_speed;
    }

    var _monster_objects = [obj_monster1, obj_monster2, obj_monster3, obj_monster4];
    for (var _i = 0; _i < array_length(_monster_objects); _i += 1) {
        with (_monster_objects[_i]) {
            chase_speed = global.monster_chase_speed;
            sight_radius = global.monster_sight_radius;
        }
    }

    with (obj_giant_vacuum) {
        if (!variable_instance_exists(id, "move_speed")) move_speed = variable_global_exists("giant_vacuum_speed") ? global.giant_vacuum_speed : 8;

        move_speed = variable_global_exists("giant_vacuum_speed") ? global.giant_vacuum_speed : move_speed;
    }

    scr_debug_log(
        "Infinite difficulty tier: "
        + string(_tier)
        + " / bomb "
        + string(global.bomb_spawn_interval)
        + " / rocket "
        + string(global.rocket_spawn_interval)
        + " / monster "
        + string(global.monster_chase_speed)
    );
}
