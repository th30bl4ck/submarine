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

if (variable_global_exists("combat_active") && global.combat_active && instance_exists(global.combat_enemy)) {
    var gui_w = display_get_gui_width();
    var gui_h = display_get_gui_height();
    var foe = global.combat_enemy;

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
    draw_text(60, 78, "Choose an action");

    var player_hp_pct = obj_player.hp / obj_player.max_hp;
    var enemy_hp_pct = foe.hp / foe.max_hp;

    draw_set_alpha(0.55);
    draw_set_colour(make_colour_rgb(80, 70, 62));
    draw_ellipse(165, 250, 385, 306, false);
    draw_ellipse(gui_w - 385, 250, gui_w - 165, 306, false);
    draw_set_alpha(1);

    draw_sprite_ext(obj_player.sprite_index, obj_player.image_index, 275, 246, 2, 2, 0, c_white, 1);
    draw_sprite_ext(foe.sprite_index, foe.image_index, gui_w - 275, 246, -2, 2, 0, c_white, 1);

    draw_set_colour(c_white);
    draw_text(60, 118, "Diver");
    draw_text(gui_w - 310, 118, "Deep Stalker");

    draw_set_colour(c_dkgray);
    draw_rectangle(60, 142, 310, 160, false);
    draw_rectangle(gui_w - 310, 142, gui_w - 60, 160, false);
    draw_set_colour(make_colour_rgb(190, 40, 45));
    draw_rectangle(60, 142, 60 + floor(250 * player_hp_pct), 160, false);
    draw_rectangle(gui_w - 310, 142, gui_w - 310 + floor(250 * enemy_hp_pct), 160, false);
    draw_set_colour(c_white);
    draw_text(66, 164, string(obj_player.hp) + " / " + string(obj_player.max_hp));
    draw_text(gui_w - 304, 164, string(foe.hp) + " / " + string(foe.max_hp));

    var names = ["1 Harpoon Strike", "2 Brace", "3 Repair Suit", "4 Desperate Flare"];
    var descs = ["Reliable damage", "Reduce the next hit", "Recover HP", "Risky high damage"];
    var bx = 60;
    var by = gui_h - 256;
    var bw = 320;
    var bh = 48;

    for (var i = 0; i < 4; i++) {
        var yy = by + (i * 54);
        draw_set_colour(make_colour_rgb(24, 28, 34));
        draw_rectangle(bx, yy, bx + bw, yy + bh, false);
        draw_set_colour(make_colour_rgb(120, 105, 82));
        draw_rectangle(bx, yy, bx + bw, yy + bh, true);
        draw_set_colour(c_white);
        draw_text(bx + 14, yy + 6, names[i]);
        draw_set_colour(make_colour_rgb(170, 170, 170));
        draw_text(bx + 34, yy + 27, descs[i]);
    }

    draw_set_colour(make_colour_rgb(15, 15, 18));
    draw_rectangle(410, gui_h - 126, gui_w - 60, gui_h - 70, false);
    draw_set_colour(make_colour_rgb(120, 105, 82));
    draw_rectangle(410, gui_h - 126, gui_w - 60, gui_h - 70, true);
    draw_set_colour(make_colour_rgb(225, 215, 190));
    draw_text(428, gui_h - 108, global.combat_message);
    draw_set_colour(c_white);
}
