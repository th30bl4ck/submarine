if (!variable_global_exists("combat_active")) {
    global.combat_active = false;
}

if (global.combat_active) {
    vx = 0;
    vy = 0;
    x = global.combat_view_x + 220;
    y = global.combat_view_y + 330;
    image_xscale = abs(image_xscale);

    if (instance_exists(global.combat_enemy)) {
        global.combat_enemy.x = global.combat_view_x + 470;
        global.combat_enemy.y = global.combat_view_y + 330;
        global.combat_enemy.image_xscale = -abs(global.combat_enemy.image_xscale);
    }

    if (global.combat_turn == "player" && instance_exists(global.combat_enemy)) {
        var move = 0;
        if (keyboard_check_pressed(ord("1"))) move = 1;
        if (keyboard_check_pressed(ord("2"))) move = 2;
        if (keyboard_check_pressed(ord("3"))) move = 3;
        if (keyboard_check_pressed(ord("4"))) move = 4;

        if (mouse_check_button_pressed(mb_left)) {
            var mx = device_mouse_x_to_gui(0);
            var my = device_mouse_y_to_gui(0);
            var bw = 320;
            var bh = 48;
            var bx = 60;
            var by = display_get_gui_height() - 256;
            for (var i = 0; i < 4; i++) {
                if (point_in_rectangle(mx, my, bx, by + (i * 54), bx + bw, by + (i * 54) + bh)) {
                    move = i + 1;
                }
            }
        }

        if (move > 0) {
            global.combat_guard = false;
            global.combat_selected_move = move;
            var foe = global.combat_enemy;
            var dmg = 0;

            switch (move) {
                case 1:
                    dmg = irandom_range(combat_attack - 3, combat_attack + 5);
                    foe.hp -= dmg;
                    global.combat_message = "Harpoon Strike hits for " + string(dmg) + ".";
                    break;
                case 2:
                    global.combat_guard = true;
                    global.combat_message = "You brace for the enemy's blow.";
                    break;
                case 3:
                    var heal = irandom_range(12, 20);
                    hp = min(max_hp, hp + heal);
                    global.combat_message = "Repair Suit restores " + string(heal) + " HP.";
                    break;
                case 4:
                    dmg = irandom_range(5, 26);
                    foe.hp -= dmg;
                    global.combat_message = "Desperate Flare burns for " + string(dmg) + ".";
                    break;
            }

            if (foe.hp <= 0) {
                with (foe) instance_destroy();
                global.combat_active = false;
                global.combat_enemy = noone;
                global.combat_turn = "player";
                global.combat_message = "Enemy defeated.";
                x = global.combat_player_return_x;
                y = global.combat_player_return_y;
                image_xscale = combat_saved_xscale;
            } else {
                var edmg = irandom_range(8, 16);
                if (global.combat_guard) edmg = ceil(edmg * 0.4);
                hp -= edmg;
                global.combat_message += " Enemy lashes back for " + string(edmg) + ".";

                if (hp <= 0) {
                    hp = max_hp;
                    oxygen = 100;
                    foe.x = global.combat_enemy_return_x;
                    foe.y = global.combat_enemy_return_y;
                    foe.image_xscale = foe.combat_saved_xscale;
                    global.combat_active = false;
                    global.combat_enemy = noone;
                    global.combat_turn = "player";
                    image_xscale = combat_saved_xscale;
                    if (instance_exists(obj_dome)) {
                        x = obj_dome.x;
                        y = obj_dome.y;
                    } else {
                        x = player_spawn_x;
                        y = player_spawn_y;
                    }
                }
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
        global.combat_enemy_return_x = foe_touch.x;
        global.combat_enemy_return_y = foe_touch.y;
        combat_saved_xscale = image_xscale;
        if (!variable_instance_exists(foe_touch, "combat_saved_xscale")) {
            foe_touch.combat_saved_xscale = foe_touch.image_xscale;
        }
        global.combat_active = true;
        global.combat_enemy = foe_touch;
        global.combat_turn = "player";
        global.combat_message = "An enemy blocks the path.";
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
if (move_left)  { vx -= spd * 0.3; facing_right = false; }
if (move_right) { vx += spd * 0.3; facing_right = true;  }
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
