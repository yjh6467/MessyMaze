var _cx = x + 16;
var _cy = y + 16;

switch (bomb_state) {
    case BOMB_IDLE:
        bomb_state = BOMB_WARNING;
        state_timer = warning_time;
        break;

    case BOMB_WARNING:
        state_timer -= 1;
        if (state_timer <= 0) {
            bomb_state = BOMB_EXPLODE;
            state_timer = explode_time;
            image_index = 0;
            image_speed = 1;

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
