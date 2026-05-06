if (!instance_exists(obj_resource_manager)) exit;

var rm = obj_resource_manager;



// Check if player is inside dome
var dx = (obj_player.x - x) / rm.dome_width;
var dy = (obj_player.y - y) / rm.dome_height;

if ((dx * dx) + (dy * dy) < 1) {
    obj_player.in_dome = true;
}