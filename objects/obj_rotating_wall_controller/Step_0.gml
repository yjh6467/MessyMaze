if (!enabled) exit;

rotate_timer -= 1;
if (rotate_timer <= 0) {
    rotate_timer = rotate_interval;
    // Future hook: swap selected wall instances between horizontal and vertical variants.
}
