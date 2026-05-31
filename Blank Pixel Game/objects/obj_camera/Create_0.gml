cam = camera_create();
view_enabled = true;
view_visible[0] = true;

var view_w = 1000;
var view_h = 563;
camera_set_view_size(cam, view_w, view_h);
view_camera[0] = cam;

if (!instance_exists(obj_player)) {
    var spawn_x = (room == room_surface) ? room_width * 0.5 + 80 : 3724;
    var spawn_y = (room == room_surface) ? 714 : 722;
    instance_create_layer(spawn_x, spawn_y, "Instances", obj_player);
}

if (instance_exists(obj_player)) {
    var target_x = clamp(obj_player.x - view_w * 0.5, 0, max(0, room_width - view_w));
    var target_y = clamp(obj_player.y - view_h * 0.5, 0, max(0, room_height - view_h));
    camera_set_view_pos(cam, target_x, target_y);
}
