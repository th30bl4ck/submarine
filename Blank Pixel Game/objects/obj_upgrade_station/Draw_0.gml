draw_self();
if (show_prompt && !show_menu) {
    draw_set_colour(c_white);
    draw_set_halign(fa_center);
    draw_text(x, y - 50, "[E] Upgrade Station");
    draw_set_halign(fa_left);
}