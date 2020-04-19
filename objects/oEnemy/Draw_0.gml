/// @description Draw the enemy
draw_sprite_ext(
    sprite_index,
    image_index,
    image_xscale == -1 ? x - sprite_width : x,
    y,
    image_xscale,
    image_yscale,
    image_angle,
    c_white,
    image_alpha
)
