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
if (room == room_ocean) {
    draw_set_colour(c_dkgray);
    draw_rectangle(10, 34, 210, 46, false);

    var ox_pct = obj_player.oxygen / 100;
    var ox_col;
    if (ox_pct > 0.5)       ox_col = make_colour_rgb(50, 220, 100);
    else if (ox_pct > 0.25) ox_col = make_colour_rgb(255, 170, 30);
    else                     ox_col = make_colour_rgb(255, 50, 50);

    draw_set_colour(ox_col);
    draw_rectangle(10, 34, 10 + (200 * ox_pct), 46, false);

    draw_set_colour(c_white);
    draw_text(10, 50, "O2");
}

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