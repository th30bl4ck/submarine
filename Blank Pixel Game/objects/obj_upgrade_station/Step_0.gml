var dist = point_distance(x, y, obj_player.x, obj_player.y);

if (dist < interact_range) {
    show_prompt = true;

    if (keyboard_check_pressed(ord("E")) && !obj_player.near_submarine) {
        show_menu = !show_menu; 
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

                // Grow the dome
                rm.dome_width  += 120;
                rm.dome_height += 80;


                with (obj_dome) {
                    image_xscale = rm.dome_width  / (sprite_width  / 2);
                    image_yscale = rm.dome_height / (sprite_height / 2);
                }

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