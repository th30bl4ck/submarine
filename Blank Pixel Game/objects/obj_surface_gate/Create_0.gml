interact_range = 96;
show_prompt = false;
required_key = clamp(ceil(abs(x - (room_width * 0.5)) / 2200), 1, 3);
gate_key = room_get_name(room) + ":gate:" + string(round(x)) + ":" + string(round(y));

if (!variable_global_exists("surface_keys")) {
    global.surface_keys = 0;
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
