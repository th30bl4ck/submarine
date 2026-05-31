globalvar WATER_Y, player_spawn_x, player_spawn_y;
randomize();
WATER_Y = 800;
player_spawn_x = 200;
player_spawn_y = 2300;
if (!instance_exists(obj_resource_manager)) {
    instance_create_depth(0, 0, 0, obj_resource_manager);
}
if (!variable_global_exists("background_music_id")) {
    global.background_music_id = noone;
}
if (!audio_is_playing(lofi_music_library_coffee_lofi_chill_lofi_ambient_458901)) {
    global.background_music_id = audio_play_sound(lofi_music_library_coffee_lofi_chill_lofi_ambient_458901, 0, true);
    audio_sound_gain(global.background_music_id, 0.18, 0);
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
if (!variable_global_exists("teammate_sprite_assignments")) {
    global.teammate_sprite_assignments = [];
}
if (!variable_global_exists("teammate_used_sprite_numbers")) {
    global.teammate_used_sprite_numbers = [];
}
if (!variable_global_exists("surface_defeated_enemies")) {
    global.surface_defeated_enemies = [];
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
if (!variable_global_exists("tutorial_popup_active")) {
    global.tutorial_popup_active = false;
    global.tutorial_popup_title = "";
    global.tutorial_popup_body = "";
}
if (!variable_global_exists("tutorial_popup_block_input")) {
    global.tutorial_popup_block_input = 0;
}
if (!variable_global_exists("tutorial_seen_hotel")) {
    global.tutorial_seen_hotel = false;
}
if (!variable_global_exists("tutorial_seen_upgrade_shop")) {
    global.tutorial_seen_upgrade_shop = false;
}
if (!variable_global_exists("tutorial_seen_survivor_equip")) {
    global.tutorial_seen_survivor_equip = false;
}
if (!variable_global_exists("tutorial_seen_loot")) {
    global.tutorial_seen_loot = false;
}
if (!variable_global_exists("tutorial_seen_combat")) {
    global.tutorial_seen_combat = false;
}
if (!variable_global_exists("win_screen_active")) {
    global.win_screen_active = false;
}
if (!variable_global_exists("win_screen_seen")) {
    global.win_screen_seen = false;
}
var city_level = instance_exists(obj_resource_manager) ? obj_resource_manager.dome_level : 1;
global.city_hp_bonus = max(0, city_level - 1) * 15;
global.city_damage_bonus = max(0, city_level - 1) * 4;
global.combat_moves = [
    {
        name: "Harpoon Strike",
        desc: "Reliable damage",
        kind: "damage",
        min_value: 1100 + global.city_damage_bonus,
        max_value: 1900 + global.city_damage_bonus,
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
        min_value: 16 + global.city_damage_bonus,
        max_value: 24 + global.city_damage_bonus,
        cooldown: 3
    },
    {
        name: "Desperate Flare",
        desc: "Risky high damage",
        kind: "damage",
        min_value: 5 + global.city_damage_bonus,
        max_value: 28 + global.city_damage_bonus,
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
