/// @description Draw the enemy
draw_set_font(fnExclamation)
draw_set_halign(fa_center)
draw_set_valign(fa_bottom)

if (actionTimer == 1) {
    draw_text_color(
        x + GRID_SIZE / 2,
        y - GRID_SIZE / 8,
        "!!",
        c_red,
        c_red,
        c_red,
        c_red,
        1
    )
} else if (actionTimer == 2) {
    draw_text_color(
        x + GRID_SIZE / 2,
        y - GRID_SIZE / 8,
        "!",
        c_red,
        c_red,
        c_red,
        c_red,
        1
    )
}

draw_set_halign(fa_left)
draw_set_valign(fa_top)
draw_set_font(-1)
