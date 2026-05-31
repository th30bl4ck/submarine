var dist = point_distance(x, y, obj_player.x, obj_player.y);

if ((variable_global_exists("tutorial_popup_active") && global.tutorial_popup_active) || (variable_global_exists("tutorial_popup_block_input") && global.tutorial_popup_block_input > 0)) {
    exit;
}

if (!instance_exists(obj_resource_manager)) {
    instance_create_depth(0, 0, 0, obj_resource_manager);
}

if (dist < interact_range) {
    show_prompt = true;

    if (keyboard_check_pressed(ord("E")) && !obj_player.near_submarine) {
        show_menu = !show_menu; 
        if (!variable_global_exists("tutorial_seen_upgrade_shop") || !global.tutorial_seen_upgrade_shop) {
            global.tutorial_seen_upgrade_shop = true;
            global.tutorial_popup_active = true;
            global.tutorial_popup_title = "UPGRADE SHOP";
            global.tutorial_popup_body = "Spend iron, crystal, and obsidian here to improve the dome.\n\nEach upgrade makes the safe area bigger. Loot the surface and ocean floor for materials, then return here and press U when you can afford the next level.";
        }
    }

    if (show_menu) {
        var rm = obj_resource_manager;
        var next_level = rm.dome_level + 1;
        var can_upgrade = false;
        var cost_iron = 0;
        var cost_crystal = 0;
        var cost_obsidian = 0;


        for (var i = 0; i < array_length(rm.upgrade_costs); i++) {
            if (rm.upgrade_costs[i][0] == next_level) {
                cost_iron     = rm.upgrade_costs[i][1];
                cost_crystal  = rm.upgrade_costs[i][2];
                cost_obsidian = rm.upgrade_costs[i][3];
                can_upgrade   = true;
                break;
            }
        }


        if (keyboard_check_pressed(ord("U")) && can_upgrade) {
            if (rm.iron >= cost_iron && rm.crystal >= cost_crystal && rm.obsidian >= cost_obsidian) {
                rm.iron     -= cost_iron;
                rm.crystal  -= cost_crystal;
                rm.obsidian -= cost_obsidian;
                rm.dome_level++;

                rm.dome_width  += 120;
                rm.dome_height += 80;

                show_menu = false;
            }
        }

        // Press Escape to close
        if (keyboard_check_pressed(vk_escape)) {
            show_menu = false;
        }
    }
} else {
    show_prompt = false;
    show_menu   = false;
}
