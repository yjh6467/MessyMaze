if (!enabled) exit;

x += dir_x * move_speed;

if (collision_rectangle(x, y, x + monster_width, y + monster_height, obj_player, false, true) != noone) {
    scr_player_hit("giant_monster");
}

if (x < -monster_width || x > room_width + monster_width) {
    instance_destroy();
}
