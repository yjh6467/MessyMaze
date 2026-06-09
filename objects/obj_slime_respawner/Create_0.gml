visible = false;
depth = -10000;
respawn_x = x;
respawn_y = y;
respawn_layer = layer;
respawn_image_xscale = 0.04;
respawn_image_yscale = 0.04;
respawn_image_angle = 0;
respawn_image_index = 0;
respawn_image_speed = 0;
respawn_image_blend = c_white;
respawn_image_alpha = 1;
respawn_piece_depth = 0;

if (!variable_global_exists("difficulty") || global.difficulty != 4) {
    instance_destroy();
    exit;
}

for (var _respawner_i = 0; _respawner_i < instance_number(obj_slime_respawner); _respawner_i += 1) {
    var _respawner = instance_find(obj_slime_respawner, _respawner_i);
    if (_respawner == id) continue;

    if (abs(_respawner.respawn_x - respawn_x) < 0.5 && abs(_respawner.respawn_y - respawn_y) < 0.5) {
        instance_destroy();
        exit;
    }
}

var _min_time = variable_global_exists("infinite_slime_respawn_min") ? global.infinite_slime_respawn_min : room_speed * 60;
var _max_time = variable_global_exists("infinite_slime_respawn_max") ? global.infinite_slime_respawn_max : room_speed * 90;
respawn_timer = irandom_range(round(_min_time), round(_max_time));
