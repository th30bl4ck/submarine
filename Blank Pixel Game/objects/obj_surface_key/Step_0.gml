show_prompt = false;

if (!instance_exists(obj_player)) exit;

if (point_distance(x, y, obj_player.x, obj_player.y) < interact_range) {
    show_prompt = true;

    if (keyboard_check_pressed(ord("E")) && !obj_player.near_submarine) {
        global.surface_keys = max(global.surface_keys, key_id);
        global.surface_collected_keys[array_length(global.surface_collected_keys)] = key_key;
        global.combat_message = "Found surface gate key " + string(key_id) + ".";
        instance_destroy();
    }
}
