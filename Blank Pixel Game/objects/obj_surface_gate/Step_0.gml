show_prompt = false;

if (!instance_exists(obj_player)) exit;

var gate_half_width = 78;
var gate_top_y = y - 168;
var gate_bottom_y = y + 166;
if (obj_player.y > gate_top_y && obj_player.y < gate_bottom_y && abs(obj_player.x - x) < gate_half_width) {
    if (obj_player.x < x) {
        obj_player.x = x - gate_half_width;
    } else {
        obj_player.x = x + gate_half_width;
    }
    obj_player.vx = 0;
}

if (point_distance(x, y, obj_player.x, obj_player.y) < interact_range) {
    show_prompt = true;

    if (keyboard_check_pressed(ord("E")) && !obj_player.near_submarine) {
        var has_required_key = false;
        if (variable_global_exists("surface_key_codes")) {
            for (var code_i = 0; code_i < array_length(global.surface_key_codes); code_i++) {
                if (global.surface_key_codes[code_i] == required_key_code) {
                    has_required_key = true;
                }
            }
        }

        var allows_legacy_key = (required_key_code == "key_" + string(required_key) && global.surface_keys >= required_key);
        if (has_required_key || allows_legacy_key) {
            global.surface_open_gates[array_length(global.surface_open_gates)] = gate_key;
            global.combat_message = "Gate unlocked.";
            instance_destroy();
        } else {
            global.combat_message = "This gate needs " + required_key_label + ".";
        }
    }
}
