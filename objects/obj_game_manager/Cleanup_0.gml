if (variable_global_exists("screen_shake_camera")) {
    if (global.screen_shake_camera != noone) {
        camera_destroy(global.screen_shake_camera);
    }

    global.screen_shake_camera = noone;
}
