/// @description Insert description here
if (actionTimer == 0 && floor(image_index) != floor(lastImageIndex)) {
    var instance
                
    instance = instance_create_layer(x + GRID_SIZE / 2, y + GRID_SIZE / 2, "Instances", oEnemyBullet)
    instance.direction = 0
                
    instance = instance_create_layer(x + GRID_SIZE / 2, y + GRID_SIZE / 2, "Instances", oEnemyBullet)
    instance.direction = 90
                
    instance = instance_create_layer(x + GRID_SIZE / 2, y + GRID_SIZE / 2, "Instances", oEnemyBullet)
    instance.direction = 180
                
    instance = instance_create_layer(x + GRID_SIZE / 2, y + GRID_SIZE / 2, "Instances", oEnemyBullet)
    instance.direction = 270
                
    audio_play_sound(snEnemyShot, 10, false)
    lastImageIndex = image_index
}
