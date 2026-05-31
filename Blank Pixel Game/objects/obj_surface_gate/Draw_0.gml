draw_self();

if (show_prompt) {
    draw_set_colour(c_white);
    draw_set_halign(fa_center);
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
        draw_text(x, y - 80, "[E] Unlock gate");
    } else {
        draw_text(x, y - 80, "Needs " + required_key_label);
    }
    draw_set_halign(fa_left);
}
