
interact_range = 50;
show_prompt    = false;
collected      = false;

// Assign sprite based on type
switch (mineral_type) {
    case "iron":     sprite_index = spr_mineral_iron;     break;
    case "crystal":  sprite_index = spr_mineral_crystal;  break;
    case "obsidian": sprite_index = spr_mineral_obsidian; break;
}