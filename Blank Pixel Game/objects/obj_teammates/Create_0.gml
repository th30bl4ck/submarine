if (!variable_global_exists("teammates_found")) {
    global.teammates_found = 0;
}
if (!variable_global_exists("teammate_collected_keys")) {
    global.teammate_collected_keys = [];
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

sprite_index = spr_survivor_1_idle;
image_index = 0;
image_speed = 0;
image_xscale = 2;
image_yscale = 2;
