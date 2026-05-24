cam = camera_create();
view_enabled = true;
view_visible[0] = true;
camera_set_view_size(cam, 680, 480);
view_camera[0] = cam;

if (instance_exists(obj_player)) {
    var target_x = clamp(obj_player.x - 340, 0, room_width - 680);
    var target_y = clamp(obj_player.y - 240, 0, room_height - 480);
    camera_set_view_pos(cam, target_x, target_y);
}
