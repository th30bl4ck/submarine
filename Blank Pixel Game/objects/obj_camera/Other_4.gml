view_enabled = true;
view_visible[0] = true;

if (!variable_instance_exists(id, "cam")) {
    cam = camera_create();
}

camera_set_view_size(cam, 680, 480);
view_camera[0] = cam;
