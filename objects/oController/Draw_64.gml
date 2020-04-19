/// @description Insert description here
#region Game over screen
if (phase == phases.game_over) {
    draw_set_alpha(0.5)
    draw_rectangle_color(0, 0, display_get_gui_width(), display_get_gui_height(), c_black, c_black, c_black, c_black, false)
    
    draw_set_alpha(0.75)
    draw_rectangle_color(0, display_get_gui_height() * 1/5, display_get_gui_width(), display_get_gui_height() * 2/5, c_black, c_black, c_black, c_black, false)
    draw_set_alpha(1)
    
    draw_set_halign(fa_center)
    draw_set_font(fnGameOver)
    draw_text(display_get_gui_width() / 2, display_get_gui_height() * 1/5 + 32, "GAME OVER")
    draw_set_valign(fa_bottom)
    draw_set_font(fnSubtitle)
    draw_text(display_get_gui_width() / 2, display_get_gui_height() * 2/5 - 32, "Comboboy " + gameOverReason)
    draw_text(display_get_gui_width() / 2, display_get_gui_height() * 4/5, "[CLICK] to retry")
    draw_text(display_get_gui_width() / 2, display_get_gui_height() * 19/20, "Made by Peter Jonsson for LD46")
    draw_set_font(-1)
    draw_set_halign(fa_left)
    draw_set_valign(fa_top)
}
#endregion

/*
var phaseName = "?"
switch (phase) {
    case phases.planning:
        phaseName = "planning"
        break
    case phases.moving:
        phaseName = "moving"
        break
    case phases.check_energy:
        phaseName = "check_energy"
        break
    case phases.game_over:
        phaseName = "game_over"
        break
    case phases.level_complete:
        phaseName = "level_complete"
        break
}

var i = 0
draw_text_color(0, 16 * i++, "Phase: " + phaseName, c_red, c_red, c_red, c_red, 1)
draw_text_color(0, 16 * i++, "Energy: " + (oPlayer.hasEnergy ? "Yes" : "No"), c_red, c_red, c_red, c_red, 1)

draw_text_color(0, 16 * i++, "---", c_red, c_red, c_red, c_red, 1)
draw_text_color(0, 16 * i++, "Enemies: " + string(instance_number(oEnemy)), c_red, c_red, c_red, c_red, 1)
draw_text_color(0, 16 * i++, "Treasures: " + string(instance_number(oEnergy)), c_red, c_red, c_red, c_red, 1)
*/