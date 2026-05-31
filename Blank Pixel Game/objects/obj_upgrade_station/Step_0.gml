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
            global.tutorial_popup_body = "Spend iron, crystal, and obsidian here to improve the city.\n\nEach level makes the safe area bigger, increases max HP for you and rescued survivors, and makes combat moves stronger. Loot the surface and ocean floor for materials, then press U here when you can afford the next level.";
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
                global.city_hp_bonus = max(0, rm.dome_level - 1) * 15;
                global.city_damage_bonus = max(0, rm.dome_level - 1) * 4;

                if (instance_exists(obj_player)) {
                    var new_player_max_hp = 100 + global.city_hp_bonus;
                    var player_hp_gain = new_player_max_hp - obj_player.max_hp;
                    obj_player.max_hp = new_player_max_hp;
                    obj_player.hp = min(obj_player.max_hp, obj_player.hp + player_hp_gain);
                }

                if (variable_global_exists("teammate_roster")) {
                    for (var roster_i = 0; roster_i < array_length(global.teammate_roster); roster_i++) {
                        var recruit = global.teammate_roster[roster_i];
                        var recruit_base_hp = recruit.max_hp - max(0, rm.dome_level - 2) * 15;
                        if (variable_struct_exists(recruit, "base_max_hp")) {
                            recruit_base_hp = recruit.base_max_hp;
                        } else if (recruit.name == "Mechanic") {
                            recruit_base_hp = 80;
                        } else if (recruit.name == "Scout") {
                            recruit_base_hp = 75;
                        } else if (recruit.name == "Bulwark") {
                            recruit_base_hp = 110;
                        }
                        var recruit_new_max_hp = recruit_base_hp + global.city_hp_bonus;
                        var recruit_hp_gain = recruit_new_max_hp - recruit.max_hp;
                        recruit.base_max_hp = recruit_base_hp;
                        recruit.max_hp = recruit_new_max_hp;
                        recruit.hp = min(recruit.max_hp, recruit.hp + recruit_hp_gain);
                        global.teammate_roster[roster_i] = recruit;
                    }
                }

                if (variable_global_exists("combat_moves") && array_length(global.combat_moves) >= 4) {
                    var harpoon_move = global.combat_moves[0];
                    harpoon_move.min_value = 11 + global.city_damage_bonus;
                    harpoon_move.max_value = 19 + global.city_damage_bonus;
                    global.combat_moves[0] = harpoon_move;

                    var repair_move = global.combat_moves[2];
                    repair_move.min_value = 16 + global.city_damage_bonus;
                    repair_move.max_value = 24 + global.city_damage_bonus;
                    global.combat_moves[2] = repair_move;

                    var flare_move = global.combat_moves[3];
                    flare_move.min_value = 5 + global.city_damage_bonus;
                    flare_move.max_value = 28 + global.city_damage_bonus;
                    global.combat_moves[3] = flare_move;
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
