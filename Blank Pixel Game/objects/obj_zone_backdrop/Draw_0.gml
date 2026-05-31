var zone_w = 1366;
var zone_h = 768;

if (room == room_surface) {
    for (var surface_zone = 0; surface_zone < ceil(room_width / zone_w); surface_zone++) {
        draw_sprite_stretched(spr_background_land, 0, surface_zone * zone_w, 0, zone_w, zone_h);
    }
    exit;
}

draw_sprite_stretched(spr_background_underwater, 0, 0, 0, zone_w, zone_h);
draw_sprite_stretched(spr_background_underwater, 0, zone_w, 0, zone_w, zone_h);
draw_sprite_stretched(spr_background_tunnel, 0, zone_w, 0, zone_w, zone_h);

var dome_bg = spr_background_dome_1;
if (instance_exists(obj_resource_manager)) {
    switch (clamp(obj_resource_manager.dome_level, 1, 4)) {
        case 2: dome_bg = spr_background_dome_2; break;
        case 3: dome_bg = spr_background_dome_3; break;
        case 4: dome_bg = spr_background_dome_4; break;
    }
}
draw_sprite_stretched(dome_bg, 0, zone_w * 2, 0, zone_w, zone_h);
draw_sprite_stretched(spr_background_underwater, 0, zone_w * 3, 0, zone_w, zone_h);
draw_sprite_stretched(spr_background_tunnel, 0, zone_w * 3, 0, zone_w, zone_h);
draw_sprite_stretched(spr_background_underwater, 0, zone_w * 4, 0, zone_w, zone_h);
