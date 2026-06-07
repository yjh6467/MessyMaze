function scr_player_hit(_reason) {
    if (!instance_exists(obj_player)) return;
    if (variable_global_exists("game_paused") && global.game_paused) return;
    if (variable_global_exists("game_cleared") && global.game_cleared) return;
    if (variable_global_exists("game_over") && global.game_over) return;

    global.last_hit_reason = _reason;

    with (obj_player) {
        if (!variable_instance_exists(id, "respawn_grace_timer")) respawn_grace_timer = 0;
        if (!variable_global_exists("player_lives")) global.player_lives = 2;

        if (!is_dead && invisible_timer <= 0 && respawn_grace_timer <= 0) {
            global.player_lives = max(0, global.player_lives - 1);
            if (global.player_lives <= 0) {
                global.game_over = true;
                show_debug_message("GAME OVER");
                exit;
            }

            is_dead = true;
            death_timer = 45;
            image_blend = c_red;
        }
    }
}
