enemy_role = "fighter";
enemy_protect = 0;
var enemy_names = ["Brinejaw", "Kelpmaw", "Riftclaw", "Siltfang", "Gloomfin", "Reefbite", "Murktooth", "Abyssal"];
var shaman_names = ["Mireseer", "Saltwitch", "Chanter", "Caller"];

if (object_index == obj_shaman) {
    enemy_role = "shaman";
    enemy_display_name = shaman_names[irandom(array_length(shaman_names) - 1)];
    sprite_index = spr_shamen;
    max_hp = 48;
} else {
    enemy_display_name = enemy_names[irandom(array_length(enemy_names) - 1)];
    sprite_index = choose(spr_enemy_3, spr_enemy_2);
    max_hp = 60;
}

hp = max_hp;
image_speed = 0;
image_index = 0;
combat_saved_xscale = image_xscale;
