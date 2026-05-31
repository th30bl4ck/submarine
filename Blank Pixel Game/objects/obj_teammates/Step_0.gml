if (!variable_global_exists("teammate_recruit_near")) {
    global.teammate_recruit_near = false;
}

if ((variable_global_exists("tutorial_popup_active") && global.tutorial_popup_active) || (variable_global_exists("tutorial_popup_block_input") && global.tutorial_popup_block_input > 0)) {
    exit;
}

if (instance_exists(obj_player) && point_distance(x, y, obj_player.x, obj_player.y) < 72) {
    global.teammate_recruit_near = true;

    if (keyboard_check_pressed(ord("E"))) {
        if (!variable_global_exists("teammate_roster")) {
            global.teammate_roster = [];
        }

        var city_hp_bonus = variable_global_exists("city_hp_bonus") ? global.city_hp_bonus : 0;
        var boosted_recruit_hp = recruit_hp + city_hp_bonus;
        global.teammate_roster[array_length(global.teammate_roster)] = {
            name: recruit_name,
            base_max_hp: recruit_hp,
            hp: boosted_recruit_hp,
            max_hp: boosted_recruit_hp,
            sprite: recruit_idle_sprite,
            idle_sprite: recruit_idle_sprite,
            walk_sprite: recruit_walk_sprite,
            active: false
        };
        if (!variable_global_exists("teammate_collected_keys")) {
            global.teammate_collected_keys = [];
        }
        global.teammate_collected_keys[array_length(global.teammate_collected_keys)] = recruit_key;
        global.combat_message = recruit_name + " joined storage.";
        if (room == room_surface && (!variable_global_exists("tutorial_seen_survivor_equip") || !global.tutorial_seen_survivor_equip)) {
            global.tutorial_seen_survivor_equip = true;
            global.tutorial_popup_active = true;
            global.tutorial_popup_title = "EQUIPPING SURVIVORS";
            global.tutorial_popup_body = "Your first survivor is waiting in the hotel back at the dome.\n\nReturn to the survivor hotel, press E to open the party manager, then press that survivor's number to equip them. You can bring up to three survivors with you. City upgrades also increase survivor max HP.";
        }
        instance_destroy();
    }
}
