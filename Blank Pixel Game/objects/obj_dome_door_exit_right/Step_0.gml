if (!instance_exists(obj_player)) exit;

if (point_distance(x, y, obj_player.x, obj_player.y) < 72 && keyboard_check_pressed(ord("E"))) {
    obj_player.vx = 0;
    obj_player.vy = 0;
    obj_player.x = 64;
    obj_player.y = 704;
    room_goto(room_ocean_floor_right_1);
}
