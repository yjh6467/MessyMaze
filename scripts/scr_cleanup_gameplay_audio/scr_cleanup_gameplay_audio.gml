function scr_cleanup_gameplay_audio() {
    if (variable_global_exists("audio_paused_by_game") && global.audio_paused_by_game) {
        audio_resume_all();
        global.audio_paused_by_game = false;
    }

    with (obj_giant_vacuum) {
        if (variable_instance_exists(id, "vacuum_sound")) {
            audio_stop_sound(vacuum_sound);
            vacuum_sound = noone;
        }
    }

    audio_stop_sound(sfx_vacuum);
    audio_stop_sound(sfx_vacuum_warning);
    audio_stop_sound(sfx_gameclear);
    audio_stop_sound(sfx_gameover);

    if (variable_global_exists("bgm_sound_id") && global.bgm_sound_id != noone && !audio_is_playing(global.bgm_sound_id)) {
        global.bgm_sound_id = noone;
        global.bgm_asset = noone;
    }
}
