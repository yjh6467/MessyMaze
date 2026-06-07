function scr_apply_difficulty_settings() {
    if (!variable_global_exists("difficulty")) global.difficulty = 2;

    var _difficulty = round(clamp(global.difficulty, 0, 4));
    global.difficulty = _difficulty;

    var _difficulty_name = "NORMAL";
    switch (_difficulty) {
        case 0:
            _difficulty_name = "TEST";
            break;

        case 1:
            _difficulty_name = "EASY";
            break;

        case 2:
            _difficulty_name = "NORMAL";
            break;

        case 3:
            _difficulty_name = "HARD";
            break;

        case 4:
            _difficulty_name = "INFINITE";
            break;
    }

    global.tile_size = 32;

    global.player_speed = 3;
    global.player_dash_distance = 96;
    global.player_dash_speed = 12;
    global.player_dash_cooldown = 90;
    global.player_stealth_duration = 300;
    global.player_stealth_cooldown = 240;
    global.player_lives_max = 2;

    global.bomb_spawn_interval = 180;
    global.max_bomb_count = 3;
    global.bomb_spawn_radius = 128;
    global.bomb_radius = 128;
    global.bomb_spawn_attempts = 30;
    global.bomb_spawn_distance_min = 64;
    global.bomb_min_distance = 96;
    global.bomb_warning_time = 300;

    global.rocket_spawn_interval = 240;
    global.rocket_warning_time = 180;
    global.rocket_speed = 18;
    global.rocket_lifetime = 180;

    global.monster_patrol_speed = 1.7;
    global.monster_chase_speed = 2.5;
    global.monster_sight_radius = global.tile_size * 8;
    global.monster_lose_radius = global.tile_size * 11;
    global.monster_rotating_avoid_radius = global.tile_size * 4;
    global.monster_direction_interval = 18;
    global.monster_chase_memory = 45;
    global.monster_respawn_delay = room_speed * 5;

    global.rotating_wall_speed = 0.75;

    global.giant_vacuum_interval = room_speed * 30;
    global.giant_vacuum_warning_interval = room_speed * 2;
    global.giant_vacuum_warning_count = 3;
    global.giant_vacuum_speed = 8;
    global.giant_vacuum_hit_margin_x = 100;
    global.giant_vacuum_hit_margin_y = 100;
    global.giant_vacuum_spawn_extra_y = 300;

    if (_difficulty == 1) {
        global.player_lives_max = 4;

        global.bomb_spawn_interval = room_speed * 5;
        global.max_bomb_count = 2;
        global.bomb_radius = global.tile_size * 2;

        global.rocket_spawn_interval = room_speed * 6;
        global.rocket_warning_time = room_speed * 4;

        global.monster_chase_speed = 2.0;

        global.rotating_wall_speed = 0.55;

        global.giant_vacuum_interval = room_speed * 60;
    }

    if (_difficulty == 2) {
        global.player_lives_max = 3;

        global.bomb_spawn_interval = room_speed * 4;
        global.max_bomb_count = 3;
        global.bomb_radius = global.tile_size * 3;

        global.rocket_spawn_interval = room_speed * 5;
        global.rocket_warning_time = room_speed * 3;

        global.monster_chase_speed = 2.25;

        global.rotating_wall_speed = 0.75;

        global.giant_vacuum_interval = room_speed * 45;
    }

    if (_difficulty == 3) {
        global.player_lives_max = 2;

        global.bomb_spawn_interval = room_speed * 3;
        global.max_bomb_count = 3;
        global.bomb_warning_time = round(room_speed * 4.5);

        global.rocket_spawn_interval = room_speed * 4;
        global.rocket_warning_time = round(room_speed * 2.5);

        global.monster_chase_speed = 2.6;
        global.monster_sight_radius = global.tile_size * 9;

        global.rotating_wall_speed = 0.9;

        global.giant_vacuum_interval = room_speed * 30;
    }

    if (_difficulty == 4) {
        // TODO: Add endless-mode specific scoring/spawn/clear rules.
        global.player_lives_max = 2;

        global.bomb_spawn_interval = room_speed * 3;
        global.max_bomb_count = 3;
        global.bomb_warning_time = round(room_speed * 4.5);

        global.rocket_spawn_interval = room_speed * 4;
        global.rocket_warning_time = round(room_speed * 2.5);

        global.monster_chase_speed = 2.6;
        global.monster_sight_radius = global.tile_size * 9;

        global.rotating_wall_speed = 0.9;

        global.giant_vacuum_interval = room_speed * 30;
    }

    show_debug_message("Difficulty Applied: " + _difficulty_name);
    show_debug_message("Bomb interval: " + string(global.bomb_spawn_interval));
    show_debug_message("Bomb spawn radius: " + string(global.bomb_spawn_radius));
    show_debug_message("Bomb explosion radius: " + string(global.bomb_radius));
    show_debug_message("Rocket interval: " + string(global.rocket_spawn_interval));
    show_debug_message("Monster chase speed: " + string(global.monster_chase_speed));
}
