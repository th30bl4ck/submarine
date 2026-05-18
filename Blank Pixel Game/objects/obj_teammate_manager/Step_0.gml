if (!variable_global_exists("teammate_manager_near")) {
    global.teammate_manager_near = false;
}

var near_player = instance_exists(obj_player) && point_distance(x, y, obj_player.x, obj_player.y) < 96;
if (near_player) {
    global.teammate_manager_near = true;
}

if (near_player && keyboard_check_pressed(ord("E")) && !global.combat_active) {
    global.teammate_menu_open = !global.teammate_menu_open;
}

if (global.teammate_menu_open) {
    if (!near_player || global.combat_active || keyboard_check_pressed(vk_escape)) {
        global.teammate_menu_open = false;
        exit;
    }

    var active_count = 0;
    for (var count_i = 0; count_i < array_length(global.teammate_roster); count_i++) {
        if (global.teammate_roster[count_i].active) active_count++;
    }

    var roster_count = min(array_length(global.teammate_roster), 9);
    for (var key_i = 0; key_i < roster_count; key_i++) {
        if (keyboard_check_pressed(ord(string(key_i + 1)))) {
            var selected_recruit = global.teammate_roster[key_i];
            if (selected_recruit.active) {
                selected_recruit.active = false;
                global.teammate_roster[key_i] = selected_recruit;
            } else if (active_count < 3) {
                selected_recruit.active = true;
                global.teammate_roster[key_i] = selected_recruit;
                active_count++;
            }
        }
    }
}
