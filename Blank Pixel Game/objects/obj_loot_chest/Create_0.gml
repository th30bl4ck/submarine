interact_range = 72;
opened = false;
show_prompt = false;
if (object_index == obj_loot_safe) {
    image_speed = 0;
    image_index = 0;
}
var cache_kind = object_index == obj_loot_safe ? "safe" : "chest";
loot_key = room_get_name(room) + ":" + cache_kind + ":" + string(round(x)) + ":" + string(round(y));

if (!variable_global_exists("surface_looted_caches")) {
    global.surface_looted_caches = [];
}

for (var i = 0; i < array_length(global.surface_looted_caches); i++) {
    if (global.surface_looted_caches[i] == loot_key) {
        opened = true;
        if (object_index == obj_loot_safe) {
            image_index = image_number - 1;
            image_speed = 0;
            image_alpha = 0.55;
        } else {
            sprite_index = spr_chest_open_empty;
        }
        break;
    }
}

var zone_bonus = floor(abs(x - (room_width * 0.5)) / 1366);
loot_iron = 1 + min(zone_bonus, 4);
loot_crystal = (zone_bonus >= 1) ? 1 : 0;
loot_obsidian = (zone_bonus >= 4) ? 1 : 0;

if (object_index == obj_loot_safe) {
    image_speed = 0;
    loot_iron = 3 + min(zone_bonus * 2, 10);
    loot_crystal = 1 + min(zone_bonus, 4);
    loot_obsidian = max(0, min(zone_bonus - 1, 3));
}
