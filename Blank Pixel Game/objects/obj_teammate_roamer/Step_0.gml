if (room != room_dome || !variable_global_exists("teammate_roster")) {
    instance_destroy();
    exit;
}

if (party_slot < 0 || party_slot >= array_length(global.teammate_roster)) {
    instance_destroy();
    exit;
}

var recruit = global.teammate_roster[party_slot];
var idle_sprite = variable_struct_exists(recruit, "idle_sprite") ? recruit.idle_sprite : spr_survivor_1_idle;
var walk_sprite = variable_struct_exists(recruit, "walk_sprite") ? recruit.walk_sprite : spr_survivor_1_walking;

y = ground_y;

if (wait_timer > 0) {
    wait_timer--;
    if (sprite_index != idle_sprite) {
        sprite_index = idle_sprite;
        image_index = 0;
    }
    image_speed = 0;
    exit;
}

if (abs(target_x - x) <= move_speed) {
    x = target_x;
    wait_timer = irandom_range(90, 210);
    target_x = irandom_range(1366 * 2 + 180, 1366 * 3 - 180);
    if (sprite_index != idle_sprite) {
        sprite_index = idle_sprite;
        image_index = 0;
    }
    image_speed = 0;
} else {
    var walk_dir = sign(target_x - x);
    x += walk_dir * move_speed;
    image_xscale = walk_dir > 0 ? 2 : -2;
    if (sprite_index != walk_sprite) {
        sprite_index = walk_sprite;
        image_index = 0;
    }
    image_speed = 0.18;
}

image_yscale = 2;
