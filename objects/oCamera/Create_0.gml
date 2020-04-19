/// @description Initialize camera
follow = oPlayer // The object to follow.

// Move to target position when starting the room.
xTo = follow.x
yTo = follow.y
x = xTo
y = yTo

// Configure view camera.
camera = camera_create()
var viewmat = matrix_build_lookat(x, y, -10, x, y, 0, 0, 1, 0)
var projmat = matrix_build_projection_ortho(384, 216, 1, 10000)
camera_set_view_mat(camera, viewmat)
camera_set_proj_mat(camera, projmat)
view_camera[0] = camera
