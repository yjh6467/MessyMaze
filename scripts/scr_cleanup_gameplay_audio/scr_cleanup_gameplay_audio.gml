function scr_cleanup_gameplay_audio() {
    with (obj_giant_vacuum) {
        if (variable_instance_exists(id, "vacuum_sound")) {
            audio_stop_sound(vacuum_sound);
        }
    }

    audio_stop_sound(sfx_vacuum);
    audio_stop_sound(sfx_vacuum_warning);
}
