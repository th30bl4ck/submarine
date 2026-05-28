interact_range = 72;
show_prompt = false;
key_id = clamp(ceil(abs(x - (room_width * 0.5)) / 2200), 1, 3);
key_key = room_get_name(room) + ":key:" + string(round(x)) + ":" + string(round(y));

if (!variable_global_exists("surface_keys")) {
    global.surface_keys = 0;
}
if (!variable_global_exists("surface_collected_keys")) {
    global.surface_collected_keys = [];
}

for (var i = 0; i < array_length(global.surface_collected_keys); i++) {
    if (global.surface_collected_keys[i] == key_key) {
        instance_destroy();
        exit;
    }
}
