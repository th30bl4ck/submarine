if (variable_global_exists("combat_active") && global.combat_active) {
    image_speed = 0;
    image_index = 0;
    exit;
}

if (instance_exists(obj_player) && point_distance(x, y, obj_player.x, obj_player.y) < 200) {
    image_speed = 0;
    image_index = min(1, image_number - 1);
} else {
    image_speed = 0;
    image_index = 0;
}
