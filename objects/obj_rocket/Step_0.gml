if (scr_pause_step_guard()) {
    exit;
}

x += dir_x * rocket_speed;
y += dir_y * rocket_speed;
life -= 1;
image_angle = point_direction(0, 0, dir_x, dir_y) - 90;

var _rocket_left = scr_instance_bbox_left_at(id, x);
var _rocket_right = scr_instance_bbox_right_at(id, x);
var _rocket_top = scr_instance_bbox_top_at(id, y);
var _rocket_bottom = scr_instance_bbox_bottom_at(id, y);

if (collision_rectangle(_rocket_left, _rocket_top, _rocket_right, _rocket_bottom, obj_player, false, true) != noone) {
    scr_player_hit("rocket");
}

if (life <= 0 || x < -64 || y < -64 || x > room_width + 64 || y > room_height + 64) {
    instance_destroy();
}
