var rooms = 5 // The number of rooms to generate.
var grid = ds_grid_create(rooms + 4, rooms + 4) // Create with additional space in order to make later checks easier.
ds_grid_set_region(grid, 0, 0, ds_grid_width(grid), ds_grid_height(grid), roomtypes.none)

#region Mark rooms for generation in grid

// Allocate lists for allowed and used coordinates.
var allowedCoordinates = ds_list_create()
var usedCoordinates = ds_list_create()

// Start level generation in the grid center.
ds_list_add(
    allowedCoordinates,
    coordinate(ds_grid_width(grid) div 2, ds_grid_height(grid) div 2)
)

for (var i = 0; i < rooms; i++) {
    var coordinateIndex = irandom(ds_list_size(allowedCoordinates) - 1)
    var coordinates = allowedCoordinates[|coordinateIndex]
    var separatorIndex = string_pos(";", coordinates)
    var xx = real(string_copy(coordinates, 0, separatorIndex))
    var yy = real(string_copy(coordinates, separatorIndex + 1, string_length(coordinates) - separatorIndex))
    
    // Mark room for generation.
    grid[# xx, yy] = (i == 0 ? roomtypes.spawn : roomtypes.normal)

    // Mark adjacent room coordinates as allowed.
    if (xx - 1 >= 0 && ds_list_find_index(usedCoordinates, coordinate(xx - 1, yy)) == -1 && ds_list_find_index(allowedCoordinates, coordinate(xx - 1, yy)) == -1) {
        ds_list_add(allowedCoordinates, coordinate(xx - 1, yy))
    }
    if (xx + 1 < ds_grid_width(grid) && ds_list_find_index(usedCoordinates, coordinate(xx + 1, yy)) == -1 && ds_list_find_index(allowedCoordinates, coordinate(xx + 1, yy)) == -1) {
        ds_list_add(allowedCoordinates, coordinate(xx + 1, yy))
    }
    if (yy - 1 >= 0 && ds_list_find_index(usedCoordinates, coordinate(xx, yy - 1)) == -1 && ds_list_find_index(allowedCoordinates, coordinate(xx, yy - 1)) == -1) {
        ds_list_add(allowedCoordinates, coordinate(xx - 1, yy))
    }
    if (yy + 1 < ds_grid_height(grid) && ds_list_find_index(usedCoordinates, coordinate(xx, yy + 1)) == -1 && ds_list_find_index(allowedCoordinates, coordinate(xx, yy + 1)) == -1) {
        ds_list_add(allowedCoordinates, coordinate(xx, yy + 1))
    }

    // Remove current coordinate from allowed coordinates and mark it as used.
    ds_list_delete(allowedCoordinates, coordinateIndex)
    ds_list_add(usedCoordinates, coordinates)
}

// Free resources.
ds_list_destroy(allowedCoordinates)
ds_list_destroy(usedCoordinates)

#endregion

var tileLayer = layer_get_id("Tiles")
var tileMap = layer_tilemap_create(
    tileLayer,
    0,
    0,
    tsWall,
    ds_grid_width(grid) * ROOM_GRID_SIZE,
    ds_grid_height(grid) * ROOM_GRID_SIZE
)
layer_set_visible(tileLayer, true)

var tileTypes = ds_grid_create(ds_grid_width(grid) * ROOM_GRID_SIZE, ds_grid_height(grid) * ROOM_GRID_SIZE)
ds_grid_set_region(tileTypes, 0, 0, ds_grid_width(tileTypes), ds_grid_height(tileTypes), tiletypes.outside_level)

for (var gridX = 0; gridX < ds_grid_width(grid); gridX++) {
    for (var gridY = 0; gridY < ds_grid_height(grid); gridY++) {
        var gridXPos = gridX * ROOM_GRID_SIZE * GRID_SIZE
        var gridYPos = gridY * ROOM_GRID_SIZE * GRID_SIZE
        
        if (grid[# gridX, gridY] == roomtypes.none) {
            continue
        }
        
        // Load level data from sprites.
        var roomSprite = sprite_for_room_type(grid[# gridX, gridY])
        var surface = surface_create(ROOM_GRID_SIZE, ROOM_GRID_SIZE)
        surface_set_target(surface)
        draw_clear($000000)
        draw_sprite(roomSprite, irandom(sprite_get_number(roomSprite) - 1), 0, 0)
        /*draw_sprite_ext(
            roomSprite,
            irandom(sprite_get_number(roomSprite) - 1),
            0,
            0,
            choose(-1, 1),
            choose(-1, 1),
            choose(0, 90, 180, 270),
            c_white,
            1
        )*/
        surface_reset_target()
        
        // Generate instances.
        for (var spriteX = 0; spriteX < ROOM_GRID_SIZE; spriteX++) {
            for (var spriteY = 0; spriteY < ROOM_GRID_SIZE; spriteY++) {
                var xx = gridXPos + spriteX * GRID_SIZE
                var yy = gridYPos + spriteY * GRID_SIZE
                var tileX = gridX * ROOM_GRID_SIZE + spriteX
                var tileY = gridY * ROOM_GRID_SIZE + spriteY
                
                switch(surface_getpixel(surface, spriteX, spriteY)) {
                        case $FFFFFF: // Wall.
                            instance_create_layer(xx, yy, "Walls", oWall)
                            tileTypes[# tileX, tileY] = tiletypes.wall
                            break
                        case $898989: // Fragile wall.
                            instance_create_layer(xx, yy, "Walls", oFragileWall)
                            break
                        case $241CEE: // Enemy.
                            instance_create_layer(xx, yy, "Instances", oEnemy)
                            break
                        case $00FF00: // Energy pickup.
                            instance_create_layer(xx, yy, "Instances", oEnergy)
                            break
                        default:
                            if (spriteX == 0 && gridX > 0 && grid[# (gridX - 1), gridY] == roomtypes.none) {
                                tileTypes[# tileX, tileY] = tiletypes.wall
                                instance_create_layer(xx, yy, "Walls", oWall)
                            } else if (spriteX == ROOM_GRID_SIZE - 1 && gridX < ds_grid_width(grid) - 1 && grid[# (gridX + 1), gridY] == roomtypes.none) {
                                tileTypes[# tileX, tileY] = tiletypes.wall
                                instance_create_layer(xx, yy, "Walls", oWall)
                            } else if (spriteY == 0 && gridY > 0 && grid[# gridX, (gridY - 1)] == roomtypes.none) {
                                tileTypes[# tileX, tileY] = tiletypes.wall
                                instance_create_layer(xx, yy, "Walls", oWall)
                            } else if (spriteY == ROOM_GRID_SIZE - 1 && gridY < ds_grid_height(grid) - 1 && grid[# gridX, (gridY + 1)] == roomtypes.none) {
                                tileTypes[# tileX, tileY] = tiletypes.wall
                                instance_create_layer(xx, yy, "Walls", oWall)
                            }
                            break
                }
                
                if (tileTypes[# tileX, tileY] != tiletypes.wall) {
                    tileTypes[# tileX, tileY] = tiletypes.floor_tile
                }
            }
        }
        
        // Update player spawn if handling the spawn room.
        if (grid[# gridX, gridY] == roomtypes.spawn) {
            oPlayer.x = gridXPos + irandom_range(2, ROOM_GRID_SIZE - 2) * GRID_SIZE
            oPlayer.y = gridYPos + irandom_range(2, ROOM_GRID_SIZE - 2) * GRID_SIZE
        }
        
        surface_free(surface)
    }
}

#region Update tiles
var TODO = 7
for (var tileX = 1; tileX < ds_grid_width(tileTypes) - 1; tileX++) {
    for (var tileY = 1; tileY < ds_grid_height(tileTypes) - 1; tileY++) {
        var tileData = noone // 1
        if (tileTypes[# tileX, tileY] == tiletypes.floor_tile) {
            tileData = 18 // Floor.
        } else if (tileTypes[# tileX, tileY] == tiletypes.wall || tileTypes[# tileX, tileY] == tiletypes.outside_level) {
            if (tileTypes[# tileX - 1, tileY] == tiletypes.floor_tile && tileTypes[# tileX + 1, tileY] == tiletypes.floor_tile && tileTypes[# tileX, tileY - 1] == tiletypes.floor_tile && tileTypes[# tileX, tileY + 1] == tiletypes.floor_tile) {
                tileData = 8 // Single wall.
            } else if (tileTypes[# tileX, tileY + 1] == tiletypes.wall && tileTypes[# tileX, tileY + 2] != tiletypes.wall && tileTypes[# tileX, tileY - 1] == tiletypes.floor_tile) {
                if (tileTypes[# tileX - 1, tileY] == tiletypes.floor_tile) {
                    tileData = 21
                } else if (tileTypes[# tileX + 1, tileY] == tiletypes.floor_tile) {
                    tileData = 23
                } else {
                    tileData = 22
                }
            } else if (tileTypes[# tileX, tileY + 1] == tiletypes.wall && tileTypes[# tileX - 1, tileY] == tiletypes.floor_tile && tileTypes[# tileX + 1, tileY] == tiletypes.floor_tile) {
                if (tileTypes[# tileX, tileY - 1] == tiletypes.floor_tile) {
                    tileData = 29
                } else if (tileTypes[# tileX, tileY + 2] == tiletypes.floor_tile) {
                    tileData = 45
                } else {
                    tileData = 37
                }
            } else if (tileTypes[# tileX, tileY + 1] == tiletypes.wall && tileTypes[# tileX, tileY - 1] == tiletypes.wall && tileTypes[# tileX - 1, tileY] == tiletypes.floor_tile && tileTypes[# tileX - 1, tileY + 2] == tiletypes.floor_tile && tileTypes[# tileX, tileY + 2] == tiletypes.floor_tile) {
                tileData = 13 // Top left wall corner.
            } else if (tileTypes[# tileX, tileY + 1] == tiletypes.wall && tileTypes[# tileX, tileY - 1] == tiletypes.wall && tileTypes[# tileX + 1, tileY] == tiletypes.floor_tile && tileTypes[# tileX + 1, tileY + 2] == tiletypes.floor_tile && tileTypes[# tileX, tileY + 2] == tiletypes.floor_tile) {
                tileData = 14 // Top right wall corner.
            } else if (tileTypes[# tileX, tileY + 1] == tiletypes.wall && tileTypes[# tileX + 1, tileY] == tiletypes.wall && tileTypes[# tileX - 1, tileY] == tiletypes.floor_tile && tileTypes[# tileX - 1, tileY - 1] == tiletypes.floor_tile && tileTypes[# tileX, tileY - 1] == tiletypes.floor_tile) {
                tileData = 5 // Bottom left wall corner.
            } else if (tileTypes[# tileX, tileY + 1] == tiletypes.wall && tileTypes[# tileX - 1, tileY] == tiletypes.wall && tileTypes[# tileX + 1, tileY] == tiletypes.floor_tile && tileTypes[# tileX + 1, tileY - 1] == tiletypes.floor_tile && tileTypes[# tileX, tileY - 1] == tiletypes.floor_tile) {
                tileData = 6 // Bottom right wall corner.
            } else if (tileTypes[# tileX, tileY - 1] == tiletypes.floor_tile) {
                tileData = tileTypes[# tileX - 1, tileY - 1] == tiletypes.wall ? 26 : 27 // Bottom wall ledge.
            } else if (tileTypes[# tileX, tileY + 1] == tiletypes.floor_tile) {
                tileData = 10 // Middle wall segment.
            } else if (tileTypes[# tileX, tileY + 2] == tiletypes.floor_tile) {
                tileData = tileTypes[# tileX - 1, tileY + 2] == tiletypes.wall ? 2 : 3 // Top wall ledge.
            } else if (tileTypes[# tileX - 1, tileY] == tiletypes.floor_tile || tileTypes[# tileX - 1, tileY + 1] == tiletypes.floor_tile) {
                tileData = 12 // Right wall ledge.
            } else if (tileTypes[# tileX - 1, tileY + 2] == tiletypes.floor_tile) {
                tileData = 4 // Top right wall ledge.
            } else if (tileTypes[# tileX + 1, tileY] == tiletypes.floor_tile || tileTypes[# tileX + 1, tileY + 1] == tiletypes.floor_tile) {
                tileData = 9 // Left wall ledge.
            } else if (tileTypes[# tileX + 1, tileY + 2] == tiletypes.floor_tile) {
                tileData = 1 // Top left wall ledge.
            } else if (tileTypes[# tileX - 1, tileY - 1] == tiletypes.floor_tile) {
                tileData = 28 // Bottom right wall ledge.
            } else if (tileTypes[# tileX + 1, tileY - 1] == tiletypes.floor_tile) {
                tileData = 25 // Bottom left wall ledge.
            }
        }
        
        if (tileData != noone) {
            tilemap_set(tileMap, tileData, tileX, tileY)
        }
    }
}
#endregion

ds_grid_destroy(tileTypes)
ds_grid_destroy(grid)
