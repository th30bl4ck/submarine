view_enabled = true;
view_visible[0] = true;

if (!variable_instance_exists(id, "cam")) {
    cam = camera_create();
}

var view_w = 1366;
var view_h = 768;
camera_set_view_size(cam, view_w, view_h);
view_camera[0] = cam;

if (instance_exists(obj_player)) {
    var target_x = clamp(obj_player.x - view_w * 0.5, 0, max(0, room_width - view_w));
    var target_y = clamp(obj_player.y - view_h * 0.5, 0, max(0, room_height - view_h));
    camera_set_view_pos(cam, target_x, target_y);
}
