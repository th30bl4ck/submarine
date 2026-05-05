if (!show_menu) {
    if (show_prompt) {
    }
    exit;
}

var rm = obj_resource_manager;
var next_level = rm.dome_level + 1;
var cost_iron = 0;
var cost_crystal = 0;
var cost_obsidian = 0;
var can_upgrade = false;
var max_level = false;

for (var i = 0; i < array_length(rm.upgrade_costs); i++) {
    if (rm.upgrade_costs[i][0] == next_level) {
        cost_iron     = rm.upgrade_costs[i][1];
        cost_crystal  = rm.upgrade_costs[i][2];
        cost_obsidian = rm.upgrade_costs[i][3];
        can_upgrade   = true;
        break;
    }
}
if (!can_upgrade) max_level = true;

// Background panel
draw_set_colour(make_colour_rgb(10, 20, 35));
draw_set_alpha(0.85);
draw_rectangle(180, 120, 500, 360, false);
draw_set_alpha(1);

// Title
draw_set_colour(c_aqua);
draw_set_halign(fa_center);
draw_text(340, 135, "DOME UPGRADE");

draw_set_colour(c_white);
draw_text(340, 165, "Current Level: " + string(rm.dome_level));

if (max_level) {
    draw_set_colour(make_colour_rgb(255, 200, 50));
    draw_text(340, 200, "Dome is fully upgraded!");
} else {
    draw_set_colour(c_ltgray);
    draw_text(340, 200, "Upgrade to Level " + string(next_level));
    draw_text(340, 230, "Cost:");

    // Iron
    var iron_col = (rm.iron >= cost_iron) ? make_colour_rgb(180,180,180) : make_colour_rgb(255,80,80);
    draw_set_colour(iron_col);
    draw_text(340, 258, "Iron:     " + string(rm.iron) + " / " + string(cost_iron));

    // Crystal
    var cry_col = (rm.crystal >= cost_crystal) ? make_colour_rgb(100,200,255) : make_colour_rgb(255,80,80);
    draw_set_colour(cry_col);
    draw_text(340, 280, "Crystal:  " + string(rm.crystal) + " / " + string(cost_crystal));

    // Obsidian
    var obs_col = (rm.obsidian >= cost_obsidian) ? make_colour_rgb(180,100,255) : make_colour_rgb(255,80,80);
    draw_set_colour(obs_col);
    draw_text(340, 302, "Obsidian: " + string(rm.obsidian) + " / " + string(cost_obsidian));

    var can_afford = (rm.iron >= cost_iron && rm.crystal >= cost_crystal && rm.obsidian >= cost_obsidian);
    draw_set_colour(can_afford ? c_green : c_dkgray);
    draw_text(340, 332, can_afford ? "[U] Upgrade" : "Not enough resources");
}

draw_set_colour(c_gray);
draw_text(340, 352, "[E] or [ESC] Close");
draw_set_halign(fa_left);