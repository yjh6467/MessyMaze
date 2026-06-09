if (scr_pause_step_guard()) {
    exit;
}

if (!variable_instance_exists(id, "vacuum_sound") || !audio_is_playing(vacuum_sound)) {
    vacuum_sound = audio_play_sound(sfx_vacuum, 10, false);
}
audio_sound_gain(vacuum_sound, variable_global_exists("sfx_volume") ? global.sfx_volume : 0.5, 0);

y += move_speed;

var _hit_left = x + hit_margin_x;
var _hit_top = y + hit_margin_y;
var _hit_right = x + vacuum_width - hit_margin_x;
var _hit_bottom = y + vacuum_height - hit_margin_y;

var _queue_monster_respawn = function(_monster) {
    var _respawner = instance_create_layer(0, 0, "Instances", obj_monster_respawner);
    _respawner.respawn_object = _monster.object_index;
    _respawner.respawn_x = variable_instance_exists(_monster, "spawn_x") ? _monster.spawn_x : _monster.x;
    _respawner.respawn_y = variable_instance_exists(_monster, "spawn_y") ? _monster.spawn_y : _monster.y;
    _respawner.respawn_xscale = _monster.image_xscale;
    _respawner.respawn_yscale = _monster.image_yscale;

    with (_monster) {
        instance_destroy();
    }
};

if (instance_exists(obj_player)) {
    var _player = collision_rectangle(_hit_left, _hit_top, _hit_right, _hit_bottom, obj_player, false, true);
    if (_player != noone) {
        if (!_player.is_dead && _player.invisible_timer <= 0) {
            scr_player_hit("giant_vacuum");
        }
    }
}

var _monster = collision_rectangle(_hit_left, _hit_top, _hit_right, _hit_bottom, obj_monster1, false, true);
while (_monster != noone) {
    _queue_monster_respawn(_monster);
    _monster = collision_rectangle(_hit_left, _hit_top, _hit_right, _hit_bottom, obj_monster1, false, true);
}

_monster = collision_rectangle(_hit_left, _hit_top, _hit_right, _hit_bottom, obj_monster2, false, true);
while (_monster != noone) {
    _queue_monster_respawn(_monster);
    _monster = collision_rectangle(_hit_left, _hit_top, _hit_right, _hit_bottom, obj_monster2, false, true);
}

_monster = collision_rectangle(_hit_left, _hit_top, _hit_right, _hit_bottom, obj_monster3, false, true);
while (_monster != noone) {
    _queue_monster_respawn(_monster);
    _monster = collision_rectangle(_hit_left, _hit_top, _hit_right, _hit_bottom, obj_monster3, false, true);
}

_monster = collision_rectangle(_hit_left, _hit_top, _hit_right, _hit_bottom, obj_monster4, false, true);
while (_monster != noone) {
    _queue_monster_respawn(_monster);
    _monster = collision_rectangle(_hit_left, _hit_top, _hit_right, _hit_bottom, obj_monster4, false, true);
}

if (y > room_height + vacuum_height) {
    instance_destroy();
}
