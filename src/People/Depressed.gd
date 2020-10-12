extends "res://src/Parents/Body.gd"

var position: Vector3 = Vector3(0, 0, 0)

var target = null
var navigation: Navigation = null

func _ready():
    speed = 10

func _physics_process(delta):
    if !target:
        return

    var path: PoolVector3Array = calculate_path(target)

    if path.size() == 0:
        return

    path.remove(0)
    var distance: float = global_transform.origin.distance_to(path[0])
    var direction: Vector3 = global_transform.origin.direction_to(path[0])

    print(distance)
    orientation = calculate_orientation(direction)

    acceleration = accelerate(direction, acceleration)

    velocity = gravity(velocity, weight)

    if (distance < 0.24):
        velocity.x = 0
        velocity.z = 0
        acceleration = 0

    animate(velocity, orientation)
    move(delta)

    move_and_slide(velocity, Vector3.UP)

func calculate_path(target) -> PoolVector3Array:
    return navigation.get_simple_path(global_transform.origin, target.global_transform.origin)

func calculate_orientation(direction: Vector3) -> Vector3:
    var out = Vector3(0, 0, 0)
    out.x = direction.x
    out.z = direction.z

    return out

"""
Animates the sprite
"""
func animate(linear_velocity: Vector3, orientation: Vector3):
    if (linear_velocity.x < 0):
        $Animation.play("walk_left")
        return
    if (linear_velocity.x > 0):
        $Animation.play("walk_right")
        return
    if (linear_velocity.z < 0):
        $Animation.play("walk_left")
        return
    if (linear_velocity.z > 0):
        $Animation.play("walk_right")
        return

    # no movement : idle animation
    if (orientation.x < 0):
        $Animation.play("idle_left")
        return
    if (orientation.x >= 0):
        $Animation.play("idle_right")
        return
    if (orientation.z < 0):
        $Animation.play("idle_left")
        return
    if (orientation.z >= 0):
        $Animation.play("idle_right")
        return

    $Animation.play("idle_left")
