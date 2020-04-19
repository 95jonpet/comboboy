/// @description Update enemy action timer.
with (oEnemy) {
    actionTimer--
    if (actionTimer < 0) {
        actionTimer = actionInterval
    }
}
