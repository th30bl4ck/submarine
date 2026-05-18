if (room != room_surface || (variable_global_exists("combat_active") && global.combat_active) || !instance_exists(obj_player) || !variable_global_exists("teammate_roster")) {
    instance_destroy();
    exit;
}

if (party_slot < 0 || party_slot >= array_length(global.teammate_roster)) {
    instance_destroy();
    exit;
}

var recruit = global.teammate_roster[party_slot];
if (!recruit.active) {
    instance_destroy();
    exit;
}

var idle_sprite = variable_struct_exists(recruit, "idle_sprite") ? recruit.idle_sprite : spr_survivor_1_idle;
var walk_sprite = variable_struct_exists(recruit, "walk_sprite") ? recruit.walk_sprite : spr_survivor_1_walking;
var target_x = obj_player.x - (48 + follow_order * 34) * sign(obj_player.image_xscale);
var target_y = obj_player.y;
var dist_to_target = point_distance(x, y, target_x, target_y);
var follower_is_moving = (abs(vx) > 0.08 || abs(vy) > 0.08) || (obj_player.vx != 0 || obj_player.vy != 0);

if (dist_to_target > 10) {
    var move_dir = point_direction(x, y, target_x, target_y);
    vx += lengthdir_x(move_speed, move_dir);
    vy += lengthdir_y(move_speed, move_dir);
} else {
    vx *= 0.72;
    vy *= 0.72;
}

var current_speed = point_distance(0, 0, vx, vy);
if (current_speed > max_follow_speed) {
    var velocity_dir = point_direction(0, 0, vx, vy);
    vx = lengthdir_x(max_follow_speed, velocity_dir);
    vy = lengthdir_y(max_follow_speed, velocity_dir);
}

x += vx;
y += vy;
vx *= 0.86;
vy *= 0.86;

if (follower_is_moving) {
    image_speed = 1;
    if (sprite_index != walk_sprite) {
        sprite_index = walk_sprite;
    }
    if (abs(vx) > 0.08) image_xscale = vx > 0 ? 2 : -2;
} else {
    image_speed = 0;
    image_index = 0;
    sprite_index = idle_sprite;
    image_xscale = obj_player.image_xscale >= 0 ? 2 : -2;
}

image_yscale = 2;
