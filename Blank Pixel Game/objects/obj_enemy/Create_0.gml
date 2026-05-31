enemy_role = "fighter";
enemy_protect = 0;
enemy_guard_tank = noone;
var enemy_names = ["Brinejaw", "Kelpmaw", "Riftclaw", "Siltfang", "Gloomfin", "Reefbite", "Murktooth", "Abyssal"];
var shaman_names = ["Mireseer", "Saltwitch", "Chanter", "Caller"];
var tank_names = ["Bulkhead", "Ironhide", "Keelback", "Brinewall"];

if (object_index == obj_shaman) {
    enemy_role = "shaman";
    enemy_display_name = shaman_names[irandom(array_length(shaman_names) - 1)];
    sprite_index = spr_shamen;
    max_hp = 48;
} else if (object_index == obj_tank) {
    enemy_role = "tank";
    enemy_display_name = tank_names[irandom(array_length(tank_names) - 1)];
    sprite_index = spr_tank;
    max_hp = 135;
} else {
    enemy_display_name = enemy_names[irandom(array_length(enemy_names) - 1)];
    sprite_index = choose(spr_enemy_3, spr_enemy_2, spr_enemy_1);
    max_hp = 60;
}

var surface_difficulty = 0;
if (room == room_surface) {
    surface_difficulty = clamp(floor(abs(x - (room_width * 0.5)) / 1100), 0, 7);
    max_hp += surface_difficulty * 9;
    if (object_index == obj_tank) {
        max_hp += surface_difficulty * 7;
    }
}

hp = max_hp;
enemy_damage_bonus = floor(surface_difficulty * 1.25);
image_speed = 0;
image_index = 0;
combat_saved_xscale = image_xscale;
