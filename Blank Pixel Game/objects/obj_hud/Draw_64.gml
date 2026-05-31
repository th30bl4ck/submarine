if (!instance_exists(obj_player)) exit;
// Zone label

var zone_w = 1366;
var player_in_single_room_dome = (room == room_dome && obj_player.x >= zone_w * 2 && obj_player.x < zone_w * 3);
var player_in_single_room_tunnel = (room == room_dome && ((obj_player.x >= zone_w && obj_player.x < zone_w * 2) || (obj_player.x >= zone_w * 3 && obj_player.x < zone_w * 4)));
var player_in_single_room_ocean = (room == room_dome && (obj_player.x < zone_w || obj_player.x >= zone_w * 4));

if (room == room_dome && (player_in_single_room_dome || player_in_single_room_tunnel)) {
    draw_set_colour(c_aqua);
    draw_text(10, 10, "DOME - Safe");
} else if (room == room_ocean_floor_left_1 || room == room_ocean_floor_right_1 || player_in_single_room_ocean) {
    draw_set_colour(make_colour_rgb(255, 170, 30));
    draw_text(10, 10, "OCEAN FLOOR - Oxygen depleting");
}

if (false) {
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
    if (variable_global_exists("teammate_menu_open") && global.teammate_menu_open) {
        var gui_w_menu = display_get_gui_width();
        var menu_w = min(560, gui_w_menu - 80);
        var menu_x = (gui_w_menu - menu_w) * 0.5;
        var menu_y = 86;
        var row_h = 38;
        var roster_count = variable_global_exists("teammate_roster") ? array_length(global.teammate_roster) : 0;
        var visible_roster = min(roster_count, 9);
        var menu_h = 142 + max(1, visible_roster) * row_h;
        var active_count = 0;
        for (var active_i = 0; active_i < roster_count; active_i++) {
            if (global.teammate_roster[active_i].active) active_count++;
        }

        draw_set_alpha(0.9);
        draw_set_colour(make_colour_rgb(10, 15, 24));
        draw_rectangle(menu_x, menu_y, menu_x + menu_w, menu_y + menu_h, false);
        draw_set_alpha(0.5);
        draw_set_colour(make_colour_rgb(28, 37, 52));
        draw_rectangle(menu_x + 10, menu_y + 52, menu_x + menu_w - 10, menu_y + menu_h - 10, false);
        draw_set_alpha(1);
        draw_set_colour(make_colour_rgb(132, 154, 178));
        draw_rectangle(menu_x, menu_y, menu_x + menu_w, menu_y + menu_h, true);
        draw_set_colour(make_colour_rgb(74, 96, 120));
        draw_line(menu_x + 16, menu_y + 74, menu_x + menu_w - 16, menu_y + 74);

        draw_set_colour(c_white);
        draw_text(menu_x + 24, menu_y + 16, "PARTY MANAGER");
        draw_set_colour(make_colour_rgb(170, 210, 190));
        draw_text(menu_x + menu_w - 150, menu_y + 18, "Party " + string(active_count) + "/3");
        draw_set_colour(make_colour_rgb(190, 198, 208));
        draw_text(menu_x + 24, menu_y + 46, "Press 1-9 to toggle recruits");

        if (roster_count <= 0) {
            draw_set_colour(make_colour_rgb(180, 180, 180));
            draw_text(menu_x + 24, menu_y + 98, "No teammates in storage yet.");
        } else {
            for (var roster_i = 0; roster_i < visible_roster; roster_i++) {
                var recruit = global.teammate_roster[roster_i];
                var row_y = menu_y + 88 + roster_i * row_h;
                draw_set_colour(recruit.active ? make_colour_rgb(26, 58, 48) : make_colour_rgb(22, 28, 38));
                draw_rectangle(menu_x + 18, row_y, menu_x + menu_w - 18, row_y + row_h - 6, false);
                draw_set_colour(recruit.active ? make_colour_rgb(92, 184, 132) : make_colour_rgb(74, 86, 102));
                draw_rectangle(menu_x + 18, row_y, menu_x + menu_w - 18, row_y + row_h - 6, true);

                draw_set_colour(c_white);
                draw_text(menu_x + 32, row_y + 8, string(roster_i + 1) + ". " + recruit.name);
                draw_set_colour(make_colour_rgb(190, 198, 208));
                draw_text(menu_x + 220, row_y + 8, "HP " + string(recruit.max_hp));
                draw_set_colour(recruit.active ? make_colour_rgb(130, 240, 165) : make_colour_rgb(170, 178, 190));
                draw_text(menu_x + menu_w - 112, row_y + 8, recruit.active ? "Equipped" : "Storage");
            }
        }
    }

    if (variable_global_exists("teammate_recruit_near")) global.teammate_recruit_near = false;
    if (variable_global_exists("teammate_manager_near")) global.teammate_manager_near = false;
}

if (variable_global_exists("combat_active") && global.combat_active && array_length(global.combat_party) > 0) {
    var gui_w = display_get_gui_width();
    var gui_h = display_get_gui_height();
    var boss_battle = false;
    var boss_inst = noone;
    for (var boss_check = 0; boss_check < array_length(global.combat_enemies); boss_check++) {
        var boss_candidate = global.combat_enemies[boss_check];
        if (instance_exists(boss_candidate) && variable_instance_exists(boss_candidate, "enemy_role") && boss_candidate.enemy_role == "boss") {
            boss_battle = true;
            boss_inst = boss_candidate;
        }
    }

    draw_set_alpha(0.78);
    draw_set_colour(make_colour_rgb(8, 8, 12));
    draw_rectangle(0, 0, gui_w, gui_h, false);
    draw_set_alpha(1);

    draw_set_colour(boss_battle ? make_colour_rgb(28, 18, 18) : make_colour_rgb(25, 23, 25));
    draw_rectangle(36, 34, gui_w - 36, gui_h - 30, false);
    draw_set_colour(boss_battle ? make_colour_rgb(205, 88, 62) : make_colour_rgb(150, 130, 100));
    draw_rectangle(36, 34, gui_w - 36, gui_h - 30, true);

    draw_set_colour(c_white);
    draw_text(60, 54, boss_battle ? "BOSS FIGHT" : "TURN-BASED COMBAT");
    draw_set_colour(boss_battle ? make_colour_rgb(255, 180, 145) : make_colour_rgb(210, 190, 150));
    draw_text(60, 78, global.combat_phase == "target_select" ? "Choose an enemy target" : "Choose an action");

    if (boss_battle && instance_exists(boss_inst)) {
        var boss_hp_pct = max(0, boss_inst.hp) / boss_inst.max_hp;
        var boss_name = variable_instance_exists(boss_inst, "enemy_display_name") ? boss_inst.enemy_display_name : "Boss";
        draw_set_halign(fa_center);
        draw_set_colour(make_colour_rgb(255, 215, 190));
        draw_text(gui_w * 0.5, 88, boss_name);
        draw_set_halign(fa_left);
        draw_set_colour(make_colour_rgb(38, 14, 14));
        draw_rectangle(gui_w * 0.5 - 260, 112, gui_w * 0.5 + 260, 128, false);
        draw_set_colour(make_colour_rgb(205, 48, 42));
        draw_rectangle(gui_w * 0.5 - 260, 112, gui_w * 0.5 - 260 + floor(520 * boss_hp_pct), 128, false);
        draw_set_colour(make_colour_rgb(255, 190, 150));
        draw_rectangle(gui_w * 0.5 - 260, 112, gui_w * 0.5 + 260, 128, true);
    }

    draw_set_colour(make_colour_rgb(225, 215, 190));
    draw_text(350, 54, "Timeline:");
    var tl_side = (global.combat_phase == "enemy_wait" || global.combat_phase == "player_wait") ? "enemy" : "party";
    var tl_party = global.combat_actor;
    var tl_enemy = global.combat_enemy_actor;
    var tl_drawn = 0;
    var tl_guard = 0;
    while (tl_drawn < 6 && tl_guard < 24) {
        tl_guard++;
        if (tl_side == "party") {
            while (tl_party < array_length(global.combat_party) && global.combat_party[tl_party].hp <= 0) tl_party++;
            if (tl_party < array_length(global.combat_party)) {
                var tl_party_name = global.combat_party[tl_party].name;
                if (string_length(tl_party_name) > 8) tl_party_name = string_copy(tl_party_name, 1, 8);
                draw_set_colour(make_colour_rgb(120, 210, 255));
                draw_text(430 + tl_drawn * 78, 54, tl_party_name);
                tl_party++;
                tl_drawn++;
            } else {
                tl_party = 0;
            }
            tl_side = "enemy";
        } else {
            while (tl_enemy < array_length(global.combat_enemies) && !instance_exists(global.combat_enemies[tl_enemy])) tl_enemy++;
            if (tl_enemy < array_length(global.combat_enemies)) {
                var tl_foe = global.combat_enemies[tl_enemy];
                var tl_name = variable_instance_exists(tl_foe, "enemy_display_name") ? tl_foe.enemy_display_name : "Enemy";
                if (string_length(tl_name) > 8) tl_name = string_copy(tl_name, 1, 8);
                draw_set_colour(make_colour_rgb(255, 150, 120));
                draw_text(430 + tl_drawn * 78, 54, tl_name);
                tl_enemy++;
                tl_drawn++;
            } else {
                tl_enemy = 0;
            }
            tl_side = "party";
        }
    }

    var combat_draw_scale = 2.15;
    var party_slots = [
        [100, 286],
        [260, 248],
        [420, 286],
        [580, 248]
    ];
    var enemy_slots = boss_battle ? [
        [gui_w - 270, 258],
        [gui_w - 440, 292],
        [gui_w - 610, 292],
        [gui_w - 780, 292]
    ] : [
        [gui_w - 100, 248],
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
        draw_sprite_ext(member.sprite, member.image, px, py + 20, combat_draw_scale, combat_draw_scale, 0, c_white, 1);
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
            var foe_scale = (variable_instance_exists(foe, "enemy_role") && foe.enemy_role == "boss") ? 2.55 : combat_draw_scale;
            var foe_is_boss = variable_instance_exists(foe, "enemy_role") && foe.enemy_role == "boss";
            draw_sprite_ext(foe.sprite_index, foe.image_index, ex, ey + 20, foe_scale, foe_scale, 0, c_white, 1);

            if (!foe_is_boss) {
                var enemy_hp_pct = max(0, foe.hp) / foe.max_hp;
                draw_set_colour(c_dkgray);
                draw_rectangle(ex - 50, ey + 108, ex + 50, ey + 116, false);
                draw_set_colour(make_colour_rgb(190, 40, 45));
                draw_rectangle(ex - 50, ey + 108, ex - 50 + floor(100 * enemy_hp_pct), ey + 116, false);
            }
            if (!foe_is_boss) {
                var foe_name = variable_instance_exists(foe, "enemy_display_name") ? foe.enemy_display_name : "Enemy";
                if (variable_instance_exists(foe, "enemy_protect") && foe.enemy_protect > 0) foe_name += " +";
                draw_set_colour(global.combat_phase == "target_select" ? c_yellow : c_white);
                draw_text(ex - 50, ey + 120, string(ei + 1) + " " + foe_name);
            }
        }
    }

    if (variable_global_exists("combat_float_texts")) {
        var old_halign_fx = draw_get_halign();
        var old_valign_fx = draw_get_valign();
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        for (var fx_i = 0; fx_i < array_length(global.combat_float_texts); fx_i++) {
            var fx = global.combat_float_texts[fx_i];
            var fx_x = 0;
            var fx_y = 0;
            if (fx.side == "party" && fx.index < array_length(party_slots)) {
                fx_x = party_slots[fx.index][0];
                fx_y = party_slots[fx.index][1] - 38 + fx.yoff;
            } else if (fx.side == "enemy" && fx.index < array_length(enemy_slots)) {
                fx_x = enemy_slots[fx.index][0];
                fx_y = enemy_slots[fx.index][1] - 38 + fx.yoff;
            }
            draw_set_alpha(clamp(fx.timer / 48, 0, 1));
            draw_set_colour(fx.col);
            draw_text(fx_x, fx_y, fx.text);
        }
        draw_set_alpha(1);
        draw_set_halign(old_halign_fx);
        draw_set_valign(old_valign_fx);
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

if (variable_global_exists("tutorial_popup_active") && global.tutorial_popup_active) {
    var tw = display_get_gui_width();
    var th = display_get_gui_height();
    var panel_w = min(760, tw - 120);
    var panel_h = 310;
    var panel_x = (tw - panel_w) * 0.5;
    var panel_y = (th - panel_h) * 0.5;
    var old_halign_tut = draw_get_halign();
    var old_valign_tut = draw_get_valign();

    draw_set_alpha(0.72);
    draw_set_colour(c_black);
    draw_rectangle(0, 0, tw, th, false);
    draw_set_alpha(1);

    draw_set_colour(make_colour_rgb(12, 20, 32));
    draw_rectangle(panel_x, panel_y, panel_x + panel_w, panel_y + panel_h, false);
    draw_set_colour(make_colour_rgb(95, 180, 210));
    draw_rectangle(panel_x, panel_y, panel_x + panel_w, panel_y + panel_h, true);
    draw_set_colour(make_colour_rgb(24, 40, 58));
    draw_rectangle(panel_x + 16, panel_y + 62, panel_x + panel_w - 16, panel_y + panel_h - 56, false);

    draw_set_valign(fa_top);
    draw_set_halign(fa_center);
    draw_set_colour(c_aqua);
    draw_text(panel_x + panel_w * 0.5, panel_y + 22, global.tutorial_popup_title);

    draw_set_halign(fa_left);
    draw_set_colour(c_white);
    draw_text_ext(panel_x + 42, panel_y + 88, global.tutorial_popup_body, 22, panel_w - 84);

    draw_set_halign(fa_center);
    draw_set_colour(make_colour_rgb(190, 210, 220));
    draw_text(panel_x + panel_w * 0.5, panel_y + panel_h - 34, "Press E, Enter, or Esc to continue");

    draw_set_halign(old_halign_tut);
    draw_set_valign(old_valign_tut);
}

if (variable_global_exists("win_screen_active") && global.win_screen_active) {
    var win_gui_w = display_get_gui_width();
    var win_gui_h = display_get_gui_height();
    var win_panel_w = min(620, win_gui_w - 80);
    var win_panel_h = 280;
    var win_panel_x = (win_gui_w - win_panel_w) * 0.5;
    var win_panel_y = (win_gui_h - win_panel_h) * 0.5;
    var win_button_w = 210;
    var win_button_h = 54;
    var win_gap = 24;
    var win_buttons_y = win_panel_y + win_panel_h - 88;
    var win_keep_x = win_panel_x + win_panel_w * 0.5 - win_button_w - win_gap * 0.5;
    var win_quit_x = win_panel_x + win_panel_w * 0.5 + win_gap * 0.5;
    var old_halign_win = draw_get_halign();
    var old_valign_win = draw_get_valign();
    var win_mx = device_mouse_x_to_gui(0);
    var win_my = device_mouse_y_to_gui(0);
    var keep_hover = point_in_rectangle(win_mx, win_my, win_keep_x, win_buttons_y, win_keep_x + win_button_w, win_buttons_y + win_button_h);
    var quit_hover = point_in_rectangle(win_mx, win_my, win_quit_x, win_buttons_y, win_quit_x + win_button_w, win_buttons_y + win_button_h);

    draw_set_alpha(0.78);
    draw_set_colour(c_black);
    draw_rectangle(0, 0, win_gui_w, win_gui_h, false);
    draw_set_alpha(1);

    draw_set_colour(make_colour_rgb(10, 20, 32));
    draw_rectangle(win_panel_x, win_panel_y, win_panel_x + win_panel_w, win_panel_y + win_panel_h, false);
    draw_set_colour(make_colour_rgb(95, 180, 210));
    draw_rectangle(win_panel_x, win_panel_y, win_panel_x + win_panel_w, win_panel_y + win_panel_h, true);

    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_colour(make_colour_rgb(255, 220, 90));
    draw_text(win_panel_x + win_panel_w * 0.5, win_panel_y + 38, "YOU WIN");
    draw_set_colour(c_white);
    draw_text(win_panel_x + win_panel_w * 0.5, win_panel_y + 92, "Thanks for playing!");
    draw_set_colour(make_colour_rgb(190, 210, 220));
    draw_text(win_panel_x + win_panel_w * 0.5, win_panel_y + 128, "The Surface Warden is defeated.");

    draw_set_colour(keep_hover ? make_colour_rgb(70, 150, 105) : make_colour_rgb(42, 105, 76));
    draw_rectangle(win_keep_x, win_buttons_y, win_keep_x + win_button_w, win_buttons_y + win_button_h, false);
    draw_set_colour(make_colour_rgb(130, 230, 170));
    draw_rectangle(win_keep_x, win_buttons_y, win_keep_x + win_button_w, win_buttons_y + win_button_h, true);
    draw_set_colour(c_white);
    draw_text(win_keep_x + win_button_w * 0.5, win_buttons_y + 16, "Keep Playing");

    draw_set_colour(quit_hover ? make_colour_rgb(140, 60, 60) : make_colour_rgb(95, 42, 46));
    draw_rectangle(win_quit_x, win_buttons_y, win_quit_x + win_button_w, win_buttons_y + win_button_h, false);
    draw_set_colour(make_colour_rgb(230, 120, 120));
    draw_rectangle(win_quit_x, win_buttons_y, win_quit_x + win_button_w, win_buttons_y + win_button_h, true);
    draw_set_colour(c_white);
    draw_text(win_quit_x + win_button_w * 0.5, win_buttons_y + 16, "Quit");

    draw_set_halign(old_halign_win);
    draw_set_valign(old_valign_win);
}
