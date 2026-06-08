function scr_apply_audio_volumes() {
    if (!variable_global_exists("bgm_volume")) global.bgm_volume = 0.5;
    if (!variable_global_exists("sfx_volume")) global.sfx_volume = 0.5;

    if (variable_global_exists("bgm_sound_id") && global.bgm_sound_id != noone) {
        audio_sound_gain(global.bgm_sound_id, global.bgm_volume, 0);
    }

    audio_sound_gain(sfx_vacuum, global.sfx_volume, 0);
    audio_sound_gain(sfx_vacuum_warning, global.sfx_volume, 0);
    audio_sound_gain(sfx_boom_explosion, global.sfx_volume, 0);
    audio_sound_gain(sfx_select_arrow_move, global.sfx_volume, 0);
    audio_sound_gain(sfx_gamestart, global.sfx_volume, 0);
    audio_sound_gain(sfx_gameclear, global.sfx_volume, 0);
    audio_sound_gain(sfx_gameover, global.sfx_volume, 0);

    with (obj_giant_vacuum) {
        if (variable_instance_exists(id, "vacuum_sound")) {
            audio_sound_gain(vacuum_sound, global.sfx_volume, 0);
        }
    }
}
