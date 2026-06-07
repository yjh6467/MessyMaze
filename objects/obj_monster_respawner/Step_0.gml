if (scr_pause_step_guard()) {
    exit;
}

respawn_timer -= 1;

if (respawn_timer <= 0) {
    if (respawn_object != noone) {
        var _monster = instance_create_layer(respawn_x, respawn_y, "Instances", respawn_object);
        _monster.image_xscale = respawn_xscale;
        _monster.image_yscale = respawn_yscale;
    }

    instance_destroy();
}
