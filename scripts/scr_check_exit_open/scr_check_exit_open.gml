function scr_check_exit_open() {
    if (!variable_global_exists("score")) global.score = 0;
    if (!variable_global_exists("score_slime_piece_value")) global.score_slime_piece_value = 1;
    if (!variable_global_exists("slime_count")) global.slime_count = 0;
    if (!variable_global_exists("total_slime_count")) {
        global.total_slime_count = global.slime_count + instance_number(obj_score_slime_piece);
    }
    if (!variable_global_exists("exit_open")) global.exit_open = false;

    if (variable_global_exists("difficulty") && global.difficulty == 4) {
        global.exit_open = false;
        return;
    }

    global.slime_count = floor(global.score / max(1, global.score_slime_piece_value));
    if (variable_global_exists("difficulty") && global.difficulty == 0) {
        var _test_total = instance_number(obj_score_slime_piece);
        if (global.total_slime_count < _test_total) {
            global.total_slime_count = _test_total;
        }

        global.slime_count = global.total_slime_count;
        global.score = global.total_slime_count * global.score_slime_piece_value;
    }

    if (global.exit_open) return;
    if (global.total_slime_count <= 0) return;
    if (global.slime_count < global.total_slime_count) return;

    global.exit_open = true;

    with (obj_exit_wall) {
        instance_destroy();
    }

    if (instance_number(obj_clear_exit) <= 0 && variable_global_exists("clear_exit_x") && variable_global_exists("clear_exit_y")) {
        instance_create_layer(global.clear_exit_x, global.clear_exit_y, "Instances", obj_clear_exit);
    }

    scr_debug_log("Exit opened!");

    // Test difficulty opens the exit immediately, but the player still has to reach it.
}
