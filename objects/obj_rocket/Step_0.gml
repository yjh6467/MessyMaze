x += dir_x * rocket_speed;
y += dir_y * rocket_speed;
life -= 1;
image_angle = point_direction(0, 0, dir_x, dir_y) - 90;

if (collision_rectangle(x, y, x + 32, y + 32, obj_player, false, true) != noone) {
    scr_player_hit("rocket");
}

if (life <= 0 || x < -64 || y < -64 || x > room_width + 64 || y > room_height + 64) {
    instance_destroy();
}
