center_x = room_width * 0.5;
floor_y = 744;
ground_y = 704;

var platform_w = 384;
for (var floor_x = platform_w * 0.5; floor_x < room_width + platform_w * 0.5; floor_x += platform_w) {
    var floor_inst = instance_create_layer(floor_x, floor_y, "Instances", obj_platform);
    floor_inst.image_xscale = 1;
    floor_inst.image_yscale = 1;
}

var sub = instance_create_layer(center_x, 640, "Instances", obj_submarine);
sub.image_xscale = 2;
sub.image_yscale = 2;

function surface_make(_obj, _x, _y, _sx, _sy) {
    var inst = instance_create_layer(_x, _y, "Instances", _obj);
    if (instance_exists(inst)) {
        inst.image_xscale = _sx;
        inst.image_yscale = _sy;
    }
    return inst;
}

function surface_key(_x, _level) {
    var inst = surface_make(obj_surface_key, _x, 704, 1.6, 1.6);
    if (instance_exists(inst)) {
        inst.key_id = _level;
    }
    return inst;
}

function surface_gate(_x, _level, _dir) {
    var inst = surface_make(obj_surface_gate, _x, 602, 2 * _dir, 2.6);
    if (instance_exists(inst)) {
        inst.required_key = _level;
    }
    return inst;
}

function surface_enemy(_obj, _x, _sx) {
    var inst = surface_make(_obj, _x, ground_y, _sx, _sx);
    return inst;
}

function surface_cache(_obj, _x) {
    return surface_make(_obj, _x, ground_y, _obj == obj_loot_safe ? 1.5 : 1.4, _obj == obj_loot_safe ? 1.5 : 1.4);
}

for (var side = -1; side <= 1; side += 2) {
    var dir = side;
    var gate_face = (dir < 0) ? 1 : -1;

    surface_make(obj_teammates, center_x + dir * 520, ground_y, 2, 1.5);
    surface_cache(obj_loot_chest, center_x + dir * 760);
    surface_enemy(obj_enemy, center_x + dir * 1020, 1.5);
    surface_make(obj_teammates, center_x + dir * 1240, ground_y, 2, 1.5);
    surface_key(center_x + dir * 1500, 1);
    surface_cache(obj_loot_safe, center_x + dir * 1740);
    surface_gate(center_x + dir * 2100, 1, gate_face);

    surface_enemy(obj_enemy, center_x + dir * 2460, 1.6);
    surface_enemy(obj_shaman, center_x + dir * 2600, 1.4);
    surface_make(obj_teammates, center_x + dir * 2860, ground_y, 2, 1.5);
    surface_cache(obj_loot_chest, center_x + dir * 3100);
    surface_enemy(obj_tank, center_x + dir * 3380, 2.0);
    surface_enemy(obj_enemy, center_x + dir * 3520, 1.7);
    surface_cache(obj_loot_safe, center_x + dir * 3740);
    surface_key(center_x + dir * 3980, 2);
    surface_gate(center_x + dir * 4320, 2, gate_face);

    surface_make(obj_teammates, center_x + dir * 4680, ground_y, 2, 1.5);
    surface_enemy(obj_enemy, center_x + dir * 4940, 1.8);
    surface_enemy(obj_shaman, center_x + dir * 5100, 1.5);
    surface_cache(obj_loot_chest, center_x + dir * 5380);
    surface_enemy(obj_tank, center_x + dir * 5620, 2.1);
    surface_cache(obj_loot_safe, center_x + dir * 5860);
    surface_make(obj_teammates, center_x + dir * 6040, ground_y, 2, 1.5);
    surface_key(center_x + dir * 6220, 3);
    surface_gate(center_x + dir * 6500, 3, gate_face);

    surface_enemy(obj_enemy, center_x + dir * 6840, 1.9);
    surface_enemy(obj_tank, center_x + dir * 7040, 2.2);
    surface_cache(obj_loot_safe, center_x + dir * 7280);
    surface_make(obj_teammates, center_x + dir * 7460, ground_y, 2, 1.5);
    surface_make(obj_surface_boss, center_x + dir * 7760, 614, 2.4 * gate_face, 2.4);
}
