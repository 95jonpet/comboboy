/// @description FSM: Handle phase state
switch (phase) {
    case phases.planning:
        nextWaypointX = (mouse_x div GRID_SIZE) * GRID_SIZE
        nextWaypointY = (mouse_y div GRID_SIZE) * GRID_SIZE

        switch(instance_number(oWaypoint)) {
            case 0: cursor_sprite = sWaypointCursor1; break
            case 1: cursor_sprite = sWaypointCursor2; break
            case 2: cursor_sprite = sWaypointCursor3; break
        }

        var wallOnCollisionLine = collision_line(
            (lastWaypoint != noone ? lastWaypoint : oPlayer).x,
            (lastWaypoint != noone ? lastWaypoint : oPlayer).y,
            nextWaypointX,
            nextWaypointY,
            oWall,
            false,
            false
        )

        nextWaypointIsPossible = (
            instance_number(oWaypoint) < maxWaypoints &&
            !(nextWaypointX == oPlayer.x && nextWaypointY == oPlayer.y) &&
            (lastWaypoint == noone || lastWaypoint.x == nextWaypointX || lastWaypoint.y == nextWaypointY) &&
            (lastWaypoint != noone || oPlayer.x == nextWaypointX || oPlayer.y == nextWaypointY) &&
            collision_point(nextWaypointX, nextWaypointY, oWall, false, false) == noone &&
            (wallOnCollisionLine == noone || (instance_number(oWaypoint) == 1 && wallOnCollisionLine.object_index == oFragileWall))
        )

        with (oWaypoint) {
            if (x == other.nextWaypointX && y == other.nextWaypointY) {
                other.nextWaypointIsPossible = false
                break   
            }
        }
        break
    case phases.moving:
        var lerpValue = 1 - power(clamp((playerMovementEndTime - current_time) / PLAYER_MOVEMENT_TIME, 0, 1), 2)
        oPlayer.x = lerp(playerOriginX, waypoints[|nextPlayerWaypointIndex].x, lerpValue)
        oPlayer.y = lerp(playerOriginY, waypoints[|nextPlayerWaypointIndex].y, lerpValue)
        oPlayer.invincible = false
        
        if (lerpValue < 0.1) {
            audio_play_sound(snStartMove, 10, false)
        }
    
        // Continuous stream of projectiles when moving to second waypoint.
        /*if (nextPlayerWaypointIndex == 1 && current_time >= lastActionTime) {
            var instance = instance_create_layer(oPlayer.x + GRID_SIZE / 2, oPlayer.y + GRID_SIZE / 2, "Instances", oAoeSplash)
            instance.direction = point_direction(playerOriginX, playerOriginY, oPlayer.x, oPlayer.y)
            instance.spd = GRID_SIZE * 8
            lastActionTime = current_time
            oPlayer.invincible = true
        }*/
        if (nextPlayerWaypointIndex == 1) {
            oPlayer.invincible = true
            with (collision_line(playerOriginX, playerOriginY, waypoints[|nextPlayerWaypointIndex].x, waypoints[|nextPlayerWaypointIndex].y, oEnemy, false, false)) {
                instance_destroy()
                oPlayer.hasEnergy = true
            }
            with (collision_line(playerOriginX, playerOriginY, waypoints[|nextPlayerWaypointIndex].x, waypoints[|nextPlayerWaypointIndex].y, oFragileWall, false, false)) {
                instance_destroy()
                oPlayer.hasEnergy = true
            }
        }
    
        if (current_time >= playerMovementEndTime) {
            playerOriginX = waypoints[|nextPlayerWaypointIndex].x
            playerOriginY = waypoints[|nextPlayerWaypointIndex].y
            
            nextPlayerWaypointIndex++
            playerMovementStartTime = current_time
            playerMovementEndTime = playerMovementStartTime + PLAYER_MOVEMENT_TIME
            
            // AuE Splash when hitting last waypoint.
            if (nextPlayerWaypointIndex == 3) {
                var instance
                var spd = GRID_SIZE * 4
                
                instance = instance_create_layer(oPlayer.x + GRID_SIZE / 2, oPlayer.y + GRID_SIZE / 2, "Instances", oAoeSplash)
                instance.direction = 0
                instance.spd = spd
                
                instance = instance_create_layer(oPlayer.x + GRID_SIZE / 2, oPlayer.y + GRID_SIZE / 2, "Instances", oAoeSplash)
                instance.direction = 90
                instance.spd = spd
                
                instance = instance_create_layer(oPlayer.x + GRID_SIZE / 2, oPlayer.y + GRID_SIZE / 2, "Instances", oAoeSplash)
                instance.direction = 180
                instance.spd = spd
                
                instance = instance_create_layer(oPlayer.x + GRID_SIZE / 2, oPlayer.y + GRID_SIZE / 2, "Instances", oAoeSplash)
                instance.direction = 270
                instance.spd = spd
                
                audio_play_sound(snExplosion, 10, false)
            }
        }
        break
    case phases.game_over:
        instance_destroy(oWaypoint)
        if (mouse_check_button(mb_left)) {
            mouse_clear(mb_left)
            room_restart()
        }
        break
    case phases.level_complete:
        room_goto_next()
        break
}
