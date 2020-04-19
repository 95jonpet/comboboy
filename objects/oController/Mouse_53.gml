/// @description Insert description here
if (nextWaypointIsPossible) {
    mouse_clear(mb_left)
    lastWaypoint = instance_create_layer(nextWaypointX, nextWaypointY, "Waypoints", oWaypoint)
    ds_list_add(waypoints, lastWaypoint)
    audio_play_sound(snPlaceWaypoint, 10, false)
}
