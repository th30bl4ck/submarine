draw_self();

if (show_prompt) {
    draw_set_colour(c_white);
    draw_set_halign(fa_center);
    if (global.surface_keys >= required_key) {
        draw_text(x, y - 80, "[E] Unlock gate");
    } else {
        draw_text(x, y - 80, "Needs key " + string(required_key));
    }
    draw_set_halign(fa_left);
}
