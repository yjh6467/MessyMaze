image_speed = 0;

if (!variable_global_exists("slime_piece_anim_index")) {
    global.slime_piece_anim_index = 0;
}

var _frame_count = max(1, sprite_get_number(sprite_index));
image_index = global.slime_piece_anim_index mod _frame_count;
