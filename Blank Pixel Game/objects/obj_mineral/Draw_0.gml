draw_self();

if (show_prompt) {
    draw_set_colour(c_white);
    draw_set_halign(fa_center);
    draw_text(x, y - 40, "[E] Collect " + mineral_type);
    draw_set_halign(fa_left);
}