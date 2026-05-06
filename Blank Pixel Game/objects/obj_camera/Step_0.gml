var target_x = obj_player.x - 340;
var target_y = obj_player.y - 240;

target_x = clamp(target_x, 0, room_width - 680);
target_y = clamp(target_y, 0, room_height - 480);

var cur_x = camera_get_view_x(cam);
var cur_y = camera_get_view_y(cam);

camera_set_view_pos(cam, lerp(cur_x, target_x, 0.1), lerp(cur_y, target_y, 0.1));