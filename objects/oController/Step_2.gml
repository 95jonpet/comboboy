/// @description FSM: Transition to new phase state
switch (phase) {
    case phases.planning:
        if (ds_list_size(waypoints) >= maxWaypoints) {
            cursor_sprite = -1
            playerMovementStartTime = current_time
            lastActionTime = current_time
            playerMovementEndTime = playerMovementStartTime + PLAYER_MOVEMENT_TIME
            nextPlayerWaypointIndex = 0
            playerOriginX = oPlayer.x
            playerOriginY = oPlayer.y
            oPlayer.hasEnergy = false
            
            phase = phases.moving
        }
        break
    case phases.moving:
        if (oPlayer.hasTouchedExit) {
            instance_destroy(oWaypoint)
            cursor_sprite = sWaypointCursor1
            
            phase = phases.level_complete
        } else if (nextPlayerWaypointIndex > ds_list_size(waypoints) - 1) {
            ds_list_clear(waypoints)
            instance_destroy(oWaypoint)
            lastWaypoint = noone
            checkEnergyStartTime = current_time
            
            alarm[0] = room_speed / 4
            
            phase = phases.check_energy
        }
        break
    case phases.check_energy:
        oPlayer.hasTouchedExit = false
        if (current_time > checkEnergyStartTime + 1000) {
            cursor_sprite = sWaypointCursor1
            
            if (oPlayer.hasEnergy) {
                phase = phases.planning
            } else {
                gameOverReason = "was not given energy"
                phase = phases.game_over
            }
        }
        break
}
