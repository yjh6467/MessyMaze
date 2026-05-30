warning_time -= 1;
if (warning_time <= 0) {
    var _rocket = instance_create_layer(x, y, "Instances", obj_rocket);
    _rocket.dir_x = dir_x;
    _rocket.dir_y = dir_y;
    instance_destroy();
}
