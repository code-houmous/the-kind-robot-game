extends Camera
class_name MainCamera

"""
This camera has multiple positions. The game is portionned in multiple areas.
Every time the player enters an area, the camera needs to move to
make a new framing
"""

# actual position
var position: Vector3 = Vector3(0, 0, 0)

# next position
var target: Vector3

# speed when it is moving
var speed: float = 1.6

# acceleration curve
var acceleration: float = 0.0

# true if the camera has reached a target
var on_place: bool = true

func _physics_process(delta):
    if !target:
        return

    if on_place:
        acceleration = 0.0
        return

    position = transform.origin

    var direction = position.direction_to(target)

    if position.distance_to(target) > 0.5:
        acceleration = min(10, acceleration + 0.05)
    else:
        acceleration = max(0, acceleration - 0.05)

    var velocity = direction * delta * speed * acceleration

    transform.origin = transform.origin + velocity

    if transform.origin.distance_to(target) < 0.1:
        on_place = true

# defines the target for camera position according to area
func set_target(vector: Vector3):
    on_place = false
    target = vector

# ========== Area collisions with player ============

func _on_Hotel_body_entered(robot: Robot):
    if not robot:
        return
    set_target(Vector3(-0.667, 0.713, 3.221))

func _on_Marcys_body_entered(robot: Robot):
    if not robot:
        return
    set_target(Vector3(0.656, 0.713, 3.919))