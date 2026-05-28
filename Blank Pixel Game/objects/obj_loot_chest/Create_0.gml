interact_range = 72;
opened = false;
show_prompt = false;
var cache_kind = object_index == obj_loot_safe ? "safe" : "chest";
loot_key = room_get_name(room) + ":" + cache_kind + ":" + string(round(x)) + ":" + string(round(y));

if (!variable_global_exists("surface_looted_caches")) {
    global.surface_looted_caches = [];
}

for (var i = 0; i < array_length(global.surface_looted_caches); i++) {
    if (global.surface_looted_caches[i] == loot_key) {
        opened = true;
        if (object_index == obj_loot_safe) {
            image_alpha = 0.55;
        } else {
            sprite_index = spr_chest_open_empty;
        }
        break;
    }
}

var zone_bonus = floor(abs(x - (room_width * 0.5)) / 1366);
loot_iron = 8 + zone_bonus * 3;
loot_crystal = 3 + floor(x / 1800) * 2;
loot_obsidian = max(0, floor(x / 2400));

if (object_index == obj_loot_safe) {
    loot_iron = 18 + zone_bonus * 5;
    loot_crystal = 8 + zone_bonus * 3;
    loot_obsidian = 3 + floor(x / 1700);
}
