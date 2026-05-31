var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

draw_set_alpha(1);
draw_sprite_stretched(spr_background_underwater, 0, 0, 0, gui_w, gui_h);

var old_halign = draw_get_halign();
var old_valign = draw_get_valign();
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_set_alpha(0.72);
draw_set_colour(make_colour_rgb(2, 8, 18));
draw_rectangle(gui_w * 0.5 - 330, gui_h * 0.21 - 58, gui_w * 0.5 + 330, gui_h * 0.21 + 58, false);
draw_set_alpha(1);
draw_set_colour(make_colour_rgb(1, 5, 12));
draw_text_transformed(gui_w * 0.5 + 6, gui_h * 0.21 + 6, "Aquaforming", 4.6, 4.6, 0);
draw_set_colour(make_colour_rgb(234, 252, 255));
draw_text_transformed(gui_w * 0.5, gui_h * 0.21, "Aquaforming", 4.6, 4.6, 0);
draw_set_colour(make_colour_rgb(88, 222, 245));
draw_text_transformed(gui_w * 0.5, gui_h * 0.21 - 4, "Aquaforming", 4.6, 4.6, 0);
draw_set_colour(make_colour_rgb(190, 216, 220));
draw_text_transformed(gui_w * 0.5, gui_h * 0.3, "Dive, gather, survive", 1.2, 1.2, 0);

var button_w = 300;
var button_h = 54;
var button_x = (gui_w - button_w) * 0.5;
var button_y = gui_h * 0.54;

for (var j = 0; j < array_length(menu_items); j++) {
    var item_y = button_y + j * 72;
    var selected = (j == menu_selected);
    draw_set_colour(selected ? make_colour_rgb(31, 102, 121) : make_colour_rgb(12, 29, 45));
    draw_rectangle(button_x, item_y, button_x + button_w, item_y + button_h, false);
    draw_set_colour(selected ? make_colour_rgb(161, 232, 238) : make_colour_rgb(76, 111, 132));
    draw_rectangle(button_x, item_y, button_x + button_w, item_y + button_h, true);
    draw_set_colour(selected ? c_white : make_colour_rgb(179, 196, 207));
    draw_text_transformed(gui_w * 0.5, item_y + button_h * 0.5, menu_items[j], 1.4, 1.4, 0);
}

draw_set_colour(make_colour_rgb(145, 170, 182));
draw_text(gui_w * 0.5, gui_h - 58, "Arrow keys or mouse to choose");
draw_text(gui_w * 0.5, gui_h - 34, "Enter, Space, or click to select");

draw_set_halign(old_halign);
draw_set_valign(old_valign);
draw_set_colour(c_white);
draw_set_alpha(1);
