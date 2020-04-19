#macro GRID_SIZE 16
#macro ROOM_GRID_SIZE 8

#macro PLAYER_MOVEMENT_TIME 500 // Milliseconds

enum phases {
    planning,
    moving,
    check_energy,
    level_complete,
    game_over
}

enum roomtypes {
    none,
    normal,
    spawn
}

enum tiletypes {
    outside_level,
    wall,
    floor_tile
}
