var _cx = x + 16;
var _cy = y + 16;

switch (bomb_state) {
    case BOMB_IDLE:
        if (instance_exists(obj_player)) {
            var _px = obj_player.x + 16;
            var _py = obj_player.y + 16;
            if (point_distance(_cx, _cy, _px, _py) <= bomb_radius) {
                bomb_state = BOMB_WARNING;
                state_timer = warning_time;
            }
        }
        break;

    case BOMB_WARNING:
        state_timer -= 1;
        if (state_timer <= 0) {
            bomb_state = BOMB_EXPLODE;
            state_timer = explode_time;

            var _hit = collision_circle(_cx, _cy, bomb_radius, obj_player, false, true);
            if (_hit != noone) {
                scr_player_hit("bomb");
            }
        }
        break;

    case BOMB_EXPLODE:
        state_timer -= 1;
        if (state_timer <= 0) {
            bomb_state = BOMB_DESTROY;
        }
        break;

    case BOMB_DESTROY:
        instance_destroy();
        break;
}
