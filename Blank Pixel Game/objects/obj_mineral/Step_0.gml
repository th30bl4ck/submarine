if (collected) exit;

var dist = point_distance(x, y, obj_player.x, obj_player.y);

if (dist < interact_range) {
    show_prompt = true;
    if (keyboard_check_pressed(ord("E")) && !obj_player.near_submarine) {
        collected = true;
        show_prompt = false;

        // Add to inventory
        switch (mineral_type) {
            case "iron":     obj_resource_manager.iron++;     break;
            case "crystal":  obj_resource_manager.crystal++;  break;
            case "obsidian": obj_resource_manager.obsidian++; break;
        }

        alarm[0] = room_speed * 60; 
        instance_deactivate_object(id);
    }
} else {
    show_prompt = false;
}