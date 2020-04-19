/// @description Initialize controller.
instance_create_depth(oPlayer.x, oPlayer.y, depth, oCamera)
cursor_sprite = sWaypointCursor1
window_set_cursor(cr_none)

if (!audio_is_playing(snMusic)) {
    audio_play_sound(snMusic, 0, true)
}

randomize()
phase = phases.planning
waypoints = ds_list_create()
hasTriggeredEnemyEvents = false
gameOverReason = "was not kept alive"

// FSM: Planning phase.
maxWaypoints = 3
lastWaypoint = noone
nextWaypointIsPossible = false
nextWaypointX = 0
nextWaypointY = 0

// FSM: Moving phase.
playerOriginX = 0
playerOriginY = 0
playerMovementStartTime = current_time
playerMovementEndTime = playerMovementStartTime
nextPlayerWaypointIndex = 0
lastActionTime = current_time

// FSM: Check energy phase.
checkEnergyStartTime = current_time

// Override camera starting position.
oCamera.xTo = oPlayer.x
oCamera.yTo = oPlayer.y
oCamera.x = oPlayer.x
oCamera.y = oPlayer.y
