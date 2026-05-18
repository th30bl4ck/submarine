draw_self();

if ((!variable_global_exists("combat_active") || !global.combat_active) && instance_exists(obj_player) && point_distance(x, y, obj_player.x, obj_player.y) < 80) {
    var old_halign = draw_get_halign();
    var old_valign = draw_get_valign();
    var label_y = bbox_top - 24;

    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_colour(c_white);
    draw_text(x, label_y, "[E] Recruit");

    draw_set_halign(old_halign);
    draw_set_valign(old_valign);
}
