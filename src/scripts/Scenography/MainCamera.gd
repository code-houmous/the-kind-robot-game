extends Camera
class_name MainCamera

"""
This camera has multiple positions. The game is portionned in multiple areas.
Every time the player enters an area, the camera needs to move to
make a new framing
"""

# if false, the camera will simply follow the player
export var cinematography_mode: bool = true

# actual position
var position: Vector3 = Vector3(0, 0, 0)

# next rotation
var target_rotation: Vector3

# next position
var target_position: Vector3

# speed when it is moving
var speed: float = 1.01

# acceleration curve
var acceleration_position: float = 0.0

# acceleration curve
var acceleration_rotation: float = 0.0

# true if the camera has reached a target
var on_place: bool = false

# true when the camera has finished to rotate
var rotated: bool = false

func _ready():
    if cinematography_mode:
        return

    # we set a default camera position
    transform.origin = Vector3(0, 0.713, 1.221)
    rotation_degrees = Vector3(-22, 0, 0)


func _physics_process(delta):
    if !cinematography_mode:
        return

    if !target_position:
        return

    if rotated and on_place:
        return

    rotate_camera(delta)
    move_camera(delta)

"""
Move the camera to target
"""
func move_camera(delta):
    if on_place:
        acceleration_position = 0.0
        return

    position = transform.origin

    var direction = position.direction_to(target_position)

    if position.distance_to(target_position) > 0.05:
        acceleration_position = min(10, acceleration_position + 0.05)
    else:
        acceleration_position = max(0, acceleration_position - 0.05)

    var velocity_position = direction * delta * speed * acceleration_position

    if !on_place:
        transform.origin = transform.origin + velocity_position

    if transform.origin.distance_to(target_position) < 0.05:
        on_place = true

"""
Rotate camera to target
"""
func rotate_camera(delta: float):
    if rotated:
        acceleration_rotation = 0.0
        return

    var angle = rotation_degrees.direction_to(target_rotation)

    if rotation_degrees.distance_to(target_rotation) > 0.5:
        acceleration_rotation = min(20, acceleration_rotation + 0.5)
    else:
        acceleration_rotation = max(0, acceleration_rotation - 0.5)

    var velocity_rotation = angle * delta * speed * acceleration_rotation

    if !rotated:
        rotation_degrees = rotation_degrees + velocity_rotation

    if rotation_degrees.distance_to(target_rotation) < 0.5:
        rotated = true


# defines the target for camera position according to area
func set_target(pos: Vector3, rot: Vector3):
    init()
    target_position = pos
    target_rotation = rot

func init():
    on_place = false
    rotated = false
    acceleration_position = 0.0
    acceleration_rotation = 0.0

# ========== Area collisions with player ============
# An area will define the distance to the subject (z), the y position, and angle

func _on_Hotel_body_entered(robot: Robot):
    if not robot:
        return
    set_target(
        Vector3(0, 0.713, 1.221),
        Vector3(-22, 0, 0)
    )

func _on_Marcys_body_entered(robot: Robot):
    if not robot:
        return
    set_target(
        Vector3(0, 0.2, 1.6),
        Vector3(-10, 0, 0)
    )

func _on_Books_body_entered(robot: Robot):
    if not robot:
        return
    set_target(
        Vector3(0, -0.1, 0.7),
        Vector3(3, 10, 0)
    )

func _on_BigBuilding_body_entered(robot: Robot):
    if not robot:
        return
    set_target(
        Vector3(-0.2, 0.3, 1.7),
        Vector3(13.4, -10.62, 1.135)
    )


