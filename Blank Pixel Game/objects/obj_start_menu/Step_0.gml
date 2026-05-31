menu_pulse += 0.05;

if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) {
    menu_selected = (menu_selected + array_length(menu_items) - 1) mod array_length(menu_items);
}

if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) {
    menu_selected = (menu_selected + 1) mod array_length(menu_items);
}

var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();
var button_w = 300;
var button_h = 54;
var button_x = (gui_w - button_w) * 0.5;
var button_y = gui_h * 0.54;
var mouse_gui_x = device_mouse_x_to_gui(0);
var mouse_gui_y = device_mouse_y_to_gui(0);

for (var i = 0; i < array_length(menu_items); i++) {
    var item_y = button_y + i * 72;
    if (point_in_rectangle(mouse_gui_x, mouse_gui_y, button_x, item_y, button_x + button_w, item_y + button_h)) {
        menu_selected = i;
        if (mouse_check_button_pressed(mb_left)) {
            if (i == 0) {
                room_goto(room_dome);
            } else {
                game_end();
            }
        }
    }
}

if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
    if (menu_selected == 0) {
        room_goto(room_dome);
    } else {
        game_end();
    }
}
