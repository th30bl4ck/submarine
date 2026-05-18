draw_self();

if (instance_exists(obj_player) && point_distance(x, y, obj_player.x, obj_player.y) < 72) {
    draw_set_colour(c_white);
    draw_set_halign(fa_center);
    draw_text(x - 58, y - 58, "[E] Enter Dome");
    draw_set_halign(fa_left);
}
