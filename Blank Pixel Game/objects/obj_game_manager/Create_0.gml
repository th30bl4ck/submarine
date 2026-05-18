globalvar WATER_Y, player_spawn_x, player_spawn_y;
WATER_Y = 800;
player_spawn_x = 200;
player_spawn_y = 2300;
if (!instance_exists(obj_resource_manager)) {
    instance_create_depth(0, 0, 0, obj_resource_manager);
}
global.combat_active = false;
global.combat_enemy = noone;
global.combat_turn = "player";
global.combat_message = "";
global.combat_guard = false;
global.combat_selected_move = 0;
global.combat_view_x = 0;
global.combat_view_y = 0;
global.combat_player_return_x = 0;
global.combat_player_return_y = 0;
global.combat_enemy_return_x = 0;
global.combat_enemy_return_y = 0;
global.combat_party = [];
global.combat_enemies = [];
if (!variable_global_exists("teammate_roster")) {
    global.teammate_roster = [];
}
if (!variable_global_exists("teammates_found")) {
    global.teammates_found = 0;
}
if (!variable_global_exists("teammate_collected_keys")) {
    global.teammate_collected_keys = [];
}
if (!variable_global_exists("teammate_menu_open")) {
    global.teammate_menu_open = false;
}
if (!variable_global_exists("teammate_manager_near")) {
    global.teammate_manager_near = false;
}
if (!variable_global_exists("teammate_recruit_near")) {
    global.teammate_recruit_near = false;
}
global.combat_moves = [
    {
        name: "Harpoon Strike",
        desc: "Reliable damage",
        kind: "damage",
        min_value: 11,
        max_value: 19,
        cooldown: 0
    },
    {
        name: "Brace",
        desc: "Guard until next turn",
        kind: "guard",
        min_value: 0,
        max_value: 0,
        cooldown: 1
    },
    {
        name: "Repair Suit",
        desc: "Heal one hero",
        kind: "heal",
        min_value: 16,
        max_value: 24,
        cooldown: 3
    },
    {
        name: "Desperate Flare",
        desc: "Risky high damage",
        kind: "damage",
        min_value: 5,
        max_value: 28,
        cooldown: 2
    }
];
global.combat_phase = "none";
global.combat_actor = 0;
global.combat_enemy_actor = 0;
global.combat_timer = 0;
global.combat_lunge_timer = 0;
global.combat_lunge_side = "";
global.combat_lunge_index = 0;
global.combat_pending_move = -1;
