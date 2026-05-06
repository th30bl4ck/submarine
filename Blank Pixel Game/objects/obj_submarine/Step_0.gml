var dist = point_distance(x, y, obj_player.x, obj_player.y);

if (dist < interact_range) {
    obj_player.near_submarine = true;
    show_prompt = true;
} else {
    show_prompt = false;
}