if (!instance_exists(obj_resource_manager)) exit;

var rm = obj_resource_manager;

// Sync scale
image_xscale = rm.dome_width  / (sprite_width  / 2);
image_yscale = rm.dome_height / (sprite_height / 2);

// Check if player is inside dome
var dx = (obj_player.x - x) / rm.dome_width;
var dy = (obj_player.y - y) / rm.dome_height;

if ((dx * dx) + (dy * dy) < 1) {
    obj_player.in_dome = true;
}