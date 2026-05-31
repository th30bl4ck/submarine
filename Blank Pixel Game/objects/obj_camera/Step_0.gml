var view_w = 1000;
var view_h = 563;

if (!instance_exists(obj_player)) {
    var spawn_x = (room == room_surface) ? room_width * 0.5 + 80 : 3724;
    var spawn_y = (room == room_surface) ? 714 : 722;
    instance_create_layer(spawn_x, spawn_y, "Instances", obj_player);
}

if (!instance_exists(obj_player)) exit;

var target_x = obj_player.x - view_w * 0.5;
var target_y = obj_player.y - view_h * 0.5;

if (variable_global_exists("combat_active") && global.combat_active) {
    target_x = global.combat_view_x;
    target_y = global.combat_view_y;
}

target_x = clamp(target_x, 0, max(0, room_width - view_w));
target_y = clamp(target_y, 0, max(0, room_height - view_h));

camera_set_view_pos(cam, target_x, target_y);
