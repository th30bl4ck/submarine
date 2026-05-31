interact_range = 96;
show_prompt = false;
required_key = clamp(ceil(abs(x - (room_width * 0.5)) / 2200), 1, 3);
required_key_code = "key_" + string(required_key);
required_key_label = "key " + string(required_key);
gate_key = room_get_name(room) + ":gate:" + string(round(x)) + ":" + string(round(y));

if (!variable_global_exists("surface_keys")) {
    global.surface_keys = 0;
}
if (!variable_global_exists("surface_key_codes")) {
    global.surface_key_codes = [];
}
if (!variable_global_exists("surface_open_gates")) {
    global.surface_open_gates = [];
}

for (var i = 0; i < array_length(global.surface_open_gates); i++) {
    if (global.surface_open_gates[i] == gate_key) {
        instance_destroy();
        exit;
    }
}
