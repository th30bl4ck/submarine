show_prompt = false;

if ((variable_global_exists("tutorial_popup_active") && global.tutorial_popup_active) || (variable_global_exists("tutorial_popup_block_input") && global.tutorial_popup_block_input > 0)) {
    exit;
}

if (opened) {
    if (object_index == obj_loot_safe && image_index >= image_number - 1) {
        image_index = image_number - 1;
        image_speed = 0;
    }
    exit;
}

if (!instance_exists(obj_player)) exit;

if (point_distance(x, y, obj_player.x, obj_player.y) < interact_range) {
    show_prompt = true;

    if (keyboard_check_pressed(ord("E")) && !obj_player.near_submarine) {
        if (!instance_exists(obj_resource_manager)) {
            instance_create_depth(0, 0, 0, obj_resource_manager);
        }

        obj_resource_manager.iron += loot_iron;
        obj_resource_manager.crystal += loot_crystal;
        obj_resource_manager.obsidian += loot_obsidian;

        global.surface_looted_caches[array_length(global.surface_looted_caches)] = loot_key;
        global.combat_message = "Found +" + string(loot_iron) + " iron, +" + string(loot_crystal) + " crystal, +" + string(loot_obsidian) + " obsidian.";
        if (!variable_global_exists("tutorial_seen_loot") || !global.tutorial_seen_loot) {
            global.tutorial_seen_loot = true;
            global.tutorial_popup_active = true;
            global.tutorial_popup_title = "LOOTING";
            global.tutorial_popup_body = "Loot caches give you the materials needed for city upgrades.\n\nIron, crystal, and obsidian appear in your resource panel. Bring those materials back to the upgrade shop to expand the safe area, raise max HP for you and survivors, and strengthen your combat moves.";
        }
        opened = true;
        show_prompt = false;
        if (object_index == obj_loot_safe) {
            image_index = 0;
            image_speed = 0.15;
            image_alpha = 0.55;
        } else {
            sprite_index = spr_chest_open_empty;
        }
    }
}
