/// @description Insert description here
if (invincible) {
    var instance
    var distance = point_distance(x, y, xprevious, yprevious)
    var spd = distance * room_speed + GRID_SIZE * 16 * 2
    
    instance = instance_create_layer(x + GRID_SIZE / 2, y + GRID_SIZE / 2, "Instances", oAoeSplash)
    instance.direction = point_direction(oController.playerOriginX, oController.playerOriginY, oPlayer.x, oPlayer.y)
    instance.spd = spd
    
    instance = instance_create_layer(x + GRID_SIZE / 2, y + GRID_SIZE / 2, "Instances", oAoeSplash)
    instance.direction = point_direction(oController.playerOriginX, oController.playerOriginY, oPlayer.x, oPlayer.y)
    instance.x += lengthdir_x(GRID_SIZE / 4, instance.direction)
    instance.y += lengthdir_y(GRID_SIZE / 4, instance.direction)
    instance.spd = spd
    
    instance = instance_create_layer(x + GRID_SIZE / 2, y + GRID_SIZE / 2, "Instances", oAoeSplash)
    instance.direction = point_direction(oController.playerOriginX, oController.playerOriginY, oPlayer.x, oPlayer.y)
    instance.x += lengthdir_x(GRID_SIZE / 2, instance.direction)
    instance.y += lengthdir_y(GRID_SIZE / 2, instance.direction)
    instance.spd = spd
}
