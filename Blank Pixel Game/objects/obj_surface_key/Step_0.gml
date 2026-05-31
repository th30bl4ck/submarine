show_prompt = false;

if (!instance_exists(obj_player)) exit;

if (point_distance(x, y, obj_player.x, obj_player.y) < interact_range) {
    show_prompt = true;

    if (keyboard_check_pressed(ord("E")) && !obj_player.near_submarine) {
        global.surface_keys = max(global.surface_keys, key_id);
        if (!variable_global_exists("surface_key_codes")) {
            global.surface_key_codes = [];
        }
        var already_has_code = false;
        for (var code_i = 0; code_i < array_length(global.surface_key_codes); code_i++) {
            if (global.surface_key_codes[code_i] == key_code) {
                already_has_code = true;
            }
        }
        if (!already_has_code) {
            global.surface_key_codes[array_length(global.surface_key_codes)] = key_code;
        }
        global.surface_collected_keys[array_length(global.surface_collected_keys)] = key_key;
        global.combat_message = "Found " + key_label + ".";
        instance_destroy();
    }
}
