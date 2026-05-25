if (!variable_global_exists("combat_active")) {
    global.combat_active = false;
}

if (room != room_surface) {
    with (obj_teammate_follower) instance_destroy();
} else if (instance_exists(obj_teammate_follower)) {
    with (obj_teammate_follower) {
        if (party_slot < 0 || !variable_global_exists("teammate_roster") || party_slot >= array_length(global.teammate_roster) || !global.teammate_roster[party_slot].active) {
            instance_destroy();
        }
    }
}

if (room != room_dome) {
    with (obj_teammate_roamer) instance_destroy();
} else if (variable_global_exists("teammate_roster")) {
    for (var roam_cleanup_i = 0; roam_cleanup_i < instance_number(obj_teammate_roamer); roam_cleanup_i++) {
        var cleanup_roamer = instance_find(obj_teammate_roamer, roam_cleanup_i);
        if (cleanup_roamer.party_slot < 0 || cleanup_roamer.party_slot >= array_length(global.teammate_roster)) {
            with (cleanup_roamer) instance_destroy();
        }
    }

    for (var roam_i = 0; roam_i < array_length(global.teammate_roster); roam_i++) {
        var found_roamer = noone;
        for (var roam_find_i = 0; roam_find_i < instance_number(obj_teammate_roamer); roam_find_i++) {
            var roamer_inst = instance_find(obj_teammate_roamer, roam_find_i);
            if (roamer_inst.party_slot == roam_i) {
                found_roamer = roamer_inst;
                break;
            }
        }
        if (found_roamer == noone) {
            found_roamer = instance_create_layer(360 + roam_i * 80, 736, "Instances", obj_teammate_roamer);
            found_roamer.party_slot = roam_i;
            found_roamer.target_x = found_roamer.x;
            found_roamer.wait_timer = irandom_range(30, 120);
        }
    }
}

if (room == room_surface && !global.combat_active && variable_global_exists("teammate_roster")) {
    var follow_number = 0;
    for (var follow_i = 0; follow_i < array_length(global.teammate_roster); follow_i++) {
        var follow_recruit = global.teammate_roster[follow_i];
        if (follow_recruit.active) {
            var found_follower = noone;
            var follower_count = instance_number(obj_teammate_follower);
            for (var follower_i = 0; follower_i < follower_count; follower_i++) {
                var follower_inst = instance_find(obj_teammate_follower, follower_i);
                if (follower_inst.party_slot == follow_i) {
                    found_follower = follower_inst;
                    break;
                }
            }
            if (found_follower == noone) {
                found_follower = instance_create_layer(x - 42 - follow_number * 34, y + 28, "Instances", obj_teammate_follower);
                found_follower.party_slot = follow_i;
            }
            found_follower.follow_order = follow_number;
            follow_number++;
        }
    }
}

if (global.combat_active) {
    vx = 0;
    vy = 0;
    sprite_index = spr_player_land_idle;
    image_index = 0;
    image_speed = 0;

    if (global.combat_lunge_timer > 0) {
        global.combat_lunge_timer--;
    }

    if (!variable_global_exists("combat_float_texts")) {
        global.combat_float_texts = [];
    }
    for (var float_i = array_length(global.combat_float_texts) - 1; float_i >= 0; float_i--) {
        var float_data = global.combat_float_texts[float_i];
        float_data.timer -= 1;
        float_data.yoff -= 0.8;
        global.combat_float_texts[float_i] = float_data;
        if (float_data.timer <= 0) {
            array_delete(global.combat_float_texts, float_i, 1);
        }
    }

    var world_lunge_amount = 0;
    if (global.combat_lunge_timer > 0) {
        if (global.combat_lunge_timer > 9) {
            world_lunge_amount = (18 - global.combat_lunge_timer) * 3;
        } else {
            world_lunge_amount = global.combat_lunge_timer * 3;
        }
    }

    x = global.combat_view_x + 220;
    if (global.combat_lunge_side == "party" && global.combat_lunge_index == 0) x += world_lunge_amount;
    y = global.combat_view_y + 330;
    image_xscale = max(abs(image_xscale), 2.5);

    var enemy_slots = [
        [725, 315],
        [565, 315],
        [645, 350],
        [485, 350]
    ];

    var e_count = array_length(global.combat_enemies);
    for (var e = 0; e < e_count; e++) {
        var enemy_inst = global.combat_enemies[e];
        if (instance_exists(enemy_inst)) {
            enemy_inst.x = global.combat_view_x + enemy_slots[e][0];
            if (global.combat_lunge_side == "enemy" && global.combat_lunge_index == e) enemy_inst.x -= world_lunge_amount;
            enemy_inst.y = global.combat_view_y + enemy_slots[e][1];
            enemy_inst.image_xscale = max(abs(enemy_inst.image_xscale), 1.35);
        }
    }

    if (global.combat_timer > 0) {
        global.combat_timer--;
    }

    if (global.combat_phase == "player_wait" && global.combat_timer <= 0) {
        while (global.combat_enemy_actor < array_length(global.combat_enemies) && !instance_exists(global.combat_enemies[global.combat_enemy_actor])) {
            global.combat_enemy_actor++;
        }

        if (global.combat_enemy_actor < array_length(global.combat_enemies)) {
            global.combat_phase = "enemy_wait";
            global.combat_timer = 30;
        } else {
            var extra_actor = global.combat_actor + 1;
            while (extra_actor < array_length(global.combat_party) && global.combat_party[extra_actor].hp <= 0) {
                extra_actor++;
            }

            if (extra_actor < array_length(global.combat_party)) {
                global.combat_actor = extra_actor;
                global.combat_phase = "player_select";
                global.combat_message = global.combat_party[global.combat_actor].name + " is ready.";
            } else {
                for (var ep = 0; ep < array_length(global.combat_enemies); ep++) {
                    var protected_enemy = global.combat_enemies[ep];
                    if (instance_exists(protected_enemy) && variable_instance_exists(protected_enemy, "enemy_protect")) {
                        protected_enemy.enemy_protect = max(0, protected_enemy.enemy_protect - 1);
                    }
                }
                for (var pc = 0; pc < array_length(global.combat_party); pc++) {
                    var cds = global.combat_party[pc].cooldowns;
                    for (var ci = 0; ci < array_length(cds); ci++) {
                        cds[ci] = max(0, cds[ci] - 1);
                    }
                    global.combat_party[pc].guard = false;
                }
                global.combat_enemy_actor = 0;
                global.combat_actor = 0;
                while (global.combat_actor < array_length(global.combat_party) && global.combat_party[global.combat_actor].hp <= 0) {
                    global.combat_actor++;
                }
                global.combat_phase = "player_select";
                global.combat_message = global.combat_party[global.combat_actor].name + " is ready.";
            }
        }
    }

    if (global.combat_phase == "enemy_wait" && global.combat_timer <= 0) {
        while (global.combat_enemy_actor < array_length(global.combat_enemies) && !instance_exists(global.combat_enemies[global.combat_enemy_actor])) {
            global.combat_enemy_actor++;
        }

        if (global.combat_enemy_actor >= array_length(global.combat_enemies)) {
            for (var ep = 0; ep < array_length(global.combat_enemies); ep++) {
                var protected_enemy = global.combat_enemies[ep];
                if (instance_exists(protected_enemy) && variable_instance_exists(protected_enemy, "enemy_protect")) {
                    protected_enemy.enemy_protect = max(0, protected_enemy.enemy_protect - 1);
                }
            }
            for (var pc = 0; pc < array_length(global.combat_party); pc++) {
                var cds = global.combat_party[pc].cooldowns;
                for (var ci = 0; ci < array_length(cds); ci++) {
                    cds[ci] = max(0, cds[ci] - 1);
                }
                global.combat_party[pc].guard = false;
            }
            global.combat_actor = 0;
            while (global.combat_actor < array_length(global.combat_party) && global.combat_party[global.combat_actor].hp <= 0) {
                global.combat_actor++;
            }
            global.combat_phase = "player_select";
            global.combat_message = global.combat_party[global.combat_actor].name + " is ready.";
        } else {
            var enemy_attacker = global.combat_enemies[global.combat_enemy_actor];
            var enemy_name = "Enemy";
            if (instance_exists(enemy_attacker) && variable_instance_exists(enemy_attacker, "enemy_display_name")) {
                enemy_name = enemy_attacker.enemy_display_name;
            }
            var live_targets = [];
            for (var ti = 0; ti < array_length(global.combat_party); ti++) {
                if (global.combat_party[ti].hp > 0) {
                    live_targets[array_length(live_targets)] = ti;
                }
            }
            var target_index = -1;
            if (array_length(live_targets) > 0) {
                target_index = live_targets[irandom(array_length(live_targets) - 1)];
            }

            if (target_index != -1 && instance_exists(enemy_attacker)) {
                var role = variable_instance_exists(enemy_attacker, "enemy_role") ? enemy_attacker.enemy_role : "fighter";
                var acted = false;

                if (role == "shaman") {
                    var heal_target_enemy = noone;
                    var lowest_enemy_pct = 1;
                    for (var shi = 0; shi < array_length(global.combat_enemies); shi++) {
                        var hurt_enemy = global.combat_enemies[shi];
                        if (instance_exists(hurt_enemy) && hurt_enemy.hp > 0 && hurt_enemy.hp < hurt_enemy.max_hp) {
                            var hurt_pct = hurt_enemy.hp / hurt_enemy.max_hp;
                            if (hurt_pct < lowest_enemy_pct) {
                                lowest_enemy_pct = hurt_pct;
                                heal_target_enemy = hurt_enemy;
                            }
                        }
                    }

                    if (heal_target_enemy != noone && lowest_enemy_pct < 0.75 && irandom(99) < 65) {
                        var enemy_heal = irandom_range(12, 22);
                        heal_target_enemy.hp = min(heal_target_enemy.max_hp, heal_target_enemy.hp + enemy_heal);
                        var heal_enemy_index = 0;
                        for (var heal_find_i = 0; heal_find_i < array_length(global.combat_enemies); heal_find_i++) {
                            if (global.combat_enemies[heal_find_i] == heal_target_enemy) heal_enemy_index = heal_find_i;
                        }
                        global.combat_float_texts[array_length(global.combat_float_texts)] = { side: "enemy", index: heal_enemy_index, text: "+" + string(enemy_heal), col: make_colour_rgb(80, 240, 120), timer: 48, yoff: 0 };
                        global.combat_message = enemy_name + " mends an ally for " + string(enemy_heal) + ".";
                        acted = true;
                    } else if (irandom(99) < 55) {
                        var guard_choices = [];
                        for (var shi_guard = 0; shi_guard < array_length(global.combat_enemies); shi_guard++) {
                            var guard_enemy = global.combat_enemies[shi_guard];
                            if (instance_exists(guard_enemy) && (!variable_instance_exists(guard_enemy, "enemy_protect") || guard_enemy.enemy_protect <= 0)) {
                                guard_choices[array_length(guard_choices)] = guard_enemy;
                            }
                        }

                        if (array_length(guard_choices) > 0) {
                            var guarded_enemy = guard_choices[irandom(array_length(guard_choices) - 1)];
                            guarded_enemy.enemy_protect = 2;
                            var guarded_name = variable_instance_exists(guarded_enemy, "enemy_display_name") ? guarded_enemy.enemy_display_name : "Enemy";
                            global.combat_message = enemy_name + " protects a " + guarded_name + ".";
                            acted = true;
                        }
                    }
                } else if (irandom(99) < 25) {
                    enemy_attacker.enemy_protect = 2;
                    global.combat_message = enemy_name + " hardens its guard.";
                    acted = true;
                }

                if (!acted) {
                    var move_roll = irandom(99);
                    var edmg = irandom_range(8, 16);
                    var move_text = "attacks";

                    if (role == "shaman") {
                        edmg = irandom_range(5, 11);
                        move_text = choose("curses", "hexes");
                    } else if (move_roll < 25) {
                        edmg = irandom_range(15, 24);
                        move_text = "crushes";
                    } else if (move_roll < 55) {
                        edmg = irandom_range(7, 13);
                        move_text = "spits acid at";
                    } else {
                        move_text = choose("swipes at", "bites");
                    }

                    if (global.combat_party[target_index].guard) edmg = ceil(edmg * 0.4);
                    global.combat_party[target_index].hp -= edmg;
                    global.combat_float_texts[array_length(global.combat_float_texts)] = { side: "party", index: target_index, text: "-" + string(edmg), col: make_colour_rgb(255, 80, 70), timer: 48, yoff: 0 };
                    global.combat_lunge_side = "enemy";
                    global.combat_lunge_index = global.combat_enemy_actor;
                    global.combat_lunge_timer = 18;
                    global.combat_message = enemy_name + " " + move_text + " " + global.combat_party[target_index].name + " for " + string(edmg) + ".";
                    if (target_index == 0) {
                        hp = max(0, global.combat_party[target_index].hp);
                    }
                }
            }

            var party_alive = false;
            for (var pa = 0; pa < array_length(global.combat_party); pa++) {
                if (global.combat_party[pa].hp > 0) party_alive = true;
            }

            if (!party_alive) {
                hp = max_hp;
                oxygen = 100;
                for (var er = 0; er < array_length(global.combat_enemies); er++) {
                    var reset_enemy = global.combat_enemies[er];
                    if (instance_exists(reset_enemy)) {
                        reset_enemy.x = reset_enemy.combat_return_x;
                        reset_enemy.y = reset_enemy.combat_return_y;
                        reset_enemy.image_xscale = reset_enemy.combat_saved_xscale;
                        reset_enemy.image_index = 0;
                    }
                }
                global.combat_active = false;
                global.combat_enemy = noone;
                global.combat_phase = "none";
                image_xscale = combat_saved_xscale;
                x = room_width * 0.5;
                y = 704;
                room_goto(room_dome);
                exit;
            }

            global.combat_enemy_actor++;
            var follow_actor = global.combat_actor + 1;
            while (follow_actor < array_length(global.combat_party) && global.combat_party[follow_actor].hp <= 0) {
                follow_actor++;
            }
            if (follow_actor < array_length(global.combat_party)) {
                global.combat_actor = follow_actor;
                global.combat_phase = "player_select";
                global.combat_message = global.combat_party[global.combat_actor].name + " is ready.";
            } else {
                global.combat_actor = 0;
                global.combat_phase = "player_wait";
                global.combat_timer = 35;
            }
        }
    }

    if (global.combat_phase == "target_select") {
        var selected_enemy = -1;
        var enemy_target_count = min(array_length(global.combat_enemies), 9);
        for (var key_target = 0; key_target < enemy_target_count; key_target++) {
            if (keyboard_check_pressed(ord(string(key_target + 1))) && instance_exists(global.combat_enemies[key_target])) {
                selected_enemy = key_target;
            }
        }

        if (mouse_check_button_pressed(mb_left)) {
            var tmx = device_mouse_x_to_gui(0);
            var tmy = device_mouse_y_to_gui(0);
            var tgw = display_get_gui_width();
            var enemy_gui_slots = [
                [tgw - 100, 248],
                [tgw - 260, 248],
                [tgw - 420, 286],
                [tgw - 580, 248]
            ];

            for (var click_enemy = 0; click_enemy < array_length(global.combat_enemies); click_enemy++) {
                var click_slot = enemy_gui_slots[click_enemy];
                if (instance_exists(global.combat_enemies[click_enemy]) && point_in_rectangle(tmx, tmy, click_slot[0] - 78, click_slot[1] - 120, click_slot[0] + 78, click_slot[1] + 140)) {
                    selected_enemy = click_enemy;
                }
            }
        }

        if (selected_enemy != -1) {
            var pending_actor = global.combat_party[global.combat_actor];
            var pending_move = global.combat_moves[global.combat_pending_move];
            var chosen_foe = global.combat_enemies[selected_enemy];
            var target_damage = irandom_range(pending_move.min_value, pending_move.max_value);
            if (variable_instance_exists(chosen_foe, "enemy_protect") && chosen_foe.enemy_protect > 0) {
                target_damage = ceil(target_damage * 0.5);
            }
            chosen_foe.hp -= target_damage;
            global.combat_float_texts[array_length(global.combat_float_texts)] = { side: "enemy", index: selected_enemy, text: "-" + string(target_damage), col: make_colour_rgb(255, 80, 70), timer: 48, yoff: 0 };
            pending_actor.cooldowns[global.combat_pending_move] = pending_move.cooldown;
            global.combat_lunge_side = "party";
            global.combat_lunge_index = global.combat_actor;
            global.combat_lunge_timer = 18;
            var chosen_name = variable_instance_exists(chosen_foe, "enemy_display_name") ? chosen_foe.enemy_display_name : "Enemy";
            global.combat_message = pending_actor.name + " hits " + chosen_name + " with " + pending_move.name + " for " + string(target_damage) + ".";
            global.combat_pending_move = -1;

            var targeted_enemies_alive = false;
            for (var tea = 0; tea < array_length(global.combat_enemies); tea++) {
                var target_alive_enemy = global.combat_enemies[tea];
                if (instance_exists(target_alive_enemy)) {
                    if (target_alive_enemy.hp <= 0) {
                        with (target_alive_enemy) instance_destroy();
                    } else {
                        targeted_enemies_alive = true;
                    }
                }
            }

            if (!targeted_enemies_alive) {
                hp = max(1, global.combat_party[0].hp);
                global.combat_active = false;
                global.combat_enemy = noone;
                global.combat_phase = "none";
                global.combat_message = "Enemy defeated.";
                x = global.combat_player_return_x;
                y = global.combat_player_return_y;
                image_xscale = combat_saved_xscale;
            } else {
                global.combat_phase = "player_wait";
                global.combat_timer = 35;
            }
        }
    }

    if (global.combat_phase == "player_select" && array_length(global.combat_enemies) > 0) {
        var move = 0;
        var available_move_count = min(array_length(global.combat_moves), 9);
        for (var key_move = 0; key_move < available_move_count; key_move++) {
            if (keyboard_check_pressed(ord(string(key_move + 1)))) {
                move = key_move + 1;
            }
        }

        if (mouse_check_button_pressed(mb_left)) {
            var mx = device_mouse_x_to_gui(0);
            var my = device_mouse_y_to_gui(0);
            var bw = 320;
            var bh = 48;
            var bx = 60;
            var by = display_get_gui_height() - 256;
            for (var i = 0; i < available_move_count; i++) {
                if (point_in_rectangle(mx, my, bx, by + (i * 54), bx + bw, by + (i * 54) + bh)) {
                    move = i + 1;
                }
            }
        }

        if (move > 0) {
            var actor_data = global.combat_party[global.combat_actor];
            var move_data = global.combat_moves[move - 1];
            if (actor_data.cooldowns[move - 1] > 0) {
                global.combat_message = move_data.name + " is cooling down for " + string(actor_data.cooldowns[move - 1]) + " turn(s).";
                exit;
            }

            global.combat_guard = false;
            global.combat_selected_move = move;
            var dmg = 0;
            var target_enemy_index = -1;
            for (var fe = 0; fe < array_length(global.combat_enemies); fe++) {
                if (instance_exists(global.combat_enemies[fe]) && target_enemy_index == -1) {
                    target_enemy_index = fe;
                }
            }

            if (move_data.kind == "damage" && target_enemy_index != -1) {
                global.combat_pending_move = move - 1;
                global.combat_phase = "target_select";
                global.combat_message = actor_data.name + " uses " + move_data.name + ". Choose an enemy target.";
                exit;
            } else if (move_data.kind == "heal") {
                var heal_target = global.combat_actor;
                var lowest_pct = 2;
                for (var ht = 0; ht < array_length(global.combat_party); ht++) {
                    if (global.combat_party[ht].hp > 0) {
                        var hp_pct = global.combat_party[ht].hp / global.combat_party[ht].max_hp;
                        if (hp_pct < lowest_pct) {
                            lowest_pct = hp_pct;
                            heal_target = ht;
                        }
                    }
                }
                var heal = irandom_range(move_data.min_value, move_data.max_value);
                global.combat_party[heal_target].hp = min(global.combat_party[heal_target].max_hp, global.combat_party[heal_target].hp + heal);
                global.combat_float_texts[array_length(global.combat_float_texts)] = { side: "party", index: heal_target, text: "+" + string(heal), col: make_colour_rgb(80, 240, 120), timer: 48, yoff: 0 };
                if (heal_target == 0) hp = global.combat_party[heal_target].hp;
                global.combat_message = actor_data.name + " repairs " + global.combat_party[heal_target].name + " for " + string(heal) + ".";
            } else if (move_data.kind == "guard") {
                global.combat_party[global.combat_actor].guard = true;
                global.combat_message = actor_data.name + " braces for impact.";
            }

            actor_data.cooldowns[move - 1] = move_data.cooldown;

            var enemies_alive = false;
            for (var ea = 0; ea < array_length(global.combat_enemies); ea++) {
                var alive_enemy = global.combat_enemies[ea];
                if (instance_exists(alive_enemy)) {
                    if (alive_enemy.hp <= 0) {
                        with (alive_enemy) instance_destroy();
                    } else {
                        enemies_alive = true;
                    }
                }
            }

            if (!enemies_alive) {
                hp = max(1, global.combat_party[0].hp);
                global.combat_active = false;
                global.combat_enemy = noone;
                global.combat_phase = "none";
                global.combat_message = "Enemy defeated.";
                x = global.combat_player_return_x;
                y = global.combat_player_return_y;
                image_xscale = combat_saved_xscale;
            } else {
                global.combat_phase = "player_wait";
                global.combat_timer = 35;
            }
        }
    }
    exit;
}

if (place_meeting(x, y, obj_enemy)) {
    var foe_touch = instance_place(x, y, obj_enemy);
    if (foe_touch != noone) {
        global.combat_view_x = clamp(x - 220, 0, room_width - 680);
        global.combat_view_y = clamp(y - 330, 0, room_height - 480);
        global.combat_player_return_x = x;
        global.combat_player_return_y = y;
        combat_saved_xscale = image_xscale;

        var max_combat_enemies = 4;
        var combat_join_distance = 360;
        global.combat_enemies = [];
        global.combat_enemies[0] = foe_touch;
        var enemy_count = 1;
        var total_enemies = instance_number(obj_enemy);
        for (var scan_enemy = 0; scan_enemy < total_enemies; scan_enemy++) {
            var found_enemy = instance_find(obj_enemy, scan_enemy);
            if (found_enemy != foe_touch && enemy_count < max_combat_enemies && point_distance(found_enemy.x, found_enemy.y, x, y) < combat_join_distance) {
                global.combat_enemies[enemy_count] = found_enemy;
                enemy_count++;
            }
        }

        for (var se = 0; se < array_length(global.combat_enemies); se++) {
            var setup_enemy = global.combat_enemies[se];
            if (instance_exists(setup_enemy)) {
                setup_enemy.combat_return_x = setup_enemy.x;
                setup_enemy.combat_return_y = setup_enemy.y;
                setup_enemy.combat_saved_xscale = setup_enemy.image_xscale;
                setup_enemy.enemy_protect = 0;
                setup_enemy.image_index = 0;
            }
        }

        for (var sort_i = 0; sort_i < array_length(global.combat_enemies); sort_i++) {
            for (var sort_j = sort_i + 1; sort_j < array_length(global.combat_enemies); sort_j++) {
                var enemy_a = global.combat_enemies[sort_i];
                var enemy_b = global.combat_enemies[sort_j];
                var a_shaman = instance_exists(enemy_a) && variable_instance_exists(enemy_a, "enemy_role") && enemy_a.enemy_role == "shaman";
                var b_shaman = instance_exists(enemy_b) && variable_instance_exists(enemy_b, "enemy_role") && enemy_b.enemy_role == "shaman";
                if (!a_shaman && b_shaman) {
                    global.combat_enemies[sort_i] = enemy_b;
                    global.combat_enemies[sort_j] = enemy_a;
                }
            }
        }

        var unique_enemy_names = ["Brinejaw", "Kelpmaw", "Riftclaw", "Siltfang", "Gloomfin", "Reefbite", "Murktooth", "Abyssal", "Chanter", "Caller", "Mireseer", "Saltwitch"];
        var used_enemy_names = [];
        for (var name_i = 0; name_i < array_length(global.combat_enemies); name_i++) {
            var named_enemy = global.combat_enemies[name_i];
            if (instance_exists(named_enemy)) {
                var current_name = variable_instance_exists(named_enemy, "enemy_display_name") ? named_enemy.enemy_display_name : "Enemy";
                var duplicate_name = false;
                for (var used_i = 0; used_i < array_length(used_enemy_names); used_i++) {
                    if (used_enemy_names[used_i] == current_name) duplicate_name = true;
                }

                while (duplicate_name) {
                    current_name = unique_enemy_names[irandom(array_length(unique_enemy_names) - 1)];
                    duplicate_name = false;
                    for (var check_i = 0; check_i < array_length(used_enemy_names); check_i++) {
                        if (used_enemy_names[check_i] == current_name) duplicate_name = true;
                    }
                }

                named_enemy.enemy_display_name = current_name;
                used_enemy_names[array_length(used_enemy_names)] = current_name;
            }
        }

        var move_count = array_length(global.combat_moves);
        global.combat_party = [
            {
                name: "Diver",
                hp: hp,
                max_hp: max_hp,
                sprite: spr_player_land_idle,
                image: 0,
                guard: false,
                cooldowns: array_create(move_count, 0)
            }
        ];
        if (!variable_global_exists("teammate_roster")) {
            global.teammate_roster = [];
        }
        for (var party_member_i = 0; party_member_i < array_length(global.teammate_roster); party_member_i++) {
            var recruit = global.teammate_roster[party_member_i];
            if (array_length(global.combat_party) < 4 && recruit.active) {
                global.combat_party[array_length(global.combat_party)] = {
                    name: recruit.name,
                    hp: recruit.hp,
                    max_hp: recruit.max_hp,
                    sprite: recruit.sprite,
                    image: 0,
                    guard: false,
                    cooldowns: array_create(move_count, 0)
                };
            }
        }

        global.combat_active = true;
        global.combat_enemy = foe_touch;
        global.combat_phase = "player_select";
        global.combat_actor = 0;
        global.combat_enemy_actor = 0;
        global.combat_timer = 0;
        global.combat_lunge_timer = 0;
        global.combat_pending_move = -1;
        global.combat_float_texts = [];
        global.combat_message = "An enemy team blocks the path.";
        global.combat_guard = false;
        global.combat_selected_move = 0;
        exit;
    }
}

// Reset flags first so other objects can set them this frame
in_dome = false;
near_submarine = false;

// Input
var move_left  = keyboard_check(vk_left)  || keyboard_check(ord("A"));
var move_right = keyboard_check(vk_right) || keyboard_check(ord("D"));
var jump       = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
var interact   = keyboard_check_pressed(ord("E"));

// Horizontal movement
if (move_left)
{
    vx -= spd * 0.3;
    facing_right = false;
    image_xscale = -2;
}

if (move_right)
{
    vx += spd * 0.3;
    facing_right = true;
    image_xscale = 2;
}

var player_is_moving = (vx != 0 || vy != 0);
var player_in_water = (room == room_ocean_floor_left_1 || room == room_ocean_floor_right_1);

if (player_is_moving)
{
    image_speed = 1;
    sprite_index = player_in_water ? spr_player_water_walk : spr_player_land_walk;
}
else
{
    image_speed = 0;
    image_index = 0;
    sprite_index = player_in_water ? spr_player_water_idle : spr_player_land_idle;
}

vx *= 0.85;

// Gravity + jump
if (jump && on_ground) vy = jump_force;
vy += grav;
vy = min(vy, 18);

// Horizontal collision
if (place_meeting(x + vx, y, obj_platform)) {
    while (!place_meeting(x + sign(vx), y, obj_platform)) {
        x += sign(vx);
    }
    vx = 0;
}
x += vx;

// Vertical collision
on_ground = false;
if (place_meeting(x, y + vy, obj_platform)) {
    while (!place_meeting(x, y + sign(vy), obj_platform)) {
        y += sign(vy);
    }
    if (vy > 0) on_ground = true;
    vy = 0;
}
y += vy;

// Clamp to room
x = clamp(x, 14, room_width - 14);

// Oxygen logic
if (room == room_dome) {
    oxygen = min(100, oxygen + ox_refill);
} else if (room == room_ocean_floor_left_1 || room == room_ocean_floor_right_1) {
    oxygen -= ox_drain;
}
    
    if (oxygen <= 0) {
    oxygen = 100;
    vx = 0;
    vy = 0;
    if (instance_exists(obj_resource_manager)) {
        obj_resource_manager.iron     = 0;
        obj_resource_manager.crystal  = 0;
        obj_resource_manager.obsidian = 0;
    }
    x = room_width * 0.5;
    y = 704;
    room_goto(room_dome);
}


// Submarine 
var near_sub = false;
if (instance_exists(obj_submarine)) {
    var dist = point_distance(x, y, obj_submarine.x, obj_submarine.y);
    if (dist < 60) {
        near_sub = true;
    }
}

if (interact && near_sub) {
    vx = 0;
    vy = 0;
    if (room == room_ocean_floor_right_1) {
        x = 192;
        y = 704;
        room_goto(room_surface);
    } else if (room == room_surface) {
        x = 352;
        y = 704;
        room_goto(room_ocean_floor_right_1);
    }
}
