enemy_role = "fighter";
enemy_display_name = "Enemy";
enemy_protect = 0;

if (object_index == obj_shaman || irandom(4) == 0) {
    enemy_role = "shaman";
    enemy_display_name = "Shaman";
    sprite_index = spr_shamen;
    max_hp = 48;
} else {
    sprite_index = choose(spr_enemy_3, spr_enemy_2);
    max_hp = 60;
}

hp = max_hp;
image_speed = 0;
image_index = 0;
combat_saved_xscale = image_xscale;
