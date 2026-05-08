if (!variable_global_exists("combat_active")) {
    global.combat_active = false;
}

if (global.combat_active) {
    vx = 0;
    vy = 0;

    if (global.combat_lunge_timer > 0) {
        global.combat_lunge_timer--;
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
    image_xscale = abs(image_xscale);

    var enemy_slots = [
        [485, 350],
        [565, 315],
        [645, 350],
        [725, 315]
    ];

    var e_count = array_length(global.combat_enemies);
    for (var e = 0; e < e_count; e++) {
        var enemy_inst = global.combat_enemies[e];
        if (instance_exists(enemy_inst)) {
            enemy_inst.x = global.combat_view_x + enemy_slots[e][0];
            if (global.combat_lunge_side == "enemy" && global.combat_lunge_index == e) enemy_inst.x -= world_lunge_amount;
            enemy_inst.y = global.combat_view_y + enemy_slots[e][1];
            enemy_inst.image_xscale = -abs(enemy_inst.image_xscale);
        }
    }

    if (global.combat_timer > 0) {
        global.combat_timer--;
    }

    if (global.combat_phase == "player_wait" && global.combat_timer <= 0) {
        var next_actor = global.combat_actor + 1;
        while (next_actor < array_length(global.combat_party) && global.combat_party[next_actor].hp <= 0) {
            next_actor++;
        }

        if (next_actor < array_length(global.combat_party)) {
            global.combat_actor = next_actor;
            global.combat_phase = "player_select";
            global.combat_message = global.combat_party[global.combat_actor].name + " is ready.";
        } else {
            global.combat_enemy_actor = 0;
            global.combat_phase = "enemy_wait";
            global.combat_timer = 90;
            global.combat_message = "The enemy team gathers itself...";
        }
    }

    if (global.combat_phase == "enemy_wait" && global.combat_timer <= 0) {
        while (global.combat_enemy_actor < array_length(global.combat_enemies) && !instance_exists(global.combat_enemies[global.combat_enemy_actor])) {
            global.combat_enemy_actor++;
        }

        if (global.combat_enemy_actor >= array_length(global.combat_enemies)) {
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
                var edmg = irandom_range(8, 16);
                if (global.combat_party[target_index].guard) edmg = ceil(edmg * 0.4);
                global.combat_party[target_index].hp -= edmg;
                global.combat_lunge_side = "enemy";
                global.combat_lunge_index = global.combat_enemy_actor;
                global.combat_lunge_timer = 18;
                global.combat_message = "Enemy " + string(global.combat_enemy_actor + 1) + " attacks " + global.combat_party[target_index].name + " for " + string(edmg) + ".";
                if (target_index == 0) {
                    hp = max(0, global.combat_party[target_index].hp);
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
                    }
                }
                global.combat_active = false;
                global.combat_enemy = noone;
                global.combat_phase = "none";
                image_xscale = combat_saved_xscale;
                if (instance_exists(obj_dome)) {
                    x = obj_dome.x;
                    y = obj_dome.y;
                } else {
                    x = player_spawn_x;
                    y = player_spawn_y;
                }
                exit;
            }

            global.combat_enemy_actor++;
            global.combat_timer = 75;
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
                [tgw - 125, 286],
                [tgw - 205, 248],
                [tgw - 285, 286],
                [tgw - 365, 248]
            ];

            for (var click_enemy = 0; click_enemy < array_length(global.combat_enemies); click_enemy++) {
                var click_slot = enemy_gui_slots[click_enemy];
                if (instance_exists(global.combat_enemies[click_enemy]) && point_in_rectangle(tmx, tmy, click_slot[0] - 54, click_slot[1] - 70, click_slot[0] + 54, click_slot[1] + 110)) {
                    selected_enemy = click_enemy;
                }
            }
        }

        if (selected_enemy != -1) {
            var pending_actor = global.combat_party[global.combat_actor];
            var pending_move = global.combat_moves[global.combat_pending_move];
            var chosen_foe = global.combat_enemies[selected_enemy];
            var target_damage = irandom_range(pending_move.min_value, pending_move.max_value);
            chosen_foe.hp -= target_damage;
            pending_actor.cooldowns[global.combat_pending_move] = pending_move.cooldown;
            global.combat_lunge_side = "party";
            global.combat_lunge_index = global.combat_actor;
            global.combat_lunge_timer = 18;
            global.combat_message = pending_actor.name + " hits Enemy " + string(selected_enemy + 1) + " with " + pending_move.name + " for " + string(target_damage) + ".";
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
            }
        }

        var move_count = array_length(global.combat_moves);
        global.combat_party = [
            {
                name: "Diver",
                hp: hp,
                max_hp: max_hp,
                sprite: sprite_index,
                image: image_index,
                guard: false,
                cooldowns: array_create(move_count, 0)
            },
            {
                name: "Mechanic",
                hp: 80,
                max_hp: 80,
                sprite: sprite_index,
                image: image_index,
                guard: false,
                cooldowns: array_create(move_count, 0)
            },
            {
                name: "Scout",
                hp: 75,
                max_hp: 75,
                sprite: sprite_index,
                image: image_index,
                guard: false,
                cooldowns: array_create(move_count, 0)
            },
            {
                name: "Bulwark",
                hp: 110,
                max_hp: 110,
                sprite: sprite_index,
                image: image_index,
                guard: false,
                cooldowns: array_create(move_count, 0)
            }
        ];

        global.combat_active = true;
        global.combat_enemy = foe_touch;
        global.combat_phase = "player_select";
        global.combat_actor = 0;
        global.combat_enemy_actor = 0;
        global.combat_timer = 0;
        global.combat_lunge_timer = 0;
        global.combat_pending_move = -1;
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
var player_in_dome = false;
if (room == room_ocean && instance_exists(obj_dome) && instance_exists(obj_resource_manager)) {
    var anim_dm = obj_dome;
    var anim_rm = obj_resource_manager;
    var anim_dx = (x - anim_dm.x) / anim_rm.dome_width;
    var anim_dy = (y - anim_dm.y) / anim_rm.dome_height;
    player_in_dome = ((anim_dx * anim_dx) + (anim_dy * anim_dy) < 1);
}
var player_in_water = (room == room_ocean && !player_in_dome);

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
if (room == room_ocean) {
    var inside_dome = false;
    if (instance_exists(obj_dome)) {
        var dm = obj_dome;
        var rm = obj_resource_manager;
        var dx = (x - dm.x) / rm.dome_width;
        var dy = (y - dm.y) / rm.dome_height;
        inside_dome = ((dx * dx) + (dy * dy) < 1);
    }
    
    if (inside_dome) {
    oxygen = min(100, oxygen + ox_refill);
        } else {
    oxygen -= ox_drain;
    }
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
    if (instance_exists(obj_dome)) {
        x = obj_dome.x;
        y = obj_dome.y;
    }
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
    if (room == room_ocean) {
        player_spawn_x = 200;
        player_spawn_y = 500;
        room_goto(room_surface);
    } else if (room == room_surface) {
        player_spawn_x = 340;
        player_spawn_y = 2300;
        room_goto(room_ocean);
    }
}
