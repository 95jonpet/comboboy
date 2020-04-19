/// @description Draw credits
draw_set_alpha(0.5)
draw_rectangle_color(0, 0, window_get_width(), window_get_height(), c_black, c_black, c_black, c_black, false)
    
draw_set_alpha(0.75)
draw_rectangle_color(0, window_get_height() * 1/5, window_get_width(), window_get_height() * 2/5, c_black, c_black, c_black, c_black, false)
draw_set_alpha(1)
    
draw_set_halign(fa_center)
draw_set_font(fnGameOver)
draw_text(window_get_width() / 2, window_get_height() * 1/5 + 32, "WELL DONE!")
draw_set_valign(fa_bottom)
draw_set_font(fnSubtitle)
draw_text(window_get_width() / 2, window_get_height() * 2/5 - 32, "Comboboy has completed all levels")
draw_text(window_get_width() / 2, window_get_height() * 4/5, "[CLICK] to restart")
draw_text(window_get_width() / 2, window_get_height() * 19/20, "Made by Peter Jonsson for LD46")
draw_set_font(-1)
draw_set_halign(fa_left)
draw_set_valign(fa_top)