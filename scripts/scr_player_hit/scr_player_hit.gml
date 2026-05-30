function scr_player_hit(_reason) {
    if (!instance_exists(obj_player)) return;

    global.last_hit_reason = _reason;

    with (obj_player) {
        if (!is_dead && invisible_timer <= 0) {
            is_dead = true;
            death_timer = 45;
            image_blend = c_red;
        }
    }
}
