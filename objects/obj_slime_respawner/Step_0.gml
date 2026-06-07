var _frozen =
    (variable_global_exists("game_paused") && global.game_paused)
    || (variable_global_exists("gameplay_frozen") && global.gameplay_frozen)
    || (variable_global_exists("game_cleared") && global.game_cleared)
    || (variable_global_exists("game_over") && global.game_over);

if (_frozen) {
    exit;
}

respawn_timer -= 1;
if (respawn_timer > 0) {
    exit;
}

if (instance_place(respawn_x, respawn_y, obj_score_slime_piece) == noone) {
    var _piece = instance_create_layer(respawn_x, respawn_y, respawn_layer, obj_score_slime_piece);
    _piece.image_xscale = respawn_image_xscale;
    _piece.image_yscale = respawn_image_yscale;
    _piece.image_angle = respawn_image_angle;
    _piece.image_index = variable_global_exists("slime_piece_anim_index") ? global.slime_piece_anim_index : respawn_image_index;
    _piece.image_speed = 0;
    _piece.image_blend = respawn_image_blend;
    _piece.image_alpha = respawn_image_alpha;
    _piece.depth = respawn_piece_depth;
}

instance_destroy();
