if (!variable_global_exists("teammate_recruit_near")) {
    global.teammate_recruit_near = false;
}

if (instance_exists(obj_player) && point_distance(x, y, obj_player.x, obj_player.y) < 72) {
    global.teammate_recruit_near = true;

    if (keyboard_check_pressed(ord("E"))) {
        if (!variable_global_exists("teammate_roster")) {
            global.teammate_roster = [];
        }

        global.teammate_roster[array_length(global.teammate_roster)] = {
            name: recruit_name,
            hp: recruit_hp,
            max_hp: recruit_hp,
            sprite: spr_survivor_1_idle,
            idle_sprite: spr_survivor_1_idle,
            walk_sprite: spr_survivor_1_walking,
            active: false
        };
        if (!variable_global_exists("teammate_collected_keys")) {
            global.teammate_collected_keys = [];
        }
        global.teammate_collected_keys[array_length(global.teammate_collected_keys)] = recruit_key;
        global.combat_message = recruit_name + " joined storage.";
        instance_destroy();
    }
}
