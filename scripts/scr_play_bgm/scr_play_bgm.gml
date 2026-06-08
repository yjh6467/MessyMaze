function scr_play_bgm(_bgm_sound) {
    if (!variable_global_exists("bgm_volume")) global.bgm_volume = 0.5;
    if (!variable_global_exists("bgm_sound_id")) global.bgm_sound_id = noone;
    if (!variable_global_exists("bgm_asset")) global.bgm_asset = noone;

    if (global.bgm_asset == _bgm_sound && global.bgm_sound_id != noone && audio_is_playing(global.bgm_sound_id)) {
        audio_sound_gain(global.bgm_sound_id, global.bgm_volume, 0);
        return;
    }

    if (global.bgm_sound_id != noone) {
        audio_stop_sound(global.bgm_sound_id);
    }

    audio_stop_sound(sfx_mainmenu_bgm);
    audio_stop_sound(sfx_maze_bgm);

    global.bgm_asset = _bgm_sound;
    global.bgm_sound_id = audio_play_sound(_bgm_sound, 1, true);
    audio_sound_gain(global.bgm_sound_id, global.bgm_volume, 0);
}
