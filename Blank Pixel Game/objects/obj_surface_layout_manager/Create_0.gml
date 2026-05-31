center_x = room_width * 0.5;
floor_y = 768;
ground_y = 728;

var platform_w = 384;
for (var floor_x = platform_w * 0.5; floor_x < room_width + platform_w * 0.5; floor_x += platform_w) {
    var floor_inst = instance_create_layer(floor_x, floor_y, "Instances", obj_platform);
    floor_inst.image_xscale = 1;
    floor_inst.image_yscale = 1;
}

var sub = instance_create_layer(center_x, 664, "Instances", obj_submarine);
sub.image_xscale = 2;
sub.image_yscale = 2;

function surface_make(_obj, _x, _y, _sx, _sy) {
    var inst = instance_create_layer(_x, _y, "Instances", _obj);
    if (instance_exists(inst)) {
        inst.image_xscale = (_x < center_x) ? abs(_sx) : -abs(_sx);
        inst.image_yscale = _sy;
    }
    return inst;
}

function surface_key(_x, _level) {
    var inst = surface_make(obj_surface_key, _x, ground_y, 1.6, 1.6);
    if (instance_exists(inst)) {
        inst.key_id = _level;
    }
    return inst;
}

function surface_gate(_x, _level, _dir) {
    var gate_scale = 2.6;
    var gate_bottom_y = floor_y + 8;
    var gate_y = gate_bottom_y - (115 - 84) * gate_scale;
    var inst = surface_make(obj_surface_gate, _x, gate_y, 2 * _dir, gate_scale);
    if (instance_exists(inst)) {
        inst.required_key = _level;
    }
    return inst;
}

function surface_enemy(_obj, _x, _sx) {
    var enemy_y = ground_y;
    if (_obj == obj_shaman) {
        enemy_y = ground_y - 32 * _sx;
    }
    var inst = surface_make(_obj, _x, enemy_y, _sx, _sx);
    if (instance_exists(inst)) {
        inst.image_xscale = (_x < center_x) ? -abs(_sx) : abs(_sx);
    }
    return inst;
}

function surface_cache(_obj, _x) {
    return surface_make(_obj, _x, ground_y, _obj == obj_loot_safe ? 1.5 : 1.4, _obj == obj_loot_safe ? 1.5 : 1.4);
}

var left_gate_face = 1;
surface_cache(obj_loot_chest, center_x - 520);
surface_make(obj_teammates, center_x - 780, ground_y, 2, 1.5);
surface_key(center_x - 1080, 1);
surface_enemy(obj_enemy, center_x - 1350, 1.45);
surface_enemy(obj_shaman, center_x - 1460, 1.3);
surface_cache(obj_loot_safe, center_x - 1700);
surface_gate(center_x - 2050, 1, left_gate_face);

surface_enemy(obj_tank, center_x - 2380, 1.85);
surface_enemy(obj_enemy, center_x - 2490, 1.5);
surface_enemy(obj_enemy, center_x - 2600, 1.5);
surface_cache(obj_loot_chest, center_x - 2860);
surface_make(obj_teammates, center_x - 3120, ground_y, 2, 1.5);
surface_key(center_x - 3380, 2);
surface_enemy(obj_enemy, center_x - 3740, 1.55);
surface_enemy(obj_shaman, center_x - 3850, 1.35);
surface_gate(center_x - 4200, 2, left_gate_face);

surface_cache(obj_loot_safe, center_x - 4520);
surface_enemy(obj_enemy, center_x - 4860, 1.6);
surface_enemy(obj_enemy, center_x - 4970, 1.6);
surface_enemy(obj_tank, center_x - 5080, 1.95);
surface_key(center_x - 5360, 3);
surface_make(obj_teammates, center_x - 5680, ground_y, 2, 1.5);
surface_enemy(obj_shaman, center_x - 6000, 1.4);
surface_enemy(obj_enemy, center_x - 6110, 1.65);
surface_enemy(obj_tank, center_x - 6220, 2.0);
surface_gate(center_x - 6650, 3, left_gate_face);
surface_cache(obj_loot_safe, center_x - 7060);
surface_enemy(obj_enemy, center_x - 7360, 1.7);
surface_enemy(obj_enemy, center_x - 7480, 1.7);

var right_gate_face = -1;
surface_make(obj_teammates, center_x + 520, ground_y, 2, 1.5);
surface_cache(obj_loot_chest, center_x + 760);
surface_key(center_x + 960, 1);
surface_enemy(obj_enemy, center_x + 1160, 1.45);
surface_enemy(obj_enemy, center_x + 1270, 1.45);
surface_make(obj_teammates, center_x + 1460, ground_y, 2, 1.5);
surface_cache(obj_loot_safe, center_x + 1740);
surface_gate(center_x + 2200, 1, right_gate_face);

surface_enemy(obj_enemy, center_x + 2520, 1.55);
surface_enemy(obj_shaman, center_x + 2630, 1.35);
surface_enemy(obj_enemy, center_x + 2740, 1.55);
surface_make(obj_teammates, center_x + 2940, ground_y, 2, 1.5);
surface_key(center_x + 3120, 2);
surface_cache(obj_loot_chest, center_x + 3260);
surface_enemy(obj_tank, center_x + 3520, 1.9);
surface_enemy(obj_enemy, center_x + 3630, 1.55);
surface_enemy(obj_enemy, center_x + 3740, 1.55);
surface_cache(obj_loot_safe, center_x + 3920);
surface_gate(center_x + 4400, 2, right_gate_face);

surface_make(obj_teammates, center_x + 4680, ground_y, 2, 1.5);
surface_enemy(obj_enemy, center_x + 4980, 1.6);
surface_enemy(obj_shaman, center_x + 5090, 1.4);
surface_enemy(obj_enemy, center_x + 5200, 1.6);
surface_enemy(obj_tank, center_x + 5310, 1.95);
surface_cache(obj_loot_chest, center_x + 5480);
surface_key(center_x + 5580, 3);
surface_enemy(obj_enemy, center_x + 5840, 1.65);
surface_enemy(obj_tank, center_x + 5950, 2.0);
surface_enemy(obj_shaman, center_x + 6060, 1.45);
surface_cache(obj_loot_safe, center_x + 6250);
surface_make(obj_teammates, center_x + 6380, ground_y, 2, 1.5);
surface_gate(center_x + 6500, 3, right_gate_face);

surface_enemy(obj_enemy, center_x + 6840, 1.7);
surface_enemy(obj_tank, center_x + 6960, 2.0);
surface_enemy(obj_enemy, center_x + 7080, 1.7);
surface_cache(obj_loot_safe, center_x + 7280);
surface_make(obj_teammates, center_x + 7460, ground_y, 2, 1.5);
var boss_inst = surface_make(obj_surface_boss, center_x + 7760, ground_y - (128 - 64) * 2.4, 2.4, 2.4);
if (instance_exists(boss_inst)) {
    boss_inst.image_xscale = 2.4;
}
