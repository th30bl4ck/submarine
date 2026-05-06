// Reset flags first so other objects can set them this frame
in_dome = false;
near_submarine = false;

// Input
var move_left  = keyboard_check(vk_left)  || keyboard_check(ord("A"));
var move_right = keyboard_check(vk_right) || keyboard_check(ord("D"));
var jump       = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
var interact   = keyboard_check_pressed(ord("E"));

// Horizontal movement
if (move_left)  { vx -= spd * 0.3; facing_right = false; }
if (move_right) { vx += spd * 0.3; facing_right = true;  }
vx *= 0.85;

// Gravity + jump
if (jump && on_ground) vy = jump_force;
vy += grav;
vy = min(vy, 18);

// Horizontal collision
if (place_meeting(x + vx, y, obj_platform)) {
    while (!place_meeting(x + sign(vx), y, obj_platform)) {
        x += sign(vx);
    }
    vx = 0;
}
x += vx;

// Vertical collision
on_ground = false;
if (place_meeting(x, y + vy, obj_platform)) {
    while (!place_meeting(x, y + sign(vy), obj_platform)) {
        y += sign(vy);
    }
    if (vy > 0) on_ground = true;
    vy = 0;
}
y += vy;

// Clamp to room
x = clamp(x, 14, room_width - 14);

// Oxygen logic
if (room == room_ocean) {
    var inside_dome = false;
    if (instance_exists(obj_dome)) {
        var dm = obj_dome;
        var rm = obj_resource_manager;
        var dx = (x - dm.x) / rm.dome_width;
        var dy = (y - dm.y) / rm.dome_height;
        inside_dome = ((dx * dx) + (dy * dy) < 1);
    }
    
    if (inside_dome) {
        oxygen = min(100, oxygen + ox_refill);
    } else {
        oxygen -= ox_drain;
        oxygen = max(0, oxygen);
    }
}

// Submarine 
var near_sub = false;
if (instance_exists(obj_submarine)) {
    var dist = point_distance(x, y, obj_submarine.x, obj_submarine.y);
    if (dist < 60) {
        near_sub = true;
    }
}

if (interact && near_sub) {
    if (room == room_ocean) {
        player_spawn_x = 200;
        player_spawn_y = 500;
        room_goto(room_surface);
    } else if (room == room_surface) {
        player_spawn_x = 340;
        player_spawn_y = 2300;
        room_goto(room_ocean);
    }
}