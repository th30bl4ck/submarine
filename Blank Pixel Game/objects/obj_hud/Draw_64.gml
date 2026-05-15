if (!instance_exists(obj_player)) exit;
// Zone label

if (room == room_ocean) {
    var inside_dome = false;
    if (instance_exists(obj_dome) && instance_exists(obj_resource_manager)) {
        var dm = obj_dome;
        var rm = obj_resource_manager;
        var dx = (obj_player.x - dm.x) / rm.dome_width;
        var dy = (obj_player.y - dm.y) / rm.dome_height;
        inside_dome = ((dx * dx) + (dy * dy) < 1);
    }

    if (inside_dome) {
        draw_set_colour(c_aqua);
        draw_text(10, 10, "DOME — Safe");
    } else {
        draw_set_colour(make_colour_rgb(255, 170, 30));
        draw_text(10, 10, "OUTSIDE DOME — Oxygen depleting");
    }
}

// Oxygen bar 
var ox_pct = obj_player.oxygen / 100;
var bar_x = 10;
var bar_y = 34;
var bar_w = 200;
var bar_h = 12;

// Background
draw_set_colour(c_dkgray);
draw_rectangle(bar_x, bar_y, bar_x + bar_w, bar_y + bar_h, false);

if (obj_player.oxygen > 0) {
    var fill_w = floor(bar_w * ox_pct);
    var ox_col;
    if (ox_pct > 0.5)       ox_col = make_colour_rgb(50, 220, 100);
    else if (ox_pct > 0.25) ox_col = make_colour_rgb(255, 170, 30);
    else                     ox_col = make_colour_rgb(255, 50, 50);
    draw_set_colour(ox_col);
    draw_rectangle(bar_x, bar_y, bar_x + fill_w, bar_y + bar_h, false);
}

// Border
draw_set_colour(c_gray);
draw_rectangle(bar_x, bar_y, bar_x + bar_w, bar_y + bar_h, true);

draw_set_colour(c_white);

// Inventory display 
if (instance_exists(obj_resource_manager)) {
    var rm = obj_resource_manager;
    var pad = 10;
    var by  = display_get_gui_height() - 80;

    draw_set_colour(make_colour_rgb(10, 20, 35));
    draw_set_alpha(0.7);
    draw_rectangle(pad, by, 220, by + 70, false);
    draw_set_alpha(1);

    draw_set_colour(make_colour_rgb(180, 180, 180));
    draw_text(pad + 8, by + 6,  "Iron:     " + string(rm.iron));
    draw_set_colour(make_colour_rgb(100, 200, 255));
    draw_text(pad + 8, by + 26, "Crystal:  " + string(rm.crystal));
    draw_set_colour(make_colour_rgb(180, 100, 255));
    draw_text(pad + 8, by + 46, "Obsidian: " + string(rm.obsidian));

    draw_set_colour(c_white);
}

if (!variable_global_exists("combat_active") || !global.combat_active) {
    var prompt_y = display_get_gui_height() - 120;

    if (variable_global_exists("teammate_recruit_near") && global.teammate_recruit_near) {
        draw_set_colour(c_white);
        draw_text(250, prompt_y, "E Recruit teammate to storage");
    }

    if (variable_global_exists("teammate_manager_near") && global.teammate_manager_near && (!variable_global_exists("teammate_menu_open") || !global.teammate_menu_open)) {
        draw_set_colour(c_white);
        draw_text(250, prompt_y + 22, "E Manage party");
    }

    if (variable_global_exists("teammate_menu_open") && global.teammate_menu_open) {
        var menu_x = 260;
        var menu_y = 110;
        var menu_w = 360;
        var roster_count = variable_global_exists("teammate_roster") ? array_length(global.teammate_roster) : 0;
        var active_count = 0;
        for (var active_i = 0; active_i < roster_count; active_i++) {
            if (global.teammate_roster[active_i].active) active_count++;
        }

        draw_set_alpha(0.86);
        draw_set_colour(make_colour_rgb(12, 14, 20));
        draw_rectangle(menu_x, menu_y, menu_x + menu_w, menu_y + 120 + max(1, roster_count) * 28, false);
        draw_set_alpha(1);
        draw_set_colour(make_colour_rgb(150, 130, 100));
        draw_rectangle(menu_x, menu_y, menu_x + menu_w, menu_y + 120 + max(1, roster_count) * 28, true);

        draw_set_colour(c_white);
        draw_text(menu_x + 18, menu_y + 16, "PARTY MANAGER");
        draw_set_colour(make_colour_rgb(190, 190, 190));
        draw_text(menu_x + 18, menu_y + 40, "Party: Diver + " + string(active_count) + "/3 teammates");
        draw_text(menu_x + 18, menu_y + 62, "Press 1-9 to move recruits between party and storage");

        if (roster_count <= 0) {
            draw_set_colour(make_colour_rgb(180, 180, 180));
            draw_text(menu_x + 18, menu_y + 96, "No teammates in storage yet.");
        } else {
            for (var roster_i = 0; roster_i < min(roster_count, 9); roster_i++) {
                var recruit = global.teammate_roster[roster_i];
                var row_y = menu_y + 96 + roster_i * 28;
                draw_set_colour(recruit.active ? make_colour_rgb(120, 230, 150) : make_colour_rgb(190, 190, 190));
                draw_text(menu_x + 18, row_y, string(roster_i + 1) + " " + recruit.name + " HP " + string(recruit.max_hp));
                draw_text(menu_x + 230, row_y, recruit.active ? "Party" : "Storage");
            }
        }
    }

    if (variable_global_exists("teammate_recruit_near")) global.teammate_recruit_near = false;
    if (variable_global_exists("teammate_manager_near")) global.teammate_manager_near = false;
}

if (variable_global_exists("combat_active") && global.combat_active && array_length(global.combat_party) > 0) {
    var gui_w = display_get_gui_width();
    var gui_h = display_get_gui_height();

    draw_set_alpha(0.78);
    draw_set_colour(make_colour_rgb(8, 8, 12));
    draw_rectangle(0, 0, gui_w, gui_h, false);
    draw_set_alpha(1);

    draw_set_colour(make_colour_rgb(25, 23, 25));
    draw_rectangle(36, 34, gui_w - 36, gui_h - 30, false);
    draw_set_colour(make_colour_rgb(150, 130, 100));
    draw_rectangle(36, 34, gui_w - 36, gui_h - 30, true);

    draw_set_colour(c_white);
    draw_text(60, 54, "TURN-BASED COMBAT");
    draw_set_colour(make_colour_rgb(210, 190, 150));
    draw_text(60, 78, global.combat_phase == "target_select" ? "Choose an enemy target" : "Choose an action");

    var combat_draw_scale = 2.15;
    var party_slots = [
        [100, 286],
        [260, 248],
        [420, 286],
        [580, 248]
    ];
    var enemy_slots = [
        [gui_w - 100, 286],
        [gui_w - 260, 248],
        [gui_w - 420, 286],
        [gui_w - 580, 248]
    ];
    var lunge_amount = 0;
    if (global.combat_lunge_timer > 0) {
        if (global.combat_lunge_timer > 9) {
            lunge_amount = (18 - global.combat_lunge_timer) * 4;
        } else {
            lunge_amount = global.combat_lunge_timer * 4;
        }
    }

    for (var party_i = 0; party_i < array_length(global.combat_party); party_i++) {
        var member = global.combat_party[party_i];
        var px = party_slots[party_i][0];
        var py = party_slots[party_i][1];
        if (global.combat_lunge_side == "party" && global.combat_lunge_index == party_i) px += lunge_amount;

        draw_set_alpha(0.55);
        draw_set_colour(make_colour_rgb(80, 70, 62));
        draw_ellipse(px - 62, py + 58, px + 62, py + 86, false);
        draw_set_alpha(member.hp > 0 ? 1 : 0.35);
        draw_sprite_ext(member.sprite, member.image, px, py, combat_draw_scale, combat_draw_scale, 0, c_white, 1);
        draw_set_alpha(1);

        var hp_pct = max(0, member.hp) / member.max_hp;
        draw_set_colour(c_dkgray);
        draw_rectangle(px - 50, py + 88, px + 50, py + 96, false);
        draw_set_colour(make_colour_rgb(190, 40, 45));
        draw_rectangle(px - 50, py + 88, px - 50 + floor(100 * hp_pct), py + 96, false);
        draw_set_colour(party_i == global.combat_actor && global.combat_phase == "player_select" ? c_yellow : c_white);
        draw_text(px - 50, py + 100, member.name);
    }

    for (var ei = 0; ei < array_length(global.combat_enemies); ei++) {
        var foe = global.combat_enemies[ei];
        if (instance_exists(foe)) {
            var ex = enemy_slots[ei][0];
            var ey = enemy_slots[ei][1];
            if (global.combat_lunge_side == "enemy" && global.combat_lunge_index == ei) ex -= lunge_amount;

            draw_set_alpha(0.55);
            draw_set_colour(make_colour_rgb(80, 70, 62));
            draw_ellipse(ex - 62, ey + 58, ex + 62, ey + 86, false);
            draw_set_alpha(1);
            draw_sprite_ext(foe.sprite_index, foe.image_index, ex, ey, combat_draw_scale, combat_draw_scale, 0, c_white, 1);

            var enemy_hp_pct = max(0, foe.hp) / foe.max_hp;
            draw_set_colour(c_dkgray);
            draw_rectangle(ex - 50, ey + 108, ex + 50, ey + 116, false);
            draw_set_colour(make_colour_rgb(190, 40, 45));
            draw_rectangle(ex - 50, ey + 108, ex - 50 + floor(100 * enemy_hp_pct), ey + 116, false);
            var foe_name = variable_instance_exists(foe, "enemy_display_name") ? foe.enemy_display_name : "Enemy";
            if (variable_instance_exists(foe, "enemy_protect") && foe.enemy_protect > 0) foe_name += " +";
            draw_set_colour(global.combat_phase == "target_select" ? c_yellow : c_white);
            draw_text(ex - 50, ey + 120, string(ei + 1) + " " + foe_name);
        }
    }

    var bx = 60;
    var by = gui_h - 256;
    var bw = 320;
    var bh = 48;

    for (var i = 0; i < array_length(global.combat_moves); i++) {
        var move_data = global.combat_moves[i];
        var cooldown_left = global.combat_party[global.combat_actor].cooldowns[i];
        var yy = by + (i * 54);
        draw_set_colour(cooldown_left > 0 ? make_colour_rgb(28, 25, 25) : make_colour_rgb(24, 28, 34));
        draw_rectangle(bx, yy, bx + bw, yy + bh, false);
        draw_set_colour(make_colour_rgb(120, 105, 82));
        draw_rectangle(bx, yy, bx + bw, yy + bh, true);
        draw_set_colour(cooldown_left > 0 ? make_colour_rgb(125, 125, 125) : c_white);
        draw_text(bx + 14, yy + 6, string(i + 1) + " " + move_data.name);
        draw_set_colour(make_colour_rgb(170, 170, 170));
        var desc = move_data.desc;
        if (cooldown_left > 0) desc += "  CD " + string(cooldown_left);
        draw_text(bx + 34, yy + 27, desc);
    }

    draw_set_colour(make_colour_rgb(15, 15, 18));
    draw_rectangle(410, gui_h - 126, gui_w - 60, gui_h - 70, false);
    draw_set_colour(make_colour_rgb(120, 105, 82));
    draw_rectangle(410, gui_h - 126, gui_w - 60, gui_h - 70, true);
    draw_set_colour(make_colour_rgb(225, 215, 190));
    draw_text(428, gui_h - 108, global.combat_message);
    draw_set_colour(c_white);
}
