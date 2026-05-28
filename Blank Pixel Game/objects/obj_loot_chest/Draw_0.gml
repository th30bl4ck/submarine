draw_self();

if (show_prompt) {
    draw_set_colour(c_white);
    draw_set_halign(fa_center);
    draw_text(x, y - 48, object_index == obj_loot_safe ? "[E] Crack safe" : "[E] Open chest");
    draw_set_halign(fa_left);
}
