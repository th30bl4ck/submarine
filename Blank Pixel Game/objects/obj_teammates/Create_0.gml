if (!variable_global_exists("teammates_found")) {
    global.teammates_found = 0;
}
if (!variable_global_exists("teammate_collected_keys")) {
    global.teammate_collected_keys = [];
}
if (!variable_global_exists("teammate_sprite_assignments")) {
    global.teammate_sprite_assignments = [];
}
if (!variable_global_exists("teammate_used_sprite_numbers")) {
    global.teammate_used_sprite_numbers = [];
}

recruit_key = room_get_name(room) + ":" + string(round(x)) + ":" + string(round(y));
for (var collected_i = 0; collected_i < array_length(global.teammate_collected_keys); collected_i++) {
    if (global.teammate_collected_keys[collected_i] == recruit_key) {
        instance_destroy();
        exit;
    }
}

var recruit_index = global.teammates_found mod 3;
if (recruit_index == 0) {
    recruit_name = "Mechanic";
    recruit_hp = 80;
} else if (recruit_index == 1) {
    recruit_name = "Scout";
    recruit_hp = 75;
} else {
    recruit_name = "Bulwark";
    recruit_hp = 110;
}
global.teammates_found++;

var survivor_idle_sprites = [
    spr_survivor_1_idle,
    spr_survivor_2_idle,
    spr_survivor_3_idle,
    spr_survivor_4_idle,
    spr_survivor_5_idle,
    spr_survivor_6_idle,
    spr_survivor_7_idle,
    spr_survivor_8_idle,
    spr_survivor_9_idle,
    spr_survivor_10_idle,
    spr_survivor_11_idle,
    spr_survivor_12_idle
];
var survivor_walk_sprites = [
    spr_survivor_1_walking,
    spr_survivor_2_walking,
    spr_survivor_3_walking,
    spr_survivor_4_walking,
    spr_survivor_5_walking,
    spr_survivor_6_walking,
    spr_survivor_7_walking,
    spr_survivor_8_walking,
    spr_survivor_9_walking,
    spr_survivor_10_walking,
    spr_survivor_11_walking,
    spr_survivor_12_walking
];

recruit_sprite_number = 1;
recruit_idle_sprite = spr_survivor_1_idle;
recruit_walk_sprite = spr_survivor_1_walking;

var found_sprite_assignment = false;
for (var assignment_i = 0; assignment_i < array_length(global.teammate_sprite_assignments); assignment_i++) {
    var assignment = global.teammate_sprite_assignments[assignment_i];
    if (assignment.key == recruit_key) {
        recruit_sprite_number = assignment.sprite_number;
        recruit_idle_sprite = assignment.idle_sprite;
        recruit_walk_sprite = assignment.walk_sprite;
        found_sprite_assignment = true;
        break;
    }
}

if (!found_sprite_assignment) {
    var available_sprite_numbers = [];
    for (var sprite_i = 0; sprite_i < array_length(survivor_idle_sprites); sprite_i++) {
        var sprite_number = sprite_i + 1;
        var already_used = false;
        for (var used_i = 0; used_i < array_length(global.teammate_used_sprite_numbers); used_i++) {
            if (global.teammate_used_sprite_numbers[used_i] == sprite_number) {
                already_used = true;
                break;
            }
        }
        if (!already_used) {
            available_sprite_numbers[array_length(available_sprite_numbers)] = sprite_number;
        }
    }

    if (array_length(available_sprite_numbers) > 0) {
        recruit_sprite_number = available_sprite_numbers[irandom(array_length(available_sprite_numbers) - 1)];
    }

    recruit_idle_sprite = survivor_idle_sprites[recruit_sprite_number - 1];
    recruit_walk_sprite = survivor_walk_sprites[recruit_sprite_number - 1];
    global.teammate_used_sprite_numbers[array_length(global.teammate_used_sprite_numbers)] = recruit_sprite_number;
    global.teammate_sprite_assignments[array_length(global.teammate_sprite_assignments)] = {
        key: recruit_key,
        sprite_number: recruit_sprite_number,
        idle_sprite: recruit_idle_sprite,
        walk_sprite: recruit_walk_sprite
    };
}

sprite_index = recruit_idle_sprite;
image_index = 0;
image_speed = 0;
image_xscale = 2;
image_yscale = 2;
