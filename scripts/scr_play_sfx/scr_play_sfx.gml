function scr_play_sfx(_sfx_sound) {
    if (!variable_global_exists("sfx_volume")) global.sfx_volume = 0.5;

    var _sound_id = audio_play_sound(_sfx_sound, 10, false);
    audio_sound_gain(_sound_id, global.sfx_volume, 0);
    return _sound_id;
}
