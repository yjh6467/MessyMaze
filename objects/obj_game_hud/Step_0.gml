global.elapsed_time = max(0, floor((current_time - hud_start_time_ms) / 1000));

if (!variable_global_exists("hud_height")) global.hud_height = 96;

if (!variable_global_exists("score")) global.score = 0;
if (!variable_global_exists("score_slime_piece_value")) global.score_slime_piece_value = 1;
if (!variable_global_exists("player_lives")) global.player_lives = 3;

global.slime_count = floor(global.score / max(1, global.score_slime_piece_value));

var _remaining_slime = instance_number(obj_score_slime_piece);
var _detected_total = global.slime_count + _remaining_slime;
if (!variable_global_exists("total_slime_count") || global.total_slime_count < _detected_total) {
    global.total_slime_count = _detected_total;
}
