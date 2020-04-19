/// @description Insert description here
if (phase == phases.planning) {
    var nextWaypointAlpha = nextWaypointIsPossible ? 0.75 : 0.25
    draw_sprite_ext(sWaypoint, ds_list_size(waypoints), nextWaypointX, nextWaypointY, 1, 1, 0, image_blend, nextWaypointAlpha)
}
