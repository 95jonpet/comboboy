/// @description Draw the player
draw_sprite_ext(
    sprite_index,
    image_index,
    xDir == -1 ? x + sprite_width : x,
    y,
    xDir,
    image_yscale,
    image_angle,
    c_white,
    invincible ? wave(0.25, 0.5, 0.25, 0) : 1
)
