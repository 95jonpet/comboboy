/// @function sprite_for_room_type(type)
/// @description Get sprite to use for room type when generating levels.
/// @param type The room type.
switch (argument0) {
    case roomtypes.spawn:
        return sRoomSpawn
    case roomtypes.normal: // Intentional fall-through.
    default:
        return sRoomNormal
}
